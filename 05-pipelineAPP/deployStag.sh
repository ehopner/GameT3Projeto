#!/bin/bash

cd 05-pipelineAPP/ansible

#ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key ~/.ssh/chaveprivada.pem

echo "Executando ansible ::::: [ ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/id_rsa ]"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionarStag.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/id_rsa
