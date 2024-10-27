#######################################
### VPC network
#######################################

resource "google_compute_network" "this" { # console.cloud.google.com/networking/networks/list
  project = var.google_project.project_id
  name    = var.platform_name

  routing_mode = "GLOBAL"

  # do not create default resources
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "this" {
  project = var.google_project.project_id
  network = google_compute_network.this.name
  name    = var.platform_name
  region  = local.gcp_region

  ip_cidr_range = local.vpc_subnet_cidr

  private_ip_google_access = true
}

#######################################
### Internet egress
#######################################

resource "google_compute_address" "egress_internet" { # console.cloud.google.com/networking/addresses/list
  project = var.google_project.project_id
  name    = "${var.platform_name}-egress-internet"
  region  = local.gcp_region

  address_type = "EXTERNAL"
}

resource "google_compute_router" "egress_internet" { # console.cloud.google.com/hybrid/routers/list
  project = var.google_project.project_id
  network = google_compute_network.this.name
  name    = "${var.platform_name}-egress-internet"
  region  = google_compute_subnetwork.this.region
}

resource "google_compute_router_nat" "egress_internet" { # console.cloud.google.com/net-services/nat/list
  project = var.google_project.project_id
  router  = google_compute_router.egress_internet.name
  name    = "${var.platform_name}-egress-internet"
  region  = google_compute_router.egress_internet.region

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = [google_compute_address.egress_internet.self_link]

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_route" "egress_internet" { # console.cloud.google.com/networking/routes/list
  project = var.google_project.project_id
  network = google_compute_network.this.name
  name    = "${var.platform_name}-egress-internet"

  dest_range       = "0.0.0.0/0"
  priority         = 1000
  next_hop_gateway = "default-internet-gateway"
}

resource "google_compute_firewall" "egress_internet" { # console.cloud.google.com/net-security/firewall-manager/firewall-policies/list
  project = var.google_project.project_id
  network = google_compute_network.this.name
  name    = "${var.platform_name}-egress-internet"

  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  priority           = 1000

  allow {
    protocol = "all"
  }
}

#######################################
### GKE cluster
#######################################

resource "google_kms_key_ring" "this" { # console.cloud.google.com/security/kms/keyrings
  project  = var.google_project.project_id
  name     = var.platform_name
  location = local.gcp_region
}

resource "google_kms_crypto_key" "gke_secrets" { # console.cloud.google.com/security/kms/keys
  key_ring = google_kms_key_ring.this.id
  name     = "gke-secrets"
  purpose  = "ENCRYPT_DECRYPT"
}

resource "google_kms_crypto_key_iam_member" "gke_secrets" {
  crypto_key_id = google_kms_crypto_key.gke_secrets.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${var.google_project.number}@container-engine-robot.iam.gserviceaccount.com"
}

resource "google_container_cluster" "this" { # console.cloud.google.com/kubernetes/list/overview
  depends_on = [
    google_compute_router_nat.egress_internet,
    google_compute_route.egress_internet,
    google_compute_firewall.egress_internet,
    google_kms_crypto_key_iam_member.gke_secrets,
  ]

  project  = var.google_project.project_id
  name     = var.platform_name
  location = local.gcp_zone

  release_channel {
    channel = local.gke_version == null ? "STABLE" : "UNSPECIFIED"
  }
  min_master_version = local.gke_version
  maintenance_policy {
    daily_maintenance_window {
      start_time = "01:00" # UTC
    }
  }

  network    = google_compute_network.this.name
  subnetwork = google_compute_subnetwork.this.name
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = local.gke_master_cidr
    master_global_access_config {
      enabled = false
    }
  }
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = local.gke_pod_cidr
    services_ipv4_cidr_block = local.gke_svc_cidr
  }

  # master_authorized_networks_config {
  #   cidr_blocks {
  #     cidr_block   = "0.0.0.0/0"
  #     display_name = "Everybody"
  #   }
  # }
  workload_identity_config {
    workload_pool = "${var.google_project.project_id}.svc.id.goog"
  }
  # authenticator_groups_config {
  #   security_group = "gke-security-groups@damlys.pl"
  # }

  enable_shielded_nodes = true
  database_encryption {
    state    = "ENCRYPTED"
    key_name = google_kms_crypto_key.gke_secrets.id
  }

  # logging_service = "none"
  logging_config {
    enable_components = []
  }
  # monitoring_service = "none"
  monitoring_config {
    enable_components = []
    managed_prometheus { enabled = false }
  }

  addons_config {
    gce_persistent_disk_csi_driver_config { enabled = true } # Google Compute Engine persistent disk driver
    gcp_filestore_csi_driver_config { enabled = false }      # Filestore driver
    gcs_fuse_csi_driver_config { enabled = false }           # Google Cloud Storage driver
    horizontal_pod_autoscaling { disabled = false }
    http_load_balancing { disabled = false }
    network_policy_config { disabled = false }
  }
  vertical_pod_autoscaling { enabled = true }
  gateway_api_config { channel = "CHANNEL_STANDARD" }
  network_policy { enabled = true }

  # do not create default node pool
  initial_node_count       = 1
  remove_default_node_pool = true

  # allow to destroy resource
  deletion_protection = false
}

