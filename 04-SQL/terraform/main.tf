provider "aws" {
  region = "sa-east-1"
}

# Dev

resource "aws_instance" "mysql_instance-dev" {
  subnet_id = "${var.subnetPrivada}"
  ami = "${var.amiId}"
  instance_type = "t2.large"
  key_name = "${var.keyPrivate}"
  root_block_device {
    encrypted = true
    volume_size = 20
  }
  tags = {
    Name = "mysql-dev"
  }
  vpc_security_group_ids = [aws_security_group.mysql-sgDev.id]
}

# Stage

resource "aws_instance" "mysql_instance-stag" {
  subnet_id = "${var.subnetPrivada}"
  ami = "${var.amiId}"
  instance_type = "t2.large"
  key_name = "${var.keyPrivate}"
  root_block_device {
    encrypted = true
    volume_size = 20
  }
  tags = {
    Name = "mysql-stag"
  }
  vpc_security_group_ids = [aws_security_group.mysql-sgStag.id]
}

#Prod

resource "aws_instance" "mysql_instance-prod" {
  subnet_id = "${var.subnetPrivada}"
  ami = "${var.amiId}"
  instance_type = "t2.large"
  key_name = "${var.keyPrivate}"
  root_block_device {
    encrypted = true
    volume_size = 20
  }
  tags = {
    Name = "mysql-prod"
  }
  vpc_security_group_ids = [aws_security_group.mysql-sgProd.id]
}

# Security Groups

resource "aws_security_group" "mysql-sgDev" {
  name        = "mysql-sgDev"
  description = "acessos inbound traffic"
  vpc_id      = "${var.vpcId}"
  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      description      = "mysql"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    }
  ]
  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]
  tags = {
    Name = "mysql-sgDev"
  }
}

resource "aws_security_group" "mysql-sgStag" {
  name        = "mysql-sgStag"
  description = "acessos inbound traffic"
  vpc_id      = "${var.vpcId}"
  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      description      = "mysql"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    }
  ]
  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]
  tags = {
    Name = "mysql-sgStag"
  }
}

resource "aws_security_group" "mysql-sgProd" {
  name        = "mysql-sgProd"
  description = "acessos inbound traffic"
  vpc_id      = "${var.vpcId}"
  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      description      = "mysql"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = null,
      security_groups: null,
      self: null
    }
  ]
  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = [],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]
  tags = {
    Name = "mysql-sgProd"
  }
}

# Variaveis

variable "vpcId" {
  type        = string
}

variable "amiId" {
  type        = string
}

variable "subnetPrivada" {
  type        = string
}

variable "keyPrivate" {
  type        = string
}

# Outputs

output "output-mysql-dev" {
  value = [
    "mysql_instance_dev ${aws_instance.mysql_instance-dev.private_ip}"
  ]
}

output "output-mysql-stag" {
  value = [
    "mysql_instance_stag ${aws_instance.mysql_instance-stag.private_ip}"
  ]
}

output "output-mysql-prod" {
  value = ["mysql_instance_prod ${aws_instance.mysql_instance-prod.private_ip}"]
}
