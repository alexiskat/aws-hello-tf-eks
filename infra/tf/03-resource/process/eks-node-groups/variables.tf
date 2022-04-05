
variable "app_code" {
  description = "A short hand for the application"
  type        = string
}

variable "eks_cluster_name" {
  description = "The EKS cluster name that the nodes will be attached to"
  type        = string
}

variable "node_role_arn" {
  description = "The IAM Role ARN to attaches to all the cluster nodes/workers"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet ID's to be used by the cluster"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}