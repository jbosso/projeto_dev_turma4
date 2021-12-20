#!/bin/bash

export USER='root'
export PASSWORD=\"$DB_PASSWORD\" 
export DATABASE_URL='mysql://192.168.13.102:3306/SpringWebYoutubeTest?useTimezone=true&serverTimezone=UTC'

echo $USER
echo $PASSWORD
echo $DATABASE_URL

#cd app-code && ./mvnw test