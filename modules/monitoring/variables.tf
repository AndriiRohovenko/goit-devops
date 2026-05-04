variable "namespace" {
  description = "Namespace where monitoring components are installed"
  type        = string
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
  sensitive   = true
}