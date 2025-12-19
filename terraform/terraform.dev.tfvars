aws_region   = "ap-south-1"
project_name = "myapp"
environment  = "dev"

vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["ap-south-1a", "ap-south-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

kubernetes_version = "1.29"
instance_type      = "m6a.large"
desired_capacity   = 2
min_capacity       = 1
max_capacity       = 4

vpc_cni_version    = "v1.15.4-eksbuild.1"
kube_proxy_version = "v1.28.2-eksbuild.2"
coredns_version    = "v1.10.1-eksbuild.6"