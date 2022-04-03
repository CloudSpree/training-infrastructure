resource "helm_release" "this" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version
  wait             = var.wait
  atomic           = var.atomic

  values = [
    templatefile("${path.module}/values.yaml", {})
  ]
}

resource "kubernetes_manifest" "ingress_route" {
  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "IngressRoute"
    metadata = {
      name      = "argo-cd"
      namespace = var.namespace
    }
    spec = {
      entryPoints = ["web", "websecure"]
      routes = [
        {
          match = "Host(`${var.hostname}`) && PathPrefix(`/`)"
          kind  = "Rule"
          services = [
            {
              name   = "argocd-server"
              port   = 443
              scheme = "https"
            }
          ]
        }
      ]
    }
  }
}