# Flask Time & IP Server with Docker & Kubernetes

A lightweight Flask-based web server that returns the current timestamp and visitor's IP address in JSON format. This application is containerized using Docker with multi-stage builds and orchestrated on a local Kubernetes cluster.

## Overview

This project demonstrates a complete DevOps workflow:
- **Flask Web Server**: A simple HTTP service that provides visitor information
- **Docker**: Multi-stage containerization for optimized image size
- **Docker Hub**: Image repository for container distribution
- **Kubernetes**: Local cluster deployment with scaling and load balancing
- **Terraform**: Infrastructure as Code for provisioning AWS EKS cluster and networking components

## Features

- Returns visitor's IP address (with proxy/load balancer support)
- Provides current timestamp in ISO format
- JSON-formatted responses
- Lightweight Alpine-based Docker images
- Non-root user execution for security
- Multi-stage Docker build for reduced image size
- Kubernetes deployment with scaling and load balancing

## Project Structure

```
project/
├── app.py                      # Flask application
├── requirements.txt            # Python dependencies
├── Dockerfile                  # Multi-stage Docker configuration
├── k8s/
│   ├── deployment.yaml         # Kubernetes deployment manifest
│   └── service.yaml            # Kubernetes NodePort service manifest
└── terraform/
    ├── backend/                # S3 & DynamoDB remote state configuration
    ├── modules/
    │   ├── eks/                # EKS cluster module
    │   ├── iam/                # IAM roles and policies module
    │   └── vpc/                # VPC and networking module
    ├── main.tf                 # Main Terraform configuration
    ├── outputs.tf              # Output values
    ├── providers.tf            # Terraform providers and version
    ├── variables.tf            # Variable definitions
    ├── terraform.dev.tfvars    # Development environment variables
    └── terraform.prod.tfvars   # Production environment variables
```

## Prerequisites

- Python 3.12+
- Docker
- Kubernetes (minikube, Docker Desktop, or local cluster)
- kubectl command-line tool
- Docker Hub account

## Setup & Installation

### 1. Local Development

```bash
mkdir flask-k8s-server && cd flask-k8s-server
```

### 2. Build & Push Docker Image

Build the Docker image:

```bash
docker build -t <your-dockerhub-username>/flask-server:latest .
```

Push to Docker Hub:

```bash
docker login
docker push <your-dockerhub-username>/flask-server:latest
```

**Note**: The image is publicly available on Docker Hub

### 3. Kubernetes Deployment

Deploy to Kubernetes:

```bash
# Create namespace (optional)
kubectl create namespace flask-app

# Apply manifests
kubectl apply -f k8s/deployment.yaml -n flask-app
kubectl apply -f k8s/service.yaml -n flask-app

# Verify deployment
kubectl get deployments -n flask-app
kubectl get pods -n flask-app
kubectl get services -n flask-app
```

## Usage

Once deployed, access the service:

```bash
# For Minikube - automatically open service in browser
minikube service flask-server-service -n flask-app

# Or get Minikube IP manually
minikube ip

# For Docker Desktop - use localhost
curl http://localhost:30000/
```

Expected response:

```json
{
  "timestamp": "2025-12-19T14:30:45.123456",
  "ip": "your ip is 192.168.1.100"
}
```

## Docker Image Details

### Multi-Stage Build Benefits

- Build stage installs Python packages in `/install` directory
- Runtime stage copies only necessary files, resulting in a smaller final image
- Final image size: ~150MB (vs ~400MB with single-stage build)

### Security Features

- Non-root user execution for container safety
- Alpine Linux for minimal attack surface
- Gunicorn production WSGI server instead of Flask development server

## Kubernetes Configuration

### Deployment

- **Replicas**: 3 pod instances for high availability
- **Image Pull Policy**: Always pulls latest image from Docker Hub
- **Resource Limits**: Memory and CPU constraints for cluster efficiency

### Service

- **Type**: NodePort for external access on port 30000
- **Selector**: Routes traffic to pods with label `app: flask-server`
- **Target Port**: 5000 (container port)

## Useful Commands

```bash
# View deployment logs
kubectl logs -f deployment/flask-server-deployment -n flask-app

# Scale replicas
kubectl scale deployment flask-server-deployment --replicas=5 -n flask-app

# Update image
kubectl set image deployment/flask-server-deployment \
  flask-app=<your-dockerhub-username>/flask-server:v2 -n flask-app

# Delete deployment
kubectl delete deployment flask-server-deployment -n flask-app
kubectl delete service flask-server-service -n flask-app

# Port forwarding (alternative to NodePort)
kubectl port-forward service/flask-server-service 5000:5000 -n flask-app
```

## Troubleshooting

Image pull errors: Create Docker registry secret

```bash
kubectl create secret docker-registry regcred \
  --docker-server=docker.io \
  --docker-username=<username> \
  --docker-password=<password> \
  --docker-email=<email>
```

Check pod logs for crashes:

```bash
kubectl describe pod <pod-name> -n flask-app
kubectl logs <pod-name> -n flask-app
```

Verify NodePort service:

```bash
kubectl get svc flask-server-service -n flask-app
```

## Infrastructure with Terraform

The `terraform/` directory contains Infrastructure as Code for provisioning the AWS EKS cluster and networking. Refer to the [Terraform EKS Infrastructure README](terraform/README.md) for detailed instructions on:

- Setting up VPC with 2 public and 2 private subnets across different availability zones
- Deploying Internet Gateway (IGW) and NAT Gateways with Elastic IPs
- Provisioning the EKS cluster with managed node groups
- Configuring IAM roles and policies
- Setting up remote state management with S3 and DynamoDB

### Quick Terraform Commands

```bash
cd terraform

# Initialize and deploy development environment
terraform init
terraform plan -var-file=terraform.dev.tfvars
terraform apply -var-file=terraform.dev.tfvars

# Retrieve cluster information
aws eks update-kubeconfig --region <region> --name <cluster-name>
kubectl get nodes
```

For comprehensive Terraform documentation, see the terraform directory README.

## Tech Stack

- **Language**: Python 3.12
- **Framework**: Flask
- **WSGI Server**: Gunicorn
- **Container**: Docker with Alpine Linux
- **Orchestration**: Kubernetes / Amazon EKS
- **Registry**: Docker Hub
- **Infrastructure as Code**: Terraform
- **Cloud Provider**: Amazon Web Services (AWS)
- **State Management**: S3 + DynamoDB
