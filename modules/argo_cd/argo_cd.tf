resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "this" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = kubernetes_namespace_v1.this.metadata[0].name
  create_namespace = false
  version          = var.chart_version

  values = [templatefile("${path.module}/values.yaml", {
    service_type = var.service_type
  })]
}

resource "helm_release" "apps" {
  name             = "argocd-apps"
  chart            = "${path.module}/charts"
  namespace        = kubernetes_namespace_v1.this.metadata[0].name
  create_namespace = false

  values = [templatefile("${path.module}/charts/values.yaml", {
    application_name      = var.application_name
    gitops_repo_url       = var.gitops_repo_url
    gitops_repo_branch    = var.gitops_repo_branch
    gitops_chart_path     = var.gitops_chart_path
    destination_namespace = var.destination_namespace
    repo_enabled          = var.repo_is_private
    repo_username         = var.repo_username != null ? var.repo_username : ""
    repo_password         = var.repo_password != null ? var.repo_password : ""
  })]

  depends_on = [helm_release.this]
}

data "kubernetes_service_v1" "server" {
  depends_on = [helm_release.this]

  metadata {
    name      = "argocd-server"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
}

data "kubernetes_secret_v1" "admin" {
  depends_on = [helm_release.this]

  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
}