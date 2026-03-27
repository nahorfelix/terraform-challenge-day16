terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # After bootstrapping remote state (modules/terraform-state), uncomment:
  # backend "s3" {
  #   bucket         = "your-unique-state-bucket-name"
  #   key            = "day16/dev/webserver-cluster/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "your-lock-table-name"
  #   encrypt        = true
  # }
}
