variable "bucket_name" {
  description = "S3 bucket name (will store terraform.tfstate)"
  type        = string
}

variable "table_name" {
  description = "DynamoDB table name (used for state lock)"
  type        = string
}

variable "force_destroy" {
  description = "If true, Terraform can delete the bucket even if it is not empty"
  type        = bool
  default     = false
}
