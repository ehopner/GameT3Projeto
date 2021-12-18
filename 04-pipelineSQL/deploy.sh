#!/bin/bash

cd 04-pipelineSQL/terraform
terraform init
# AMI ubuntu
terraform apply -auto-approve

echo "Aguardando criação de maquinas ..."
sleep 10 # 10 segundos

echo $"[ec2-mysql-dev]" > ../ansible/hosts # cria arquivo
echo "$(terraform output | grep mysql_instance_dev | awk '{print $2;exit}' | sed -e "s/\",//g")" >> ../ansible/hosts # captura output faz split de espaco e replace de ",
echo $"[ec2-mysql-stag]" >> ../ansible/hosts # cria arquivo
echo "$(terraform output | grep mysql_instance_stag | awk '{print $2;exit}' | sed -e "s/\",//g")" >> ../ansible/hosts # captura output faz split de espaco e replace de ",
echo $"[ec2-mysql-prod]" >> ../ansible/hosts # cria arquivo
echo "$(terraform output | grep mysql_instance_prod | awk '{print $2;exit}' | sed -e "s/\",//g")" >> ../ansible/hosts # captura output faz split de espaco e replace de ",


echo "Aguardando criação de maquinas ..."
sleep 10 # 10 segundos

cd ../ansible

echo $"[client]" > dumpsql/.my.cnf
echo $"user=root" >> dumpsql/.my.cnf
echo $"password=$PASSWORD" >> dumpsql/.my.cnf

#ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key ~/.ssh/chaveprivada.pem

echo "Executando ansible ::::: [ ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/id_rsa ]"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/id_rsa

echo $"[client]" > dumpsql/.my.cnf
echo $"user=root" >> dumpsql/.my.cnf
echo $"password=" >> dumpsql/.my.cnf