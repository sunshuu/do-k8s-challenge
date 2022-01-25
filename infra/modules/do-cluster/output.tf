
output "host" {
  value     = digitalocean_kubernetes_cluster.cluster.endpoint
  sensitive = true
}

output "token" {
  value     = digitalocean_kubernetes_cluster.cluster.kube_config[0].token
  sensitive = true
}

output "ca_cert" {
  value     = base64decode(digitalocean_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate)
  sensitive = true
}

output "kube_config" {
  value     = digitalocean_kubernetes_cluster.cluster.kube_config[0].raw_config
  sensitive = true
}

output "registry_name" {
  value = digitalocean_container_registry.registry.name
}

output "registry_endpoint" {
  value = digitalocean_container_registry.registry.endpoint
}