#!/bin/bash
set -e

kubectl delete namespace observability --ignore-not-found
kubectl delete namespace logging --ignore-not-found

echo "Observability stack removed."


#make executable
#chmod +x scripts/cleanup.sh