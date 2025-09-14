# S3 & RDS User Group - Storage and Database Management
# This group manages S3 buckets, RDS databases, and related resources

# IAM Policy for S3 Management
resource "aws_iam_policy" "s3_management_policy" {
  name        = "S3ManagementPolicy"
  description = "Policy for S3 bucket and object management"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3BucketManagement"
        Effect = "Allow"
        Action = [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:ListBucket",
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation",
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy",
          "s3:DeleteBucketPolicy",
          "s3:GetBucketAcl",
          "s3:PutBucketAcl",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning",
          "s3:GetBucketEncryption",
          "s3:PutBucketEncryption",
          "s3:GetBucketPublicAccessBlock",
          "s3:PutBucketPublicAccessBlock",
          "s3:GetBucketOwnershipControls",
          "s3:PutBucketOwnershipControls"
        ]
        Resource = "*"
      },
      {
        Sid    = "S3ObjectManagement"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObjectAcl",
          "s3:PutObjectAcl",
          "s3:GetObjectVersion",
          "s3:DeleteObjectVersion"
        ]
        Resource = "arn:aws:s3:::*/*"
      }
    ]
  })

  tags = {
    Name        = "S3-Management-Policy"
    Environment = "Production"
    Team        = "Storage"
  }
}

# IAM Policy for RDS Management
resource "aws_iam_policy" "rds_management_policy" {
  name        = "RDSManagementPolicy"
  description = "Policy for RDS database management"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "RDSInstanceManagement"
        Effect = "Allow"
        Action = [
          "rds:CreateDBInstance",
          "rds:DeleteDBInstance",
          "rds:ModifyDBInstance",
          "rds:StartDBInstance",
          "rds:StopDBInstance",
          "rds:RebootDBInstance",
          "rds:DescribeDBInstances",
          "rds:DescribeDBEngineVersions",
          "rds:DescribeDBParameterGroups",
          "rds:DescribeDBParameters",
          "rds:DescribeOrderableDBInstanceOptions"
        ]
        Resource = "*"
      },
      {
        Sid    = "RDSSubnetGroupManagement"
        Effect = "Allow"
        Action = [
          "rds:CreateDBSubnetGroup",
          "rds:DeleteDBSubnetGroup",
          "rds:ModifyDBSubnetGroup",
          "rds:DescribeDBSubnetGroups"
        ]
        Resource = "*"
      },
      {
        Sid    = "RDSSecurityGroupManagement"
        Effect = "Allow"
        Action = [
          "rds:CreateDBSecurityGroup",
          "rds:DeleteDBSecurityGroup",
          "rds:AuthorizeDBSecurityGroupIngress",
          "rds:RevokeDBSecurityGroupIngress",
          "rds:DescribeDBSecurityGroups"
        ]
        Resource = "*"
      },
      {
        Sid    = "RDSSnapshotManagement"
        Effect = "Allow"
        Action = [
          "rds:CreateDBSnapshot",
          "rds:DeleteDBSnapshot",
          "rds:DescribeDBSnapshots",
          "rds:RestoreDBInstanceFromDBSnapshot",
          "rds:CopyDBSnapshot"
        ]
        Resource = "*"
      },
      {
        Sid    = "RDSBackupManagement"
        Effect = "Allow"
        Action = [
          "rds:CreateDBCluster",
          "rds:DeleteDBCluster",
          "rds:DescribeDBClusters",
          "rds:ModifyDBCluster"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "RDS-Management-Policy"
    Environment = "Production"
    Team        = "Database"
  }
}

# IAM Group for S3 & RDS Users
resource "aws_iam_group" "s3_rds_users" {
  name = "s3-rds-users"
  path = "/"
}

# Attach S3 policy to group
resource "aws_iam_group_policy_attachment" "s3_rds_users_s3_policy" {
  group      = aws_iam_group.s3_rds_users.name
  policy_arn = aws_iam_policy.s3_management_policy.arn
}

# Attach RDS policy to group
resource "aws_iam_group_policy_attachment" "s3_rds_users_rds_policy" {
  group      = aws_iam_group.s3_rds_users.name
  policy_arn = aws_iam_policy.rds_management_policy.arn
}

# Sample S3 & RDS Users (uncomment and modify as needed)
# resource "aws_iam_user" "storage_admin_1" {
#   name = "storage-admin-1"
#   path = "/"
#   
#   tags = {
#     Name = "Storage Administrator 1"
#     Team = "Storage"
#   }
# }

# resource "aws_iam_user" "database_admin_1" {
#   name = "database-admin-1"
#   path = "/"
#   
#   tags = {
#     Name = "Database Administrator 1"
#     Team = "Database"
#   }
# }

# resource "aws_iam_group_membership" "s3_rds_users_membership" {
#   name = "s3-rds-users-membership"
#   
#   users = [
#     aws_iam_user.storage_admin_1.name,
#     aws_iam_user.database_admin_1.name,
#   ]
#   
#   group = aws_iam_group.s3_rds_users.name
# }

# Outputs
output "s3_management_policy_arn" {
  description = "ARN of the S3 management policy"
  value       = aws_iam_policy.s3_management_policy.arn
}

output "rds_management_policy_arn" {
  description = "ARN of the RDS management policy"
  value       = aws_iam_policy.rds_management_policy.arn
}

output "s3_rds_users_group_name" {
  description = "Name of the S3 & RDS users group"
  value       = aws_iam_group.s3_rds_users.name
}
