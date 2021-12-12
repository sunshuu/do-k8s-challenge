
variable "cluster_host" {
  type        = string
  description = "Endpoint to connect to K8s cluster"
}

variable "cluster_token" {
  type        = string
  description = "Token to authenticate to K8s cluster"
}

variable "cluster_cacert" {
  type        = string
  description = "CA Certificate to connect to K8s cluster"
}

variable "target_path" {
  type = string
  default = "workloads"
  description = "flux sync target path"
}

variable "github_owner" {
  type        = string
  description = "github owner"
}

variable "github_token" {
  type        = string
  description = "github token"
}

variable "repository_name" {
  type        = string
  default     = "test-provider"
  description = "github repository name"
}

variable "branch" {
  type        = string
  default     = "main"
  description = "branch name"
}