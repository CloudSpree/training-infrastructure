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

module "argo_rollouts" {
  source = "../../modules/argo_rollouts"
}

module "prometheus" {
  source = "../../modules/prometheus"

  depends_on = [
    module.traefik
  ]
}

resource "kubernetes_namespace" "staging" {
  metadata {
    name = "staging"
  }
}

resource "kubernetes_namespace" "production" {
  metadata {
    name = "production"
  }
}

resource "kubernetes_secret" "docker_credentials_staging" {
  metadata {
    name      = "docker-cfg"
    namespace = kubernetes_namespace.staging.metadata[0].name
  }

  data = {
    ".dockerconfigjson" = digitalocean_container_registry_docker_credentials.this.docker_credentials
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_secret" "docker_credentials_production" {
  metadata {
    name      = "docker-cfg"
    namespace = kubernetes_namespace.production.metadata[0].name
  }

  data = {
    ".dockerconfigjson" = digitalocean_container_registry_docker_credentials.this.docker_credentials
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_secret" "lightstep_staging" {
  metadata {
    name      = "lightstep-token"
    namespace = kubernetes_namespace.staging.metadata[0].name
  }
  data = {
    LIGHTSTEP_TOKEN = var.lightstep_token
  }
}

resource "kubernetes_secret" "lightstep_production" {
  metadata {
    name      = "lightstep-token"
    namespace = kubernetes_namespace.production.metadata[0].name
  }
  data = {
    LIGHTSTEP_TOKEN = var.lightstep_token
  }
}

resource "kubernetes_config_map" "environment_commin_staging" {
  metadata {
    name      = "environment-common"
    namespace = kubernetes_namespace.staging.metadata[0].name
  }

  data = {
    ENVIRONMENT_NAME = kubernetes_namespace.staging.metadata[0].name
  }
}

resource "kubernetes_config_map" "environment_commin_production" {
  metadata {
    name      = "environment-common"
    namespace = kubernetes_namespace.production.metadata[0].name
  }

  data = {
    ENVIRONMENT_NAME = kubernetes_namespace.production.metadata[0].name
  }
}
