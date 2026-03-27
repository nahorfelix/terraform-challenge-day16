provider "aws" {
  region = var.aws_region
}

module "webserver_cluster" {
  source = "../../../modules/webserver-cluster"

  cluster_name  = var.cluster_name
  environment   = var.environment
  project_name  = var.project_name
  team_name     = var.team_name
  instance_type = var.instance_type
  min_size      = var.min_size
  max_size      = var.max_size

  enable_detailed_monitoring = var.enable_detailed_monitoring
  use_existing_vpc           = false
}
