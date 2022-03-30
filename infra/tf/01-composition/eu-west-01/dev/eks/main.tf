# terraform init -backend-config=backend.config

module "eks-vpc" {
  source = "../../../../02-Module/eks-vpc" # using infra module VPC which acts like a facade to many sub-resources
  #  ## DynamoDB ##
  #  read_capacity                  = var.read_capacity
  #  write_capacity                 = var.write_capacity
  #  hash_key                       = var.hash_key
  #  server_side_encryption_enabled = var.server_side_encryption_enabled
  #  attributes                     = var.attributes
  name = var.name
  cidr = var.cidr

  azs              = var.azs
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  ## Common tag metadata ##
  #app_name = var.application_name
  env    = var.env
  tags   = local.tags
  region = var.region
}
