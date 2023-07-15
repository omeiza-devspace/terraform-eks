#!/bin/sh

########################################
# Date: July 14, 2023
# Author: Omeiza O. 
#
# Script to create nginx app deployment 
########################################


# get eks nodes
echo "attempting to get nodes from the eks cluster"
kubectl get nodes

# if nodes exist, deploy nginx app to eks cluster
if [ $? -ne 0 ]
then
   echo "kubectl cannot connect to the eks cluster"
   exit 1
else
   echo  "nginx is ready for setup"
   kubectl apply -f "./k8s/deployment.yml"  
   kubectl apply -f "./k8s/service.yml"  
   kubectl get pods -o wide 
fi
