#!/bin/bash
cd 02-AMI/terraform

uri=$(terraform output | grep private_ip | awk '{print $2;exit}' | sed -e "s/\",//g")

kube_adm=$(ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@$uri 'kubeadm version')
docker=$(ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@$uri 'docker --version')

regex_kube=$(echo $kube_adm | awk '{print $1$2;exit}')
regex_docker=$(echo $docker | awk '{print $1$2;exit}')

if [ "$regex_kube" = 'kubeadmversion:' ] && [ "$regex_docker" = 'Dockerversion' ]; then 
    echo "::::: kubernetes e docker UP :::::"
    exit 0
else
    echo "::::: kubernetes e docker OFFLINE :::::"
    exit 1
fi
