variable "project_id" {
  type = string
}

variable "project_name" {
  type = string
}

variable "billing_account_id" {
  type    = string
  default = null
}

variable "services" {
  type = list(string)
  default = [
    "artifactregistry.googleapis.com",
    "compute.googleapis.com",
    "dns.googleapis.com",
  ]
}

variable "firebase_enabled" {
  type    = bool
  default = false
}

variable "iam_viewers" {
  type    = list(string)
  default = []
}
variable "iam_editors" {
  type    = list(string)
  default = []
}
variable "iam_owners" {
  type    = list(string)
  default = []
}
