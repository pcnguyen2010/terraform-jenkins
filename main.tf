terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

/*
AWS IAM
username: terraform-admin
Access key: AKIAQPNNHBFIY77NU3U7
Secret key: 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
*/

provider "aws" {
  region     = "us-east-2"
  access_key = "AKIAQPNNHBFIY77NU3U7"
  secret_key = "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"
}

// To Generate Private Key
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "key_name" {
  description = "Name of the SSH key pair"
}

// Create Key Pair for Connecting EC2 via SSH
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

// Save PEM file locally
resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name
}

# Create a security group
resource "aws_security_group" "sg_ec2" {
  name        = "sg_ec2"
  description = "Security group for EC2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*
ssh key pair:
codesagar_pem
*/
resource "aws_instance" "public_instance" {
  ami                    = "ami-05fb0b8c1424f266b"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]

  tags = {
    Name = "public_instance"
  }

   root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }
}
