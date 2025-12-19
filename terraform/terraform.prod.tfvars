aws_region   = "ap-south-1"
project_name = "myapp"
environment  = "prod"

vpc_cidr             = "10.1.0.0/16"
availability_zones   = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
private_subnet_cidrs = ["10.1.10.0/24", "10.1.11.0/24", "10.1.12.0/24"]

kubernetes_version = "1.29"
instance_type      = "m6a.large"
desired_capacity   = 3
min_capacity       = 3
max_capacity       = 10

vpc_cni_version    = "v1.15.4-eksbuild.1"
kube_proxy_version = "v1.28.2-eksbuild.2"
coredns_version    = "v1.10.1-eksbuild.6"