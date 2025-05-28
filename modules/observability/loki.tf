resource "helm_release" "loki_stack" {
  name       = "loki-stack"
  chart      = "loki-stack"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "grafana.enabled"
    value = true
  }
  set {
    name  = "promtail.enabled"
    value = true
  }
  set {
    name  = "loki.persistence.enabled"
    value = true
  }
  set {
    name  = "loki.persistence.size"
    value = "10Gi"
  }
  set {
    name  = "loki.persistence.storageClassName"
    value = "gp2"
  }
}