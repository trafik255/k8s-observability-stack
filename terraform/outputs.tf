output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "grafana_url" {
  value = "http://grafana.observability.svc.cluster.local"
}
