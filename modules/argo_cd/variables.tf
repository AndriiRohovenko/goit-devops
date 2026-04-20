variable "namespace" {
  description = "Namespace for Argo CD"
  type        = string
}

variable "chart_version" {
  description = "Optional Argo CD chart version"
  type        = string
  default     = null
}

variable "service_type" {
  description = "Argo CD server service type"
  type        = string
}

variable "gitops_repo_url" {
  description = "GitOps repository URL watched by Argo CD"
  type        = string
}

variable "gitops_repo_branch" {
  description = "Git branch watched by Argo CD"
  type        = string
}

variable "gitops_chart_path" {
  description = "Path to the chart inside the GitOps repository"
  type        = string
}

variable "application_name" {
  description = "Argo CD Application name"
  type        = string
}

variable "destination_namespace" {
  description = "Destination namespace for the Argo CD Application"
  type        = string
}

variable "repo_is_private" {
  description = "Whether the GitOps repository is private"
  type        = bool
  default     = false
}

variable "repo_username" {
  description = "Optional username for GitOps repository auth"
  type        = string
  default     = null
}

variable "repo_password" {
  description = "Optional token or password for GitOps repository auth"
  type        = string
  default     = null
  sensitive   = true
}