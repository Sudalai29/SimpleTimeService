variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "cluster_role_arn" {
  description = "EKS cluster IAM role ARN"
  type        = string
}

variable "nodes_role_arn" {
  description = "EKS nodes IAM role ARN"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "cluster_sg_id" {
  description = "Cluster security group ID"
  type        = string
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

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
