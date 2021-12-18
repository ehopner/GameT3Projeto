provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "mysql_instance-dev" {
  subnet_id = "${var.subnetPrivada}"
  ami = "${var.amiId}"
  instance_type = "t2.large"
  key_name = "${var.chave}"
  root_block_device {
    encrypted = true
    volume_size = 20
  }
  tags = {
    Name = "projetofinal-mysql-dev"
  }
  vpc_security_group_ids = [aws_security_group.projetofinal-mysql-sgDev.id]
}

resource "aws_instance" "mysql_instance-stag" {
  subnet_id = "${var.subnetPrivada}"
  ami = "${var.amiId}"
  instance_type = "t2.large"
  key_name = "${var.chave}"
  root_block_device {
    encrypted = true
    volume_size = 20
  }
  tags = {
    Name = "projetofinal-mysql-stag"
  }
  vpc_security_group_ids = [aws_security_group.projetofinal-mysql-sgStag.id]
}

resource "aws_instance" "mysql_instance-prod" {
  subnet_id = "${var.subnetPrivada}"
  ami = "${var.amiId}"
  instance_type = "t2.large"
  key_name = "${var.chave}"
  root_block_device {
    encrypted = true
    volume_size = 20
  }
  tags = {
    Name = "projetofinal-mysql-prod"
  }
  vpc_security_group_ids = [aws_security_group.projetofinal-mysql-sgProd.id]
}

resource "aws_security_group" "projetofinal-mysql-sgDev" {
  name        = "projetofinal-mysql-sgDev"
  description = "acessos inbound traffic"
  vpc_id      = "${var.vpc_id}"
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
    Name = "projetofinal-mysql-sgDev"
  }
}

resource "aws_security_group" "projetofinal-mysql-sgStag" {
  name        = "projetofinal-mysql-sgStag"
  description = "acessos inbound traffic"
  vpc_id      = "${var.vpc_id}"
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
    Name = "projetofinal-mysql-sgStag"
  }
}

resource "aws_security_group" "projetofinal-mysql-sgProd" {
  name        = "projetofinal-mysql-sgProd"
  description = "acessos inbound traffic"
  vpc_id      = "${var.vpc_id}"
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
    Name = "projetofinal-mysql-sgProd"
  }
}


variable "vpc_id" {
  type        = string
}

variable "igw_id" {
  type        = string
}

variable "amiId" {
  type        = string
}

variable "subnetPrivada" {
  type        = string
}

variable "chave" {
  type        = string
}

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
