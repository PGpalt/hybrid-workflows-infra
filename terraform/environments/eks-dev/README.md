# eks-dev

Placeholder for the future `eks-dev` environment.

The plan is to reuse the same Terraform bootstrap pattern as `minikube`:

- create or connect to the target cluster
- install Argo CD with the Helm provider
- create bootstrap secrets with the Kubernetes provider
- point the root Argo CD `Application` at `clusters/eks-dev` in the GitOps repo

This directory is intentionally lightweight until the Minikube bootstrap flow is
proven end to end.
