
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


module "eks_vpc" {
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
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    }
  )
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }
}

#
# Security Groups
#

module "eks_internet_sg" {
  source = "../../03-resource/security/security-group"

  name        = "${var.app_code}-public-sg"
  description = "Security group for Internet into ports 80 and 443"
  vpc_id      = module.eks_vpc.vpc_id
  tags        = var.tags

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Public https"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Public http"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Access to the internet"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "eks_data_plane_sg" {
  source = "../../03-resource/security/security-group"

  name        = "${var.app_code}-worker-sg"
  description = "Allow nodes to communicate with each other"
  vpc_id      = module.eks_vpc.vpc_id
  tags        = var.tags

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      description = "Allow nodes to communicate with each other"
      cidr_blocks = join(",", flatten([var.private_subnets, var.public_subnets]))
    },
    {
      from_port   = 1025
      to_port     = 65535
      protocol    = "tcp"
      description = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
      cidr_blocks = join(",", flatten([var.private_subnets, var.public_subnets]))
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow Nodes access to the internet"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "eks_control_plane_sg" {
  source = "../../03-resource/security/security-group"

  name        = "${var.app_code}-control-plane-sg"
  description = "Allow nodes to communicate with each other"
  vpc_id      = module.eks_vpc.vpc_id
  tags        = var.tags

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "Allow control place communicate with each other"
      cidr_blocks = join(",", flatten([var.private_subnets, var.public_subnets]))
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      description = "Allow access to the internet"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

#
# IAM
#
module "eks_cluster_role" {
  source = "../../03-resource/security/iam/assumable-role"

  role_name         = "${var.app_code}-cluster-role"
  role_requires_mfa = false
  trusted_role_services = [
    "eks.amazonaws.com"
  ]
  create_role = true
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]
  tags = var.tags
}

module "eks_node_role" {
  source = "../../03-resource/security/iam/assumable-role"

  role_name         = "${var.app_code}-worker-role"
  role_requires_mfa = false
  trusted_role_services = [
    "ec2.amazonaws.com"
  ]
  create_role = true
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  tags = var.tags
}

#
# EKS Cluster
#
module "eks_cluster" {
  source = "../../03-resource/process/eks-cluster"

  app_code         = var.app_code
  subnet_ids       = module.eks_vpc.private_subnets
  cluster_role_arn = module.eks_cluster_role.iam_role_arn
  tags             = var.tags
}

#
# EKS Nodes
#
module "eks_node" {
  source = "../../03-resource/process/eks-node-groups"

  eks_cluster_name = module.eks_cluster.cluster_name
  app_code         = var.app_code
  subnet_ids       = module.eks_vpc.private_subnets
  node_role_arn    = module.eks_node_role.iam_role_arn
  tags             = var.tags
}


module "eks_cluster_sg" {
  source = "../../03-resource/security/security-group"

  name        = "${var.app_code}-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = module.eks_vpc.vpc_id
  tags = merge(
    var.tags,
    {
      Name                                                    = "${var.eks_cluster_name}-node-sg"
      "kubernetes.io/cluster/${var.eks_cluster_name}-cluster" = "owned"
    }
  )

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  ingress_with_self = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      description = "Allow nodes to communicate with each other"
      self        = true
    }
  ]
  ingress_with_source_security_group_id = [
    {
      from_port                = 1025
      to_port                  = 65535
      protocol                 = "tcp"
      description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
      source_security_group_id = module.eks_cluster_sg.security_group_id
    },
  ]
}

module "eks_oidc" {
  source = "../../03-resource/security/oidc"

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks-demo-cluster.certificates[0].sha1_fingerprint]
  url             = module.eks_cluster.cluster_identity.0.oidc.0.issuer
  tags            = var.tags
}
  