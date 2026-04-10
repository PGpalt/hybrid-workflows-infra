resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = var.argocd_namespace
  }
}

resource "kubernetes_namespace_v1" "argo" {
  count = var.create_argo_namespace || var.create_minio_bootstrap_secret ? 1 : 0

  metadata {
    name = var.argo_namespace
  }
}

resource "helm_release" "argocd" {
  name             = var.argocd_release_name
  repository       = var.argocd_chart_repository
  chart            = var.argocd_chart_name
  version          = var.argocd_chart_version
  namespace        = kubernetes_namespace_v1.argocd.metadata[0].name
  create_namespace = false
  wait             = var.wait
  timeout          = var.timeout_seconds
  cleanup_on_fail  = true
  atomic           = true

  values = [
    yamlencode(var.argocd_values)
  ]
}

resource "kubernetes_secret_v1" "minio_bootstrap" {
  count = var.create_minio_bootstrap_secret ? 1 : 0

  metadata {
    name      = var.minio_secret_name
    namespace = var.argo_namespace
  }

  type = "Opaque"

  data = {
    rootUser     = var.minio_access_key
    rootPassword = var.minio_secret_key
    accesskey    = var.minio_access_key
    secretkey    = var.minio_secret_key
  }

  depends_on = [
    kubernetes_namespace_v1.argo
  ]
}
