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

output "db_endpoint" {
  description = "Primary database endpoint"
  value       = module.rds.endpoint
}

output "db_reader_endpoint" {
  description = "Aurora reader endpoint when Aurora is enabled"
  value       = module.rds.reader_endpoint
}

output "db_security_group_id" {
  description = "Security group attached to the database"
  value       = module.rds.security_group_id
}

output "jenkins_namespace" {
  description = "Namespace where Jenkins is installed"
  value       = var.enable_k8s_addons ? module.jenkins[0].namespace : null
}

output "jenkins_url" {
  description = "Jenkins load balancer URL, if assigned"
  value       = var.enable_k8s_addons ? module.jenkins[0].url : null
}

output "jenkins_admin_user" {
  description = "Jenkins admin user"
  value       = var.enable_k8s_addons ? module.jenkins[0].admin_user : null
}

output "argocd_namespace" {
  description = "Namespace where Argo CD is installed"
  value       = var.enable_k8s_addons ? module.argo_cd[0].namespace : null
}

output "argocd_server_url" {
  description = "Argo CD load balancer URL, if assigned"
  value       = var.enable_k8s_addons ? module.argo_cd[0].server_url : null
}

output "argocd_admin_password" {
  description = "Initial Argo CD admin password"
  value       = var.enable_k8s_addons ? module.argo_cd[0].admin_password : null
  sensitive   = true
}
