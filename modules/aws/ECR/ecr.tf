# -------------------------------------------------------------------------------------
#
# Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
#
# This software is the property of WSO2 LLC. and its suppliers, if any.
# Dissemination of any information or reproduction of any material contained
# herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
# You may not alter or remove any copyright or other notice from copies of this content.
#
# --------------------------------------------------------------------------------------

# AVD-AWS-0030 checks whether AWS's default scanning tool is enabled for the ECR repository,
# This ideally should be a customized parameter, based on the user's requirement
# https://avd.aquasec.com/misconfig/aws/ecr/avd-aws-0030/
# AVD-AWS-0033 checks whether AWS's default encryption is enabled for the ECR repository,
# While it has been enabled by default at the module level (check `encryption_type`) users may configure it
# as per their requirement
# https://avd.aquasec.com/misconfig/aws/ecr/avd-aws-0033/
# trivy:ignore:AVD-AWS-0030
# trivy:ignore:AVD-AWS-0033
resource "aws_ecr_repository" "ecr_repository" {
  name = join("-", [var.project, var.application, var.environment, var.region, "ecr"])
  tags = var.tags

  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push # Custom parameter for AVD-AWS-0030
  }

  encryption_configuration {
    encryption_type = var.encryption_type # Custom parameter for AVD-AWS-0033
    kms_key         = var.encryption_type == "KMS" ? var.kms_key : null
  }
}

resource "aws_iam_policy" "ecr_admin_iam_policy" {
  name = join("-", [var.project, var.application, var.environment, var.region, "ecr-admin-iam-policy"])

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ],
        Effect   = "Allow",
        Resource = aws_ecr_repository.ecr_repository.arn
      }
    ]
  })
  depends_on = [
    aws_ecr_repository.ecr_repository
  ]
  tags = var.tags
}

resource "aws_iam_policy" "ecr_pull_only_iam_policy" {
  name = join("-", [var.project, var.application, var.environment, var.region, "ecr-pull-only-iam-policy"])

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ],
        Effect   = "Allow",
        Resource = aws_ecr_repository.ecr_repository.arn
      }
    ]
  })
  tags = var.tags

  depends_on = [
    aws_ecr_repository.ecr_repository
  ]
}
