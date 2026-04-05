output "repository_url" {
  description = "ECR repository URL (docker push target)"
  value       = aws_ecr_repository.this.repository_url
}
