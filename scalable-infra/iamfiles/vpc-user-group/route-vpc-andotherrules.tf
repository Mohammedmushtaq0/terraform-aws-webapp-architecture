# VPC User Group - Network Infrastructure Management
# This group manages VPC, subnets, routing, security groups, NACLs

# IAM Policy for VPC Management
resource "aws_iam_policy" "vpc_management_policy" {
  name        = "VPCManagementPolicy"
  description = "Policy for VPC and network infrastructure management"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "VPCFullAccess"
        Effect = "Allow"
        Action = [
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:ModifyVpcAttribute",
          "ec2:DescribeVpcs",
          "ec2:DescribeVpcAttribute"
        ]
        Resource = "*"
      },
      {
        Sid    = "SubnetManagement"
        Effect = "Allow"
        Action = [
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:ModifySubnetAttribute",
          "ec2:DescribeSubnets",
          "ec2:DescribeAvailabilityZones"
        ]
        Resource = "*"
      },
      {
        Sid    = "InternetGatewayManagement"
        Effect = "Allow"
        Action = [
          "ec2:CreateInternetGateway",
          "ec2:DeleteInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:DetachInternetGateway",
          "ec2:DescribeInternetGateways"
        ]
        Resource = "*"
      },
      {
        Sid    = "NATGatewayManagement"
        Effect = "Allow"
        Action = [
          "ec2:CreateNatGateway",
          "ec2:DeleteNatGateway",
          "ec2:DescribeNatGateways",
          "ec2:AllocateAddress",
          "ec2:ReleaseAddress",
          "ec2:DescribeAddresses"
        ]
        Resource = "*"
      },
      {
        Sid    = "RouteTableManagement"
        Effect = "Allow"
        Action = [
          "ec2:CreateRouteTable",
          "ec2:DeleteRouteTable",
          "ec2:CreateRoute",
          "ec2:DeleteRoute",
          "ec2:ReplaceRoute",
          "ec2:AssociateRouteTable",
          "ec2:DisassociateRouteTable",
          "ec2:DescribeRouteTables"
        ]
        Resource = "*"
      },
      {
        Sid    = "SecurityGroupManagement"
        Effect = "Allow"
        Action = [
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSecurityGroupRules"
        ]
        Resource = "*"
      },
      {
        Sid    = "NACLManagement"
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkAcl",
          "ec2:DeleteNetworkAcl",
          "ec2:CreateNetworkAclEntry",
          "ec2:DeleteNetworkAclEntry",
          "ec2:ReplaceNetworkAclEntry",
          "ec2:ReplaceNetworkAclAssociation",
          "ec2:DescribeNetworkAcls"
        ]
        Resource = "*"
      },
      {
        Sid    = "TagManagement"
        Effect = "Allow"
        Action = [
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "VPC-Management-Policy"
    Environment = "Production"
    Team        = "Network"
  }
}

# IAM Group for VPC Users
resource "aws_iam_group" "vpc_users" {
  name = "vpc-users"
  path = "/"
}

# Attach policy to group
resource "aws_iam_group_policy_attachment" "vpc_users_policy" {
  group      = aws_iam_group.vpc_users.name
  policy_arn = aws_iam_policy.vpc_management_policy.arn
}

# Sample VPC Users (uncomment and modify as needed)
# resource "aws_iam_user" "vpc_user_1" {
#   name = "network-admin-1"
#   path = "/"
#   
#   tags = {
#     Name = "Network Administrator 1"
#     Team = "Network"
#   }
# }

# resource "aws_iam_group_membership" "vpc_users_membership" {
#   name = "vpc-users-membership"
#   
#   users = [
#     aws_iam_user.vpc_user_1.name,
#   ]
#   
#   group = aws_iam_group.vpc_users.name
# }

# Output the policy ARN for reference
output "vpc_management_policy_arn" {
  description = "ARN of the VPC management policy"
  value       = aws_iam_policy.vpc_management_policy.arn
}

output "vpc_users_group_name" {
  description = "Name of the VPC users group"
  value       = aws_iam_group.vpc_users.name
}
