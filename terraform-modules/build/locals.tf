locals {
  gcp_region = "europe-west1" # https://cloud.google.com/build/docs/locations#restricted_regions_for_some_projects

  gsa = "service-${data.google_project.this.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
}
