# Digital Ocean Kubernetes Challenge 2021

Sunny Xu's submission to Digital Ocean's 2021 Kubernetes Challenge.

Attempted Challenge: Deploy a machine learning managemetn platform

List of Tasks Performed:

- Deploy Infrastructure on Digital Ocean
- Bootstrap management workloads
- Install Kubeflow
- Setup authentication
- Verify functionality

## Tasks
---

### Deploy Infastructure

Terraform (and terragrunt as a wrapper) is used to manage the infrastructure and bootstrap Flux.

Terraform has a fairly simple provider available for Digital Ocean resources, which for this challenge we will only be needing the `kubernetes_cluster`. Something to note that is nice to see is that there is an `auto_upgrade` option which will keep the cluster up to date with the latest patches. Pretty handy I think.

Bootstrapping the cluster with FLux offers some pros and cons but if this were more of a production environment, I would say that this is an extremely useful tool to make sure all the resources in the cluster is being tracked with GitOps. We are using it here to ensure all the components we install can be consistent across different deployments (hopefully!).

1. Set up environment with the following variables.
```
export DIGITALOCEAN_TOKEN=<digital ocean token>
export FLUX_TOKEN=<flux token to pull from git>
```
2. Navigate to the `infra/deploy` directory and run `terragrunt run-all apply`