#!/bin/bash

echo "--> kubernetes to gergo-cluster on EKS"
aws eks --region eu-central-1 update-kubeconfig --name gergo-cluster

echo "--> wait for k8s api to be available"
until kubectl get nodes &>/dev/null; do
  echo "--> not ready yet"
  sleep 10
done
echo "--> connected to kubernetes api"

echo "--> deploy yaml files"
echo "--> apply mongo..."
kubectl apply -f mongo-deployment.yaml
kubectl wait --for=condition=ready pod --all --timeout=10m

echo "--> apply backend..."
kubectl apply -f backend-deployment.yaml
kubectl wait --for=condition=ready pod --all --timeout=10m

echo "--> apply frontend..."
kubectl apply -f frontend-deployment.yaml
kubectl wait --for=condition=ready pod --all --timeout=10m

echo "--> apply ingress..."
kubectl apply -f ingress.yaml
kubectl wait --for=condition=ready pod --all --timeout=10m

echo "--> verifying deployment"
kubectl get pods -o wide

echo "--> deployment succesful"