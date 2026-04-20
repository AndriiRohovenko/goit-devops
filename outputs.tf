output "tfstate_bucket_url" {
  description = "S3 bucket used for Terraform state"
  value       = module.s3_backend.bucket_url
}

output "tfstate_lock_table_name" {
  description = "DynamoDB table used for Terraform state lock"
  value       = module.s3_backend.dynamodb_table_name
}

output "vpc_id" {
  description = "VPC id"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet ids"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet ids"
  value       = module.vpc.private_subnet_ids
}

output "ecr_repository_url" {
  description = "ECR repository URL (where to push images)"
  value       = module.ecr.repository_url
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "EKS control plane security group id"
  value       = module.eks.cluster_security_group_id
}

output "eks_node_group_name" {
  description = "Managed node group name"
  value       = module.eks.node_group_name
}

output "jenkins_namespace" {
  description = "Namespace where Jenkins is installed"
  value       = module.jenkins.namespace
}

output "jenkins_url" {
  description = "Jenkins load balancer URL, if assigned"
  value       = module.jenkins.url
}

output "jenkins_admin_user" {
  description = "Jenkins admin user"
  value       = module.jenkins.admin_user
}

output "argocd_namespace" {
  description = "Namespace where Argo CD is installed"
  value       = module.argo_cd.namespace
}

output "argocd_server_url" {
  description = "Argo CD load balancer URL, if assigned"
  value       = module.argo_cd.server_url
}

output "argocd_admin_password" {
  description = "Initial Argo CD admin password"
  value       = module.argo_cd.admin_password
  sensitive   = true
}
