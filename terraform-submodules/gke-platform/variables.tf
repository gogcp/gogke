variable "google_project" {
  type = object({
    project_id = string
    number     = number
  })
}

variable "platform_name" {
  type = string
}
