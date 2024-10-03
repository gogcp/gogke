data "helm_template" "this" {
  repository = var.repository
  chart      = var.chart
  version    = var.chart_version

  name       = var.name
  namespace  = var.namespace
  values     = var.values
  skip_crds  = var.skip_crds
  skip_tests = var.skip_tests
  timeout    = var.timeout
  wait       = var.wait
}

resource "kubernetes_manifest" "this" {
  for_each = {
    for m in [
      for n in split("\n---\n", data.helm_template.this.manifest)
      : yamldecode(n)
    ]
    : "${m.apiVersion}/${m.kind}/${try(m.metadata.namespace, "-")}/${m.metadata.name}" => m
  }
  manifest = each.value
}
