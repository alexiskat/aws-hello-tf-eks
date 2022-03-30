########################################
# Metadata
########################################
variable "env" {
  description = "The name of the environment."
  type        = string
}

variable "region" {
  description = "The AWS region this bucket should reside in."
  type        = string
}

########################################
## DynamoDB
########################################

# variable "attributes" {
#   description = "List of nested attribute definitions. Only required for hash_key and range_key attributes. Each attribute has two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data"
#   type        = list(map(string))
#   default     = []
# }
# 
# variable "hash_key" {
#   description = "The attribute to use as the hash (partition) key. Must also be defined as an attribute"
#   type        = string
#   default     = null
# }
# 
# variable "write_capacity" {
#   description = "The number of write units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
#   type        = number
#   default     = null
# }
# 
# variable "read_capacity" {
#   description = "The number of read units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
#   type        = number
#   default     = null
# }
# 
# variable "server_side_encryption_enabled" {
#   description = "Whether or not to enable encryption at rest using an AWS managed KMS customer master key (CMK)"
#   type        = bool
#   default     = false
# }
# 
# variable "tags" {
#   description = "A map of tags to add to all resources"
#   type        = map(string)
#   default     = {}
# }

########################################
## VPC
########################################
variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}
variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
}
variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
}
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
}
variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}
variable "database_subnets" {
  description = "A list of database subnets"
  type        = list(string)
  default     = []
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
}
variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "eks_cluster_name" {
  description = "The EKS cluster name"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}