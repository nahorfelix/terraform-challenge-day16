variable "cluster_name" {
  description = "Prefix for named resources in this stack."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "project_name" {
  description = "Project label applied via common_tags.Project."
  type        = string
}

variable "team_name" {
  description = "Owning team label applied via common_tags.Owner."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for ASG instances. If null, derived from environment (t2.micro dev, t2.medium prod)."
  type        = string
  default     = null

  validation {
    condition     = var.instance_type == null || can(regex("^(t2|t3)\\.(nano|micro|small|medium|large)", var.instance_type))
    error_message = "instance_type must be a t2 or t3 family size (e.g. t2.micro, t3.small)."
  }
}

variable "server_port" {
  description = "Application HTTP port on instances behind the ALB."
  type        = number
  default     = 8080

  validation {
    condition     = var.server_port >= 1024 && var.server_port <= 65535
    error_message = "server_port must be between 1024 and 65535."
  }
}

variable "enable_autoscaling" {
  description = "Create scale-out policy driven by CPU alarm."
  type        = bool
  default     = true
}

variable "enable_detailed_monitoring" {
  description = "Enable CloudWatch CPU alarm and SNS notifications."
  type        = bool
  default     = false
}

variable "create_dns_record" {
  description = "Create a Route53 alias to the ALB."
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "FQDN for Route53 when create_dns_record is true."
  type        = string
  default     = ""

  validation {
    condition     = !var.create_dns_record || length(trimspace(var.domain_name)) > 0
    error_message = "domain_name is required when create_dns_record is true."
  }
}

variable "route53_zone_name" {
  description = "Hosted zone name for Route53 lookup (e.g. example.com)."
  type        = string
  default     = ""

  validation {
    condition     = !var.create_dns_record || length(trimspace(var.route53_zone_name)) > 0
    error_message = "route53_zone_name is required when create_dns_record is true."
  }
}

variable "use_existing_vpc" {
  description = "Use an existing VPC by Name tag; otherwise create a new VPC."
  type        = bool
  default     = false
}

variable "existing_vpc_name" {
  description = "Tag Name of existing VPC when use_existing_vpc is true."
  type        = string
  default     = "existing-vpc"
}

variable "new_vpc_cidr" {
  description = "CIDR for a newly created VPC when use_existing_vpc is false."
  type        = string
  default     = "10.42.0.0/16"
}

variable "additional_tags" {
  description = "Extra tags merged into common_tags on supported resources."
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "CloudWatch log group retention in days."
  type        = number
  default     = 30

  validation {
    condition = contains([
      0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180,
      365, 400, 545, 731, 1827, 3653
    ], var.log_retention_days)
    error_message = "log_retention_days must be a valid CloudWatch Logs retention value."
  }
}

variable "cpu_alarm_threshold" {
  description = "CPU percent threshold for the high-CPU alarm."
  type        = number
  default     = 80
}

variable "min_size" {
  description = "Override ASG minimum size (default: env-based — 1 dev/staging, 3 production)."
  type        = number
  default     = null

  validation {
    condition     = var.min_size == null || var.min_size >= 1
    error_message = "min_size must be >= 1 when set."
  }
}

variable "max_size" {
  description = "Override ASG maximum size (default: env-based — 3 dev/staging, 10 production)."
  type        = number
  default     = null

  validation {
    condition     = var.max_size == null || var.max_size >= 1
    error_message = "max_size must be >= 1 when set."
  }

  validation {
    condition     = var.min_size == null || var.max_size == null || var.max_size >= var.min_size
    error_message = "max_size must be >= min_size when both are set."
  }
}
