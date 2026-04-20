output "namespace" {
  description = "Namespace where Argo CD is installed"
  value       = kubernetes_namespace_v1.this.metadata[0].name
}

output "server_url" {
  description = "Argo CD server load balancer URL when assigned"
  value       = try("http://${data.kubernetes_service_v1.server.status[0].load_balancer[0].ingress[0].hostname}", null)
}

output "admin_password" {
  description = "Initial Argo CD admin password"
  value       = data.kubernetes_secret_v1.admin.data.password
  sensitive   = true
}