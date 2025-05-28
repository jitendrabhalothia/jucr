variable "region" {
  description = "AWS region for autoscaler Helm chart"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
}