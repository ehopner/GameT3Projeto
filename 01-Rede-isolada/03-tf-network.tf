#>>---Captura o IP da máquina local---<<
# Necessário se apenas o equipamento local puder acessar
/* data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
} */

#>>---Cria a VPC---<<
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block       = "${var.vpc_ip}" # uma classe de IP
  instance_tenancy = "default"  # - (Optional) A tenancy option for instances launched into the VPC. Default is default, which makes your instances shared on the host. Using either of the other options (dedicated or host) costs at least $2/hr.
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-t3-tf"
    Owner = "Turma 3"
    Negocio = "Arcade Division"
  }
}

#>>---Cria a(s) Subnet(s)---<<
resource "aws_subnet" "subnet-t3-a-pub" { #Subnet será definida como pública
  vpc_id            = aws_vpc.main.id
  cidr_block        = "${var.subnet_a_ip_pub}"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "subnet-t3-a-pub"
  }
}

resource "aws_subnet" "subnet-t3-a-pvt" { #Subnet será definida como privada
  vpc_id            = aws_vpc.main.id
  cidr_block        = "${var.subnet_a_ip_pvt}"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "subnet-t3-a-pvt"
  }
}

#>>---Cria o Internet Gateway---<<
resource "aws_internet_gateway" "gw_t3" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "gw_t3"
  }
}

#>>---Cria a(s) Route Table(s)---<<
resource "aws_route_table" "rt_t3_pub" {
  vpc_id = aws_vpc.main.id

  route = [
      {
        carrier_gateway_id         = ""
        cidr_block                 = "0.0.0.0/0"
        destination_prefix_list_id = ""
        egress_only_gateway_id     = ""
        gateway_id                 = aws_internet_gateway.gw_t3.id
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
    Name = "rt_t3_pub"
  }
}

resource "aws_route_table" "rt_t3_pvt" {
  vpc_id = aws_vpc.main.id

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
        nat_gateway_id             = aws_nat_gateway.nat_gt_t3.id
        network_interface_id       = ""
        transit_gateway_id         = ""
        vpc_endpoint_id            = ""
        vpc_peering_connection_id  = ""
      }
  ]

  tags = {
    Name = "rt_t3_pvt"
  }
}

#>>---Associa a(s) Subnet(s) à Route Table---<<
resource "aws_route_table_association" "a_pub" {
  subnet_id      = aws_subnet.subnet-t3-a-pub.id
  route_table_id = aws_route_table.rt_t3_pub.id
}

resource "aws_route_table_association" "a_pvt" {
  subnet_id      = aws_subnet.subnet-t3-a-pvt.id
  route_table_id = aws_route_table.rt_t3_pvt.id
}

resource "aws_nat_gateway" "nat_gt_t3" {
  subnet_id     = aws_subnet.subnet-t3-a-pub.id
  connectivity_type = "private"
  depends_on = [aws_internet_gateway.gw_t3]
  tags = {
    Name = "nat_gt_t3"
  }
}

