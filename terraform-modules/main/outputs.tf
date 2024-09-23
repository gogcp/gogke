output "gcp_projects" {
  value = [
    module.main_project.google_project.project_id,
    module.test_project.google_project.project_id,
    module.prod_project.google_project.project_id,
  ]
}

output "terraform_state_buckets" {
  value = [
    module.main_terraform_state_bucket.google_storage_bucket.name
  ]
}
