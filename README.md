# Examen Pratique DevOps - CV One Page

## Table des matières
1. [Introduction](#introduction)
2. [Préparation de l’environnement](#préparation-de-lenvironnement)
3. [Automatisation avec Ansible](#automatisation-avec-ansible)
4. [Pipeline CI/CD avec Jenkins](#pipeline-cicd-avec-jenkins)
5. [Déploiement avec Terraform](#déploiement-avec-terraform)
6. [Orchestration Kubernetes avec K3s et Argo CD](#orchestration-kubernetes-avec-k3s-et-argo-cd)
7. [Supervision et Monitoring avec Grafana Cloud](#supervision-et-monitoring-avec-grafana-cloud)
8. [Conclusion](#conclusion)
9. [Structure du projet](#structure-du-projet)

---

## Introduction
Ce projet met en place une chaîne DevOps complète pour déployer un **CV One Page**.
Outils utilisés : **Ansible, Docker, Terraform, Jenkins, K3s, Argo CD, Grafana Cloud**.
Toutes les configurations et scripts sont centralisés dans ce dépôt GitHub.

---

## Préparation de l’environnement

### 1. Création de la VM
- OS : Ubuntu Server 24.04  
- Nom de la VM : `DEVOPS-LAB`  
- Vérification :
```bash
lsb_release -a
```

### 2. Configuration SSH
- Génération des clés SSH :
```bash
ssh-keygen -t rsa -b 4096 -C "devops@example.com"
```
- Copie de la clé publique vers la VM :
```bash
ssh-copy-id user@DEVOPS-LAB
```

---

## Automatisation avec Ansible

### 1. Mise à jour du système
```bash
ansible-playbook update-upgrade.yml
```

### 2. Installation de Docker
```bash
ansible-playbook install-docker.yml
```

### 3. Installation de Terraform
```bash
ansible-playbook install-terraform.yml
```

### 4. Installation de Jenkins
```bash
ansible-playbook install-jenkins.yml
```

---

## Pipeline CI/CD avec Jenkins

### Jenkinsfile
- Clone le dépôt GitHub `CV One Page`
- Build et push de l’image Docker :
```bash
docker build -t oumaymazekri/cv-onepage:latest .
docker push oumaymazekri/cv-onepage:latest
```
- Notification Slack après exécution.

### Déclenchement
- Poll SCM toutes les 5 minutes.

### Vérification
```bash
docker images
```

---

## Déploiement avec Terraform

### Fichier `main.tf`
```hcl
provider "docker" {}

resource "docker_container" "moncv" {
  name  = "moncv"
  image = "oumaymazekri/cv-onepage:latest"
  ports {
    internal = 80
    external = 8585
  }
}
```

### Commandes Terraform
```bash
terraform init
terraform apply
```

### Test de l’accès
```bash
curl http://DEVOPS-LAB:8585
```

---

## Orchestration Kubernetes avec K3s et Argo CD

### 1. Installation K3s
```bash
curl -sfL https://get.k3s.io | sh -
sudo k3s kubectl get nodes
```

### 2. Déploiement via Argo CD
- Application : `cv-onepage`  
- Deployment : 2 replicas  
- Service : NodePort  

### Manifest Kubernetes (`deployment.yaml`)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cv-onepage
spec:
  replicas: 2
  selector:
    matchLabels:
      app: cv-onepage
  template:
    metadata:
      labels:
        app: cv-onepage
    spec:
      containers:
        - name: cv-onepage
          image: oumaymazekri/cv-onepage:latest
          ports:
            - containerPort: 80
```

### Test de l’accès
```bash
kubectl get svc cv-onepage -o wide
curl http://DEVOPS-LAB:<NodePort>
```

---

## Supervision et Monitoring avec Grafana Cloud

### Configuration minimale du Grafana Agent (`grafana-agent.yaml`)
```yaml
server:
  http_listen_port: 12345

metrics:
  wal_directory: "/tmp/grafana-agent-wal"
  global:
    scrape_interval: 15s
  configs:
    - name: default
      scrape_configs:
        - job_name: "node"
          static_configs:
            - targets: ["localhost:9100"]
```

### Commandes
```bash
sudo systemctl restart grafana-agent
sudo systemctl status grafana-agent
```

### Surveillance
- VM DEVOPS-LAB  
- Docker  
- K3s cluster  

---

## Conclusion
- Pipeline DevOps complet opérationnel : CI/CD, IaC, orchestration et monitoring.  
- CV One Page déployé sur Docker et K3s.  
- Monitoring via Grafana Cloud actif et fonctionnel.

---

## Structure du projet
```
├── ansible/
│   ├── roles/
│   └── playbooks/
├── terraform/
│   └── main.tf
├── jenkins/
│   └── Jenkinsfile
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
├── docker/
│   └── Dockerfile
├── CV-OnePage/
│   └── index.html
└── README.md
```

