provider "aws" {
  region = "sa-east-1"
}

# Criar a VPC

resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-Team4"
  }
}
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "igw-Team4"
  }
}

# Criar Subnets Publicas
resource "aws_subnet" "Team4_subnetPub_1a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.16.10.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "Team4_subnetPub_1a"
  }
}

resource "aws_subnet" "Team4_subnetPub_1c" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.16.11.0/24"
  availability_zone = "sa-east-1c"

  tags = {
    Name = "Team4_subnetPub_1c"
  }
}

# Criar Subnets Privada

resource "aws_subnet" "Team4_subnetPriv_1a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.16.12.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "Team4_subnetPriv_1a"
  }
}
resource "aws_subnet" "Team4_subnetPriv_1c" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "172.16.13.0/24"
  availability_zone = "sa-east-1c"

  tags = {
    Name = "Team4_subnetPriv_1c"
  }
}

# Criar Tabela de Rota Publica

resource "aws_route_table" "Team4_rtPub" {
  vpc_id = "${aws_vpc.main.id}"
  route = [
      {
        carrier_gateway_id         = ""
        cidr_block                 = "0.0.0.0/0"
        destination_prefix_list_id = ""
        egress_only_gateway_id     = ""
        gateway_id                 = "${var.ig}"
        instance_id                = ""
        ipv6_cidr_block            = ""
        local_gateway_id           = ""
        nat_gateway_id             = ""
        network_interface_id       = ""
        transit_gateway_id         = ""
        vpc_endpoint_id            = ""
        vpc_peering_connection_id  = ""
      }
  ]
  tags = {
    Name = "Team4_rtPub"
  }
}

# Criar Tabela de Rota Privada

resource "aws_route_table" "Team4_rtPriv1a" {
  vpc_id = "${aws_vpc.main.id}"
  route = [
      {
        carrier_gateway_id         = ""
        cidr_block                 = "0.0.0.0/0"
        destination_prefix_list_id = ""
        egress_only_gateway_id     = ""
        gateway_id                 = ""
        instance_id                = ""
        ipv6_cidr_block            = ""
        local_gateway_id           = ""
        nat_gateway_id             = aws_nat_gateway.Team4_natgateway1a.id
        network_interface_id       = ""
        transit_gateway_id         = ""
        vpc_endpoint_id            = ""
        vpc_peering_connection_id  = ""
      }
  ]
  tags = {
    Name = "Team4_rtPriv1a"
  }
}
resource "aws_route_table" "Team4_rtPriv1c" {
  vpc_id = "${aws_vpc.main.id}"
  route = [
      {
        carrier_gateway_id         = ""
        cidr_block                 = "0.0.0.0/0"
        destination_prefix_list_id = ""
        egress_only_gateway_id     = ""
        gateway_id                 = ""
        instance_id                = ""
        ipv6_cidr_block            = ""
        local_gateway_id           = ""
        nat_gateway_id             = aws_nat_gateway.Team4_natgateway1c.id
        network_interface_id       = ""
        transit_gateway_id         = ""
        vpc_endpoint_id            = ""
        vpc_peering_connection_id  = ""
      }
  ]
  tags = {
    Name = "Team4_rtPriv1c"
  }
}

# Associar Subnet

resource "aws_route_table_association" "Team4_rtPriv_Assoc1a" {
  subnet_id      = aws_subnet.Team4_subnetPriv_1a.id
  route_table_id = aws_route_table.Team4_rtPriv1a.id
}
resource "aws_route_table_association" "Team4_rtPriv_Assoc1c" {
  subnet_id      = aws_subnet.Team4_subnetPriv_1c.id
  route_table_id = aws_route_table.Team4_rtPriv1c.id
}


resource "aws_route_table_association" "Team4_rtPub_Assoc1a" {
  subnet_id      = aws_subnet.Team4_subnetPub_1a.id
  route_table_id = aws_route_table.Team4_rtPub.id
}

resource "aws_route_table_association" "Team4_rtPub_Assoc1c" {
  subnet_id      = aws_subnet.Team4_subnetPub_1c.id
  route_table_id = aws_route_table.Team4_rtPub.id
}

# Criar Nat Gateway

resource "aws_eip" "nat_gateway1a" {
  depends_on = [aws_internet_gateway.ig]
  vpc = true
}
resource "aws_eip" "nat_gateway1c" {
  depends_on = [aws_internet_gateway.ig]
  vpc = true
}


resource "aws_nat_gateway" "Team4_natgateway1a" {
  allocation_id = aws_eip.nat_gateway1a.id
  subnet_id     = "${var.SubnetPub1a}"
  tags = {
    Name = "Team4_natgateway1a"
  }
}
resource "aws_nat_gateway" "Team4_natgateway1c" {
  allocation_id = aws_eip.nat_gateway1c.id
  subnet_id     = aws_subnet.Team4_subnetPub_1c.id
  tags = {
    Name = "Team4_natgateway1c"
  }
}

# Output

output "subnets" {
  value = [
    "SubnetPub1a: ${var.SubnetPub1a} " ,
    "SubnetPub1c: ${aws_subnet.Team4_subnetPub_1c.id} " ,
    "SubnetPriv1a: ${aws_subnet.Team4_subnetPriv_1a.id} " ,
    "SubnetPriv1c: ${aws_subnet.Team4_subnetPriv_1c.id} " ,
    "vpcId: ${aws_vpc.main.id} "
  ]
}
