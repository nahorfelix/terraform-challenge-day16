# Day 16 — Building Production-Grade Infrastructure

Chapter 8 themes: **modular**, **testable**, **tagged**, **validated**, and **operable** Terraform — refactored webserver stack with remote-state bootstrap module, Terratest example, and checklist-oriented patterns.

## Layout

```
terraform-challenge-day16/
├── modules/
│   ├── webserver-cluster/     # ALB + ASG (ELB health checks), SNS, alarms, logs, IAM
│   └── terraform-state/       # S3 + DynamoDB (encryption, prevent_destroy)
├── live/dev/                  # Example root calling webserver-cluster
├── test/                      # Terratest (Go) — optional CI run
├── backend.tf.example         # Remote state wiring after bootstrap
└── .gitignore
```

## Checklist highlights

| Area | Implementation |
|------|----------------|
| Structure | Split `.tf` files (VPC, security, ALB, ASG, IAM, logging, monitoring) |
| Tags | `locals.common_tags` → `merge(...)` on resources |
| No literals | Variables + `coalesce` / `locals` for sizing |
| Reliability | ASG `health_check_type = "ELB"`; `create_before_destroy` on LT/SG/ASG; `name_prefix` on SGs |
| Critical data | `prevent_destroy` on state bucket + lock table module |
| Security | No secrets in repo; least-privilege IAM for log writes; instance ingress only from ALB SG |
| Observability | CloudWatch log retention; CPU alarm → SNS; optional scale-out policy |
| Maintainability | Module READMEs; pinned `required_providers`; `.terraform.lock.hcl` committed |

## Commands

```powershell
cd live/dev
copy terraform.tfvars.example terraform.tfvars   # edit values
terraform init
terraform plan
terraform apply
```

Destroy when done to avoid charges:

```powershell
terraform destroy
```

## Remote state (Lab 1–2)

1. Apply `modules/terraform-state` once (unique bucket name globally).
2. Uncomment `backend "s3"` in `live/dev/versions.tf` and point at bucket + DynamoDB table.
3. `terraform init -migrate-state` from `live/dev`.

## Terratest

```powershell
cd test
go mod tidy
go test -v -timeout 60m
```

Requires Go, AWS credentials, and real AWS spend for the test stack.
