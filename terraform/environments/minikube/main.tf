locals {
  argocd_values = {
    configs = {
      params = {
        "server.insecure" = "true"
      }
    }
    server = {
      service = {
        type          = "NodePort"
        nodePortHttps = var.argocd_server_node_port
      }
    }
  }
}

module "argocd_bootstrap" {
  source = "../../modules/argocd-bootstrap"

  argocd_namespace             = var.argocd_namespace
  argocd_release_name          = var.argocd_release_name
  argocd_chart_version         = var.argocd_chart_version
  argocd_values                = local.argocd_values
  argo_namespace               = var.argo_namespace
  create_minio_bootstrap_secret = var.create_minio_bootstrap_secret
  minio_secret_name            = var.minio_secret_name
  minio_access_key             = var.minio_access_key
  minio_secret_key             = var.minio_secret_key
  wait                         = var.argocd_wait
  timeout_seconds              = var.argocd_timeout_seconds
}

module "argocd_root_application" {
  count  = var.enable_root_application ? 1 : 0
  source = "../../modules/argocd-root-application"

  name                  = var.root_application_name
  namespace             = module.argocd_bootstrap.argocd_namespace
  gitops_repo_url       = var.gitops_repo_url
  gitops_target_revision = var.gitops_target_revision
  gitops_cluster_path   = var.gitops_cluster_path

  depends_on = [
    module.argocd_bootstrap
  ]
}
