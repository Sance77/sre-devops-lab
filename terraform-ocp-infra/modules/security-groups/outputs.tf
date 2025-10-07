output "master_security_group_id" {
  description = "ID of the master security group"
  value       = aws_security_group.openshift_master_sg.id
}

output "worker_security_group_id" {
  description = "ID of the worker security group"
  value       = aws_security_group.openshift_worker_sg.id
}

output "lb_security_group_id" {
  description = "ID of the load balancer security group"
  value       = aws_security_group.openshift_lb_sg.id
}

output "master_security_group_arn" {
  description = "ARN of the master security group"
  value       = aws_security_group.openshift_master_sg.arn
}

output "worker_security_group_arn" {
  description = "ARN of the worker security group"
  value       = aws_security_group.openshift_worker_sg.arn
}

output "lb_security_group_arn" {
  description = "ARN of the load balancer security group"
  value       = aws_security_group.openshift_lb_sg.arn
}