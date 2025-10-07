output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"  
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of the public subnets"
  value       = module.vpc.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of the private subnets"
  value       = module.vpc.private_subnet_cidrs
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = module.vpc.nat_gateway_ids
}

output "master_security_group_id" {
  description = "ID of the master security group"
  value       = module.security_groups.master_security_group_id
}

output "worker_security_group_id" {
  description = "ID of the worker security group"
  value       = module.security_groups.worker_security_group_id
}

output "lb_security_group_id" {
  description = "ID of the load balancer security group"
  value       = module.security_groups.lb_security_group_id
}

output "hosted_zone_id" {
  description = "ID of the Route53 hosted zone"
  value       = module.route53.hosted_zone_id
}

output "hosted_zone_name_servers" {
  description = "Name servers for the hosted zone (if created)"
  value       = module.route53.hosted_zone_name_servers
}

output "base_domain" {
  description = "Base domain for the cluster"
  value       = var.base_domain
}

output "cluster_name" {
  description = "OpenShift cluster name"
  value       = local.cluster_id
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

output "availability_zones" {
  description = "Availability zones used"
  value       = var.availability_zones
}

output "master_instance_profile_name" {
  description = "Name of the master instance profile"
  value       = module.iam.master_instance_profile_name
}

output "worker_instance_profile_name" {
  description = "Name of the worker instance profile"
  value       = module.iam.worker_instance_profile_name
}

output "installer_access_key_id" {
  description = "Access key ID for OpenShift installer"
  value       = module.iam.installer_access_key_id
  sensitive   = true
}

output "installer_secret_access_key" {
  description = "Secret access key for OpenShift installer"  
  value       = module.iam.installer_secret_access_key
  sensitive   = true
}

# Summary output
output "cluster_info_summary" {
  description = "Summary of cluster information"
  value = {
    cluster_name    = local.cluster_id
    vpc_id         = module.vpc.vpc_id
    region         = var.aws_region
    base_domain    = var.base_domain
    hosted_zone_id = module.route53.hosted_zone_id
    access_method  = "Direct from local machine (no bastion needed)"
  }
}