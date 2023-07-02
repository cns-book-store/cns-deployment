#!/bin/sh

echo "📦 Initializing Kubernetes cluster..."

minikube start --cpus 2 --memory 4g --driver docker --profile cns

echo "🔌 Enabling NGINX Ingress Controller..."

minikube addons enable ingress --profile cns

sleep 15

echo "📦 Deploying platform services..."

kubectl apply -f services

sleep 5

echo "⌛ Waiting for PostgreSQL to be deployed..."

while [ $(kubectl get pod -l db=cns-postgres | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "⌛ Waiting for PostgreSQL to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=cns-postgres \
  --timeout=180s

echo "⌛ Waiting for Redis to be deployed..."

while [ $(kubectl get pod -l db=cns-redis | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "⌛ Waiting for Redis to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=cns-redis \
  --timeout=180s

echo "⛵ Happy Sailing!"

echo "🚜 Starting cns services..."

tilt -f ../../applications/development/Tiltfile up

sleep 10
