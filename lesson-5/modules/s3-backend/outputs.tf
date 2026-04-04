output "bucket_url" {
  description = "S3 bucket URL"
  value       = "s3://${aws_s3_bucket.this.bucket}"
}

output "dynamodb_table_name" {
  description = "DynamoDB table name (state lock)"
  value       = aws_dynamodb_table.this.name
}
