resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "this" {
  name             = "jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  namespace        = kubernetes_namespace_v1.this.metadata[0].name
  create_namespace = false
  version          = var.chart_version
  timeout          = 900

  values = [templatefile("${path.module}/values.yaml", {
    admin_user          = var.admin_user
    admin_password      = var.admin_password
    service_type        = var.service_type
    persistence_enabled = var.persistence_enabled
    app_repo_url        = var.app_repo_url
    gitops_repo_url     = var.gitops_repo_url
    gitops_repo_branch  = var.gitops_repo_branch
  })]
}

data "kubernetes_service_v1" "this" {
  depends_on = [helm_release.this]

  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
}