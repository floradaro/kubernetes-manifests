# 🌐 Manifiestos YAML Personalizado

Este proyecto contiene los manifiestos YAML y el proceso completo para desplegar el sitio web en un clúster local usando MiniKube, realizada como parte de la práctica de la materia **Computación en la Nube** del ITU - UNCuyo.

## ✨ Pre-requisitos

- Docker Desktop ([Descargar](https://www.docker.com/products/docker-desktop))  
- Kubernetes habilitado en Docker Desktop  
- Minikube instalado ([Instrucciones](https://minikube.sigs.k8s.io/docs/start/))  
- Git y GitHub
- `kubectl` instalado  
- WSL
- Terminal PowerShell o Git Bash

## 🚀 Despliegue del Entorno  

### **1. Iniciar Minikube**  
```bash
minikube start --driver=docker
```
- Verificar estado
```bash
minikube status
kubectl get nodes
```

### **2. Crear Directorios y Repositorios** 

- Creación de directorios locales
```bash
mkdir -p web-content manifiestos
```

- Iniciar repositorios Git
```bash
cd web-content
git init
cd ../manifiestos
git init
```
### **3. Configurar el Contenido Web**

- Ve a https://github.com/ewojjowe/static-website
- Fork del repositorio base
```bash
cd web-content
git clone https://github.com/tu-usuario/static-website .
```
- Personaliza el contenido según necesites y luego:
```bash
git add .
git commit -m "Personalización inicial del contenido web"
git push origin main
```

### **4. Clonar repositorios Kubernetes**
```bash
cd ../kubernetes-manufests
git clone https://github.com/tu-usuario/manifiestos.git
```
### **5. Configurar Manifiestos de Kubernetes**

- Estructura de Directorios

/cloud-project
│
├── /web-content        # Contenido estático del sitio
│   ├── index.html
│   ├── styles.css
│   └── assets/
│
└── /manifiestos  # Configuraciones Kubernetes
    ├── /deployments
    ├── /services
    └── /persistent-volumes

```bash
cd ../manifiestos
mkdir -p deployments services persistent-volumes
```

### **6. Configuración de Volumenes de Persistentes**

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: web-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/data/contenido-web" #Importante. Ruta que lleva a index.html
    type: Directory
```

### **7. Aplicar Manifiestos de Kubernetes**

Aplicar los manifiestos en todo el entorno:

```bash

kubectl apply -f persistent-volumes/
kubectl apply -f deployments/
kubectl apply -f services/
```
### **8. Verificar Estado**

```bash
kubectl get pods,svc,pv,pvc
```

### **9. Acceder al sitio Web**

```bash
minikube service web-service --url
```
Luego, abre tu navegador en:
👉 http://ruta_proporcionada_por_minikube

Ejemplo: http://127.0.0.1:57103/

### **10. Flujo de Trabajo Diario**

- Modificar archivos en web-content
- Sincronizar los cambios
```bash
kubectl cp C:\cloud-project\web-content\ $(kubectl get pod -l app=web -o jsonpath='{.items[0].metadata.name}'):/usr/share/nginx/html
```

- Reiniciar despliegue
```bash
kubectl rollout restart deployment/web-deployment
```

Si usas hostPath, montar la carpeta correcta

- En otra terminal (y no la cierres!):
```bash
minikube mount "c/cloud-project/web-content"
```
Guardar y recargar página servida por Minikube

##  🚀 Despliegue Automático

- 1. Incorporar archivo deploy.sh en la raíz de la carpeta del proyecto

- 2  Colocar ruta de los archivos  en el script

- 3. Dar permisos de ejecución

```bash
cd kubernetes-manifests
chmod +x deploy.sh
```
- 3. Ejecutar despliegue

```bash
./deploy.sh
```
- 4. Copiar URL proporcionada y acceder a la pagina. LISTO! Ya puedes visuar el contenido 

## 📚 Recursos Adicionales

([Documentación oficial de Minikube](https://minikube.sigs.k8s.io/docs/)) 

([Kubernetes para principiantes](https://kubernetes.io/docs/tutorials/kubernetes-basics/)) 

