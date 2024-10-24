module "test_platform" {
  source = "../../terraform-submodules/gke-platform"

  google_project = data.google_project.this
  platform_name  = "gogke-test-7"
}
