module "test_platform" {
  source = "../../terraform-submodules/gke-platform"

  google_project = data.google_project.this
  platform_name  = "gogke-test-7"

  namespace_names = [
    "gomod-test-9",
    "kuard",
  ]
  namespace_iam_testers = {
    "gomod-test-9" = [
      "user:damlys.test@gmail.com",
    ],
  }
  namespace_iam_developers = {
    "kuard" = [
      "user:damlys.test@gmail.com",
    ]
  }
}
