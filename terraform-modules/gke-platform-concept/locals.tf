locals {
  gcp_location = "EU"
  gcp_region   = "europe-central2"
  gcp_zones    = ["europe-central2-a"]
  gcp_zone     = local.gcp_zones[0]

  gke_version = "1.30.3-gke.1969001" # gcloud container get-server-config --region="europe-central2-a" --flatten="channels" --filter="channels.channel=STABLE" --format="value(channels.defaultVersion)"

  vpc_subnet_cidr   = "10.1.0.0/20"
  gke_master_cidr   = "10.0.0.0/28"
  gke_pods_cidr     = "10.2.0.0/20"
  gke_services_cidr = "10.3.0.0/20"
}
