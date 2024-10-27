locals {
  desc = "cluster: gke_${var.google_project.project_id}_${var.google_container_cluster.location}_${var.google_container_cluster.name}, namespace: ${var.kubernetes_namespace.metadata[0].name}, name: ${var.service_account_name}"
  hash = substr(sha256(local.desc), 0, 5)
}
