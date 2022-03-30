
# ########################################
# ## Dynamodb for TF state locking
# ########################################
# module "kms_key" {
#   source                  = "../../03-resource/security/kms"
#   description             = "KMS key for dynamodb tf state lock"
#   deletion_window_in_days = 10
#   enable_key_rotation     = true
#   alias                   = "alias/dynamodb-tf-state-lock"
#   tags                    = var.tags
# }
# module "dynamodb_terraform_state_lock" {
#   source                             = "../../03-resource/database/dynamodb"
#   name                               = local.dynamodb_name
#   read_capacity                      = var.read_capacity
#   write_capacity                     = var.write_capacity
#   hash_key                           = var.hash_key
#   attributes                         = var.attributes
#   server_side_encryption_enabled     = var.server_side_encryption_enabled
#   billing_mode                       = "PROVISIONED"
#   tags                               = var.tags
#   server_side_encryption_kms_key_arn = module.kms_key.key_arn
# }


module "eks-vpc" {
  source = "../../03-resource/network/vpc"

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
  tags = merge(
    var.tags,
    {
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    }
  )
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}