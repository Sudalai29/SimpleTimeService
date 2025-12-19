variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod, staging)"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "instance_type" {
  description = "Instance type for worker nodes"
  type        = string
  default     = "m6a.large"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "max_capacity" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "vpc_cni_version" {
  description = "VPC CNI addon version"
  type        = string
  default     = "v1.15.4-eksbuild.1"
}

variable "kube_proxy_version" {
  description = "Kube-proxy addon version"
  type        = string
  default     = "v1.28.2-eksbuild.2"
}

variable "coredns_version" {
  description = "CoreDNS addon version"
  type        = string
  default     = "v1.10.1-eksbuild.6"
}
