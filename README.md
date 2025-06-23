EKS Terraform Solution

## ✅ Overview

This repository provisions a fully automated Amazon EKS environment using only raw Terraform resources (no community modules). It supports local testing on Minikube with a parallel observability stack.:

- VPC with 3 AZs, public and private subnets
- EKS Cluster and Node Groups
- IAM roles, OIDC, and IRSA
- Observability Stack: Prometheus, Grafana, Loki, Promtail, Cluster Autoscaler
- Separate testing module for Minikube observability stack

### Terraform EKS Architecture

![EKS Diagram](https://jitendrabhalothia.github.io/eks-diagram/eks-f1.drawio.svg)

👉 [View Fullscreen](https://jitendrabhalothia.github.io/eks-diagram/eks-f1.drawio.svg)

## ⚙️ Usage

### Initialize
```bash
terraform init
```

### Plan
```bash
terraform plan -var-file="eks.tfvars"
```

### Apply (EKS)
```bash
terraform apply -var-file="eks.tfvars"
```

### Apply (Minikube)
```bash
cd observability-local-stack
export KUBECONFIG=~/.kube/config
terraform init
terraform plan -var-file="minikube.tfvars
terraform apply -var-file="minikube.tfvars"
```

## 🔄 Upgrades

### EKS Version
Change in `eks.tfvars`:
```hcl
eks_version = "1.30"
```

### Helm Charts
Update `version` field in `helm_release` blocks:
- Loki: `2.11.0`
- Prometheus: `57.0.0`

Apply:
```bash
terraform apply -target=helm_release.loki_stack
terraform apply -target=helm_release.prometheus
```

PromQL support is updated via Prometheus/Grafana upgrades.

## 📘 Notes

- Prometheus & Autoscaler use IRSA roles in EKS.
- Minikube stack uses local Helm charts without AWS dependencies.
- Everything is deployable via Terraform without wrappers.
