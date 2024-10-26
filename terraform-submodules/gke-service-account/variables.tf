variable "google_project" {
  type = object({
    project_id = string
  })
}

variable "google_container_cluster" {
  type = object({
    location = string
    name     = string
  })
}

variable "kubernetes_namespace" {
  type = object({
    metadata = list(object({
      name = string
    }))
  })
}

variable "service_account_name" {
  type = string
  validation { # min=6 and max=30 for google service account, but there is a "gke-" prefix added
    condition     = length(var.service_account_name) >= 2 && length(var.service_account_name) <= 26
    error_message = "Value must be between 2 and 26 characters."
  }
}
