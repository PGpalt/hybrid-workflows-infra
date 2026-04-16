variable "aws_region" {
  description = "AWS region where the target EKS cluster exists."
  type        = string
  default     = "eu-north-1"
}

variable "aws_profile" {
  description = "AWS shared config profile used for Terraform operations."
  type        = string
  default     = "eks-dev"
}

variable "eks_cluster_name" {
  description = "Name of the existing EKS cluster that Terraform should bootstrap."
  type        = string
  default     = "hybrid-workflows-eks-dev"
}

variable "gitops_repo_url" {
  description = "GitOps repository URL consumed by the root Argo CD Application."
  type        = string
  default     = "https://github.com/PGpalt/hybrid-workflows-gitops.git"
}

variable "gitops_target_revision" {
  description = "Git revision for the GitOps repository."
  type        = string
  default     = "main"
}

variable "gitops_cluster_path" {
  description = "Environment path inside the GitOps repository."
  type        = string
  default     = "clusters/eks-dev"
}

variable "root_application_name" {
  description = "Root Application name for the eks-dev environment."
  type        = string
  default     = "eks-dev-root"
}

variable "enable_root_application" {
  description = "Whether to create the root Argo CD Application after Argo CD CRDs exist."
  type        = bool
  default     = false
}

variable "argocd_chart_version" {
  description = "Pinned Argo CD Helm chart version."
  type        = string
  default     = "7.8.2"
}

variable "argocd_namespace" {
  description = "Namespace where Argo CD will be installed."
  type        = string
  default     = "argocd"
}

variable "argocd_release_name" {
  description = "Helm release name for Argo CD."
  type        = string
  default     = "argocd"
}

variable "argocd_server_service_type" {
  description = "Kubernetes service type for the Argo CD server on EKS."
  type        = string
  default     = "ClusterIP"
}

variable "argocd_admin_password" {
  description = "Argo CD admin password managed by Terraform for the eks-dev environment."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.argocd_admin_password) > 0
    error_message = "Set argocd_admin_password in terraform.tfvars."
  }
}

variable "argo_namespace" {
  description = "Namespace used by Argo Workflows and related runtime resources."
  type        = string
  default     = "argo"
}

variable "argocd_wait" {
  description = "Whether Helm should wait for Argo CD resources to become ready."
  type        = bool
  default     = true
}

variable "argocd_timeout_seconds" {
  description = "Timeout for the Argo CD Helm release."
  type        = number
  default     = 600
}
