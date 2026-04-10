output "application_name" {
  description = "Name of the root Argo CD Application."
  value       = kubernetes_manifest.root_application.object.metadata.name
}
