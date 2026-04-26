output "namespace" {
  description = "Namespace where Jenkins is installed"
  value       = kubernetes_namespace_v1.this.metadata[0].name
}

output "admin_user" {
  description = "Jenkins admin username"
  value       = var.admin_user
}

output "url" {
  description = "Jenkins load balancer URL when assigned"
  value       = try("http://${data.kubernetes_service_v1.this.status[0].load_balancer[0].ingress[0].hostname}:8080", null)
}