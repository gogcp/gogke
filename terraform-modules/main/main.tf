#######################################
### GCP projects
#######################################

module "main_project" {
  source = "../../terraform-submodules/gcp-project"

  project_id   = "gogke-main-0"
  project_name = "gogke-main-0"
}

module "test_project" {
  source = "../../terraform-submodules/gcp-project"

  project_id   = "gogke-test-0"
  project_name = "gogke-test-0"
}

module "prod_project" {
  source = "../../terraform-submodules/gcp-project"

  project_id   = "gogke-prod-0"
  project_name = "gogke-prod-0"
}

#######################################
### Terraform state buckets
#######################################

module "terraform_state_bucket" {
  source = "../../terraform-submodules/gcp-terraform-state-bucket"

  google_project  = module.main_project.google_project
  bucket_name     = "terraform-state"
  bucket_location = local.gcp_region
}

#######################################
### Docker images registries
#######################################

module "public_docker_images_registry" {
  source = "../../terraform-submodules/gcp-docker-images-registry"

  google_project    = module.main_project.google_project
  registry_name     = "public-docker-images"
  registry_location = local.gcp_region

  iam_readers = ["allUsers"]
}

module "private_docker_images_registry" {
  source = "../../terraform-submodules/gcp-docker-images-registry"

  google_project    = module.main_project.google_project
  registry_name     = "private-docker-images"
  registry_location = local.gcp_region

  iam_readers = [
    "serviceAccount:gogke-test-7-gke-node@gogke-test-0.iam.gserviceaccount.com",
  ]
}

#######################################
### Helm charts registries
#######################################

module "public_helm_charts_registry" {
  source = "../../terraform-submodules/gcp-helm-charts-registry"

  google_project    = module.main_project.google_project
  registry_name     = "public-helm-charts"
  registry_location = local.gcp_region

  iam_readers = ["allUsers"]
}

module "private_helm_charts_registry" {
  source = "../../terraform-submodules/gcp-helm-charts-registry"

  google_project    = module.main_project.google_project
  registry_name     = "private-helm-charts"
  registry_location = local.gcp_region
}

#######################################
### Terraform submodules registries
#######################################

module "public_terraform_modules_registry" {
  source = "../../terraform-submodules/gcp-terraform-modules-registry"

  google_project    = module.main_project.google_project
  registry_name     = "public-terraform-modules"
  registry_location = local.gcp_region

  iam_readers = ["allUsers"]
}

module "private_terraform_modules_registry" {
  source = "../../terraform-submodules/gcp-terraform-modules-registry"

  google_project    = module.main_project.google_project
  registry_name     = "private-terraform-modules"
  registry_location = local.gcp_region
}
