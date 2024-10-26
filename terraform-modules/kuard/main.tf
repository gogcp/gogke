data "kubernetes_namespace" "this" {
  metadata {
    name = "kuard"
  }
}

module "kuard_service_account" {
  source = "../../terraform-submodules/gke-service-account"

  google_project           = data.google_project.this
  google_container_cluster = data.google_container_cluster.this
  kubernetes_namespace     = data.kubernetes_namespace.this
  service_account_name     = "kuard"
}

module "kuard" {
  source = "../../terraform-submodules/kuard"
  # source = "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/kuard/0.0.0.zip"

  kubernetes_namespace       = data.kubernetes_namespace.this
  kubernetes_service_account = module.kuard_service_account.kubernetes_service_account
}
