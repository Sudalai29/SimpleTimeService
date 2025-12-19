# Terraform EKS Infrastructure

Infrastructure as Code (IaC) for deploying a production-ready Amazon EKS cluster with VPC, networking, IAM roles, and all required components using Terraform.

## Overview

This Terraform project automates the provisioning of a complete EKS infrastructure including:
- **VPC & Networking**: Custom VPC with public/private subnets, NAT gateways, route tables
- **EKS Cluster**: Managed Kubernetes cluster with auto-scaling capabilities
- **IAM Roles**: Proper IAM roles and policies for EKS cluster and node groups
- **Node Groups**: Worker nodes for running containerized applications
- **Remote State Management**: S3 backend with DynamoDB locking for team collaboration

## Features

- Modular Terraform structure for reusability and maintainability
- Multi-environment support (dev and prod)
- Remote state management with S3 and DynamoDB
- VPC with 2 public and 2 private subnets across different availability zones
- Internet Gateway (IGW) for public subnet internet access
- NAT Gateways with Elastic IPs for private subnet outbound connectivity
- EKS cluster with managed node groups
- Proper IAM policies and roles
- Auto-scaling capabilities for worker nodes
- State file locking to prevent concurrent modifications
- High availability across multiple AZs

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- AWS account with necessary permissions (EKS, VPC, IAM, S3, DynamoDB)
- kubectl installed for cluster management
- aws-iam-authenticator for authentication

## Project Structure

```
terraform/
├── backend/                    # S3 & DynamoDB remote state configuration
├── modules/
│   ├── eks/                   # EKS cluster module
│   ├── iam/                   # IAM roles and policies module
│   └── vpc/                   # VPC and networking module
├── outputs.tf                 # Output values
├── providers.tf               # Terraform providers and version
├── variables.tf               # Variable definitions
├── terraform.dev.tfvars       # Development environment variables
├── terraform.prod.tfvars      # Production environment variables
└── main.tf                    # Main configuration file
```

## Setup & Initialization

### 1. Initialize Remote State (One-time setup)

Set up S3 bucket and DynamoDB table for remote state:

```bash
cd backend
terraform init
terraform plan
terraform apply
```

### 2. Configure Terraform Backend

Update the backend configuration in `providers.tf` with the S3 bucket and DynamoDB table names created above:

```bash
terraform init
```

When prompted, confirm to migrate local state to remote (if applicable).

### 3. Initialize Terraform

```bash
terraform init
```

This downloads necessary providers and initializes the working directory.

## Deployment

### Development Environment

Plan and apply for development:

```bash
terraform plan -var-file=terraform.dev.tfvars
terraform apply -var-file=terraform.dev.tfvars
```

### Production Environment

Plan and apply for production:

```bash
terraform plan -var-file=terraform.prod.tfvars
terraform apply -var-file=terraform.prod.tfvars
```

## Validation & Testing

Validate Terraform configuration:

```bash
terraform validate
```

Format Terraform files:

```bash
terraform fmt -recursive
```

## AWS Resources Created

### VPC Module

The VPC module creates a highly available network infrastructure:

- **VPC**: Configurable CIDR block with DNS support
- **Public Subnets**: 2 public subnets across different availability zones (AZ1 & AZ2) for NAT gateways, load balancers, and bastion hosts
- **Private Subnets**: 2 private subnets across different availability zones (AZ1 & AZ2) for EKS worker nodes and application pods
- **Internet Gateway (IGW)**: Provides internet access to public subnets
- **NAT Gateways**: 2 NAT gateways (one per AZ) for private subnet outbound connectivity
- **Elastic IPs (EIPs)**: 2 Elastic IPs (one per NAT gateway) for consistent outbound IP addresses
- **Route Tables**: Separate route tables for public and private subnets with appropriate routes
- **Subnet Associations**: Proper association of subnets with route tables
- **Security**: Network ACLs and security groups for layer security

