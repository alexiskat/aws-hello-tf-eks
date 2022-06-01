
output "oidc_arn" {
  description = "ARN of openid provider"
  value       = try(aws_iam_openid_connect_provider.this.arn, "")
}