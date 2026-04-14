variable "bucket_name" {
  description = "S3 bucket name (will store terraform.tfstate)"
  type        = string
}

variable "aws_region" {
  description = "AWS region for provider-managed resources"
  type        = string
  default     = "eu-central-1"
}

variable "backend_force_destroy" {
  description = "If true, Terraform can delete the backend bucket even when it contains state objects"
  type        = bool
  default     = true
}

variable "table_name" {
  description = "DynamoDB table name (used for state lock)"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC network range (CIDR), for example 10.0.0.0/16"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet CIDRs (3 items)"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDRs (3 items)"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for subnets (same count/order as subnets)"
  type        = list(string)
}

variable "vpc_name" {
  description = "Name used in AWS tags"
  type        = string
}

variable "ecr_name" {
  description = "ECR repository name"
  type        = string
}

variable "scan_on_push" {
  description = "If true, scan Docker images on push"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.32"
}

variable "node_group_name" {
  description = "Managed node group name"
  type        = string
}

variable "node_desired_size" {
  description = "Desired number of EKS worker nodes"
  type        = number
  default     = 3
}

variable "node_min_size" {
  description = "Minimum number of EKS worker nodes"
  type        = number
  default     = 3
}

variable "node_max_size" {
  description = "Maximum number of EKS worker nodes"
  type        = number
  default     = 3
}

variable "node_instance_types" {
  description = "EC2 instance types for the EKS worker nodes"
  type        = list(string)
  default     = ["t3.micro"]
}
