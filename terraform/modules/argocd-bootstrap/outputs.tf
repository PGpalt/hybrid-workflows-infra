output "argocd_namespace" {
  description = "Namespace where Argo CD is installed."
  value       = kubernetes_namespace_v1.argocd.metadata[0].name
}

output "argocd_release_name" {
  description = "Helm release name for Argo CD."
  value       = helm_release.argocd.name
}

output "argo_namespace" {
  description = "Namespace created for runtime-owned bootstrap objects."
  value       = var.argo_namespace
}

output "minio_secret_name" {
  description = "Name of the bootstrap MinIO credentials secret."
  value       = var.create_minio_bootstrap_secret ? kubernetes_secret_v1.minio_bootstrap[0].metadata[0].name : null
  sensitive   = true
}
