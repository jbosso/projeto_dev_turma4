#!/bin/bash

# -- Variaveis AWS
uri='ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@localhost'

export SQLdev=$($uri 'aws --region sa-east-1 ec2 describe-instances --filters Name=tag:Name,Values=mysql-dev --query "Reservations[*].Instances[*].[PrivateIpAddress]" --output text | grep 172')
# -- 

export USER='root'
export PASSWORD="$DB_PASSWORD" 
export DATABASE_URL='mysql://'$SQLdev':3306/SpringWebYoutubeTest?useTimezone=true&serverTimezone=UTC'

echo $USER
echo $PASSWORD
echo $DATABASE_URL

#

cd app-code && ./mvnw test