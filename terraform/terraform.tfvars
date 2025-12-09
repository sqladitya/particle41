# AWS Configuration
aws_region   = "us-east-1"
project_name = "simpletimeservice"

# Network Configuration
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

# Container Configuration
# IMPORTANT: Update this with your actual DockerHub username and image
container_image = "sqladitya/simpletimeservice:latest"

# ECS Configuration
task_cpu      = "256"
task_memory   = "512"
desired_count = 2

# Tags
tags = {
  Project     = "SimpleTimeService"
  Environment = "dev"
  ManagedBy   = "Terraform"
}
