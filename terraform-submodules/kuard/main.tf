resource "kubernetes_namespace" "this" {
  metadata {
    name = "kuard"
  }
}

module "helm_release" {
  source = "../helm-release" # TODO
  # source = "gcs::https://www.googleapis.com/storage/v1/gogke-main-0-private-terraform-modules/gogke/helm-release/0.0.0.zip"

  chart = "../../helm-charts/kuard" # TODO
  # repository    = "oci://europe-central2-docker.pkg.dev/gogke-main-0/private-helm-charts"
  # chart         = "gogke/kuard"
  # chart_version = "0.0.0"

  namespace = kubernetes_namespace.this.metadata[0].name
  name      = "kuard"
  values    = [file("${path.module}/assets/values.yaml")]
}
