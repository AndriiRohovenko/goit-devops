output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "EKS cluster API server endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate data required for kubeconfig"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "Security group id attached to the EKS control plane"
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "node_group_name" {
  description = "Managed node group name"
  value       = aws_eks_node_group.this.node_group_name
}