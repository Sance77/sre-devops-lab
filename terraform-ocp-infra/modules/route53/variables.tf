variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_id" {
  description = "Cluster ID for naming"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "base_domain" {
  description = "Base domain for the cluster"
  type        = string
}

variable "create_hosted_zone" {
  description = "Whether to create a new Route53 hosted zone"
  type        = bool
  default     = true
}

variable "hosted_zone_id" {
  description = "Existing Route53 hosted zone ID"
  type        = string
  default     = ""
}