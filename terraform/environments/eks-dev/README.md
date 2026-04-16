# eks-dev

Argo CD bootstrap stage for the existing `eks-dev` demo cluster.

This environment assumes the AWS foundation layer already exists, typically from
`terraform/environments/eks-dev-cluster`.

It is responsible for:

- connecting Terraform to the demo EKS cluster through the AWS provider
- installing Argo CD with the Helm provider
- creating the Argo CD root `Application`
- pointing that root `Application` at `clusters/eks-dev` in the GitOps repo

It intentionally does not create the VPC, EKS control plane, node groups, or
artifact bucket. Those belong to the separate AWS foundation stage.

## Workflow

1. Apply `terraform/environments/eks-dev-cluster` first.
2. Run `aws eks update-kubeconfig --region <region> --name <cluster-name> --profile <profile>`.
3. Copy `terraform.tfvars.example` to `terraform.tfvars`.
4. Set `argocd_admin_password`.
5. Run `make tf-init ENV=eks-dev`.
6. Run `make tf-plan ENV=eks-dev`.
7. Run `make tf-apply ENV=eks-dev`.
8. Run `make tf-plan-root ENV=eks-dev`.
9. Run `make tf-apply-root ENV=eks-dev`.

The split between `tf-apply` and `tf-apply-root` is still deliberate: Argo CD
must exist before Terraform can create the root `Application` CR.

## Current Demo Assumptions

- the foundation cluster name is `hybrid-workflows-eks-dev`
- the infra default region is `eu-north-1`
- the GitOps repo still points Argo Workflows at the
  `hybrid-workflows-eks-dev-artifacts` S3 bucket
- the GitOps repo uses service account names `argo-workflow` and `argo-server`
  for the Pod Identity associations created by infra

If you change those values in the foundation stage, update the GitOps repo to
match.
