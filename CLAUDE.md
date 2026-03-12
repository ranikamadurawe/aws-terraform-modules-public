# CLAUDE.md

## Project Overview

AWS Terraform modules for WSO2 cloud deployments. This repository contains reusable Terraform modules for AWS and MongoDB Atlas resources.

## Repository Structure

```
modules/
├── aws/           # AWS provider modules (100+ modules)
└── mongodbatlas/  # MongoDB Atlas provider modules
```

Module directories use PascalCase with hyphens (e.g., `EKS-Cluster`, `Autoscaling-Group`).

## Standard Module File Structure

Every module must contain these files:

| File | Purpose |
|---|---|
| `versions.tf` | Required providers and Terraform version constraints |
| `variables.tf` | Input variable declarations |
| `outputs.tf` | Output value declarations |
| `<resource>.tf` | Main resource definition (named after the resource type in snake_case) |

Optional files used when needed: `data.tf`, `locals.tf`, `iam_role.tf`, `network.tf`.

## Naming Conventions

**TF files**: snake_case matching the resource type (e.g., `autoscaling_group.tf`, `iam_role.tf`)

**Terraform resource labels**: snake_case matching the file name (e.g., `resource "aws_autoscaling_group" "autoscaling_group"`)

**Resource name values**: Always constructed using:
```hcl
join("-", [var.project, var.application, var.environment, var.region, var.name, "<suffix>"])
```
Where `<suffix>` is a short abbreviation (e.g., `asg`, `sg`, `vpc`).

## Standard Variables

All modules must include these common variables:

```hcl
variable "project"     { type = string }
variable "environment" { type = string }
variable "application" { type = string }
variable "region"      { type = string }
variable "name"        { type = string }
variable "tags"        { ... }
```

**Tags pattern** — always use a list of objects:
```hcl
variable "tags" {
  type = list(object({
    key                 = string
    value               = string
    propagate_at_launch = optional(bool, true)
  }))
}
```

## Provider Version Requirements

**AWS modules** (`versions.tf`):
```hcl
terraform {
  required_version = ">= 1.3.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

**MongoDB Atlas modules** (`versions.tf`):
```hcl
terraform {
  required_version = ">= 1.6"
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = ">= 1.15"
    }
  }
}
```

## Copyright Header

Every `.tf` file must start with this header (update the year accordingly):

```hcl
# -------------------------------------------------------------------------------------
#
# Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
#
# This software is the property of WSO2 LLC. and its suppliers, if any.
# Dissemination of any information or reproduction of any material contained
# herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
# You may not alter or remove any copyright or other notice from copies of this content.
#
# --------------------------------------------------------------------------------------
```

## Lifecycle Conventions

Most resources use:
```hcl
lifecycle {
  create_before_destroy = true
}
```

## CI/CD Checks

All PRs against `main` must pass three GitHub Actions workflows:

1. **TF Formatting** (`tffmt.yml`): `terraform fmt` compliance via super-linter
2. **TF Linter** (`tflinter.yml`): `tflint` checks via super-linter
3. **Trivy Security Scan** (`trivy.yml`): IaC security scan (ignores `AVD-AWS-0052`, `AVD-AWS-0053`)

Before submitting a PR, ensure formatting is correct locally:
```bash
terraform fmt -recursive
```

## Git Workflow

- **Main branch**: `main`
- Work on feature branches; PRs target `main`
- Commit messages are short and imperative (e.g., `Create autoscaling-group module`, `Fix linter issues`, `Add module output file`)
- PRs use the template in `pull_request_template.md`
