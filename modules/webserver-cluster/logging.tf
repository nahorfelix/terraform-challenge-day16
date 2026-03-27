resource "aws_cloudwatch_log_group" "app" {
  name              = "/webserver/${var.cluster_name}/app"
  retention_in_days = var.log_retention_days

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-app-logs"
  })
}
