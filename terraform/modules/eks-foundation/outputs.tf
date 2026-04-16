output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint for the EKS cluster."
  value       = module.eks.cluster_endpoint
}

output "artifact_bucket_name" {
  description = "S3 bucket name for Argo Workflows artifacts."
  value       = aws_s3_bucket.artifacts.bucket
}

output "argo_pod_identity_role_arn" {
  description = "IAM role ARN used by the Argo Pod Identity associations for S3 access."
  value       = aws_iam_role.argo_pod_identity_s3.arn
}

output "argo_pod_identity_association_ids" {
  description = "EKS Pod Identity association IDs keyed by Kubernetes service account name."
  value = {
    for service_account, association in aws_eks_pod_identity_association.argo_s3_access :
    service_account => association.association_id
  }
}
