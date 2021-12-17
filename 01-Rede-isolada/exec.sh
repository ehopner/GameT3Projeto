export TF_VAR_ssh_pub_key=$(cat t3-rsa.pub)
terraform init
terraform apply -auto-approve