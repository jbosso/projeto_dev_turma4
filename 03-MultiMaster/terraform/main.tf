provider "aws" {
  region = "sa-east-1"
}

# ::::::::::::: HA Proxy

resource "aws_instance" "k8s_proxy" {
  subnet_id = "${element(var.subnets, 0)}"
  ami = "${var.amiId}"
  instance_type = "t2.large"
  associate_public_ip_address = false
  key_name = "${var.keyPrivate}"
  root_block_device {
    encrypted = true
    volume_size = 32
  }
  tags = {
    Name = "k8s-haproxy"
  }
  vpc_security_group_ids = [aws_security_group.acessos_haproxy.id]
}

# ::::::::::::: Masters

resource "aws_instance" "k8s_masters" {
  subnet_id = "${element(var.subnets, count.index)}"
  ami = "${var.amiId}"
  instance_type = "t2.large"
  associate_public_ip_address = false
  key_name = "${var.keyPrivate}"
  count         = "${length(var.subnets)}"
  root_block_device {
    encrypted = true
    volume_size = 32
  }
  tags = {
    Name = "k8s-master${count.index}"
  }
  vpc_security_group_ids = [aws_security_group.acessos_masters.id]
  depends_on = [
    aws_instance.k8s_workers,
  ]
}

# ::::::::::::: Workers

resource "aws_instance" "k8s_workers" {
  subnet_id = "${element(var.subnets, count.index)}"
  ami = "${var.amiId}"
  instance_type = "t2.large"
  associate_public_ip_address = false
  key_name = "${var.keyPrivate}"
  count         = "${length(var.subnets)}"
  root_block_device {
    encrypted = true
    volume_size = 32
  }
  tags = {
    Name = "k8s_workers${count.index}"
  }
  vpc_security_group_ids = [aws_security_group.acessos_workers.id]
}

# Variaveis

variable "amiId" {
  type = string
  description = "amiId"
}

variable "subnets" {
  type        = list(string)
}

variable "vpcId" {
  type = string
  description = "vpcId"
}

variable "keyPrivate" {
  type        = string
}