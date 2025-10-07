resource "aws_route53_zone" "openshift_zone" {
  count = var.create_hosted_zone ? 1 : 0
  
  name          = var.base_domain
  comment       = "Hosted zone for OpenShift cluster ${var.cluster_id}"
  force_destroy = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-hosted-zone"
  })
}

data "aws_route53_zone" "existing_zone" {
  count = var.create_hosted_zone ? 0 : 1
  
  zone_id = var.hosted_zone_id
}
locals {
  hosted_zone_id = var.create_hosted_zone ? aws_route53_zone.openshift_zone[0].zone_id : var.hosted_zone_id
  name_servers   = var.create_hosted_zone ? aws_route53_zone.openshift_zone[0].name_servers : []
}