
variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "region" {
  type        = string
  default     = "sfo3"
  description = "Digital Ocean region for cluster"
}

variable "k8s_version" {
  type        = string
  default     = "1.21"
  description = "K8s latest version prefix to deploy"
}

variable "node_count" {
  type        = number
  default     = 3
  description = "Number of nodes in the cluster"
}

variable "node_size" {
  type        = string
  default     = "s-4vcpu-8gb"
  description = "Size of the nodes in the cluster"
}

variable "kube_path" {
  type = string
  description = "Path to the kubeconfig"
}