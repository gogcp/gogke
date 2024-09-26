#######################################
### IP address & DNS zone
#######################################

resource "google_compute_address" "this" { # https://console.cloud.google.com/networking/addresses/list?project=damlys-ace-1
  project = data.google_project.this.project_id
  name    = var.platform_name
  region  = local.gcp_region

  address_type = "EXTERNAL"
}

resource "google_dns_managed_zone" "this" { # https://console.cloud.google.com/net-services/dns/zones?project=damlys-ace-1
  project  = data.google_project.this.project_id
  name     = var.platform_name
  dns_name = "${var.platform_name}.damlys.dev."

  visibility = "public"
}

resource "google_dns_record_set" "this" {
  project      = data.google_project.this.project_id
  managed_zone = google_dns_managed_zone.this.name

  for_each = toset([google_dns_managed_zone.this.dns_name, "*.${google_dns_managed_zone.this.dns_name}"])
  name     = each.key
  type     = "A"
  ttl      = 300
  rrdatas  = [google_compute_address.this.address]
}

#######################################
### VPC network
#######################################

resource "google_compute_network" "this" { # https://console.cloud.google.com/networking/networks/list?project=damlys-ace-1
  project = data.google_project.this.project_id
  name    = var.platform_name

  routing_mode = "GLOBAL"

  # do not create default resources
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "this" {
  project = data.google_project.this.project_id
  network = google_compute_network.this.name
  name    = var.platform_name
  region  = local.gcp_region

  ip_cidr_range = "10.0.0.0/8"
}

#######################################
### VPC ingress
#######################################

#######################################
### VPC egress
#######################################

resource "google_compute_route" "egress_internet" { # https://console.cloud.google.com/networking/routes/list?project=damlys-ace-1
  project = data.google_project.this.project_id
  network = google_compute_network.this.name
  name    = "egress-internet"

  dest_range       = "0.0.0.0/0"
  priority         = 1000
  next_hop_gateway = "default-internet-gateway"
}
