output name_VPC {
  value = [
    aws_vpc.main.id,
    "Name: ${aws_vpc.main.tags.Name}",
    "Division: ${aws_vpc.main.tags.Negocio}",
    "Subnet Pvt (1a) - Nome: ${aws_subnet.subnet-t3-a-pvt.tags.Name} / Id: ${aws_subnet.subnet-t3-a-pvt.id}",
    "Subnet Pub (1a) - Nome: ${aws_subnet.subnet-t3-a-pub.tags.Name} / Id: ${aws_subnet.subnet-t3-a-pub.id}",
  ]
}

/* output "teste_IPs" {
    value = ["${chomp(data.http.myip.body)}/32"]
    value = "${data.http.myip.body}"
} */

#>>---Cria documento com os dados do que foi gerado---<<
resource "local_file" "recursos_liberados" {
  filename = "liberacao.txt"
  content = <<EOF
    VPC: ${aws_vpc.main.id}
    Name: ${aws_vpc.main.tags.Name}
    Division: ${aws_vpc.main.tags.Negocio}
    Subnet Pvt (1a) - Nome: ${aws_subnet.subnet-t3-a-pvt.tags.Name} / Id: ${aws_subnet.subnet-t3-a-pvt.id}
    Subnet Pub (1a) - Nome: ${aws_subnet.subnet-t3-a-pub.tags.Name} / Id: ${aws_subnet.subnet-t3-a-pub.id}
  EOF
}