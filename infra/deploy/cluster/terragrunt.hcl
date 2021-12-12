include {
  path = find_in_parent_folders()
}

terraform {
  source = "../..//modules/do-cluster"
}

inputs = {
  cluster_name = "do-challenge"
}