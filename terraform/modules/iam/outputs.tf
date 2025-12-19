output "eks_cluster_role_arn" {
  description = "EKS cluster IAM role ARN"
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_nodes_role_arn" {
  description = "EKS nodes IAM role ARN"
  value       = aws_iam_role.eks_nodes.arn
}

output "eks_nodes_role_name" {
  description = "EKS nodes IAM role name"
  value       = aws_iam_role.eks_nodes.name
}