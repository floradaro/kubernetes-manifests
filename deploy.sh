#!/bin/bash

# Variables
PROFILE="minikube"
NAMESPACE="default"
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CONTENT_DIR="$SCRIPT_DIR/../static-website"
MANIFESTS_DIR="$SCRIPT_DIR"

echo ">>> Iniciando Minikube..."
minikube -p $PROFILE status || minikube start -p $PROFILE --driver=docker --addons=metrics-server,dashboard,ingress

echo ">>> Creando Namespace (si no existe)..."
kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE

echo ">>> Copiando contenido web a Minikube..."
cd "$CONTENT_DIR"
tar czf contenido.tar.gz ./*
minikube -p $PROFILE cp contenido.tar.gz /tmp/contenido.tar.gz
minikube -p $PROFILE ssh "sudo mkdir -p /data/contenido-web && sudo tar xzf /tmp/contenido.tar.gz -C /data/contenido-web --strip-components=1 && sudo chmod -R 755 /data/contenido-web && sudo rm /tmp/contenido.tar.gz"
rm contenido.tar.gz

echo ">>> Aplicando manifiestos (en orden)..."
# Aplicar PersistentVolume primero
kubectl apply -f "$MANIFESTS_DIR/persistent-volume/persistent-volume.yaml" -n $NAMESPACE
# Deployment
kubectl apply -f "$MANIFESTS_DIR/deployment/deployment.yaml" -n $NAMESPACE
# Service
kubectl apply -f "$MANIFESTS_DIR/service/service.yaml" -n $NAMESPACE

echo ">>> Esperando a que el pod esté listo..."
kubectl wait --for=condition=Ready pod -l app=web-app -n $NAMESPACE --timeout=120s

echo ">>> Listando recursos desplegados..."
kubectl get all,pv,pvc -n $NAMESPACE

echo ">>> URL del servicio:"
minikube -p $PROFILE service web-service --url -n $NAMESPACE

echo ">>> Fin del despliegue automático."
