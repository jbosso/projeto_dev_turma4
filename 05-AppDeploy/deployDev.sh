#!/bin/bash

# -- Variaveis AWS
uri='ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@52.67.249.96'

export masterIP=$($uri 'aws --region sa-east-1 ec2 describe-instances --filters Name=tag:Name,Values=k8s-master0 --query "Reservations[*].Instances[*].[PrivateIpAddress]" --output text | grep 172')
export SQLdev=$($uri 'aws --region sa-east-1 ec2 describe-instances --filters Name=tag:Name,Values=mysql-dev --query "Reservations[*].Instances[*].[PrivateIpAddress]" --output text | grep 172')

echo $masterIP
echo $SQLdev
## --

cd 05-AppDeploy/ansible

echo "[k8s-master0]" > ../ansible/hosts
echo $masterIP >> ../ansible/hosts

cat <<EOF > k8s-deploy/mysql-configmap-dev.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-configmap-dev
data:
  USER: root
  # PASSWORD: root
  DATABASE_URL: mysql://$SQLdev:3306/SpringWebYoutubeTest?useTimezone=true&serverTimezone=UTC
EOF

echo "Executando ansible ::::: [ ansible-playbook -i hosts provisionarDev.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/id_rsa ]"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionarDev.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/id_rsa