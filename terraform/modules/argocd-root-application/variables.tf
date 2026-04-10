variable "name" {
  description = "Name of the root Argo CD Application."
  type        = string
}

variable "namespace" {
  description = "Namespace where the Application object will be created."
  type        = string
  default     = "argocd"
}

variable "project" {
  description = "Argo CD project name."
  type        = string
  default     = "default"
}

variable "gitops_repo_url" {
  description = "Git URL for the GitOps repository."
  type        = string
}

variable "gitops_target_revision" {
  description = "Git revision for the GitOps repository."
  type        = string
  default     = "main"
}

variable "gitops_cluster_path" {
  description = "Path within the GitOps repository for the environment app-of-apps."
  type        = string
}

variable "destination_server" {
  description = "Destination cluster API server."
  type        = string
  default     = "https://kubernetes.default.svc"
}

variable "destination_namespace" {
  description = "Namespace used for the Application destination."
  type        = string
  default     = "argocd"
}

variable "enable_finalizer" {
  description = "Whether to add the Argo CD resources finalizer."
  type        = bool
  default     = true
}

variable "prune" {
  description = "Whether automated sync should prune drifted resources."
  type        = bool
  default     = true
}

variable "self_heal" {
  description = "Whether automated sync should self-heal drifted resources."
  type        = bool
  default     = true
}

variable "create_namespace_sync_option" {
  description = "Whether to set CreateNamespace=true on the root Application."
  type        = bool
  default     = true
}
