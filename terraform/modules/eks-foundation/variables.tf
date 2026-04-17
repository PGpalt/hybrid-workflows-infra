variable "name_prefix" {
  description = "Prefix used when naming EKS foundation resources."
  type        = string
  default     = "hybrid-workflows"
}

variable "environment" {
  description = "Environment name, for example eks-dev."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS control plane."
  type        = string
  default     = "1.34"
}

variable "artifact_bucket_name" {
  description = "Globally unique S3 bucket name for Argo Workflows artifacts."
  type        = string

  validation {
    condition     = length(var.artifact_bucket_name) > 0
    error_message = "Set artifact_bucket_name to the S3 bucket name your eks-dev GitOps overlay will use."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the demo VPC. Two public subnets are derived from this range automatically."
  type        = string
  default     = "10.50.0.0/16"
}

variable "node_instance_type" {
  description = "Instance type used by the single demo EKS managed node."
  type        = string
  default     = "t3.medium"
}

variable "tags" {
  description = "Extra tags applied to foundation resources."
  type        = map(string)
  default     = {}
}
