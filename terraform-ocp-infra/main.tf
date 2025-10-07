resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Local values
locals {
  cluster_id = "${var.cluster_name}-${random_string.suffix.result}"
  
  common_tags = {
    "kubernetes.io/cluster/${local.cluster_id}" = "owned"
    ClusterName                                 = local.cluster_id
    Project                                     = var.project_name
    Environment                                 = var.environment
  }
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  project_name             = var.project_name
  environment              = var.environment
  cluster_id               = local.cluster_id
  common_tags              = local.common_tags
  aws_region               = var.aws_region
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_subnet_cidrs     = var.private_subnet_cidrs
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security-groups"
  
  project_name      = var.project_name
  environment       = var.environment
  cluster_id        = local.cluster_id
  common_tags       = local.common_tags
  vpc_id            = module.vpc.vpc_id
  vpc_cidr          = var.vpc_cidr
  allowed_ssh_cidr  = var.allowed_ssh_cidr
  allowed_api_cidr  = var.allowed_api_cidr
}

# Route53 Module
module "route53" {
  source = "./modules/route53"
  
  project_name        = var.project_name
  environment         = var.environment
  cluster_id          = local.cluster_id
  common_tags         = local.common_tags
  base_domain         = var.base_domain
  create_hosted_zone  = var.create_hosted_zone
  hosted_zone_id      = var.hosted_zone_id
}

# IAM Module
module "iam" {
  source = "./modules/iam"
  
  project_name = var.project_name
  environment  = var.environment
  cluster_id   = local.cluster_id
  common_tags  = local.common_tags
}