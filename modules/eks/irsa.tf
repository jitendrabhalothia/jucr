resource "aws_iam_role" "irsa_autoscaler" {
  name = "eks-irsa-autoscaler"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:cluster-autoscaler"
        }
      }
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  ]
}

resource "aws_iam_role" "irsa_prometheus" {
  name = "eks-irsa-prometheus"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:monitoring:prometheus"
        }
      }
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  ]
}