# 🌐 Static Website Personalizado

Este proyecto contiene los manifiestos YAML para desplegar el sitio web en un clúster local usando MiniKube, realizada como parte de la práctica de la materia **Computación en la Nube** del ITU - UNCuyo.

## ✨ Pre-requisitos

- Docker Desktop ([Descargar](https://www.docker.com/products/docker-desktop))  
- Kubernetes habilitado en Docker Desktop  
- Minikube instalado ([Instrucciones](https://minikube.sigs.k8s.io/docs/start/))  
- `kubectl` instalado  

## ☸️ Estructura de Directorios

kubernetes-manifests/
├── deployments/: Configuración del Deployment
│   └── web-deployment.yaml
├── services/: Configuración del Service
│   └── web-service.yaml
└── persistent-volumes/: Volúmenes para el contenido web
    ├── persistent-volume.yaml

## 🚀 Despliegue del Entorno  

### **1. Iniciar Minikube**  
```bash
minikube start --driver=docker
```
### **2. Aplicar Manifiestos de Kubernetes**

Aplicar todo el entorno:

```bash
kubectl apply -f persistent-volumes/
kubectl apply -f deployments/
kubectl apply -f services/
```
### ** 3.Verificar Estado**

```bash
kubectl get pods,svc,pv,pvc
```

### ** 4.Acceder al sitio Web**

```bash
# Método 1: Port-forward
kubectl port-forward svc/web-service 8080:80

# Método 2: Minikube service
minikube service web-service --url
```
Luego, abre tu navegador en:
👉 http://localhost:8080

## 🚨 Solución de Problemas

### Error 403 Forbidden

# Verificar contenido del pod
kubectl exec $POD_NAME -- ls -la /usr/share/nginx/html

# Verificar logs de Nginx
kubectl logs $POD_NAME
