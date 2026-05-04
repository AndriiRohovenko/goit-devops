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

variable "enable_monitoring" {
  description = "If true, install Prometheus and Grafana after the EKS cluster exists"
  type        = bool
  default     = true
}

variable "monitoring_namespace" {
  description = "Namespace for Prometheus and Grafana"
  type        = string
  default     = "monitoring"
}

variable "prometheus_chart_version" {
  description = "Optional Prometheus chart version"
  type        = string
  default     = null
}

variable "grafana_chart_version" {
  description = "Optional Grafana chart version"
  type        = string
  default     = null
}

variable "grafana_admin_user" {
  description = "Grafana admin username"
  type        = string
  default     = "admin"
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  default     = "admin123"
  sensitive   = true
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

variable "enable_k8s_addons" {
  description = "If true, install Jenkins and Argo CD into the EKS cluster after the cluster already exists"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment tag applied to shared resources"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project tag applied to shared resources"
  type        = string
  default     = "django-app"
}

variable "db_name_prefix" {
  description = "Identifier prefix for the RDS instance or Aurora cluster"
  type        = string
  default     = "django-db"
}

variable "db_use_aurora" {
  description = "If true, create an Aurora cluster instead of a standard RDS instance"
  type        = bool
  default     = false
}

variable "db_engine" {
  description = "Engine for a standard RDS instance"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Engine version for a standard RDS instance"
  type        = string
  default     = "17.2"
}

variable "db_parameter_group_family_rds" {
  description = "Parameter group family for a standard RDS instance"
  type        = string
  default     = "postgres17"
}

variable "db_engine_cluster" {
  description = "Engine for Aurora clusters"
  type        = string
  default     = "aurora-postgresql"
}

variable "db_engine_version_cluster" {
  description = "Engine version for Aurora clusters"
  type        = string
  default     = "15.3"
}

variable "db_parameter_group_family_aurora" {
  description = "Parameter group family for Aurora clusters"
  type        = string
  default     = "aurora-postgresql15"
}

variable "db_aurora_instance_count" {
  description = "Total number of Aurora instances including the writer"
  type        = number
  default     = 2
}

variable "db_instance_class" {
  description = "Instance class for RDS or Aurora instances"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB for a standard RDS instance"
  type        = number
  default     = 20
}

variable "db_database_name" {
  description = "Initial database name"
  type        = string
  default     = "app"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "db_publicly_accessible" {
  description = "Whether the database should be placed in public subnets and exposed publicly"
  type        = bool
  default     = false
}

variable "db_multi_az" {
  description = "Whether to enable Multi-AZ for a standard RDS instance"
  type        = bool
  default     = false
}

variable "db_backup_retention_period" {
  description = "Number of days to keep automated backups"
  type        = number
  default     = 0
}

variable "db_skip_final_snapshot" {
  description = "Whether Terraform should skip a final snapshot during destroy"
  type        = bool
  default     = true
}

variable "db_allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to the database port"
  type        = list(string)
  default     = []
}

variable "db_parameters" {
  description = "Database parameters applied to the RDS or Aurora parameter group"
  type        = map(string)
  default = {
    max_connections = "200"
    log_statement   = "ddl"
    work_mem        = "4096"
  }
}
