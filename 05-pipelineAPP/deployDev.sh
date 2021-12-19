#!/bin/bash
export TF_VAR_PATH_KEY="/home/ubuntu/ehopner-dev.pem"


cd 05-pipelineAPP/ansible

#ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key ~/.ssh/chaveprivada.pem

echo "Executando ansible ::::: [ ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key $TF_VAR_PATH_KEY ]"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionarDev.yml -u ubuntu --private-key $TF_VAR_PATH_KEY
