#!/bin/bash
set -e

echo "Deploying Observability Stack..."

helm upgrade --install prometheus charts/prometheus -n observability
helm upgrade --install grafana charts/grafana -n observability
helm upgrade --install kube-state-metrics charts/kube-state-metrics -n observability
helm upgrade --install loki charts/loki -n logging

echo "Done."

# make executable
# chmod +x scripts/deploy.sh