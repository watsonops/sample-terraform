terraform {
  cloud {
    organization = "dariustechnologies"
    workspaces {
      name = "watsonspace"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}
# -- AWS Provider
provider "aws" {
  profile = "default"
  region  =  var.aws_region
}
## -- KMS Key
resource "aws_kms_key" "k8s_dev_kms01" {
  description             = "KMS key 1"
  deletion_window_in_days = 7
  tags = {
    Name = "k8s-dev-kms"
    Env = "dev"
  }
}

resource "aws_vpc" "k8s_dev_vpc01" {
  cidr_block       = "10.100.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "k8s-dev-vpc"
    Env = "dev"
    "kubernetes.io/cluster" = "k8s-dev-k8s"
    "kubernetes.io/cluster/k8s-dev-k8s" = "owned"
  }
}

## -- Public subs
resource "aws_subnet" "k8s_dev_subnet_pub01" {
  vpc_id     = aws_vpc.k8s_dev_vpc01.id
  availability_zone = var.aws_region_zone01
  cidr_block = "10.100.1.0/24"
  tags = {
    Name = "k8s-dev-subnet-pub01"
    Tier = "public"
    Env = "dev"
  }
}
resource "aws_subnet" "k8s_dev_subnet_pub02" {
  vpc_id     = aws_vpc.k8s_dev_vpc01.id
  availability_zone = var.aws_region_zone02
  cidr_block = "10.100.2.0/24"
  tags = {
    Name = "k8s-dev-subnet-pub02"
    Tier = "public"
    Env = "dev"
  }
}
resource "aws_subnet" "k8s_dev_subnet_pub03" {
  vpc_id     = aws_vpc.k8s_dev_vpc01.id
  availability_zone = var.aws_region_zone03
  cidr_block = "10.100.3.0/24"
  tags = {
    Name = "k8s-dev-subnet-pub03"
    Tier = "public"
    Env = "dev"
  }
}
## -- Private subs
resource "aws_subnet" "k8s_dev_subnet_prv01" {
  vpc_id     = aws_vpc.k8s_dev_vpc01.id
  availability_zone = var.aws_region_zone01
  cidr_block = "10.100.11.0/24"
  tags = {
    Name = "k8s-dev-subnet-prv01"
    Tier = "private"
    Env = "dev"
    "kubernetes.io/cluster" = "k8s-dev-k8s"
    "kubernetes.io/cluster/k8s-dev-k8s" = "owned"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
resource "aws_subnet" "k8s_dev_subnet_prv02" {
  vpc_id     = aws_vpc.k8s_dev_vpc01.id
  availability_zone = var.aws_region_zone02
  cidr_block = "10.100.12.0/24"
  tags = {
    Name = "k8s-dev-subnet-prv02"
    Tier = "private"
    Env = "dev"
    "kubernetes.io/cluster" = "k8s-dev-k8s"
    "kubernetes.io/cluster/k8s-dev-k8s" = "owned"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
resource "aws_subnet" "k8s_dev_subnet_prv03" {
  vpc_id     = aws_vpc.k8s_dev_vpc01.id
  availability_zone = var.aws_region_zone03
  cidr_block = "10.100.13.0/24"
  tags = {
    Name = "k8s-dev-subnet-prv03"
    Tier = "private"
    Env = "dev"
    "kubernetes.io/cluster" = "k8s-dev-k8s"
    "kubernetes.io/cluster/k8s-dev-k8s" = "owned"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
## -- Internet Gateway
resource "aws_internet_gateway" "k8s_dev_gw01" {
  vpc_id = aws_vpc.k8s_dev_vpc01.id
  tags = {
    Name = "k8s-dev-gw01"
    Env = "dev"
  }
}
## -- Route tables
resource "aws_route_table" "k8s_dev_pub_rt01" {
  vpc_id = aws_vpc.k8s_dev_vpc01.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s_dev_gw01.id
  }
  tags = {
    Name = "k8s-dev-pub-rt01"
    Env = "dev"
  }
}
resource "aws_route_table_association" "k8s_dev_pub_rt01_assoc" {
  subnet_id = aws_subnet.k8s_dev_subnet_pub01.id
  route_table_id = aws_route_table.k8s_dev_pub_rt01.id
}
## -- Security Groups
resource "aws_security_group" "k8s_dev_sg_allow_ssh" {
  name        = "k8s_dev_allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.k8s_dev_vpc01.id

  ingress {
    description      = "allow ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "k8s-dev-sg-allow-ssh"
    Env = "dev"
  }
}
resource "aws_security_group" "k8s_dev_sg_allow_web" {
  name        = "k8s_dev_allow_web"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.k8s_dev_vpc01.id

  ingress {
    description      = "artifactory"
    from_port        = 8082
    to_port          = 8082
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "artifactory-tls"
    from_port        = 8080
    to_port          = 8080
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "all-outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

    tags = {
    Name = "k8s-dev-sg-allow-web"
    Env = "dev"
  }
}
resource "aws_security_group" "k8s_dev_sg_allow_internal" {
  name        = "k8s_dev_allow_internal"
  description = "Allow internal traffic"
  vpc_id      = aws_vpc.k8s_dev_vpc01.id

  ingress {
    description      = "Internal from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["10.100.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "k8s-dev-sg-allow-internal"
    Env = "dev"
  }
}
## -- RHEL 8 Instance
resource "aws_instance" "my_vm_rhel" {
  ami = var.ami_rhel
  instance_type = "t2.medium"
  vpc_security_group_ids = [ aws_security_group.k8s_dev_sg_allow_ssh.id, aws_security_group.k8s_dev_sg_allow_web.id, aws_security_group.k8s_dev_sg_allow_internal.id ]
  subnet_id = aws_subnet.k8s_dev_subnet_pub01.id
  associate_public_ip_address = true
  key_name = var.key_name
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    # encrypted   = true
    # kms_key_id  = aws_kms_key.k8s_dev_kms01.id
  }
  user_data = <<EOF
#! /bin/bash
echo "automated startup $(date)" >> /tmp/automated_log.txt
sudo yum -y update
sudo yum -y upgrade
sudo yum -y install epel-release
sudo yum clean all
sudo hostnamectl set-hostname my-vm-rhel
sleep 5
echo "automated end $(date)" >> /tmp/automated_log.txt
sudo init 6
EOF
  tags = {
    Name = "my-vm-rhel"
    OS = "rhel"
    Env = "dev"
    App = "rhel_app"
  }
}

## -- Ubuntu Instance
resource "aws_instance" "my_vm_ubuntu" {
  ami = var.ami_ubuntu
  instance_type = "t2.medium"
  vpc_security_group_ids = [ aws_security_group.k8s_dev_sg_allow_ssh.id, aws_security_group.k8s_dev_sg_allow_web.id, aws_security_group.k8s_dev_sg_allow_internal.id ]
  subnet_id = aws_subnet.k8s_dev_subnet_pub01.id
  associate_public_ip_address = true
  key_name = var.key_name
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    # encrypted   = true
    # kms_key_id  = aws_kms_key.k8s_dev_kms01.id
  }
  user_data = <<EOF
#! /bin/bash
echo "automated startup $(date)" >> /tmp/automated_log.txt
sudo apt -y update
sudo apt -y upgrade
sudo hostnamectl set-hostname my-vm-ubuntu
sleep 5
echo "automated end $(date)" >> /tmp/automated_log.txt
sudo init 6
EOF
  tags = {
    Name = "my-vm-ubuntu"
    OS = "ubuntu"
    Env = "dev"
    App = "ubuntu_app"
  }
}



