locals {
  root_application_metadata = merge(
    {
      name      = var.name
      namespace = var.namespace
    },
    var.enable_finalizer ? {
      finalizers = ["resources-finalizer.argocd.argoproj.io"]
    } : {}
  )

  root_application_sync_policy = merge(
    {
      automated = {
        prune    = var.prune
        selfHeal = var.self_heal
      }
    },
    var.create_namespace_sync_option ? {
      syncOptions = ["CreateNamespace=true"]
    } : {}
  )
}

resource "kubernetes_manifest" "root_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata   = local.root_application_metadata
    spec = {
      project = var.project
      source = {
        repoURL        = var.gitops_repo_url
        targetRevision = var.gitops_target_revision
        path           = var.gitops_cluster_path
      }
      destination = {
        server    = var.destination_server
        namespace = var.destination_namespace
      }
      syncPolicy = local.root_application_sync_policy
    }
  }
}
