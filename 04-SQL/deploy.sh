#!/bin/bash

# -- Variaveis AWS
uri='ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@52.67.249.96'

export TF_VAR_vpcId=$($uri 'aws --region sa-east-1 ec2 describe-vpcs --filters Name=tag:Name,Values=vpc-Team4 --query "Vpcs[*].VpcId" --output text')
export TF_VAR_subnetPrivada=$($uri 'aws --region sa-east-1 ec2 describe-subnets --filters "Name=vpc-id,Values='$TF_VAR_vpcId'" "Name=tag:Name,Values=*Priv*" --query "Subnets[1].SubnetId" --output text')
export TF_VAR_keyPrivate='jb-key'
export TF_VAR_amiId='ami-0e66f5495b4efdd0f'

echo $TF_VAR_vpcId
echo $TF_VAR_subnetPrivada
echo $TF_VAR_keyPrivate
echo $TF_VAR_amiId
# --

cd 04-SQL/terraform
terraform init
terraform apply -auto-approve

echo "Aguardando criação de maquinas ..."
sleep 10 # 10 segundos

echo "[ec2-mysql-dev]" > ../ansible/hosts
echo "$(terraform output | grep mysql_instance_dev | awk '{print $2;exit}' | sed -e "s/\",//g")" >> ../ansible/hosts
echo "[ec2-mysql-stag]" >> ../ansible/hosts
echo "$(terraform output | grep mysql_instance_stag | awk '{print $2;exit}' | sed -e "s/\",//g")" >> ../ansible/hosts
echo "[ec2-mysql-prod]" >> ../ansible/hosts
echo "$(terraform output | grep mysql_instance_prod | awk '{print $2;exit}' | sed -e "s/\",//g")" >> ../ansible/hosts

sleep 10 # 10 segundos
cd ../ansible

echo "[client]" > dumpsql/.my.cnf
echo "user=root" >> dumpsql/.my.cnf
echo "password=$DB_PASSWORD" >> dumpsql/.my.cnf

echo "Executando ansible ::::: [ ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/id_rsa]"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/id_rsa

echo "Executando ansible ::::: [ ansible-playbook -i hosts provisionarDataBase.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/id_rsa]"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionarDataBase.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/id_rsa

# Limpar a Senha Digitada
echo "[client]" > dumpsql/.my.cnf
echo "user=root" >> dumpsql/.my.cnf
echo "password=" >> dumpsql/.my.cnf