resource "helm_release" "this" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = var.chart_version
  wait             = var.wait
  atomic           = var.atomic

  values = [
    templatefile("${path.module}/values.yaml", {})
  ]
}