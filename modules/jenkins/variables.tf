variable "namespace" {
  description = "Namespace for Jenkins"
  type        = string
}

variable "chart_version" {
  description = "Optional Jenkins chart version"
  type        = string
  default     = null
}

variable "admin_user" {
  description = "Jenkins admin username"
  type        = string
}

variable "admin_password" {
  description = "Jenkins admin password"
  type        = string
  sensitive   = true
}

variable "service_type" {
  description = "Jenkins service type"
  type        = string
}

variable "persistence_enabled" {
  description = "Whether Jenkins persistence is enabled"
  type        = bool
}

variable "app_repo_url" {
  description = "App repository URL shown in Jenkins config guidance"
  type        = string
}

variable "gitops_repo_url" {
  description = "GitOps repository URL shown in Jenkins config guidance"
  type        = string
}

variable "gitops_repo_branch" {
  description = "GitOps branch updated by Jenkins"
  type        = string
}