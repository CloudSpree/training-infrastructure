resource "digitalocean_kubernetes_cluster" "this" {
  name    = var.environment
  region  = var.region
  version = data.digitalocean_kubernetes_versions.k8s_versions.latest_version

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 3

    labels = {
      "k8s.cloudspree.cz/environment" = "development"
    }

    tags = [
      "environment:${var.environment}",
    ]
  }

  tags = [
    "environment:${var.environment}",
  ]
}

resource "digitalocean_firewall" "this" {
  name = "only-22-80-and-443"

  tags = [
    "environment:${var.environment}",
  ]

  inbound_rule {
    protocol   = "tcp"
    port_range = module.traefik.port_web
    source_load_balancer_uids = [
      digitalocean_loadbalancer.public.id,
    ]
  }

  inbound_rule {
    protocol   = "tcp"
    port_range = module.traefik.port_websecure
    source_load_balancer_uids = [
      digitalocean_loadbalancer.public.id,
    ]
  }

  outbound_rule {
    protocol              = "tcp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
    port_range            = "1-65535"
  }

  outbound_rule {
    protocol              = "udp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
    port_range            = "1-65535"
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

data "digitalocean_container_registry" "this" {
  name = "cloudspree"
}

resource "digitalocean_container_registry_docker_credentials" "this" {
  registry_name = data.digitalocean_container_registry.this.name
}

resource "kubernetes_secret" "docker_credentials" {
  metadata {
    name      = "docker-cfg"
    namespace = "default"
  }

  data = {
    ".dockerconfigjson" = digitalocean_container_registry_docker_credentials.this.docker_credentials
  }

  type = "kubernetes.io/dockerconfigjson"
}