data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  cluster_name                 = "${var.name_prefix}-${var.environment}"
  argo_namespace               = "argo"
  argo_service_accounts_for_s3 = ["argo-workflow", "argo-server"]

  common_tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "hybrid-workflows"
    },
    var.tags
  )
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidrs = [
    for index, _az in local.availability_zones : cidrsubnet(var.vpc_cidr, 8, index)
  ]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.cluster_name
  cidr = var.vpc_cidr

  azs            = local.availability_zones
  public_subnets = local.public_subnet_cidrs

  enable_nat_gateway      = false
  single_nat_gateway      = false
  map_public_ip_on_launch = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  tags = local.common_tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
    demo = {
      instance_types = [var.node_instance_type]
      capacity_type  = "ON_DEMAND"
      desired_size   = 1
      min_size       = 1
      max_size       = 1
    }
  }

  tags = local.common_tags
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = module.eks.cluster_name
  addon_name   = "eks-pod-identity-agent"

  depends_on = [
    module.eks
  ]
}

resource "aws_s3_bucket" "artifacts" {
  bucket        = var.artifact_bucket_name
  force_destroy = true

  tags = merge(
    local.common_tags,
    {
      Name = var.artifact_bucket_name
    }
  )
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "argo_pod_identity_assume" {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks-cluster-name"
      values   = [local.cluster_name]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes-namespace"
      values   = [local.argo_namespace]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes-service-account"
      values   = local.argo_service_accounts_for_s3
    }
  }
}

resource "aws_iam_role" "argo_pod_identity_s3" {
  name               = "${local.cluster_name}-argo-pod-identity-s3"
  assume_role_policy = data.aws_iam_policy_document.argo_pod_identity_assume.json

  tags = local.common_tags
}

data "aws_iam_policy_document" "argo_pod_identity_s3_access" {
  statement {
    sid = "ListArtifactsBucket"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]

    resources = [aws_s3_bucket.artifacts.arn]
  }

  statement {
    sid = "ReadWriteArtifacts"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:AbortMultipartUpload",
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
    ]

    resources = ["${aws_s3_bucket.artifacts.arn}/*"]
  }
}

resource "aws_iam_policy" "argo_pod_identity_s3_access" {
  name   = "${local.cluster_name}-argo-pod-identity-s3-access"
  policy = data.aws_iam_policy_document.argo_pod_identity_s3_access.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "argo_pod_identity_s3_access" {
  role       = aws_iam_role.argo_pod_identity_s3.name
  policy_arn = aws_iam_policy.argo_pod_identity_s3_access.arn
}

resource "aws_eks_pod_identity_association" "argo_s3_access" {
  for_each = toset(local.argo_service_accounts_for_s3)

  cluster_name    = module.eks.cluster_name
  namespace       = local.argo_namespace
  service_account = each.value
  role_arn        = aws_iam_role.argo_pod_identity_s3.arn

  depends_on = [
    aws_eks_addon.pod_identity_agent
  ]
}
