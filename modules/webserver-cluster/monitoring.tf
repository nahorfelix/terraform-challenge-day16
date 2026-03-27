resource "aws_sns_topic" "alerts" {
  name = "${replace(var.cluster_name, "_", "-")}-alerts"

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-alerts"
  })
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count = local.monitoring_enabled ? 1 : 0

  alarm_name          = "${var.cluster_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = var.cpu_alarm_threshold
  alarm_description   = "Triggers when ASG average CPU exceeds ${var.cpu_alarm_threshold}% for 4 minutes"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  alarm_actions = concat(
    [aws_sns_topic.alerts.arn],
    local.autoscaling_enabled ? [aws_autoscaling_policy.scale_out[0].arn] : []
  )

  treat_missing_data = "notBreaching"
}
