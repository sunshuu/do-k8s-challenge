include {
  path = find_in_parent_folders()
}

terraform {
  source = "../..//modules/do-cluster"
}

inputs = {
  cluster_name = "sunshuu-kubeflow"
  kube_path    = "${get_parent_terragrunt_dir()}/../../kube/config"
}