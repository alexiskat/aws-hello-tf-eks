
locals {
  tags = {
    Environment = var.env
    Application = var.app_name
    ManageBy    = "Terraform"
  }
}