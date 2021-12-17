provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "k8s_proxy" {
  subnet_id = "${var.subnets}" #preencher com o subnet id da publica
  ami = "${var.amiId}"
  instance_type = "t2.large"
  associate_public_ip_address = true
  key_name = "${var.chave}"
  root_block_device {
    encrypted = true
    volume_size = 30
  }
  tags = {
    Name = "t3-k8s-haproxy-projeto"
  }
  vpc_security_group_ids = [aws_security_group.acessos_haproxy.id]
}

resource "aws_instance" "k8s_masters" {
  subnet_id = "${var.subnets}"
  ami = "${var.amiId}"
  instance_type = "t2.large"
  associate_public_ip_address = true
  key_name = "${var.chave}"
  count         = 2
  root_block_device {
    encrypted = true
    volume_size = 30
  }
  tags = {
    Name = "t3-k8s-master-projeto${count.index}"
  }
  vpc_security_group_ids = [aws_security_group.acessos_masters.id]
  depends_on = [
    aws_instance.k8s_workers,
  ]
}

resource "aws_instance" "k8s_workers" {
  subnet_id = "${var.subnets}"
  ami = "${var.amiId}"
  instance_type = "t2.large"
  associate_public_ip_address = true
  key_name = "${var.chave}"
  count         = 4
  root_block_device {
    encrypted = true
    volume_size = 30
  }
  tags = {
    Name = "t3-k8s_workers-projeto${count.index}"
  }
  vpc_security_group_ids = [aws_security_group.acessos_workers.id]
}

resource "aws_security_group" "acessos_masters" {
  name        = "t3-k8s-acessos_masters"
  description = "acessos inbound traffic"
  vpc_id = var.vpcId
  
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
    Name = "t3-acessos_masters"
  }
}

resource "aws_security_group" "acessos_haproxy" {
  name        = "t3-k8s-haproxy"
  description = "acessos inbound traffic"
  vpc_id = var.vpcId
  
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
    Name = "t3-allow_haproxy_ssh"
  }
}

resource "aws_security_group" "acessos_workers" {
  name        = "t3-k8s-workers"
  description = "acessos inbound traffic"
  vpc_id = var.vpcId
  
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
    Name = "t3-acessos_workers"
  }
}

resource "aws_security_group_rule" "acessos_workers_rule_ssh" {
  type             = "ingress"
  description      = "Libera acessos"
  from_port        = 22
  to_port          = 22
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.acessos_workers.id
}
resource "aws_security_group_rule" "acessos_workers_masters" {
  type             = "ingress"
  description      = "Libera acessos"
  from_port        = 0
  to_port          = 0
  protocol         = "all"
  source_security_group_id = aws_security_group.acessos_workers.id
  security_group_id = aws_security_group.acessos_masters.id
}

resource "aws_security_group_rule" "acessos_master_rule_tcp" {
  type             = "ingress"
  description      = "Libera acessos"
  from_port        = 30000
  to_port          = 30000
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.acessos_masters.id
}
resource "aws_security_group_rule" "acessos_master_rule_ssh" {
  type             = "ingress"
  description      = "Libera acessos"
  from_port        = 22
  to_port          = 22
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.acessos_masters.id
}
resource "aws_security_group_rule" "acessos_master_hproxy" {
  type             = "ingress"
  description      = "Libera acessos"
  from_port        = 0
  to_port          = 0
  protocol         = "all"
  source_security_group_id = aws_security_group.acessos_masters.id
  security_group_id = aws_security_group.acessos_haproxy.id
}
resource "aws_security_group_rule" "acessos_master_master" {
  type             = "ingress"
  description      = "Libera acessos"
  from_port        = 0
  to_port          = 0
  protocol         = "all"
  source_security_group_id = aws_security_group.acessos_masters.id
  security_group_id = aws_security_group.acessos_masters.id
}
resource "aws_security_group_rule" "acessos_master_workers" {
  type             = "ingress"
  description      = "Libera acessos"
  from_port        = 0
  to_port          = 0
  protocol         = "all"
  source_security_group_id = aws_security_group.acessos_masters.id
  security_group_id = aws_security_group.acessos_workers.id
}

resource "aws_security_group_rule" "acessos_haproxy_master" {
  type             = "ingress"
  description      = "Libera acessos"
  from_port        = 0
  to_port          = 0
  protocol         = "all"
  source_security_group_id = aws_security_group.acessos_haproxy.id
  security_group_id = aws_security_group.acessos_masters.id
}
resource "aws_security_group_rule" "acessos_haproxy_to_workers" {
  type             = "ingress"
  description      = "Libera acessos"
  from_port        = 0
  to_port          = 0
  protocol         = "all"
  source_security_group_id = aws_security_group.acessos_workers.id
  security_group_id = aws_security_group.acessos_haproxy.id
}
resource "aws_security_group_rule" "acessos_workers_to_haproxy" {
  type             = "ingress"
  description      = "Libera acessos"
  from_port        = 0
  to_port          = 0
  protocol         = "all"
  source_security_group_id = aws_security_group.acessos_haproxy.id
  security_group_id = aws_security_group.acessos_workers.id
}
resource "aws_security_group_rule" "acessos_haproxy_ssh" {
  type             = "ingress"
  description      = "Libera acessos"
  from_port        = 22
  to_port          = 22
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.acessos_haproxy.id
}


output "k8s-masters" {
  value = [
    for key, item in aws_instance.k8s_masters :
      "k8s-master ${key+1} - ${item.private_ip} - ssh -i ${var.PATH_KEY} ubuntu@${item.public_dns} -o ServerAliveInterval=60"
  ]
}

output "output-k8s_workers" {
  value = [
    for key, item in aws_instance.k8s_workers :
      "k8s-workers ${key+1} - ${item.private_ip} - ssh -i ${var.PATH_KEY} ubuntu@${item.public_dns} -o ServerAliveInterval=60"
  ]
}

output "output-k8s_proxy" {
  value = [
    "k8s_proxy - ${aws_instance.k8s_proxy.private_ip} - ssh -i ${var.PATH_KEY} ubuntu@${aws_instance.k8s_proxy.public_dns} -o ServerAliveInterval=60"
  ]
}

output "security-group-haproxy" {
  value = aws_security_group.acessos_haproxy.id
}

output "security-group-workers" {
  value = aws_security_group.acessos_workers.id
}

output "security-group-masters" {
  value = aws_security_group.acessos_masters.id
}


variable PATH_KEY {
  type = string
  description = "path da chave"
}

variable "amiId" {
  type = string
  default = "ami-0e59f23edd14d9ea6"
  description = "amiId"
}

variable "subnets" {
  type        = string
  default = "subnet-0df4c84deb2937ae2"
  description = "publicSubNetId"
}
variable "vpcId" {
  type = string
  default = "vpc-071b02541a42d8de0"
  description = "vpcId"
}
variable "chave" {
  type = string
  default = "ehopner-dev"
  description = "awsKey"
}

#variable "sgMasters" {
#  type = string
#  description = "sgMasters"
#}
#
#variable "sgWorkers" {
#  type = string
#  description = "sgWorkers"
#}
#
#variable "sgHaproxy" {
#  type = string
#  description = "sgHaproxy"
#}


# terraform refresh para mostrar o ssh