########################################
# Variables
########################################

variable "env" {
  description = "The name of the environment."
  type        = string
}

variable "region" {
  type = string
}

variable "application_name" {
  description = "The name of the application."
  type        = string
}

variable "app_name" {
  description = "The name of the application."
  type        = string
}

########################################
## DynamoDB
########################################

# variable "read_capacity" {
#   description = "The number of read units for this table."
#   type        = string
# }
# 
# variable "write_capacity" {
#   description = "The number of write units for this table."
#   type        = string
# }
# 
# variable "hash_key" {
#   description = "The attribute to use as the hash (partition) key."
#   type        = string
# }
# 
# variable "attributes" {
#   description = "List of nested attribute definitions. Only required for hash_key and range_key attributes. Each attribute has two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data"
#   type        = list(map(string))
#   default     = []
# }
# 
# variable "server_side_encryption_enabled" {
#   description = "Encryption at rest using an AWS managed Customer Master Key. If enabled is false then server-side encryption is set to AWS owned CMK (shown as DEFAULT in the AWS console). If enabled is true then server-side encryption is set to AWS managed CMK (shown as KMS in the AWS console). ."
#   type        = string
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
