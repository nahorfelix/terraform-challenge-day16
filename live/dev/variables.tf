variable "aws_region" {
  description = "AWS region for this stack."
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Logical name prefix for the webserver cluster."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project tag (common_tags.Project)."
  type        = string
}

variable "team_name" {
  description = "Owning team tag (common_tags.Owner)."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type (t2/t3 family)."
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "ASG minimum capacity."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "ASG maximum capacity."
  type        = number
  default     = 2
}

variable "server_port" {
  description = "Application HTTP port on instances."
  type        = number
  default     = 8080
}

variable "enable_autoscaling" {
  type    = bool
  default = true
}

variable "enable_detailed_monitoring" {
  description = "Enable CloudWatch CPU alarm + SNS (also on by default in production)."
  type        = bool
  default     = true
}

variable "use_existing_vpc" {
  type    = bool
  default = false
}

variable "existing_vpc_name" {
  type    = string
  default = ""
}

variable "new_vpc_cidr" {
  type    = string
  default = "10.42.0.0/16"
}

variable "create_dns_record" {
  type    = bool
  default = false
}

variable "domain_name" {
  type    = string
  default = ""
}

variable "route53_zone_name" {
  type    = string
  default = ""
}

variable "log_retention_days" {
  type    = number
  default = 30
}

variable "cpu_alarm_threshold" {
  type    = number
  default = 80
}
