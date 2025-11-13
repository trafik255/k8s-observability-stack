#############################################
# VPC
#############################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]

  public_subnets  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  private_subnets = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]

  enable_nat_gateway = true
}

#############################################
# EKS Cluster
#############################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      max_size       = 4
      min_size       = 1
      instance_types = ["t3.large"]
    }
  }
}

#############################################
# Namespaces for Observability Stack
#############################################
resource "kubernetes_namespace" "observability" {
  metadata {
    name = "observability"
  }
}

#############################################
# Helm: Prometheus
#############################################
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "56.6.2"

  namespace = kubernetes_namespace.observability.metadata[0].name

  values = [
    file("${path.module}/../manifests/values-prometheus.yaml")
  ]
}

#############################################
# Helm: Loki
#############################################
resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "6.6.3"

  namespace = kubernetes_namespace.observability.metadata[0].name
}

#############################################
# Helm: Grafana
#############################################
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "7.3.9"

  namespace = kubernetes_namespace.observability.metadata[0].name

  values = [
    file("${path.module}/../manifests/values-grafana.yaml")
  ]
}
