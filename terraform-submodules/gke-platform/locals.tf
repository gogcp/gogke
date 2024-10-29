locals {
  vpc_subnet_cidr = "10.1.0.0/20"
  gke_master_cidr = "10.0.0.0/28"
  gke_pod_cidr    = "10.2.0.0/20"
  gke_svc_cidr    = "10.3.0.0/20"

  all_namespace_names = toset(concat(
    tolist(var.namespace_names),
    keys(var.namespace_iam_testers),
    keys(var.namespace_iam_developers),
  ))
  all_namespace_iam_members = toset(flatten(concat(
    values(var.namespace_iam_testers),
    values(var.namespace_iam_developers),
  )))
}
