# Metrics and Monitoring Group - Centralized Monitoring and Alerting
# This group manages CloudWatch metrics, alarms, dashboards, SNS notifications, and monitoring infrastructure

# IAM Policy for CloudWatch Monitoring
resource "aws_iam_policy" "cloudwatch_monitoring_policy" {
  name        = "CloudWatchMonitoringPolicy"
  description = "Policy for CloudWatch metrics, alarms, and dashboard management"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudWatchMetricsAccess"
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:GetMetricData",
          "cloudwatch:ListMetrics",
          "cloudwatch:PutMetricData",
          "cloudwatch:GetMetricWidgetImage"
        ]
        Resource = "*"
      },
      {
        Sid    = "CloudWatchAlarmsManagement"
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DeleteAlarms",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:DescribeAlarmHistory",
          "cloudwatch:DescribeAlarmsForMetric",
          "cloudwatch:EnableAlarmActions",
          "cloudwatch:DisableAlarmActions",
          "cloudwatch:SetAlarmState"
        ]
        Resource = "*"
      },
      {
        Sid    = "CloudWatchDashboardsManagement"
        Effect = "Allow"
        Action = [
          "cloudwatch:GetDashboard",
          "cloudwatch:ListDashboards",
          "cloudwatch:PutDashboard",
          "cloudwatch:DeleteDashboards"
        ]
        Resource = "*"
      },
      {
        Sid    = "CloudWatchLogsAccess"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DeleteLogGroup",
          "logs:DeleteLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:FilterLogEvents",
          "logs:GetLogEvents",
          "logs:PutLogEvents",
          "logs:PutRetentionPolicy"
        ]
        Resource = "*"
      },
      {
        Sid    = "CloudWatchInsightsAccess"
        Effect = "Allow"
        Action = [
          "logs:StartQuery",
          "logs:StopQuery",
          "logs:GetQueryResults",
          "logs:DescribeQueries"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "CloudWatch-Monitoring-Policy"
    Environment = "Production"
    Team        = "Monitoring"
  }
}

# IAM Policy for SNS Notifications
resource "aws_iam_policy" "sns_notifications_policy" {
  name        = "SNSNotificationsPolicy"
  description = "Policy for SNS topic and subscription management for alerts"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SNSTopicManagement"
        Effect = "Allow"
        Action = [
          "sns:CreateTopic",
          "sns:DeleteTopic",
          "sns:SetTopicAttributes",
          "sns:GetTopicAttributes",
          "sns:ListTopics",
          "sns:ListTopicsByTag"
        ]
        Resource = "*"
      },
      {
        Sid    = "SNSSubscriptionManagement"
        Effect = "Allow"
        Action = [
          "sns:Subscribe",
          "sns:Unsubscribe",
          "sns:ListSubscriptions",
          "sns:ListSubscriptionsByTopic",
          "sns:GetSubscriptionAttributes",
          "sns:SetSubscriptionAttributes"
        ]
        Resource = "*"
      },
      {
        Sid    = "SNSPublishAccess"
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = "*"
      },
      {
        Sid    = "SNSTagManagement"
        Effect = "Allow"
        Action = [
          "sns:TagResource",
          "sns:UntagResource",
          "sns:ListTagsForResource"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "SNS-Notifications-Policy"
    Environment = "Production"
    Team        = "Monitoring"
  }
}

# IAM Policy for Infrastructure Monitoring
resource "aws_iam_policy" "infrastructure_monitoring_policy" {
  name        = "InfrastructureMonitoringPolicy"
  description = "Policy for monitoring EC2, RDS, ALB, and other infrastructure resources"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2MonitoringAccess"
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumeStatus",
          "ec2:DescribeSnapshots"
        ]
        Resource = "*"
      },
      {
        Sid    = "RDSMonitoringAccess"
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters",
          "rds:DescribeDBLogFiles",
          "rds:DownloadDBLogFilePortion"
        ]
        Resource = "*"
      },
      {
        Sid    = "LoadBalancerMonitoringAccess"
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DescribeListeners"
        ]
        Resource = "*"
      },
      {
        Sid    = "AutoScalingMonitoringAccess"
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribePolicies"
        ]
        Resource = "*"
      },
      {
        Sid    = "S3MonitoringAccess"
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation",
          "s3:GetBucketNotification",
          "s3:GetBucketMetricsConfiguration"
        ]
        Resource = "*"
      },
      {
        Sid    = "EventBridgeAccess"
        Effect = "Allow"
        Action = [
          "events:PutRule",
          "events:DeleteRule",
          "events:DescribeRule",
          "events:ListRules",
          "events:PutTargets",
          "events:RemoveTargets",
          "events:ListTargetsByRule"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "Infrastructure-Monitoring-Policy"
    Environment = "Production"
    Team        = "Monitoring"
  }
}

