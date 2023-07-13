#!/bin/sh

##############################
# Script to deploy nginx pod
##############################


# get eks nodes
echo "attempting to connect kubectl to the eks cluster"
kubectl get nodes

# if nodes exist, deploy nginx app to eks cluster
if [ $? -ne 0 ]
then
   echo "kubectl cannot connect to the eks cluster"
   exit 1
else
   echo  "nginx pods is ready for deployment"
   kubectl deploy -f "../k8s/nginx.yml"
   kubectl get pods -n default -o wide
fi


 