output "kubeconfig" {
  sensitive = true
  value     = digitalocean_kubernetes_cluster.this.kube_config[0].raw_config
}