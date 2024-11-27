locals {
  gcp_region = "europe-central2"

  gsa = "service-${data.google_project.this.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
}
