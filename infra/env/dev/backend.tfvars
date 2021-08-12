bucket         = "k8s-dev-terraform-state-files"
key            = "terraform.tfstate"
region         = "eu-west-1"
dynamodb_table = "k8s-terraform-lock"
encrypt        = true