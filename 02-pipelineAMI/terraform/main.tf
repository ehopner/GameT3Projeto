provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "dev_img_kubernetes" {
  subnet_id                   = "${var.subnetId}"
  ami                         = "${var.amiId}"
  instance_type = "t2.large"
  associate_public_ip_address = true
  key_name                    = "${var.chave}"
  root_block_device {
    encrypted   = true
    volume_size = 30
  }
  tags = {
    Name = "dev-img-kubernetes"
  }
  vpc_security_group_ids = [aws_security_group.projetofinal_kubernetes.id]
}

resource "aws_security_group" "projetofinal_kubernetes" {
  name        = "projetofinal_kubernetes"
  description = "projetofinal_kubernetes inbound traffic"
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
    Name = "projetofinal_kubernetes"
  }
}

variable "vpcId" {
  type        = string
}

variable "subnetId" {
  type        = string
}

variable "chave" {
  type        = string
}

variable "amiId" {
  type        = string
}

# terraform refresh para mostrar o ssh
output "dev_img_kubernetes" {
  value = [
    "resource_id: ${aws_instance.dev_img_kubernetes.id}",
    "public_ip: ${aws_instance.dev_img_kubernetes.public_ip}",
    "public_dns: ${aws_instance.dev_img_kubernetes.public_dns}",
    "ssh -i /home/ubuntu/.ssh/id_rsa ubuntu@${aws_instance.dev_img_kubernetes.public_dns}"
  ]
}
