# hybrid-workflows-infra

Terraform bootstrap for the Hybrid Workflows platform.

The current focus is a Terraform-first bootstrap flow for Minikube plus a
minimal `eks-dev` EKS demo path that we can evolve later toward `eks-prod`.

## Scope

This repo is intended to own cluster bootstrap concerns and the minimal AWS
foundation scaffolding needed by EKS demo environments:

- connect Terraform to an existing Kubernetes cluster
- optionally create AWS foundation resources for EKS environments
- install Argo CD with the Helm provider
- set the Argo CD admin password through local Terraform variables
- create bootstrap namespaces and runtime-owned secrets with the Kubernetes provider
- create the Argo CD root `Application` that hands off to the GitOps repo

The GitOps repo remains the source of truth for platform workloads, overlays,
and app-of-apps structure.

## Current layout

```text
terraform/
  environments/
    minikube/
    eks-dev-cluster/
    eks-dev/
    eks-prod/
  modules/
    argocd-bootstrap/
    argocd-root-application/
    eks-foundation/
```

## Minikube workflow

1. Start Minikube outside Terraform.
2. Copy `terraform/environments/minikube/terraform.tfvars.example` to a local
   `terraform.tfvars`.
3. Set `argocd_admin_password`, `minio_access_key`, and `minio_secret_key` in
   that local file.
4. Run `make tf-init ENV=minikube`.
5. Run `make tf-plan ENV=minikube`.
6. Run `make tf-apply ENV=minikube`.
7. Run `make tf-plan-root ENV=minikube`.
8. Run `make tf-apply-root ENV=minikube`.
9. If you want the local Slurm demo path and example dataset seeding, run
   `bash scripts/setup.sh` from the sibling `hybrid-workflows-operator` repo.

The split between `tf-apply` and `tf-apply-root` is deliberate. Argo CD is
installed by Helm first, and only after its CRDs exist do we create the root
`Application` with the Kubernetes provider.

The `Makefile` uses saved plan files by default so `apply` uses the exact plan
you reviewed. Those local plan artifacts are ignored by Git.

## EKS Dev Workflow

`eks-dev` now uses two Terraform stages:

1. `terraform/environments/eks-dev-cluster` creates the minimal AWS/EKS demo
   foundation.
2. `terraform/environments/eks-dev` bootstraps Argo CD into that existing EKS
   cluster and creates the root `Application`.

Typical flow:

1. Copy `terraform/environments/eks-dev-cluster/terraform.tfvars.example` to a
   local `terraform.tfvars`.
2. Set the artifact bucket name that the `clusters/eks-dev` GitOps overlay will
   use.
3. Run `make tf-init ENV=eks-dev-cluster`.
4. Run `make tf-plan ENV=eks-dev-cluster`.
5. Run `make tf-apply ENV=eks-dev-cluster`.
6. Run the `kubectl_update_command` output to configure local Kubernetes access.
7. Copy `terraform/environments/eks-dev/terraform.tfvars.example` to a local
   `terraform.tfvars`.
8. Set `argocd_admin_password`.
9. Run `make tf-init ENV=eks-dev`.
10. Run `make tf-plan ENV=eks-dev`.
11. Run `make tf-apply ENV=eks-dev`.
12. Run `make tf-plan-root ENV=eks-dev`.
13. Run `make tf-apply-root ENV=eks-dev`.

The current `clusters/eks-dev` GitOps overlay assumes:

- infra default region `eu-north-1`
- bucket `hybrid-workflows-eks-dev-artifacts`
- Pod Identity-aligned Argo service account names `argo-workflow` and `argo-server`

For `eks-dev`, Terraform owns the Argo CD install and the root `Application`.
Argo CD then owns the `argo` namespace and the platform workloads under
`clusters/eks-dev`.

## Minikube assumptions

- Minikube is already running.
- Your kubeconfig has a `minikube` context.
- The sibling GitOps repo contains `clusters/minikube`.
- The Argo CD admin password and MinIO credentials are provided through local
  Terraform variables and are not committed.

## Forking This Stack

If you fork the three repos and want infra to bootstrap from your own GitOps
repo, set `gitops_repo_url` in your local `terraform.tfvars` for the bootstrap
environments (`minikube`, `eks-dev`). The default values in
[terraform/environments/minikube/variables.tf](/workspaces/hybrid-workflows-infra/terraform/environments/minikube/variables.tf:13)
and [terraform/environments/eks-dev/variables.tf](/workspaces/hybrid-workflows-infra/terraform/environments/eks-dev/variables.tf:18)
still point at `https://github.com/PGpalt/hybrid-workflows-gitops.git`.

You may also want to override `gitops_target_revision` if your GitOps repo uses
a different default branch.
