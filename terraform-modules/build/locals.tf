locals {
  docker_images        = setsubtract(toset([for _, v in fileset("${path.root}/../../docker-images", "**") : split("/", dirname(v))[0]]), ["."])
  helm_charts          = setsubtract(toset([for _, v in fileset("${path.root}/../../helm-charts", "**") : split("/", dirname(v))[0]]), ["."])
  helm_releases        = setsubtract(toset([for _, v in fileset("${path.root}/../../helm-releases", "**") : split("/", dirname(v))[0]]), ["."])
  kubernetes_manifests = setsubtract(toset([for _, v in fileset("${path.root}/../../kubernetes-manifests", "**") : split("/", dirname(v))[0]]), ["."])
  terraform_modules    = setsubtract(toset([for _, v in fileset("${path.root}/../../terraform-modules", "**") : split("/", dirname(v))[0]]), ["."])
  terraform_submodules = setsubtract(toset([for _, v in fileset("${path.root}/../../terraform-submodules", "**") : split("/", dirname(v))[0]]), ["."])
}
output "debug" {
  value = {
    docker_images        = local.docker_images
    helm_charts          = local.helm_charts
    helm_releases        = local.helm_releases
    kubernetes_manifests = local.kubernetes_manifests
    terraform_modules    = local.terraform_modules
    terraform_submodules = local.terraform_submodules
  }
}
