module "eks_foundation" {
  source = "../../modules/eks-foundation"

  name_prefix          = var.name_prefix
  environment          = var.environment
  kubernetes_version   = var.kubernetes_version
  artifact_bucket_name = var.artifact_bucket_name
  vpc_cidr             = var.vpc_cidr
  node_instance_type   = var.node_instance_type
  tags                 = var.tags
}
