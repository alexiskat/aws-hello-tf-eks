# terraform init -backend-config=backend.config

module "dynamoDb-backend-only" {
  source = "../../../../02-Module/eks" # using infra module VPC which acts like a facade to many sub-resources
  ## DynamoDB ##
  read_capacity                  = var.read_capacity
  write_capacity                 = var.write_capacity
  hash_key                       = var.hash_key
  server_side_encryption_enabled = var.server_side_encryption_enabled
  attributes                     = var.attributes
  ## Common tag metadata ##
  #app_name = var.application_name
  env    = var.env
  tags   = local.tags
  region = var.region
}