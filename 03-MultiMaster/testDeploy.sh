#!/bin/bash

cd 03-MultiMaster/terraform

uri=$(terraform output | grep "k8s-master 1" | awk '{print $6 " " $7 " " $8 " " $9;exit}')

kubectl=$($uri 'sudo kubectl get nodes -o wide | tail -n +2 | grep -v Ready')

echo $kubectl

if [ $kubectl == ""];then 
    echo "::::: Masters e workers UP :::::"
    exit 0
else
    echo "::::: Masters e workers OFFLINE :::::"
    exit 1
fi