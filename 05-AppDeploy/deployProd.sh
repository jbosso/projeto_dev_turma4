#!/bin/bash

# -- Variaveis AWS
uri='ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@localhost'

export masterIP=$($uri 'aws --region sa-east-1 ec2 describe-instances --filters Name=tag:Name,Values=k8s-master0 --query "Reservations[*].Instances[*].[PrivateIpAddress]" --output text')
export SQLprod=$($uri 'aws --region sa-east-1 ec2 describe-instances --filters Name=tag:Name,Values=mysql-prod --query "Reservations[*].Instances[*].[PrivateIpAddress]" --output text')

echo $masterIP
echo $SQLprod
## --

cd 05-AppDeploy/ansible

echo "[k8s-master0]" > ../ansible/hosts
echo $masterIP >> ../ansible/hosts

cat <<EOF > k8s-deploy/mysql-configmap-prod.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-configmap-prod
data:
  USER: root
  # PASSWORD: root
  DATABASE_URL: mysql://$SQLprod:3306/SpringWebYoutubeTest?useTimezone=true&serverTimezone=UTC
EOF

echo "Executando ansible ::::: [ ansible-playbook -i hosts provisionarProd.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/id_rsa ]"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionarProd.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/id_rsa