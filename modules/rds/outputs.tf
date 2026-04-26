output "endpoint" {
  description = "Primary endpoint for the standard RDS instance or Aurora writer endpoint"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : aws_db_instance.standard[0].address
}

output "reader_endpoint" {
  description = "Reader endpoint for Aurora clusters"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].reader_endpoint : null
}

output "security_group_id" {
  description = "Security group id attached to the database"
  value       = aws_security_group.rds.id
}

output "subnet_group_name" {
  description = "Database subnet group name"
  value       = aws_db_subnet_group.default.name
}

output "parameter_group_name" {
  description = "Parameter group name used by the database"
  value       = var.use_aurora ? aws_rds_cluster_parameter_group.aurora[0].name : aws_db_parameter_group.standard[0].name
}