### EKS Module

- Managed EKS cluster
- Auto Scaling Group for worker nodes
- Security groups for cluster and nodes
- Worker node IAM instance profiles
- Cluster logging and monitoring

### IAM Module

- EKS cluster service role
- EKS node group role
- VPC CNI plugin role
- Necessary policies and trust relationships

## Useful Commands

### State Management

```bash
# View remote state
terraform state list
terraform state show <resource>

# Lock state file (DynamoDB automatically manages this)
terraform refresh

# Pull remote state locally (for inspection)
terraform state pull > state.json

# Push local state to remote
terraform state push state.json
```

### Infrastructure Management

```bash
# Plan changes
terraform plan -var-file=terraform.dev.tfvars -out=tfplan

# Apply changes
terraform apply tfplan

# Destroy infrastructure (use with caution)
terraform destroy -var-file=terraform.dev.tfvars

# Target specific resource
terraform apply -target=module.eks.aws_eks_cluster.main -var-file=terraform.dev.tfvars

# Refresh state
terraform refresh -var-file=terraform.dev.tfvars
```

### Workspace Management (Optional)

```bash
# List workspaces
terraform workspace list

# Create new workspace
terraform workspace new <workspace-name>

# Switch workspace
terraform workspace select <workspace-name>
```

## Retrieve Cluster Information

### Update kubeconfig

```bash
aws eks update-kubeconfig --region <region> --name <cluster-name>
```

### Verify Cluster Access

```bash
kubectl get nodes
kubectl get pods --all-namespaces
```

## Troubleshooting

### State Lock Issues

```bash
# View DynamoDB locks
aws dynamodb scan --table-name <lock-table-name> --region <region>

# Force unlock (use only if lock is stuck)
terraform force-unlock <LOCK_ID>
```

### Provider Authentication

```bash
# Verify AWS credentials
aws sts get-caller-identity

# Configure AWS credentials
aws configure
```

### EKS Cluster Issues

```bash
# Check cluster status
aws eks describe-cluster --name <cluster-name> --region <region>

# View cluster logs
aws eks describe-cluster --name <cluster-name> --query 'cluster.logging.clusterLogging' --region <region>
```

### Terraform Debug

```bash
# Enable debug logging
export TF_LOG=DEBUG
terraform apply -var-file=terraform.dev.tfvars

# Disable debug
unset TF_LOG
```

## Module Inputs & Outputs

Review available inputs and outputs for each module:

```bash
# Show all outputs
terraform output

# Show specific output
terraform output <output-name>

# Show all variables
terraform console  # then type var.<variable_name>
```

## Best Practices

- Always run `terraform plan` before `terraform apply`
- Use separate `.tfvars` files for different environments
- Enable state file locking with DynamoDB
- Store sensitive data in AWS Secrets Manager or Parameter Store
- Use remote state for team collaboration
- Keep Terraform code in version control (exclude `.tfstate` files)
- Tag all resources for cost tracking and organization
- Use modules for reusable infrastructure components

## Environment Variables

```bash
# Development environment
terraform plan -var-file=terraform.dev.tfvars

# Production environment
terraform plan -var-file=terraform.prod.tfvars
```

## Destroy Infrastructure

```bash
# Development
terraform destroy -var-file=terraform.dev.tfvars

# Production (with confirmation)
terraform destroy -var-file=terraform.prod.tfvars -auto-approve
```

## Remote State Cleanup

```bash
# Remove local state files
rm -rf .terraform.tfstate*

# State is managed by S3 and DynamoDB backend
```

## Tech Stack

- **IaC Tool**: Terraform
- **Cloud Provider**: Amazon Web Services (AWS)
- **Container Orchestration**: Kubernetes (EKS)
- **State Management**: S3 + DynamoDB
- **Networking**: VPC, Subnets, NAT Gateway
- **Compute**: EC2 Auto Scaling Groups
- **Identity & Access**: IAM
