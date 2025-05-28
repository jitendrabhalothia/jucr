resource "kubernetes_service_account" "autoscaler" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.irsa_autoscaler.arn
    }
  }
}

resource "helm_release" "autoscaler" {
  name       = "cluster-autoscaler"
  chart      = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  namespace  = "kube-system"

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = kubernetes_service_account.autoscaler.metadata[0].name
  }
}