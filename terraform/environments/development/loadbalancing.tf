resource "digitalocean_certificate" "wildcard" {
  name = "wildcard-dev-stepanvrany-cz"
  type = "lets_encrypt"
  domains = [
    "stepanvrany.cz",
    "*.dev.stepanvrany.cz",
  ]
}

resource "digitalocean_loadbalancer" "public" {
  name   = var.environment
  region = var.region

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = module.traefik.port_websecure
    target_protocol = "https"

    certificate_name = digitalocean_certificate.wildcard.name
  }

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = module.traefik.port_web
    target_protocol = "http"
  }

  healthcheck {
    port                   = module.traefik.port_web
    protocol               = "tcp"
    check_interval_seconds = 3
  }

  droplet_tag = "environment:${var.environment}"
}

resource "digitalocean_record" "wildcard" {
  domain = data.digitalocean_domain.stepanvrany_cz.id
  type   = "A"
  name   = "*.dev"
  value  = digitalocean_loadbalancer.public.ip
}