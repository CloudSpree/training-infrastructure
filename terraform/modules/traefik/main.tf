resource "helm_release" "this" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://helm.traefik.io/traefik"
  chart            = "traefik"
  version          = var.chart_version
  wait             = var.wait
  atomic           = var.atomic

  values = [
    templatefile("${path.module}/values.yaml", {
      port_web       = var.port_web
      port_websecure = var.port_websecure
    })
  ]
}