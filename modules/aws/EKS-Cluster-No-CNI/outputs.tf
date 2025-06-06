# -------------------------------------------------------------------------------------
#
# Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
#
# This software is the property of WSO2 LLC. and its suppliers, if any.
# Dissemination of any information or reproduction of any material contained
# herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
# You may not alter or remove any copyright or other notice from copies of this content.
#
# --------------------------------------------------------------------------------------

output "eks_cluster_name" {
  value      = aws_eks_cluster.eks_cluster.name
  depends_on = [aws_eks_cluster.eks_cluster]
}

output "eks_subnet_ids" {
  value      = aws_subnet.eks_subnet[*].id
  depends_on = [aws_subnet.eks_subnet]
}

output "eks_security_group_rule_id" {
  value      = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  depends_on = [aws_subnet.eks_subnet]
}

output "autoscaler_role_arn" {
  value      = var.enable_autoscaler ? aws_iam_role.cluster_autoscaler_role[0].arn : null
  depends_on = [aws_iam_role.cluster_autoscaler_role[0]]
}

output "lb_role_arn" {
  value      = var.enable_cluster_loadbalancer ? aws_iam_role.cluster_loadbalancer_role[0].arn : null
  depends_on = [aws_iam_role.cluster_loadbalancer_role[0]]
}

output "cloudwatch_fluent_bit_agent_role_arn" {
  value      = var.enable_fluent_bit ? aws_iam_role.cluster_container_cloudwatch_fluent_bit_agent_role[0].arn : null
  depends_on = [aws_iam_role.cluster_container_cloudwatch_fluent_bit_agent_role[0]]
}

output "cloudwatch_agent_role_arn" {
  value      = var.enable_cloudwatch_agent ? aws_iam_role.cluster_cloudwatch_agent_role[0].arn : null
  depends_on = [aws_iam_role.cluster_cloudwatch_agent_role[0]]
}

output "ebs_csi_driver_role_arn" {
  value      = var.enable_ebs_csi_driver ? aws_iam_role.cluster_ebs_csi_driver_role[0].arn : null
  depends_on = [aws_iam_role.cluster_ebs_csi_driver_role[0]]
}

output "efs_csi_driver_role_arn" {
  value      = var.enable_efs_csi_driver ? aws_iam_role.cluster_efs_csi_driver_role[0].arn : null
  depends_on = [aws_iam_role.cluster_efs_csi_driver_role[0]]
}

output "oidc_provider_arn" {
  value      = aws_iam_openid_connect_provider.eks_ca_oidc_provider.arn
  depends_on = [aws_iam_openid_connect_provider.eks_ca_oidc_provider]
}

output "oidc_provider_id" {
  value      = aws_iam_openid_connect_provider.eks_ca_oidc_provider.id
  depends_on = [aws_iam_openid_connect_provider.eks_ca_oidc_provider]
}

output "oidc_provider_url" {
  value      = aws_iam_openid_connect_provider.eks_ca_oidc_provider.url
  depends_on = [aws_iam_openid_connect_provider.eks_ca_oidc_provider]
}

output "eks_cluster_endpoint" {
  value      = aws_eks_cluster.eks_cluster.endpoint
  depends_on = [aws_eks_cluster.eks_cluster]
}

output "tls_cert_sha1_fingerprint" {
  value      = data.tls_certificate.tls.certificates[0].sha1_fingerprint
  depends_on = [data.tls_certificate.tls]
}

output "eks_cluster_issuer" {
  value      = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
  depends_on = [data.aws_eks_cluster.eks_cluster]
}

output "eks_route_table_ids" {
  value      = aws_route_table.route_table[*].id
  depends_on = [aws_route_table.route_table]
}

output "eks_security_group_id" {
  value      = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  depends_on = [aws_eks_cluster.eks_cluster]
}

output "eks_base64_encoded_ca_cert" {
  value      = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  depends_on = [aws_eks_cluster.eks_cluster]
}

output "eks_cluster_arn" {
  value      = aws_eks_cluster.eks_cluster.arn
  depends_on = [aws_eks_cluster.eks_cluster]
}
