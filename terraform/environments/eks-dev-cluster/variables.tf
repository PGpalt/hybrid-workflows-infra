variable "aws_region" {
  description = "AWS region where the EKS dev cluster should be created."
  type        = string
  default     = "eu-north-1"
}

variable "aws_profile" {
  description = "AWS shared config profile used for Terraform operations."
  type        = string
  default     = "eks-dev"
}

variable "name_prefix" {
  description = "Prefix used when naming cluster resources."
  type        = string
  default     = "hybrid-workflows"
}

variable "environment" {
  description = "Environment name used in resource names and tags."
  type        = string
  default     = "eks-dev"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS control plane."
  type        = string
  default     = "1.35"
}

variable "artifact_bucket_name" {
  description = "S3 bucket name for Argo Workflows artifacts. This should match the current eks-dev GitOps overlay."
  type        = string

  validation {
    condition     = length(var.artifact_bucket_name) > 0
    error_message = "Set artifact_bucket_name to the bucket the eks-dev GitOps overlay will use."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the demo VPC. Terraform derives two public subnets from this range automatically."
  type        = string
  default     = "10.50.0.0/16"
}

variable "node_instance_type" {
  description = "Instance type used by the single demo EKS managed node."
  type        = string
  default     = "t3.small"
}

variable "tags" {
  description = "Extra tags applied to AWS resources."
  type        = map(string)
  default     = {}
}
