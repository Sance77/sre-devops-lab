resource "aws_iam_role" "openshift_master_role" {
  name = "${var.cluster_id}-master-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-master-role"
  })
}

resource "aws_iam_role_policy_attachment" "master_poweruser" {
  role       = aws_iam_role.openshift_master_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

# Additional IAM permissions for master nodes
resource "aws_iam_role_policy_attachment" "master_iam_readonly" {
  role       = aws_iam_role.openshift_master_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

# IAM Instance Profile for Master Nodes
resource "aws_iam_instance_profile" "openshift_master_profile" {
  name = "${var.cluster_id}-master-profile"
  role = aws_iam_role.openshift_master_role.name

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-master-profile"
  })
}

# IAM Role for OpenShift Worker Nodes
resource "aws_iam_role" "openshift_worker_role" {
  name = "${var.cluster_id}-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-worker-role"
  })
}

resource "aws_iam_role_policy_attachment" "worker_ec2_readonly" {
  role       = aws_iam_role.openshift_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

# IAM Instance Profile for Worker Nodes
resource "aws_iam_instance_profile" "openshift_worker_profile" {
  name = "${var.cluster_id}-worker-profile"
  role = aws_iam_role.openshift_worker_role.name

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-worker-profile"
  })
}

# IAM User for OpenShift Installer (
resource "aws_iam_user" "openshift_installer" {
  name = "${var.cluster_id}-installer"
  path = "/"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-installer-user"
  })
}

# Attach AdministratorAccess policy to installer user
resource "aws_iam_user_policy_attachment" "installer_admin" {
  user       = aws_iam_user.openshift_installer.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Access key for installer
resource "aws_iam_access_key" "openshift_installer_key" {
  user = aws_iam_user.openshift_installer.name
}