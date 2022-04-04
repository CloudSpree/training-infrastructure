resource "helm_release" "this" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-rollouts"
  version          = var.chart_version
  wait             = var.wait
  atomic           = var.atomic

  values = [
    templatefile("${path.module}/values.yaml", {})
  ]
}