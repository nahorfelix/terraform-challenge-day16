provider "aws" {
  region = var.aws_region
}

# Local path for development. For production, pin a Git tag:
# source = "git::https://github.com/YOUR_ORG/terraform-challenge-day16.git//modules/webserver-cluster?ref=v1.0.0"
module "webserver_cluster" {
  source = "../../modules/webserver-cluster"

  cluster_name  = var.cluster_name
  environment   = var.environment
  project_name  = var.project_name
  team_name     = var.team_name
  instance_type = var.instance_type
  min_size      = var.min_size
  max_size      = var.max_size
  server_port   = var.server_port

  enable_autoscaling         = var.enable_autoscaling
  enable_detailed_monitoring = var.enable_detailed_monitoring

  use_existing_vpc    = var.use_existing_vpc
  existing_vpc_name   = var.existing_vpc_name
  new_vpc_cidr        = var.new_vpc_cidr
  create_dns_record   = var.create_dns_record
  domain_name         = var.domain_name
  route53_zone_name   = var.route53_zone_name
  log_retention_days  = var.log_retention_days
  cpu_alarm_threshold = var.cpu_alarm_threshold
}
