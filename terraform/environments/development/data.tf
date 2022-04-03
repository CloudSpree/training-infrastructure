data "digitalocean_kubernetes_versions" "k8s_versions" {
  version_prefix = "1.22."
}

data "digitalocean_domain" "stepanvrany_cz" {
  name = "stepanvrany.cz"
}