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

variable "argocd_chart_repository" {
  description = "Helm repository for the Argo CD chart."
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "argocd_chart_name" {
  description = "Helm chart name for Argo CD."
  type        = string
  default     = "argo-cd"
}

variable "argocd_chart_version" {
  description = "Pinned Argo CD chart version."
  type        = string
}

variable "argocd_values" {
  description = "Extra Helm values to pass to the Argo CD chart."
  type        = any
  default     = {}
}

variable "argo_namespace" {
  description = "Namespace used by the Argo Workflows and MinIO apps."
  type        = string
  default     = "argo"
}

variable "create_argo_namespace" {
  description = "Whether Terraform should create the runtime namespace used by bootstrap secrets."
  type        = bool
  default     = true
}

variable "create_minio_bootstrap_secret" {
  description = "Whether Terraform should create the MinIO credentials secret before GitOps sync."
  type        = bool
  default     = true
}

variable "minio_secret_name" {
  description = "Name of the MinIO credentials secret consumed by the GitOps stack."
  type        = string
  default     = "my-minio-cred"
}

variable "minio_access_key" {
  description = "MinIO access key for the bootstrap secret."
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = !var.create_minio_bootstrap_secret || var.minio_access_key != null
    error_message = "Set minio_access_key when create_minio_bootstrap_secret is true."
  }
}

variable "minio_secret_key" {
  description = "MinIO secret key for the bootstrap secret."
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = !var.create_minio_bootstrap_secret || var.minio_secret_key != null
    error_message = "Set minio_secret_key when create_minio_bootstrap_secret is true."
  }
}

variable "wait" {
  description = "Whether Helm should wait for Argo CD resources to become ready."
  type        = bool
  default     = true
}

variable "timeout_seconds" {
  description = "Timeout for the Helm release."
  type        = number
  default     = 600
}
