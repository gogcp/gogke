variable "google_project" {
  type = object({
    project_id = string
    number     = number
  })
}

variable "platform_name" {
  type = string
}

variable "namespaces" {
  type    = set(string)
  default = []
}

variable "iam_viewers" {
  type    = map(set(string))
  default = {}
}
variable "iam_developers" {
  type    = map(set(string))
  default = {}
}
