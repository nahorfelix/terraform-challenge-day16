# terraform-state

Creates an encrypted, versioned S3 bucket and a DynamoDB table for Terraform remote state. The S3 bucket and lock table use `lifecycle { prevent_destroy = true }` to reduce accidental deletion.

## Usage

```hcl
module "remote_state" {
  source = "../../modules/terraform-state"

  state_bucket_name = "mycompany-terraform-state-unique"
  lock_table_name   = "terraform-locks"
  project_name      = "platform"
  team_name         = "infra"
  environment       = "production"
}
```

Point your root module `backend "s3"` block at `bucket` and `dynamodb_table` from this module (deploy state backend once, then configure the backend).

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | ~> 5.0 |

## Inputs

| Name | Description | Type |
|------|-------------|------|
| state_bucket_name | Globally unique bucket name | string |
| lock_table_name | DynamoDB lock table name | string |
| project_name | Tag: Project | string |
| team_name | Tag: Owner | string |
| environment | dev / staging / production | string |

## Outputs

| Name | Description |
|------|-------------|
| state_bucket_id | Bucket name |
| state_bucket_arn | Bucket ARN |
| dynamodb_table_name | Lock table name |
| dynamodb_table_arn | Lock table ARN |
