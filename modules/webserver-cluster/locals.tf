locals {
  is_production = var.environment == "production"

  resolved_instance_type = coalesce(
    var.instance_type,
    local.is_production ? "t2.medium" : "t2.micro"
  )

  min_size = coalesce(var.min_size, local.is_production ? 3 : 1)
  max_size = coalesce(var.max_size, local.is_production ? 10 : 3)

  monitoring_enabled  = local.is_production || var.enable_detailed_monitoring
  autoscaling_enabled = var.enable_autoscaling

  common_tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "terraform"
      Project     = var.project_name
      Owner       = var.team_name
    },
    var.additional_tags
  )

  vpc_id     = var.use_existing_vpc ? data.aws_vpc.existing[0].id : aws_vpc.this[0].id
  subnet_ids = var.use_existing_vpc ? data.aws_subnets.existing[0].ids : aws_subnet.public[*].id
}
