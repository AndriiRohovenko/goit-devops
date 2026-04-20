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

variable "app_repo_url" {
  description = "Git URL of the Django application repository that Jenkins builds"
  type        = string
}

variable "gitops_repo_url" {
  description = "Git URL of the GitOps repository watched by Argo CD"
  type        = string
}

variable "gitops_repo_branch" {
  description = "Git branch that Jenkins updates in the GitOps repository"
  type        = string
  default     = "main"
}

variable "gitops_chart_path" {
  description = "Path to the Django Helm chart inside the GitOps repository"
  type        = string
  default     = "charts/django-app"
}

variable "jenkins_namespace" {
  description = "Namespace for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "jenkins_chart_version" {
  description = "Optional Jenkins chart version"
  type        = string
  default     = null
}

variable "jenkins_admin_user" {
  description = "Jenkins admin username"
  type        = string
  default     = "admin"
}

variable "jenkins_admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true
}

variable "jenkins_service_type" {
  description = "Kubernetes service type for Jenkins"
  type        = string
  default     = "LoadBalancer"
}

variable "jenkins_persistence_enabled" {
  description = "Whether Jenkins should use a persistent volume"
  type        = bool
  default     = false
}

variable "argo_cd_namespace" {
  description = "Namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "argo_cd_chart_version" {
  description = "Optional Argo CD chart version"
  type        = string
  default     = null
}

variable "argo_cd_service_type" {
  description = "Kubernetes service type for Argo CD server"
  type        = string
  default     = "LoadBalancer"
}

variable "argo_cd_application_name" {
  description = "Name of the Argo CD Application resource"
  type        = string
  default     = "django-app"
}

variable "argo_cd_destination_namespace" {
  description = "Target namespace where Argo CD deploys the application"
  type        = string
  default     = "default"
}

variable "gitops_repo_is_private" {
  description = "Whether the GitOps repo is private and needs credentials in Argo CD"
  type        = bool
  default     = false
}

variable "gitops_repo_username" {
  description = "Optional Git username for private GitOps repository access"
  type        = string
  default     = null
}

variable "gitops_repo_password" {
  description = "Optional Git password or token for private GitOps repository access"
  type        = string
  default     = null
  sensitive   = true
}
