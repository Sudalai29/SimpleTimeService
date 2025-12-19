
  # Uncomment and configure for remote state
  terraform {
    backend "s3" {
      bucket         = "my-terraform-state-smd29-py"
      key            = "eks/terraform.tfstate"
      region         = "ap-south-1"
      dynamodb_table = "terraform-lock-table"
      encrypt        = true
    }
  }

locals {
  cluster_name = "${var.project_name}-${var.environment}-eks"
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags
}

module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  cluster_name         = local.cluster_name
  tags                 = local.common_tags
}

module "eks" {
  source = "./modules/eks"

  cluster_name        = local.cluster_name
  kubernetes_version  = var.kubernetes_version
  cluster_role_arn    = module.iam.eks_cluster_role_arn
  nodes_role_arn      = module.iam.eks_nodes_role_arn
  private_subnet_ids  = module.vpc.private_subnet_ids
  public_subnet_ids   = module.vpc.public_subnet_ids
  cluster_sg_id       = module.vpc.eks_cluster_sg_id
  instance_type       = var.instance_type
  desired_capacity    = var.desired_capacity
  min_capacity        = var.min_capacity
  max_capacity        = var.max_capacity
  vpc_cni_version     = var.vpc_cni_version
  kube_proxy_version  = var.kube_proxy_version
  coredns_version     = var.coredns_version
  tags                = local.common_tags

  depends_on = [
    module.iam,
    module.vpc
  ]
}

