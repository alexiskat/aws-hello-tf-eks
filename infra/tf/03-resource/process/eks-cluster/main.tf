# EKS Cluster

resource "aws_eks_cluster" "this" {
  name     = "${var.app_code}-cluster"
  role_arn = var.cluster_role_arn
  version  = "1.22"

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true #Make the API server access via internet. Can be to false but need bastion
    public_access_cidrs     = ["82.24.103.68/32"]
  }

  tags = var.tags
}