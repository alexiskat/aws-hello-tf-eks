########################################
## Dynamodb for TF state locking
########################################
locals {
  dynamodb_name = "dynamo-${var.region}-${var.env}-terraform-state-lock"
}

data "tls_certificate" "eks-demo-cluster" {
  url = module.eks_cluster.cluster_identity.0.oidc.0.issuer
}