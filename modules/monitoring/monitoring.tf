resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  namespace        = kubernetes_namespace_v1.this.metadata[0].name
  create_namespace = false
  version          = var.prometheus_chart_version
  timeout          = 900

  values = [templatefile("${path.module}/values-prometheus.yaml", {})]
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = kubernetes_namespace_v1.this.metadata[0].name
  create_namespace = false
  version          = var.grafana_chart_version
  timeout          = 900

  values = [templatefile("${path.module}/values-grafana.yaml", {
    admin_user          = var.grafana_admin_user
    admin_password      = var.grafana_admin_password
    prometheus_endpoint = "http://prometheus-server.${var.namespace}.svc.cluster.local"
  })]

  depends_on = [helm_release.prometheus]
}

data "kubernetes_service_v1" "prometheus" {
  depends_on = [helm_release.prometheus]

  metadata {
    name      = "prometheus-server"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
}

data "kubernetes_service_v1" "grafana" {
  depends_on = [helm_release.grafana]

  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }
}