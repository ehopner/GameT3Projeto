#>>---Declarando as variáveis---<<
variable "ssh_pub_key" {
  type = string
}

variable "vpc_ip" {
  type = string
  default = "10.99.0.0/16"
}

variable "subnet_a_ip_pub" {
  type = string
  default = "10.99.0.0/24"
}

variable "subnet_a_ip_pvt" {
  type = string
  default = "10.99.128.0/24"
}
