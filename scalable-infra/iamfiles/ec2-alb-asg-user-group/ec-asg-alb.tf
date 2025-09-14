# EC2, ALB, ASG User Group - Compute Infrastructure Management
# This group manages EC2 instances, Application Load Balancers, Auto Scaling Groups, and Launch Templates

# IAM Policy for EC2 Management
resource "aws_iam_policy" "ec2_management_policy" {
  name        = "EC2ManagementPolicy"
  description = "Policy for EC2 instance and compute resource management"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2InstanceManagement"
        Effect = "Allow"
        Action = [
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:RebootInstances",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeInstanceAttribute",
          "ec2:ModifyInstanceAttribute",
          "ec2:DescribeImages",
          "ec2:DescribeKeyPairs",
          "ec2:CreateKeyPair",
          "ec2:DeleteKeyPair",
          "ec2:ImportKeyPair"
        ]
        Resource = "*"
      },
      {
        Sid    = "LaunchTemplateManagement"
        Effect = "Allow"
        Action = [
          "ec2:CreateLaunchTemplate",
          "ec2:CreateLaunchTemplateVersion",
          "ec2:DeleteLaunchTemplate",
          "ec2:DeleteLaunchTemplateVersions",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:ModifyLaunchTemplate"
        ]
        Resource = "*"
      },
      {
        Sid    = "SecurityGroupAccess"
        Effect = "Allow"
        Action = [
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSecurityGroupRules"
        ]
        Resource = "*"
      },
      {
        Sid    = "SubnetAccess"
        Effect = "Allow"
        Action = [
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "EC2-Management-Policy"
    Environment = "Production"
    Team        = "Compute"
  }
}

# IAM Policy for Load Balancer Management
resource "aws_iam_policy" "alb_management_policy" {
  name        = "ALBManagementPolicy"
  description = "Policy for Application Load Balancer management"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "LoadBalancerManagement"
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes"
        ]
        Resource = "*"
      },
      {
        Sid    = "TargetGroupManagement"
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetGroupAttributes",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets"
        ]
        Resource = "*"
      },
      {
        Sid    = "ListenerManagement"
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:CreateRule",
          "elasticloadbalancing:DeleteRule",
          "elasticloadbalancing:ModifyRule",
          "elasticloadbalancing:DescribeRules"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "ALB-Management-Policy"
    Environment = "Production"
    Team        = "Compute"
  }
}

# IAM Policy for Auto Scaling Group Management
resource "aws_iam_policy" "asg_management_policy" {
  name        = "ASGManagementPolicy"
  description = "Policy for Auto Scaling Group management"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AutoScalingGroupManagement"
        Effect = "Allow"
        Action = [
          "autoscaling:CreateAutoScalingGroup",
          "autoscaling:DeleteAutoScalingGroup",
          "autoscaling:UpdateAutoScalingGroup",
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ]
        Resource = "*"
      },
      {
        Sid    = "ScalingPolicyManagement"
        Effect = "Allow"
        Action = [
          "autoscaling:PutScalingPolicy",
          "autoscaling:DeletePolicy",
          "autoscaling:DescribePolicies",
          "autoscaling:ExecutePolicy"
        ]
        Resource = "*"
      },
      {
        Sid    = "CloudWatchAlarmManagement"
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DeleteAlarms",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics"
        ]
        Resource = "*"
      },
      {
        Sid    = "CloudWatchActionsForASG"
        Effect = "Allow"
        Action = [
          "cloudwatch:EnableAlarmActions",
          "cloudwatch:DisableAlarmActions"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "ASG-Management-Policy"
    Environment = "Production"
    Team        = "Compute"
  }
}

# IAM Group for EC2, ALB, ASG Users
resource "aws_iam_group" "ec2_alb_asg_users" {
  name = "ec2-alb-asg-users"
  path = "/"
}

# Attach EC2 policy to group
resource "aws_iam_group_policy_attachment" "ec2_alb_asg_users_ec2_policy" {
  group      = aws_iam_group.ec2_alb_asg_users.name
  policy_arn = aws_iam_policy.ec2_management_policy.arn
}

# Attach ALB policy to group
resource "aws_iam_group_policy_attachment" "ec2_alb_asg_users_alb_policy" {
  group      = aws_iam_group.ec2_alb_asg_users.name
  policy_arn = aws_iam_policy.alb_management_policy.arn
}

# Attach ASG policy to group
resource "aws_iam_group_policy_attachment" "ec2_alb_asg_users_asg_policy" {
  group      = aws_iam_group.ec2_alb_asg_users.name
  policy_arn = aws_iam_policy.asg_management_policy.arn
}

# Sample EC2, ALB, ASG Users (uncomment and modify as needed)
# resource "aws_iam_user" "compute_admin_1" {
#   name = "compute-admin-1"
#   path = "/"
#   
#   tags = {
#     Name = "Compute Administrator 1"
#     Team = "Compute"
#   }
# }

# resource "aws_iam_user" "devops_engineer_1" {
#   name = "devops-engineer-1"
#   path = "/"
#   
#   tags = {
#     Name = "DevOps Engineer 1"
#     Team = "DevOps"
#   }
# }

# resource "aws_iam_group_membership" "ec2_alb_asg_users_membership" {
#   name = "ec2-alb-asg-users-membership"
#   
#   users = [
#     aws_iam_user.compute_admin_1.name,
#     aws_iam_user.devops_engineer_1.name,
#   ]
#   
#   group = aws_iam_group.ec2_alb_asg_users.name
# }

# Outputs
output "ec2_management_policy_arn" {
  description = "ARN of the EC2 management policy"
  value       = aws_iam_policy.ec2_management_policy.arn
}

output "alb_management_policy_arn" {
  description = "ARN of the ALB management policy"
  value       = aws_iam_policy.alb_management_policy.arn
}

output "asg_management_policy_arn" {
  description = "ARN of the ASG management policy"
  value       = aws_iam_policy.asg_management_policy.arn
}

output "ec2_alb_asg_users_group_name" {
  description = "Name of the EC2, ALB, ASG users group"
  value       = aws_iam_group.ec2_alb_asg_users.name
}
