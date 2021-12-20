#!/bin/bash

cd 04-SQL/terraform

export SqlDev=$(terraform output | grep mysql_instance_dev | awk '{print $2;exit}' | sed -e "s/\",//g")
export SqlStag=$(terraform output | grep mysql_instance_stag | awk '{print $2;exit}' | sed -e "s/\",//g")
export SqlProd=$(terraform output | grep mysql_instance_prod | awk '{print $2;exit}' | sed -e "s/\",//g")

echo $SqlDev
echo $SqlStag
echo $SqlProd

#

ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@$SqlDev -oStrictHostKeyChecking=no << EOF
sudo mysql -u root -p'$DB_PASSWORD' -e "create user 'root'@'%' identified with mysql_native_password by '$DB_PASSWORD'"
sudo mysql -u root -p'$DB_PASSWORD' -e "grant all privileges on *.* to 'root'@'%'"
sudo mysql -u root -p'$DB_PASSWORD' -e "FLUSH PRIVILEGES"
sudo mysql -u root -p'$DB_PASSWORD' < /tmp/dumpsql.sql
EOF


ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@$SqlStag -oStrictHostKeyChecking=no << EOF
sudo mysql -u root -p'$DB_PASSWORD' -e "create user 'root'@'%' identified with mysql_native_password by '$DB_PASSWORD'"
sudo mysql -u root -p'$DB_PASSWORD' -e "grant all privileges on *.* to 'root'@'%'"
sudo mysql -u root -p'$DB_PASSWORD' -e "FLUSH PRIVILEGES"
sudo mysql -u root -p'$DB_PASSWORD' < /tmp/dumpsql.sql
EOF

ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@$SqlProd -oStrictHostKeyChecking=no << EOF
sudo mysql -u root -p'$DB_PASSWORD' -e "create user 'root'@'%' identified with mysql_native_password by '$DB_PASSWORD'"
sudo mysql -u root -p'$DB_PASSWORD' -e "grant all privileges on *.* to 'root'@'%'"
sudo mysql -u root -p'$DB_PASSWORD' -e "FLUSH PRIVILEGES"
sudo mysql -u root -p'$DB_PASSWORD' < /tmp/dumpsql.sql
EOF