
########################################
## Dynamodb for TF state locking
########################################
module "dynamodb_terraform_state_lock" {
  source                         = "../../03-resource/database/dynamodb"
  name                           = local.dynamodb_name
  read_capacity                  = var.read_capacity
  write_capacity                 = var.write_capacity
  hash_key                       = var.hash_key
  attributes                     = var.attributes
  server_side_encryption_enabled = var.server_side_encryption_enabled
  billing_mode                   = "PROVISIONED"
  tags                           = var.tags
}