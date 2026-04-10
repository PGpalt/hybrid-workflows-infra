output "argocd_namespace" {
  description = "Namespace where Argo CD is installed."
  value       = module.argocd_bootstrap.argocd_namespace
}

output "argocd_release_name" {
  description = "Argo CD Helm release name."
  value       = module.argocd_bootstrap.argocd_release_name
}

output "argo_namespace" {
  description = "Namespace created for runtime bootstrap objects."
  value       = module.argocd_bootstrap.argo_namespace
}

output "root_application_name" {
  description = "Root Argo CD Application name if enabled."
  value       = try(module.argocd_root_application[0].application_name, null)
}

output "argocd_server_node_port" {
  description = "Configured Argo CD HTTPS NodePort for Minikube."
  value       = var.argocd_server_node_port
}
