variable "google_project" {
  type = object({
    project_id = string
  })
}

variable "registry_name" {
  type = string
}

variable "registry_location" {
  type = string
}

variable "iam_readers" {
  type    = list(string)
  default = []
}
variable "iam_writers" {
  type    = list(string)
  default = []
}
