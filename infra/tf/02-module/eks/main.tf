
########################################
## Dynamodb for TF state locking
########################################
module "kms_key" {
  source                  = "../../03-resource/security/kms"
  description             = "KMS key for dynamodb tf state lock"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  alias                   = "alias/dynamodb-tf-state-lock"
  tags                    = var.tags
}
module "dynamodb_terraform_state_lock" {
  source                             = "../../03-resource/database/dynamodb"
  name                               = local.dynamodb_name
  read_capacity                      = var.read_capacity
  write_capacity                     = var.write_capacity
  hash_key                           = var.hash_key
  attributes                         = var.attributes
  server_side_encryption_enabled     = var.server_side_encryption_enabled
  billing_mode                       = "PROVISIONED"
  tags                               = var.tags
  server_side_encryption_kms_key_arn = module.kms_key.alias_name
}