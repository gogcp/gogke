variable "google_client_config" {
  description = "oauth2"
  type = object({
    access_token = string
  })
}

variable "google_project" {
  type = object({
    project_id = string
    number     = number
  })
}

variable "platform_name" {
  type = string
}

variable "platform_region" {
  type    = string
  default = "europe-central2"
}

variable "platform_zones" {
  type    = set(string)
  default = ["europe-central2-a"]
}

variable "namespace_names" {
  type    = set(string)
  default = []
}

variable "namespace_iam_testers" {
  type    = map(set(string))
  default = {}
}
variable "namespace_iam_developers" {
  type    = map(set(string))
  default = {}
}
