variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state (lowercase, DNS-compliant)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.state_bucket_name))
    error_message = "state_bucket_name must be a valid S3 bucket name (lowercase letters, numbers, dots, hyphens)."
  }
}

variable "lock_table_name" {
  description = "DynamoDB table name used for Terraform state locking."
  type        = string
}

variable "environment" {
  description = "Deployment environment label for tagging."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "environment must be dev, staging, or production."
  }
}

variable "project_name" {
  description = "Project name for tagging."
  type        = string
}

variable "team_name" {
  description = "Owning team for tagging."
  type        = string
}
