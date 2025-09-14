# Admin Group - Full Infrastructure Management
# This group has administrative access to all AWS resources

# IAM Policy for Admin Management (Alternative to PowerUserAccess)
resource "aws_iam_policy" "admin_management_policy" {
  name        = "AdminManagementPolicy"
  description = "Comprehensive administrative policy for infrastructure management"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "FullEC2Access"
        Effect = "Allow"
        Action = [
          "ec2:*"
        ]
        Resource = "*"
      },
      {
        Sid    = "FullRDSAccess"
        Effect = "Allow"
        Action = [
          "rds:*"
        ]
        Resource = "*"
      },
      {
        Sid    = "FullS3Access"
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = "*"
      },
      {
        Sid    = "FullLoadBalancingAccess"
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:*"
        ]
        Resource = "*"
      },
      {
        Sid    = "FullAutoScalingAccess"
        Effect = "Allow"
        Action = [
          "autoscaling:*"
        ]
        Resource = "*"
      },
      {
        Sid    = "FullCloudWatchAccess"
        Effect = "Allow"
        Action = [
          "cloudwatch:*",
          "logs:*"
        ]
        Resource = "*"
      },
      {
        Sid    = "FullRoute53Access"
        Effect = "Allow"
        Action = [
          "route53:*"
        ]
        Resource = "*"
      },
      {
        Sid    = "IAMReadAccess"
        Effect = "Allow"
        Action = [
          "iam:Get*",
          "iam:List*",
          "iam:Generate*"
        ]
        Resource = "*"
      },
      {
        Sid    = "IAMUserSelfManagement"
        Effect = "Allow"
        Action = [
          "iam:ChangePassword",
          "iam:CreateAccessKey",
          "iam:DeleteAccessKey",
          "iam:GetUser",
          "iam:ListAccessKeys",
          "iam:UpdateAccessKey"
        ]
        Resource = "arn:aws:iam::*:user/$${aws:username}"
      },
      {
        Sid    = "SupportAccess"
        Effect = "Allow"
        Action = [
          "support:*"
        ]
        Resource = "*"
      },
      {
        Sid    = "BillingAccess"
        Effect = "Allow"
        Action = [
          "aws-portal:ViewBilling",
          "aws-portal:ViewUsage"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "Admin-Management-Policy"
    Environment = "Production"
    Team        = "Administration"
  }
}

# IAM Group for Administrators
resource "aws_iam_group" "admin_users" {
  name = "admin-users"
  path = "/"
}

# Attach custom admin policy to group
resource "aws_iam_group_policy_attachment" "admin_users_custom_policy" {
  group      = aws_iam_group.admin_users.name
  policy_arn = aws_iam_policy.admin_management_policy.arn
}

# Attach AWS managed PowerUserAccess policy (optional - provides extensive permissions)
resource "aws_iam_group_policy_attachment" "admin_users_power_user" {
  group      = aws_iam_group.admin_users.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

# Attach AWS managed ReadOnlyAccess policy for additional read permissions
resource "aws_iam_group_policy_attachment" "admin_users_read_only" {
  group      = aws_iam_group.admin_users.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Sample Admin Users (uncomment and modify as needed)
# resource "aws_iam_user" "admin_user_1" {
#   name = "admin-1"
#   path = "/"
#   
#   tags = {
#     Name = "System Administrator 1"
#     Team = "Administration"
#     Role = "Admin"
#   }
# }

# resource "aws_iam_user" "admin_user_2" {
#   name = "admin-2"
#   path = "/"
#   
#   tags = {
#     Name = "System Administrator 2"
#     Team = "Administration"
#     Role = "Admin"
#   }
# }

# Enable MFA requirement for admin users (recommended)
# resource "aws_iam_group_policy" "admin_require_mfa" {
#   name  = "admin-require-mfa"
#   group = aws_iam_group.admin_users.name
# 
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowViewAccountInfo"
#         Effect = "Allow"
#         Action = [
#           "iam:GetAccountPasswordPolicy",
#           "iam:GetAccountSummary",
#           "iam:ListVirtualMFADevices"
#         ]
#         Resource = "*"
#       },
#       {
#         Sid    = "AllowManageOwnPasswords"
#         Effect = "Allow"
#         Action = [
#           "iam:ChangePassword",
#           "iam:GetUser"
#         ]
#         Resource = "arn:aws:iam::*:user/${aws:username}"
#       },
#       {
#         Sid    = "AllowManageOwnMFA"
#         Effect = "Allow"
#         Action = [
#           "iam:CreateVirtualMFADevice",
#           "iam:DeleteVirtualMFADevice",
#           "iam:EnableMFADevice",
#           "iam:ListMFADevices",
#           "iam:ResyncMFADevice"
#         ]
#         Resource = [
#           "arn:aws:iam::*:mfa/${aws:username}",
#           "arn:aws:iam::*:user/${aws:username}"
#         ]
#       },
#       {
#         Sid       = "DenyAllExceptUnlessSignedInWithMFA"
#         Effect    = "Deny"
#         NotAction = [
#           "iam:CreateVirtualMFADevice",
#           "iam:EnableMFADevice",
#           "iam:GetUser",
#           "iam:ListMFADevices",
#           "iam:ListVirtualMFADevices",
#           "iam:ResyncMFADevice",
#           "sts:GetSessionToken"
#         ]
#         Resource = "*"
#         Condition = {
#           BoolIfExists = {
#             "aws:MultiFactorAuthPresent" = "false"
#           }
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_group_membership" "admin_users_membership" {
#   name = "admin-users-membership"
#   
#   users = [
#     aws_iam_user.admin_user_1.name,
#     aws_iam_user.admin_user_2.name,
#   ]
#   
#   group = aws_iam_group.admin_users.name
# }

# Outputs
output "admin_management_policy_arn" {
  description = "ARN of the admin management policy"
  value       = aws_iam_policy.admin_management_policy.arn
}

output "admin_users_group_name" {
  description = "Name of the admin users group"
  value       = aws_iam_group.admin_users.name
}
