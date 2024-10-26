variable "google_project" {
  type = object({
    project_id = string
    number     = number
  })
}

variable "platform_name" {
  type = string
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
