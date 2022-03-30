
locals {
 
  eks_cluster_name = "hello-eks"
  tags = {
    Environment = var.env
    Application = var.app_name
    ManageBy    = "Terraform"
  }
}