# IAM Policy for Systems Manager (for enhanced monitoring)
resource "aws_iam_policy" "systems_manager_monitoring_policy" {
  name        = "SystemsManagerMonitoringPolicy"
  description = "Policy for Systems Manager monitoring capabilities"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SSMParameterAccess"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath",
          "ssm:DescribeParameters"
        ]
        Resource = "*"
      },
      {
        Sid    = "SSMInstanceAccess"
        Effect = "Allow"
        Action = [
          "ssm:DescribeInstanceInformation",
          "ssm:GetCommandInvocation",
          "ssm:ListCommandInvocations",
          "ssm:DescribeInstanceAssociationsStatus"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "Systems-Manager-Monitoring-Policy"
    Environment = "Production"
    Team        = "Monitoring"
  }
}

# IAM Group for Metrics and Monitoring Users
resource "aws_iam_group" "metrics_monitoring_users" {
  name = "metrics-monitoring-users"
  path = "/"
}

# Attach CloudWatch monitoring policy to group
resource "aws_iam_group_policy_attachment" "metrics_monitoring_cloudwatch_policy" {
  group      = aws_iam_group.metrics_monitoring_users.name
  policy_arn = aws_iam_policy.cloudwatch_monitoring_policy.arn
}

# Attach SNS notifications policy to group
resource "aws_iam_group_policy_attachment" "metrics_monitoring_sns_policy" {
  group      = aws_iam_group.metrics_monitoring_users.name
  policy_arn = aws_iam_policy.sns_notifications_policy.arn
}

# Attach infrastructure monitoring policy to group
resource "aws_iam_group_policy_attachment" "metrics_monitoring_infrastructure_policy" {
  group      = aws_iam_group.metrics_monitoring_users.name
  policy_arn = aws_iam_policy.infrastructure_monitoring_policy.arn
}

# Attach systems manager monitoring policy to group
resource "aws_iam_group_policy_attachment" "metrics_monitoring_ssm_policy" {
  group      = aws_iam_group.metrics_monitoring_users.name
  policy_arn = aws_iam_policy.systems_manager_monitoring_policy.arn
}

# Attach AWS managed CloudWatchReadOnlyAccess policy for additional read permissions
resource "aws_iam_group_policy_attachment" "metrics_monitoring_readonly_policy" {
  group      = aws_iam_group.metrics_monitoring_users.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

# Sample Monitoring Users (uncomment and modify as needed)
# resource "aws_iam_user" "monitoring_engineer_1" {
#   name = "monitoring-engineer-1"
#   path = "/"
#   
#   tags = {
#     Name = "Monitoring Engineer 1"
#     Team = "Monitoring"
#     Role = "Engineer"
#   }
# }

# resource "aws_iam_user" "sre_engineer_1" {
#   name = "sre-engineer-1"
#   path = "/"
#   
#   tags = {
#     Name = "Site Reliability Engineer 1"
#     Team = "SRE"
#     Role = "Engineer"
#   }
# }

# resource "aws_iam_user" "devops_monitoring_1" {
#   name = "devops-monitoring-1"
#   path = "/"
#   
#   tags = {
#     Name = "DevOps Monitoring Specialist 1"
#     Team = "DevOps"
#     Role = "Monitoring"
#   }
# }

# resource "aws_iam_group_membership" "metrics_monitoring_users_membership" {
#   name = "metrics-monitoring-users-membership"
#   
#   users = [
#     aws_iam_user.monitoring_engineer_1.name,
#     aws_iam_user.sre_engineer_1.name,
#     aws_iam_user.devops_monitoring_1.name,
#   ]
#   
#   group = aws_iam_group.metrics_monitoring_users.name
# }

# Outputs
output "cloudwatch_monitoring_policy_arn" {
  description = "ARN of the CloudWatch monitoring policy"
  value       = aws_iam_policy.cloudwatch_monitoring_policy.arn
}

output "sns_notifications_policy_arn" {
  description = "ARN of the SNS notifications policy"
  value       = aws_iam_policy.sns_notifications_policy.arn
}

output "infrastructure_monitoring_policy_arn" {
  description = "ARN of the infrastructure monitoring policy"
  value       = aws_iam_policy.infrastructure_monitoring_policy.arn
}

output "systems_manager_monitoring_policy_arn" {
  description = "ARN of the Systems Manager monitoring policy"
  value       = aws_iam_policy.systems_manager_monitoring_policy.arn
}

output "metrics_monitoring_users_group_name" {
  description = "Name of the metrics and monitoring users group"
  value       = aws_iam_group.metrics_monitoring_users.name
}
