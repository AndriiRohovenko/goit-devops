output "namespace" {
  description = "Namespace where monitoring is installed"
  value       = kubernetes_namespace_v1.this.metadata[0].name
}

output "prometheus_service_name" {
  description = "Prometheus service name"
  value       = data.kubernetes_service_v1.prometheus.metadata[0].name
}

output "grafana_service_name" {
  description = "Grafana service name"
  value       = data.kubernetes_service_v1.grafana.metadata[0].name
}

output "grafana_admin_user" {
  description = "Grafana admin user"
  value       = var.grafana_admin_user
}

output "grafana_admin_password" {
  description = "Grafana admin password"
  value       = var.grafana_admin_password
  sensitive   = true
}