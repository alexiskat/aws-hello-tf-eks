########################################
# Environment setting
########################################
region           = "eu-west-1"
env              = "dev"
application_name = "tf-hello-eks-demo"
app_name         = "tf-hello-eks-demo"

########################################
## VPC
########################################
name = "eks-hello-vpc"
cidr = "999.11.0.0/16"

azs              = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
private_subnets  = ["10.11.1.0/24", "10.11.2.0/24", "10.11.3.0/24"]
public_subnets   = ["10.11.101.0/24", "10.11.102.0/24", "10.11.103.0/24"]
database_subnets = ["10.11.201.0/24", "10.11.202.0/24", "10.11.203.0/24"]

enable_nat_gateway = true
single_nat_gateway = true #set this to false for prod

enable_dns_hostnames = true
enable_dns_support   = true

########################################
## DynamoDB
########################################
# read_capacity                  = 5
# write_capacity                 = 5
# hash_key                       = "LockID"
# server_side_encryption_enabled = true # enable server side encryption
# attributes = [
#   {
#     name = "LockID"
#     type = "S"
#   }
# ]