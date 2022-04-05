########################################
## Dynamodb for TF state locking
########################################
locals {
  dynamodb_name = "dynamo-${var.region}-${var.env}-terraform-state-lock"
}