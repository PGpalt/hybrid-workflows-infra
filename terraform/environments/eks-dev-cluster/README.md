# eks-dev-cluster

Minimal AWS foundation stage for the `eks-dev` demo cluster.

This environment creates only the AWS resources the current `clusters/eks-dev`
GitOps stack needs to run:

- a public-only VPC
- an EKS cluster with a public API endpoint
- one EKS managed node
- an S3 bucket for Argo Workflows artifacts
- the EKS Pod Identity Agent add-on
- EKS Pod Identity associations for the Argo service accounts that need S3 access

It intentionally does not add NAT gateways, private subnets, load balancers, or
extra worker pools. Those can come later if the demo grows beyond the current
operator + platform stack.

This stage is intentionally separate from `terraform/environments/eks-dev`,
which bootstraps Argo CD into an already existing EKS cluster.

## Workflow

1. Copy `terraform.tfvars.example` to `terraform.tfvars`.
2. Set `artifact_bucket_name`. If you cannot claim the current GitOps bucket
   name globally, change the GitOps repo to match the name you use here.
3. The infra demo defaults use `eu-north-1`. Keep the GitOps repo aligned with
   the same region and bucket name.
4. Run `make tf-init ENV=eks-dev-cluster`.
5. Run `make tf-plan ENV=eks-dev-cluster`.
6. Run `make tf-apply ENV=eks-dev-cluster`.
7. After the cluster becomes active, run the `kubectl_update_command` output to
   configure local Kubernetes access.
8. Continue with `terraform/environments/eks-dev` to bootstrap Argo CD.

For teardown, use:

1. `make tf-plan-destroy ENV=eks-dev-cluster`
2. `make tf-apply-destroy ENV=eks-dev-cluster`

## Demo Defaults

- Terraform automatically uses the first two available AZs in the region.
- Terraform automatically derives two public subnets from `vpc_cidr`.
- The demo node group is fixed at one `t3.medium` node.
- The artifact bucket is set to `force_destroy = true` so teardown is easier for
  an ephemeral demo cluster.

You will still incur EKS control-plane and EC2 costs as soon as you apply it.

## Demo Wiring

The cluster stage now creates Pod Identity associations for:

- `argo/argo-workflow`
- `argo/argo-server`

Keep those service account names aligned with the `eks-dev` Argo Workflows
Helm values in the GitOps repo.
