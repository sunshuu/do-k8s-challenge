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

1. Set up environment with the following variables. Fill in the appropriate variables in the `templates/template_envrc` file and run `cp templates/template_envrc .envrc` from the repository's root directory.
2. Navigate to the `infra/deploy` directory and run `terragrunt run-all apply`


### Deploy Kubeflow

Use older version of kustomize

```
python3 -c 'from passlib.hash import bcrypt; import getpass; print(bcrypt.using(rounds=12, ident="2y").hash(getpass.getpass()))'
```

notes:
APP_SECURE_COOKIES set to false jupyter


- size of the nodes, needs a lot of memory
- volume limits 10, remember to delete them

`kubectl get svc -n istio-system istio-ingressgateway -o yaml | grep ip: | awk '{print $3}'`

Login with admin@cannedlobster.net
password is P@ssw0rd12345

### MNIST on Kubeflow

```
kubectl -n mnist create configmap docker-config --from-literal=config.json=$(kubectl get secrets -n flux-system docker-config -o yaml | grep dockerconfigjson: | awk '{print $2}' | base64 -d)
```
 tensorflow/tensorflow:1.15.0-jupyter

 pip install kubeflow-fairing

 git clone https://github.com/kubeflow/examples.git git_kubeflow-examples

 registry.digitalocean.com/cannedlobster-do-challenge