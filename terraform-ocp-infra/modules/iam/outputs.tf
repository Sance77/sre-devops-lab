output "master_instance_profile_name" {
  description = "Name of the master instance profile"
  value       = aws_iam_instance_profile.openshift_master_profile.name
}

output "worker_instance_profile_name" {
  description = "Name of the worker instance profile"
  value       = aws_iam_instance_profile.openshift_worker_profile.name
}

output "master_role_arn" {
  description = "ARN of the master IAM role"
  value       = aws_iam_role.openshift_master_role.arn
}

output "worker_role_arn" {
  description = "ARN of the worker IAM role"
  value       = aws_iam_role.openshift_worker_role.arn
}

output "installer_user_name" {
  description = "Name of the installer IAM user"
  value       = aws_iam_user.openshift_installer.name
}

output "installer_access_key_id" {
  description = "Access key ID for OpenShift installer"
  value       = aws_iam_access_key.openshift_installer_key.id
  sensitive   = true
}

output "installer_secret_access_key" {
  description = "Secret access key for OpenShift installer"
  value       = aws_iam_access_key.openshift_installer_key.secret
  sensitive   = true
}