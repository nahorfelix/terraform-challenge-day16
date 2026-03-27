# webserver-cluster

Production-style module: VPC (optional), public ALB, ASG with **ELB health checks**, IAM least-privilege for CloudWatch Logs, SNS + CPU alarm, consistent tagging via `locals.common_tags`, and variable validation.

## Usage

```hcl
module "web" {
  source = "git::https://github.com/YOUR_ORG/terraform-challenge-day16.git//modules/webserver-cluster?ref=v1.0.0"

  cluster_name  = "my-app"
  environment   = "dev"
  project_name  = "payments"
  team_name     = "platform"

  min_size = 1
  max_size = 2
}
```

Pin `ref=` to a **tag or commit**, not `main`, for reproducible deploys.

## Key inputs

| Name | Description |
|------|-------------|
| `environment` | `dev`, `staging`, or `production` (validated) |
| `instance_type` | t2/t3 family (regex validated) |
| `min_size` / `max_size` | Optional overrides; defaults scale with `environment` |
| `enable_detailed_monitoring` | Enables CloudWatch CPU alarm + SNS notifications |
| `use_existing_vpc` | If true, supply `existing_vpc_name` and subnets must reach an IGW for the ALB |

## Outputs

`alb_dns_name`, `alb_zone_id`, `target_group_arn`, `autoscaling_group_name`, `sns_topic_arn`, `app_log_group_name`, `vpc_id`.

## Requirements

- Terraform `>= 1.5.0` (uses `lifecycle { precondition { ... } }`)
- AWS provider `~> 5.0`
