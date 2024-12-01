#######################################
###
#######################################

resource "google_project_iam_member" "secret_manager_admin" {
  project = data.google_project.this.project_id
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${local.gsa}"
}

#######################################
### GitHub personal access token
#######################################

resource "google_secret_manager_secret" "github_token" {
  project   = data.google_project.this.project_id
  secret_id = "github-token"

  replication {
    auto {
    }
  }
}

resource "google_secret_manager_secret_version" "github_token" {
  secret      = google_secret_manager_secret.github_token.id
  secret_data = var.github_token
}

resource "google_secret_manager_secret_iam_member" "github_token" {
  project   = data.google_project.this.project_id
  secret_id = google_secret_manager_secret.github_token.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${local.gsa}"
}

#######################################
### GitHub repository connection
#######################################

resource "google_cloudbuildv2_connection" "github" {
  depends_on = [
    google_secret_manager_secret_iam_member.github_token,
  ]

  project  = data.google_project.this.project_id
  location = local.gcp_region
  name     = "github"

  github_config {
    app_installation_id = "57695585" # https://github.com/settings/installations/57695585
    authorizer_credential {
      oauth_token_secret_version = google_secret_manager_secret_version.github_token.id
    }
  }
}

data "github_repository" "gogcp" {
  full_name = "damlys/gogcp"
}

resource "google_cloudbuildv2_repository" "gogcp" {
  project           = data.google_project.this.project_id
  location          = local.gcp_region
  parent_connection = google_cloudbuildv2_connection.github.name
  name              = data.github_repository.gogcp.full_name
  remote_uri        = data.github_repository.gogcp.http_clone_url
}

#######################################
### task, steps, trigger
#######################################

resource "google_service_account" "todo" {
  project    = data.google_project.this.project_id
  account_id = "todo-build"
}

resource "google_cloudbuild_trigger" "todo" {
  project     = data.google_project.this.project_id
  location    = local.gcp_region
  name        = "push"
  description = "push github.com/damlys/gogcp terraform-modules/build concept/build"

  repository_event_config {
    repository = google_cloudbuildv2_repository.gogcp.id
    push {
      branch = "^concept/build$"
    }
  }
  included_files = ["terraform-modules/build/**"]

  service_account = google_service_account.todo.id
  build {
    step {
      name   = "debian"
      script = "ls -l"
    }
  }
}
