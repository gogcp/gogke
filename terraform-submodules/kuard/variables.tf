variable "kubernetes_namespace" {
  type = object({
    metadata = list(object({
      name = string
    }))
  })
}

variable "kubernetes_service_account" {
  type = object({
    metadata = list(object({
      name = string
    }))
  })
}
