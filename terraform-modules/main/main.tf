#######################################
### GCP projects
#######################################

module "main_project" {
  source = "../../terraform-submodules/gcp-project"

  project_id   = "gogke-main-0"
  project_name = "gogke-main"
}

module "test_project" {
  source = "../../terraform-submodules/gcp-project"

  project_id   = "gogke-test-0"
  project_name = "gogke-test"
}

module "prod_project" {
  source = "../../terraform-submodules/gcp-project"

  project_id   = "gogke-prod-0"
  project_name = "gogke-prod"
}

#######################################
### Terraform state buckets
#######################################

module "main_terraform_state_bucket" {
  source = "../../terraform-submodules/gcp-terraform-state-bucket"

  google_project  = module.main_project.google_project
  bucket_name     = "tfstate"
  bucket_location = local.gcp_region
}