resource "google_service_account" "gke_node" { # console.cloud.google.com/iam-admin/serviceaccounts
  project    = var.google_project.project_id
  account_id = "${var.platform_name}-gke-node"
}

resource "google_container_node_pool" "this" {
  project        = var.google_project.project_id
  cluster        = google_container_cluster.this.id
  name           = var.platform_name
  node_locations = local.gcp_zones

  version = local.gke_version
  management {
    auto_upgrade = local.gke_version == null
    auto_repair  = true
  }

  node_count = 1
  autoscaling {
    min_node_count  = 1
    max_node_count  = 1
    location_policy = local.gke_spot ? "ANY" : "BALANCED"
  }

  node_config {
    machine_type = "n2d-standard-2"
    spot         = local.gke_spot
    disk_type    = "pd-standard"
    disk_size_gb = 100

    shielded_instance_config {
      enable_secure_boot = true
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    service_account = google_service_account.gke_node.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  lifecycle {
    ignore_changes = [
      node_count,
    ]
  }
}

#######################################
### Google IAM & Kubernetes RBAC
#######################################

resource "kubernetes_namespace" "gke_security_groups" {
  metadata {
    name = "gke-security-groups"
  }
}

resource "kubernetes_cluster_role" "namespaces_viewer" {
  metadata {
    name = "custom:namespaces-viewer"
  }
  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_namespace" "this" {
  for_each = local.all_namespace_names

  metadata {
    name = each.value
  }
}

resource "google_project_iam_member" "clusters_viewers" {
  for_each = local.all_namespace_iam_members

  project = var.google_project.project_id
  role    = "roles/container.clusterViewer"
  member  = each.value
}

resource "kubernetes_cluster_role_binding" "namespaces_viewers" {
  metadata {
    name = "custom:namespaces-viewers"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.namespaces_viewer.metadata[0].name
  }
  dynamic "subject" {
    for_each = local.all_namespace_iam_members

    content {
      api_group = "rbac.authorization.k8s.io"
      kind      = startswith(subject.value, "user:") ? "User" : startswith(subject.value, "group:") ? "Group" : startswith(subject.value, "serviceAccount:") ? "User" : null
      name      = split(":", subject.value)[1]
      namespace = kubernetes_namespace.gke_security_groups.metadata[0].name
    }
  }
}

resource "kubernetes_role_binding" "testers" {
  for_each = var.namespace_iam_testers

  metadata {
    namespace = kubernetes_namespace.this[each.key].metadata[0].name
    name      = "custom:testers"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.tester.metadata[0].name
  }
  dynamic "subject" {
    for_each = each.value

    content {
      api_group = "rbac.authorization.k8s.io"
      kind      = startswith(subject.value, "user:") ? "User" : startswith(subject.value, "group:") ? "Group" : startswith(subject.value, "serviceAccount:") ? "User" : null
      name      = split(":", subject.value)[1]
      namespace = kubernetes_namespace.gke_security_groups.metadata[0].name
    }
  }
}

resource "kubernetes_role_binding" "developers" {
  for_each = var.namespace_iam_developers

  metadata {
    namespace = kubernetes_namespace.this[each.key].metadata[0].name
    name      = "custom:developers"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.developer.metadata[0].name
  }
  dynamic "subject" {
    for_each = each.value

    content {
      api_group = "rbac.authorization.k8s.io"
      kind      = startswith(subject.value, "user:") ? "User" : startswith(subject.value, "group:") ? "Group" : startswith(subject.value, "serviceAccount:") ? "User" : null
      name      = split(":", subject.value)[1]
      namespace = kubernetes_namespace.gke_security_groups.metadata[0].name
    }
  }
}

#######################################
### Internet ingress
#######################################

resource "google_compute_address" "ingress_internet" { # console.cloud.google.com/networking/addresses/list
  project = var.google_project.project_id
  name    = "${var.platform_name}-ingress-internet"
  region  = local.gcp_region

  address_type = "EXTERNAL"
}

resource "google_dns_managed_zone" "ingress_internet" { # console.cloud.google.com/net-services/dns/zones
  project  = var.google_project.project_id
  name     = "${var.platform_name}-ingress-internet"
  dns_name = "${var.platform_name}.damlys.pl."

  visibility = "public"

  # override default description
  description = "-"
}

resource "google_dns_record_set" "ingress_internet" {
  project      = var.google_project.project_id
  managed_zone = google_dns_managed_zone.ingress_internet.name

  for_each = toset([google_dns_managed_zone.ingress_internet.dns_name, "*.${google_dns_managed_zone.ingress_internet.dns_name}"])
  name     = each.key
  type     = "A"
  ttl      = 300
  rrdatas  = [google_compute_address.ingress_internet.address]
}
