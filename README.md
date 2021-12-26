# Digital Ocean Kubernetes Challenge 2021

Sunny Xu's submission to Digital Ocean's 2021 Kubernetes Challenge.

Attempted Challenge: Deploy a machine learning managemetn platform

List of Tasks Performed:

- Deploy Infrastructure on Digital Ocean
- Deploy Kubeflow and access it

### Prerequisites

- (terraform)[https://www.terraform.io/downloads] and (terragrunt)[https://terragrunt.gruntwork.io/docs/getting-started/install/]
- (direnv)[https://direnv.net/]
- (kubectl)[https://kubernetes.io/docs/tasks/tools/]
- (Flux CLI)[https://fluxcd.io/docs/installation/]
- (K9s (optional))[https://github.com/derailed/k9s]

- AWS S3 Credentials and Bucket name to use as the Terraform Backend.
  - If this is not desired, delete the `remote_state` block in `infra/deploy/terragrunt.hcl`
- DigitalOcean Token
- GitHub Repository token

### Deploy Infastructure

Terraform (and terragrunt as a wrapper) is used to manage the infrastructure and bootstrap Flux.

Terraform has a fairly simple provider available for Digital Ocean resources, which for this challenge we will only be needing the `kubernetes_cluster`. Something to note that is nice to see is that there is an `auto_upgrade` option which will keep the cluster up to date with the latest patches.

Bootstrapping the cluster with Flux offers some pros and cons but if this were more of a production environment, I would say that this is an extremely useful tool to make sure all the resources in the cluster is being tracked with GitOps. We are using it here to ensure all the components we install can be consistent across different deployments.

1. Set up environment with the following variables. Fill in the appropriate variables in the `templates/template_envrc` file and run `cp templates/template_envrc .envrc` from the repository's root directory.
2. If any additional configuration is desired, modify the `terragrunt.hcl` files accordingingly under the `infra/deploy` directories.
3. Navigate to the `infra/deploy` directory and run `terragrunt run-all apply`

So what got deployed after running `terragrunt`? First a Digital Ocean K8s cluster got deployed and its kubeneretes configuration file was created in your repository's root directory. With that, you will be able to run `kubectl get nodes` to verify that the cluster is up and running. A Digital Ocean container registry has also been deployed which is required for some pipeline runs in Kubeflow.


### Deploy Kubeflow

Once the cluster is up, the bootstrapped flux workloads will start deploying raw K8s manifests within this directory. Since there are some resources that depends on others, `Kustomize` is used to ensure the correct order of deployments. This will ensure that deployments will remain consistent.

Kubeflow quite a few components so it will take a while for it to come up. You can verify progress by running `kubectl -n flux-system get kustomization`. In additional to waiting for Kubeflow to be ready, the load balancer to access the workloads will need to be provisioned by Digital Ocean. To verify that it's ready, see if the `EXTERNAL-IP` attribute has been set when you run `kubectl get svc -n istio-system istio-ingressgateway`.

If everything looks good, go ahead and use the web browser to access the IP from this command: `kubectl get svc -n istio-system istio-ingressgateway -o yaml | grep ip: | awk '{print $3}'`. You should be directed to a Dex login page. Use username: `admin@cannedlobster.net` and password: `P@ss0wrd12345`. Instructions to change this will be included below.

Now you have access to Kubeflow! There are tutorials in the home page and examples found here: https://github.com/kubeflow/examples.

### FAQ

How were the K8s manifests generated to deploy Kubeflow?

> (These installation steps)[https://github.com/kubeflow/manifests#installation] will show how kustomize can be used to install it. WARNING: Ensure that you install the right version of kustomize (3.2.0) or else it will not work.

How to change the credentials for the login page?

> You will need to create a hash for the new password. Use python command below to accomplish that. Once you have the hash, go to `kubeflow/prereqs/configs.yaml` and search `staticPasswords`. There should be an email you can change as well as the password hash. 

```
python3 -c 'from passlib.hash import bcrypt; import getpass; print(bcrypt.using(rounds=12, ident="2y").hash(getpass.getpass()))'

# kubeflow/preqreqs/configs.yaml (search staticPasswords)
    enablePasswordDB: true
    staticPasswords:
    - email: admin@cannedlobster.net # < Change this
      hash: $2y$12$2eShO0mUpXMD9gw7R9.C7ey1ghYBUhZWS3eP8iS9QcQ/nMdmUtWC. # < Change this
      # https://github.com/dexidp/dex/pull/1601/commits
      # FIXME: Use hashFromEnv instead
      username: admin
```

Some pods are not coming up because the PVCs aren't being provisioned.

> It is possible that you may have reached the max limit of Digital Ocean volumes that can be provisioned for your account (usually 10). Go to your console and navigate to your volumes page. Delete any unused volumes.

I cannot run `terragrunt run-all destroy`.

> Some resources and namespaces are stubborn and refuse to be deleted. It is easier to just delete it from the cluster directory and remove the tfstate for bootstrap manually.

### Additional Notes

> Environment variable `APP_SECURE_COOKIES` were set the false for jupyter. Required because it is being accessed via HTTP instead of HTTPS.

> Don't forget to delete your Load Balancers when cleaning up your cluster.
