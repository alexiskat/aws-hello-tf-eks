

output "cluster_id" {
  description = "The EKS cluster ID"
  value       = try(aws_eks_cluster.this.id, "")
}

output "cluster_name" {
  description = "The EKS cluster Name"
  value       = try(aws_eks_cluster.this.name, "")
}