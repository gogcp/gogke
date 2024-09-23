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
