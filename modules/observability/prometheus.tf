resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  chart      = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "serviceAccounts.server.annotations.eks\.amazonaws\.com/role-arn"
    value = aws_iam_role.irsa_prometheus.arn
  }
}