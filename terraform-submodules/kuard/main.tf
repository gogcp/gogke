module "service_account" {
  source = "../gke-service-account"

  google_project           = var.google_project
  google_container_cluster = var.google_container_cluster
  kubernetes_namespace     = var.kubernetes_namespace
  service_account_name     = "kuard"
}

module "helm_release" {
  source = "../helm-release"
  # source = "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/helm-release/0.0.0.zip"

  chart = "../../helm-charts/kuard"
  # repository    = "oci://europe-central2-docker.pkg.dev/gogke-main-0/private-helm-charts/gogke"
  # chart         = "kuard"
  # chart_version = "0.0.0"

  namespace = var.kubernetes_namespace.metadata[0].name
  name      = "kuard"
  values = [templatefile("${path.module}/assets/values.yaml.tftpl", {
    service_account_name = module.service_account.kubernetes_service_account.metadata[0].name
  })]
}
