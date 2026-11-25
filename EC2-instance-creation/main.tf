
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.2.0"
}

# AWS Provider Configuration
provider "aws" {
  region = "ap-south-1"
}

# Fetch latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create EC2 Instance
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name        = "Terraform_Demo"
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}

# Display EC2 Public IP
output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
}

# Display EC2 Instance ID
output "instance_id" {
  value = aws_instance.app_server.id
}
