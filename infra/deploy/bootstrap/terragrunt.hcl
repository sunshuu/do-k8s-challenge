include {
  path = find_in_parent_folders()
}

terraform {
  source = "../..//modules/bootstrap"
}

dependency "cluster" {
  config_path = "../cluster"
  mock_outputs = {
    cluster_host  = ""
    cluster_token = ""
    ca_cert       = ""
  }
}

inputs = {
  cluster_host  = dependency.cluster.host
  cluster_token = dependency.cluster.token
  ca_cert       = dependency.cluster.ca_cert
  github_owner = "sunshuu"
  github_token = get_env("GITHUB_TOKEN")
  repository_name = "do-k8s-challenge"
  branch = "work"
}