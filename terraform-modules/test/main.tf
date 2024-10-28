module "test_platform" {
  source = "../../terraform-submodules/gke-platform"

  google_client_config = data.google_client_config.oauth2

  google_project = data.google_project.this
  platform_name  = "gogke-test-7"

  namespace_names = [
    "gomod-test-9",
    "kuar-demo",
  ]
  namespace_iam_testers = {
    "gomod-test-9" = [
      "user:damlys.test@gmail.com",
    ],
  }
  namespace_iam_developers = {
    "kuar-demo" = [
      "user:damlys.test@gmail.com",
    ]
  }
}
