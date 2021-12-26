terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "digitalocean" {}

data "digitalocean_kubernetes_versions" "k8s_version" {
  version_prefix = var.k8s_version
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name         = var.cluster_name
  region       = var.region
  auto_upgrade = true
  version      = data.digitalocean_kubernetes_versions.k8s_version.latest_version

  maintenance_policy {
    start_time = "04:00"
    day        = "sunday"
  }

  node_pool {
    name       = "worker-pool"
    size       = var.node_size
    node_count = var.node_count
  }
}

resource "digitalocean_container_registry" "registry" {
  name                   = var.registry_name
  subscription_tier_slug = "starter"
}

resource "local_file" "kube_config" {
  filename = var.kube_path
  sensitive_content = digitalocean_kubernetes_cluster.cluster.kube_config[0].raw_config
  file_permission = "0400"
}