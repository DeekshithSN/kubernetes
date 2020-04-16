## Follow  below commands for creating prometheus pod and scrap the data from cluster 

 - Create a Namespace monitoring 
 ``` kubectl create namespace monitoring ```
 
 - Create the role using the following command
 ``` kubectl create -f clusterRole.yaml ```
 
 - Execute the following command to create the config map in Kubernetes
 ``` kubectl create -f config-map.yaml ```
 
 - Create a deployment on monitoring namespace using the above file 
 ``` kubectl create  -f prometheus-deployment.yaml ```
 
 - You can check the created deployment using the following command
 ``` kubectl get deployments --namespace=monitoring ```


## Connecting To Prometheus Dashboard 

- First, get the Prometheus pod name
``` kubectl get pods --namespace=monitoring ```

- Execute the following command with your pod name to access Prometheus from localhost or host-ip port 8080
``` kubectl port-forward prometheus-monitoring-3331088907-hm5n1 8080:9090 -n monitoring ``` ( note replace your pod name )

- Exposing Prometheus as a Service ( if you dont want to use port-forward )
``` kubectl create -f prometheus-service.yaml --namespace=monitoring ```


## General Commands 

- How to set any working namespace
```kubectl config set-context --current --namespace=monitoring```

- How to view the current namespace 
```kubectl config view | grep namespace```
