# ::::::::::::: Security Group

resource "aws_security_group" "acessos_masters" {
  #name        = "k8s-masters"
  description = "acessos inbound traffic"
  vpc_id      = "${var.vpcId}"
  tags = {
    Name = "k8s-masters"
  }
}

resource "aws_security_group" "acessos_haproxy" {
  #name        = "k8s-haproxy"
  description = "acessos inbound traffic"
  vpc_id      = "${var.vpcId}"
  tags = {
    Name = "k8s-haproxy"
  }
}

resource "aws_security_group" "acessos_workers" {
  #name        = "k8s-workers"
  description = "acessos inbound traffic"
  vpc_id      = "${var.vpcId}"
  tags = {
    Name = "k8s-workers"
  }
}


########

resource "aws_security_group_rule" "Master_rule1" {
  security_group_id        = "${aws_security_group.acessos_masters.id}"
  type = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = []
  prefix_list_ids = []
  description = "Libera dados da rede interna"
}

resource "aws_security_group_rule" "Master_rule2" {
  security_group_id        = "${aws_security_group.acessos_masters.id}"
  type = "ingress"
  description      = "SSH from anywhere"
  from_port        = 22
  to_port          = 22
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = []
  prefix_list_ids = []
}

resource "aws_security_group_rule" "Master_rule3" {
  security_group_id        = "${aws_security_group.acessos_masters.id}"
  type = "ingress"
  description      = "Liberando pro mundo"
  from_port        = 30000
  to_port          = 30100
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = []
  prefix_list_ids = []
}

resource "aws_security_group_rule" "Master_rule4" {
  security_group_id        = "${aws_security_group.acessos_masters.id}"
  type = "ingress"
  description      = "Libera acesso k8s_masters"
  from_port        = 0
  prefix_list_ids  = []
  protocol         = "-1"
  self             = true
  to_port          = 0
}

# HAProxy -> Master
resource "aws_security_group_rule" "Master_rule5" {
  security_group_id        = "${aws_security_group.acessos_masters.id}"
  type = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.acessos_haproxy.id}"
}

# Workers -> Master
resource "aws_security_group_rule" "Master_rule6" {
  security_group_id        = "${aws_security_group.acessos_masters.id}"
  type = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.acessos_workers.id}"
}

########


resource "aws_security_group_rule" "HAProxy_rule1" {
  security_group_id        = "${aws_security_group.acessos_haproxy.id}"
  type = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = []
  prefix_list_ids = []
  description = "Libera dados da rede interna"
}

resource "aws_security_group_rule" "HAProxy_rule2" {
  security_group_id        = "${aws_security_group.acessos_haproxy.id}"
  type = "ingress"
  description      = "SSH from anywhere"
  from_port        = 22
  to_port          = 22
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = []
  prefix_list_ids = []
}

# Worker -> HAProxy
resource "aws_security_group_rule" "HAProxy_rule3" {
  security_group_id        = "${aws_security_group.acessos_haproxy.id}"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.acessos_workers.id}"
}

# Master -> HAProxy 
resource "aws_security_group_rule" "HAProxy_rule4" {
  security_group_id        = "${aws_security_group.acessos_haproxy.id}"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.acessos_masters.id}"
}

#########

resource "aws_security_group_rule" "Worker_rule1" {
  security_group_id        = "${aws_security_group.acessos_workers.id}"
  type = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = []
  prefix_list_ids = []
  description = "Libera dados da rede interna"
}

resource "aws_security_group_rule" "Worker_rule2" {
  security_group_id        = "${aws_security_group.acessos_workers.id}"
  type = "ingress"
  description      = "SSH from anywhere"
  from_port        = 22
  to_port          = 22
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = []
  prefix_list_ids = []
}

# Master -> Worker
resource "aws_security_group_rule" "Worker_rule3" {
  security_group_id        = "${aws_security_group.acessos_workers.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  type                     = "ingress"
  source_security_group_id = "${aws_security_group.acessos_masters.id}"
}

# HAProxy -> Worker
resource "aws_security_group_rule" "Worker_rule4" {
  security_group_id        = "${aws_security_group.acessos_workers.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  type                     = "ingress"
  source_security_group_id = "${aws_security_group.acessos_haproxy.id}"
}

resource "aws_security_group_rule" "Worker_rule5" {
  security_group_id        = "${aws_security_group.acessos_workers.id}"
  type = "ingress"
  description      = "Libera acesso k8s_workers"
  from_port        = 0
  prefix_list_ids  = []
  protocol         = "-1"
  self             = true
  to_port          = 0
}
