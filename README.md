# hybrid-workflows-infra

Terraform bootstrap for the Hybrid Workflows platform.

The current focus is a Terraform-first Minikube bootstrap that proves the
workflow we want to reuse later for `eks-dev` and `eks-prod`.

## Scope

This repo is intended to own cluster bootstrap concerns:

- connect Terraform to an existing Kubernetes cluster
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
    eks-dev/
    eks-prod/
  modules/
    argocd-bootstrap/
    argocd-root-application/
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

## Minikube assumptions

- Minikube is already running.
- Your kubeconfig has a `minikube` context.
- The sibling GitOps repo contains `clusters/minikube`.
- The Argo CD admin password and MinIO credentials are provided through local
  Terraform variables and are not committed.

## Forking This Stack

If you fork the three repos and want infra to bootstrap from your own GitOps
repo, set `gitops_repo_url` in your local `terraform.tfvars`. The default value
in [terraform/environments/minikube/variables.tf]
still points at `https://github.com/PGpalt/hybrid-workflows-gitops.git`.

You may also want to override `gitops_target_revision` if your GitOps repo uses
a different default branch.
