provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "dev_img_kubernetes" {
  subnet_id                   = "${var.subnetIdPrivA}"
  ami                         = "ami-0e66f5495b4efdd0f"
  instance_type = "t2.large"
  associate_public_ip_address = false
  key_name                    = "${var.keyPrivate}"
  root_block_device {
    encrypted   = true
    volume_size = 32
  }
  tags = {
    Name = "dev-img-kubernetes"
  }
  vpc_security_group_ids = [aws_security_group.kubernetes_sg_team4.id]
}

resource "aws_security_group" "kubernetes_sg_team4" {
  name        = "kubernetes_sg_team4"
  description = "kubernetes_sg_team4 inbound traffic"
  vpc_id      = "${var.vpcId}"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null,
      security_groups : null,
      self : null
    },
    {
      description      = "SSH from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null,
      security_groups : null,
      self : null
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids  = null,
      security_groups : null,
      self : null,
      description : "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "kubernetes_sg_team4"
  }
}

# Variaveis

variable "vpcId" {
  type        = string
}

variable "subnetIdPrivA" {
  type        = string
}

variable "keyPrivate" {
  type        = string
}

# terraform refresh para mostrar o ssh
output "dev_img_kubernetes" {
  value = [
    "resource_id: ${aws_instance.dev_img_kubernetes.id}",
    "private_ip: ${aws_instance.dev_img_kubernetes.private_ip}",
    "ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@${aws_instance.dev_img_kubernetes.private_ip}"
  ]
}