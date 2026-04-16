output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks_foundation.cluster_name
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint for the EKS cluster."
  value       = module.eks_foundation.cluster_endpoint
}

output "artifact_bucket_name" {
  description = "S3 bucket that should match the GitOps Argo Workflows artifact repository."
  value       = module.eks_foundation.artifact_bucket_name
}

output "argo_pod_identity_role_arn" {
  description = "IAM role ARN used by the Argo Pod Identity associations for S3 access."
  value       = module.eks_foundation.argo_pod_identity_role_arn
}

output "argo_pod_identity_association_ids" {
  description = "EKS Pod Identity association IDs for the Argo service accounts that need S3 access."
  value       = module.eks_foundation.argo_pod_identity_association_ids
}

output "kubectl_update_command" {
  description = "Suggested command to configure kubectl after the EKS cluster becomes active."
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks_foundation.cluster_name} --profile ${var.aws_profile}"
}
