variable "ecr_name" {
  description = "ECR repository name"
  type        = string
}

variable "scan_on_push" {
  description = "If true, scan Docker images on push"
  type        = bool
  default     = true
}
