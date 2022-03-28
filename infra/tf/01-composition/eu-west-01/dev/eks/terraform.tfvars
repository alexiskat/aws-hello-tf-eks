########################################
# Environment setting
########################################
region           = "eu-west-1"
env              = "dev"
application_name = "tf-hello-eks-demo"
app_name         = "tf-hello-eks-demo"

########################################
## DynamoDB
########################################
read_capacity                  = 5
write_capacity                 = 5
hash_key                       = "LockID"
server_side_encryption_enabled = true # enable server side encryption
attributes = [
  {
    name = "LockID"
    type = "S"
  }
]