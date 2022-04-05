
variable "app_code" {
  description = "A short hand for the application"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet ID's to be used by the cluster"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "ARN of the role used by the EKS cluster"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}