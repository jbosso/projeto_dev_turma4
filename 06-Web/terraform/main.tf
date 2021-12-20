provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "dev_nginx" {
  subnet_id                   = "${var.subnetIdPubA}"
  ami                         = "ami-0e66f5495b4efdd0f"
  instance_type = "t2.large"
  associate_public_ip_address = true
  key_name                    = "${var.keyPrivate}"
  root_block_device {
    encrypted   = true
    volume_size = 16
  }
  tags = {
    Name = "dev-img-kubernetes"
  }
  vpc_security_group_ids = [aws_security_group.nginx_web.id]
}

resource "aws_security_group" "nginx_web" {
  name        = "nginx_web"
  description = "nginx_web inbound traffic"
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
	    {
      description      = "SSH from VPC"
      from_port        = 30000
      to_port          = 30005
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
    Name = "nginx_web"
  }
}

# Variaveis

variable "vpcId" {
  type        = string
}

variable "subnetIdPubA" {
  type        = string
}

variable "keyPrivate" {
  type        = string
}

# terraform refresh para mostrar o ssh
output "dev_nginx" {
  value = [
    "resource_id: ${aws_instance.dev_nginx.id}",
    "private_ip: ${aws_instance.dev_nginx.private_ip}",
	  "public_ip: ${aws_instance.dev_nginx.public_ip}",
    "ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@${aws_instance.dev_nginx.public_ip}"
  ]
}