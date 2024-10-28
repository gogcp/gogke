provider "kubernetes" {
  host                   = "https://${google_container_cluster.this.endpoint}"
  token                  = var.google_client_config.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.this.master_auth[0].cluster_ca_certificate)
}
