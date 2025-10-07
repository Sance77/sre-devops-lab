output "hosted_zone_id" {
  description = "ID of the Route53 hosted zone"
  value       = local.hosted_zone_id
}

output "hosted_zone_name_servers" {
  description = "Name servers for the hosted zone"
  value       = local.name_servers
}

output "hosted_zone_arn" {
  description = "ARN of the hosted zone"
  value       = var.create_hosted_zone ? aws_route53_zone.openshift_zone[0].arn : null
}

output "base_domain" {
  description = "Base domain for the cluster"
  value       = var.base_domain
}