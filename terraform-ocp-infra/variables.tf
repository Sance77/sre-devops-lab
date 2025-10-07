variable "aws_region" {
  description = "AWS region for OpenShift cluster"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "openshift-cluster"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "OpenShift cluster name"
  type        = string
  default     = "openshift-dev"
}

variable "base_domain" {
  description = "Base domain for the cluster (e.g., example.com)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "allowed_api_cidr" {
  description = "CIDR block allowed for API access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "openshift_version" {
  description = "OpenShift version"
  type        = string
  default     = "4.18"
}

variable "create_hosted_zone" {
  description = "Whether to create a new Route53 hosted zone"
  type        = bool
  default     = true
}

variable "hosted_zone_id" {
  description = "Existing Route53 hosted zone ID (if create_hosted_zone is false)"
  type        = string
  default     = ""
}