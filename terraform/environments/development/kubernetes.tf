module "traefik" {
  source = "../../modules/traefik"
}

module "argocd" {
  source   = "../../modules/argo_cd"
  hostname = "argocd.dev.stepanvrany.cz"

  depends_on = [
    module.traefik
  ]
}