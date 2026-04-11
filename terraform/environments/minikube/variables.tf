variable "kubeconfig_path" {
  description = "Path to the kubeconfig file Terraform should use."
  type        = string
  default     = "~/.kube/config"
}

variable "kubeconfig_context" {
  description = "Kubeconfig context name for Minikube."
  type        = string
  default     = "minikube"
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
  default     = "clusters/minikube"
}

variable "root_application_name" {
  description = "Root Application name for the Minikube environment."
  type        = string
  default     = "minikube-root"
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

variable "argocd_server_node_port" {
  description = "NodePort to expose the Argo CD server service over HTTPS."
  type        = number
  default     = 32002
}

variable "argocd_admin_password" {
  description = "Argo CD admin password managed by Terraform for the Minikube environment."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.argocd_admin_password) > 0
    error_message = "Set argocd_admin_password in terraform.tfvars."
  }
}

variable "argo_namespace" {
  description = "Namespace where runtime-owned bootstrap objects should be created."
  type        = string
  default     = "argo"
}

variable "create_minio_bootstrap_secret" {
  description = "Whether to create the MinIO credentials secret before Argo CD syncs workloads."
  type        = bool
  default     = true
}

variable "minio_secret_name" {
  description = "Name of the MinIO credentials secret."
  type        = string
  default     = "my-minio-cred"
}

variable "minio_access_key" {
  description = "MinIO access key used by Argo Workflows and MinIO."
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = !var.create_minio_bootstrap_secret || var.minio_access_key != null
    error_message = "Set minio_access_key when create_minio_bootstrap_secret is true."
  }
}

variable "minio_secret_key" {
  description = "MinIO secret key used by Argo Workflows and MinIO."
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = !var.create_minio_bootstrap_secret || var.minio_secret_key != null
    error_message = "Set minio_secret_key when create_minio_bootstrap_secret is true."
  }
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
