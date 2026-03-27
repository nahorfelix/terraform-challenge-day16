output "alb_dns_name" {
  description = "Open this URL in a browser to hit the load balancer."
  value       = module.webserver_cluster.alb_dns_name
}

output "alb_url" {
  description = "HTTP URL for the load-balanced app."
  value       = "http://${module.webserver_cluster.alb_dns_name}"
}

output "sns_topic_arn" {
  description = "SNS topic for CloudWatch alarms."
  value       = module.webserver_cluster.sns_topic_arn
}
