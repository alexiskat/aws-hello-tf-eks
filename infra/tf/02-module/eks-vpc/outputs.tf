## DynamoDB ##
#output "dynamodb_id" {
#  description = "The name of the table"
#  value       = module.dynamodb_terraform_state_lock.dynamodb_table_id
#}
#
#output "dynamodb_arn" {
#  description = "The arn of the table"
#  value       = module.dynamodb_terraform_state_lock.dynamodb_table_arn
#}

## VPC ##
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.eks_vpc.vpc_id
}