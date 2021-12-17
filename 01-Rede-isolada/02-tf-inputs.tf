#>>---Declarando as variáveis---<<
variable "ssh_pub_key" {
  type = string
}

variable "vpc_ip" {
  type = string
  default = "14.100.0.0/16"
}

variable "subnet_a_ip_pub" {
  type = string
  default = "14.100.16.0/24"
}

variable "subnet_a_ip_pvt" {
  type = string
  default = "14.100.32.0/24"
}
