output "alb_dns_name" {
  description = "DNS name of the public Application Load Balancer."
  value       = aws_lb.public.dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID of the ALB (for Route53 alias records)."
  value       = aws_lb.public.zone_id
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = aws_lb.public.arn
}

output "target_group_arn" {
  description = "ARN of the HTTP target group."
  value       = aws_lb_target_group.http.arn
}

output "autoscaling_group_name" {
  description = "Name of the web tier Auto Scaling group."
  value       = aws_autoscaling_group.web.name
}

output "vpc_id" {
  description = "VPC ID used by this cluster."
  value       = local.vpc_id
}

output "sns_topic_arn" {
  description = "SNS topic ARN for CloudWatch alarm notifications."
  value       = aws_sns_topic.alerts.arn
}

output "app_log_group_name" {
  description = "CloudWatch Logs group for application logs."
  value       = aws_cloudwatch_log_group.app.name
}
