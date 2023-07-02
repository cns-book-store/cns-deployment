#!/bin/sh

echo "✋ Stopping cns services..."

tilt -f ../../applications/development/Tiltfile down

sleep 10

echo "🛑 Destroying Kubernetes cluster..."

minikube stop --profile cns

minikube delete --profile cns

echo "🏴️ Cluster destroyed"
