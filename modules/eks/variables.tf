variable "eks_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.29"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = "jucr-cluster"
}