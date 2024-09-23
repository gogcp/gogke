output "gcp_projects" {
  value = [
    module.main_project.google_project.project_id,
    module.test_project.google_project.project_id,
    module.prod_project.google_project.project_id,
  ]
}
