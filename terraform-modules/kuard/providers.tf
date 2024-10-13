provider "google" {
  project = "damlys-ace-1"
}

data "google_client_config" "oauth2" {
}

data "google_project" "this" {
}

data "google_container_cluster" "this" { # gke_damlys-ace-1_europe-central2-a_gkeconcept1
  location = "europe-central2-a"
  name     = "gkeconcept1"
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.this.endpoint}"
  token                  = data.google_client_config.oauth2.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.this.endpoint}"
    token                  = data.google_client_config.oauth2.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth[0].cluster_ca_certificate)
  }
  registry {
    url      = "oci://europe-central2-docker.pkg.dev/gogke-main-0/private-helm-charts"
    username = "oauth2accesstoken"
    password = data.google_client_config.oauth2.access_token
  }
}
