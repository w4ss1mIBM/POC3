# IAM Role for EC2
resource "aws_iam_role" "ec2_cloudwatch_ssm_role" {
  name = "ec2_cloudwatch_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server_policy" {
  role       = aws_iam_role.ec2_cloudwatch_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ec2_cloudwatch_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#EC2 instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_cloudwatch_ssm_profile"
  role = aws_iam_role.ec2_cloudwatch_ssm_role.name
}



# resource "aws_sns_topic" "ec2_monitoring" {
#   name         = local.topic_name_ec2_resource_utilization
#   display_name = "EC2 Instance Resource Utilization"
# }

# resource "aws_sns_topic_subscription" "email_subscription" {
#   for_each  = toset(var.emails)
#   topic_arn = aws_sns_topic.ec2_monitoring.arn
#   protocol  = "email"
#   endpoint  = each.value
# }

# resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
#   count               = length(aws_instance.windows_ec2.*.id)
#   alarm_name          = "${local.cpu_alarm_name}-${count.index}"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 60
#   statistic           = "Average"
#   threshold           = local.cpu_utilization_threshold
#   alarm_description   = "Monitors EC2 CPU utilization."
#   dimensions          = { InstanceId = aws_instance.windows_ec2[count.index].id }
#   alarm_actions       = [aws_sns_topic.ec2_monitoring.arn]
# }

# resource "aws_cloudwatch_metric_alarm" "logical_disk_free_space_alarm" {
#   count               = length(aws_instance.windows_ec2.*.id)
#   alarm_name          = "${local.disk_alarm_name}-${count.index}"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "LogicalDisk % Free Space"
#   namespace           = "CWAgent"
#   period              = 60
#   statistic           = "Average"
#   threshold           = local.logical_disk_free_space_threshold
#   dimensions          = { InstanceId = aws_instance.windows_ec2[count.index].id }
#   alarm_actions       = [aws_sns_topic.ec2_monitoring.arn]
# }

# resource "aws_cloudwatch_metric_alarm" "memory_committed_bytes_in_use_alarm" {
#   count               = length(aws_instance.windows_ec2.*.id)
#   alarm_name          = "${local.memory_alarm_name}-${count.index}"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = 3
#   metric_name         = "Memory % Committed Bytes In Use"
#   namespace           = "CWAgent"
#   period              = 60
#   statistic           = "Average"
#   threshold           = local.memory_utilization_threshold
#   dimensions          = { InstanceId = aws_instance.windows_ec2[count.index].id }
#   alarm_actions       = [aws_sns_topic.ec2_monitoring.arn]
# }

# resource "aws_sns_topic" "ec2_state_change" {
#   name         = local.topic_name_ec2_stat_change
#   display_name = "AWS EC2 State Change"
# }

# resource "aws_sns_topic_subscription" "ec2_state_change_email" {
#   for_each  = toset(var.emails)
#   topic_arn = aws_sns_topic.ec2_state_change.arn
#   protocol  = "email"
#   endpoint  = each.value
# }

# resource "aws_cloudwatch_event_rule" "ec2_state_change" {
#   name        = local.ec2_state_change_rule_name
#   description = "Triggers SNS topic when EC2 instance state changes"
#   event_pattern = jsonencode({
#     source        = ["aws.ec2"],
#     "detail-type" = ["EC2 Instance State-change Notification"],
#     detail = {
#       state = ["stopped", "terminated", "running"]
#     }
#   })
# }

# resource "aws_cloudwatch_event_target" "ec2_state_change_target" {
#   rule      = aws_cloudwatch_event_rule.ec2_state_change.name
#   target_id = "ec2StateChangeTarget"
#   arn       = aws_sns_topic.ec2_state_change.arn
# }

# resource "aws_sns_topic_policy" "default" {
#   arn    = aws_sns_topic.ec2_state_change.arn
#   policy = data.aws_iam_policy_document.sns_topic_policy.json
# }

# data "aws_iam_policy_document" "sns_topic_policy" {
#   statement {
#     effect  = "Allow"
#     actions = ["SNS:Publish"]
#     principals {
#       type        = "Service"
#       identifiers = ["events.amazonaws.com"]
#     }
#     resources = [aws_sns_topic.ec2_state_change.arn]
#   }
# }
