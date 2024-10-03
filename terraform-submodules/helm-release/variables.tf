variable "repository" {
  type    = string
  default = null
}

variable "chart" {
  type = string
}

variable "chart_version" { # the "version" attribute is reserved by Terraform and cannot be used here
  type = string
}

variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "values" {
  type = list(string)
}

variable "skip_crds" {
  type    = bool
  default = false
}

variable "skip_tests" {
  type    = bool
  default = false
}

variable "timeout" {
  type    = number
  default = 300
}

variable "wait" {
  type    = bool
  default = true
}
