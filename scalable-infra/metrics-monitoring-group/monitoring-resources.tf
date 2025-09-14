# Sample Monitoring Infrastructure Resources
# These are example resources that the monitoring team can manage

# SNS Topic for Critical Alerts
resource "aws_sns_topic" "critical_alerts" {
  name = "critical-infrastructure-alerts"

  tags = {
    Name        = "Critical Infrastructure Alerts"
    Environment = "Production"
    Team        = "Monitoring"
  }
}

# SNS Topic for Warning Alerts
resource "aws_sns_topic" "warning_alerts" {
  name = "warning-infrastructure-alerts"

  tags = {
    Name        = "Warning Infrastructure Alerts"
    Environment = "Production"
    Team        = "Monitoring"
  }
}

# Sample Email Subscription for Critical Alerts (uncomment and update email)
# resource "aws_sns_topic_subscription" "critical_email" {
#   topic_arn = aws_sns_topic.critical_alerts.arn
#   protocol  = "email"
#   endpoint  = "admin@yourcompany.com"
# }

# Sample Email Subscription for Warning Alerts (uncomment and update email)
# resource "aws_sns_topic_subscription" "warning_email" {
#   topic_arn = aws_sns_topic.warning_alerts.arn
#   protocol  = "email"
#   endpoint  = "monitoring@yourcompany.com"
# }

# CloudWatch Dashboard for Infrastructure Overview
resource "aws_cloudwatch_dashboard" "infrastructure_overview" {
  dashboard_name = "Infrastructure-Overview"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization"],
            ["AWS/ApplicationELB", "RequestCount"],
            ["AWS/RDS", "CPUUtilization"]
          ]
          period = 300
          stat   = "Average"
          region = "ap-south-1"
          title  = "Infrastructure Metrics Overview"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime"],
            ["AWS/RDS", "DatabaseConnections"]
          ]
          period = 300
          stat   = "Average"
          region = "ap-south-1"
          title  = "Performance Metrics"
        }
      }
    ]
  })

  depends_on = [
    aws_iam_policy.cloudwatch_monitoring_policy
  ]
}

# CloudWatch Alarm for High EC2 CPU Usage
resource "aws_cloudwatch_metric_alarm" "high_ec2_cpu" {
  alarm_name          = "high-ec2-cpu-usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_sns_topic.critical_alerts.arn]
  ok_actions          = [aws_sns_topic.critical_alerts.arn]

  tags = {
    Name        = "High EC2 CPU Usage"
    Environment = "Production"
    Team        = "Monitoring"
  }
}

# CloudWatch Alarm for ALB High Response Time
resource "aws_cloudwatch_metric_alarm" "high_alb_response_time" {
  alarm_name          = "high-alb-response-time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Average"
  threshold           = "2"
  alarm_description   = "This metric monitors ALB response time"
  alarm_actions       = [aws_sns_topic.warning_alerts.arn]
  ok_actions          = [aws_sns_topic.warning_alerts.arn]

  tags = {
    Name        = "High ALB Response Time"
    Environment = "Production"
    Team        = "Monitoring"
  }
}

# CloudWatch Alarm for RDS High CPU Usage
resource "aws_cloudwatch_metric_alarm" "high_rds_cpu" {
  alarm_name          = "high-rds-cpu-usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"
  alarm_description   = "This metric monitors RDS CPU utilization"
  alarm_actions       = [aws_sns_topic.critical_alerts.arn]
  ok_actions          = [aws_sns_topic.critical_alerts.arn]

  tags = {
    Name        = "High RDS CPU Usage"
    Environment = "Production"
    Team        = "Monitoring"
  }
}

# CloudWatch Log Group for Application Logs
resource "aws_cloudwatch_log_group" "application_logs" {
  name              = "/aws/application/product-v1"
  retention_in_days = 30

  tags = {
    Name        = "Application Logs"
    Environment = "Production"
    Team        = "Monitoring"
  }
}

# CloudWatch Log Group for Infrastructure Logs
resource "aws_cloudwatch_log_group" "infrastructure_logs" {
  name              = "/aws/infrastructure/product-v1"
  retention_in_days = 14

  tags = {
    Name        = "Infrastructure Logs"
    Environment = "Production"
    Team        = "Monitoring"
  }
}

# Outputs for monitoring resources
output "critical_alerts_topic_arn" {
  description = "ARN of the critical alerts SNS topic"
  value       = aws_sns_topic.critical_alerts.arn
}

output "warning_alerts_topic_arn" {
  description = "ARN of the warning alerts SNS topic"
  value       = aws_sns_topic.warning_alerts.arn
}

output "infrastructure_dashboard_url" {
  description = "URL of the infrastructure overview dashboard"
  value       = "https://console.aws.amazon.com/cloudwatch/home?region=ap-south-1#dashboards:name=${aws_cloudwatch_dashboard.infrastructure_overview.dashboard_name}"
}

output "application_log_group_name" {
  description = "Name of the application log group"
  value       = aws_cloudwatch_log_group.application_logs.name
}

output "infrastructure_log_group_name" {
  description = "Name of the infrastructure log group"
  value       = aws_cloudwatch_log_group.infrastructure_logs.name
}