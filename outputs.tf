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
