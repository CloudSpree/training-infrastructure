resource "digitalocean_container_registry" "this" {
  name                   = "cloudspree"
  subscription_tier_slug = "basic"
  region                 = var.region
}
