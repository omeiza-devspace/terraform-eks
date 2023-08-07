#!/bin/sh

########################################
# Date: July 14, 2023
# Author: Omeiza O. 
#
# Script to create nginx app deployment 
# Setup external dns
########################################

NGINX_NS="default"
FILE_DIR="./k8s"
DOMAIN="nginx.mydevcloud.local"  #private domain

# get eks nodes
echo "attempting to get nodes from the eks cluster"
kubectl get nodes

# if nodes exist, deploy nginx app to eks cluster
if [ $? -ne 0 ]
then

   echo "kubectl cannot connect to the eks cluster"
   exit 1

else

   echo  "############## app is ready for setup ##############"

   kubectl get namespaces | grep -q $NGINX_NS || kubectl create namespace ${NGINX_NS:-"default"}

   kubectl create -f "$FILE_DIR/" -n ${NGINX_NS:-"default"}

   ############## Test result on installations ##############

   echo  "############## Testing deployment service and dns ##############"

   kubectl get all -n ${NGINX_NS:-"default"} -o wide
fi

