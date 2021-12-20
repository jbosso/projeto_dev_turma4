#!/bin/bash

cd 05-AppDeploy/ansible

DBPassword=$(echo -n $DB_PASSWORD | base64)

cat <<EOF > k8s-deploy/mysql-secret.yml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
data:
  PASSWORD: $DBPassword
EOF