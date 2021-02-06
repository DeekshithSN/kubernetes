First lets create namespace with name jenkins 
```
kubectl create ns jenkins
```

Now lets set namespace to jenkins by below command 
```
kubectl config view | grep namespace
kubectl config set-context --current --namespace=jenkins
```

Then apply deploymet and service which are present in master folder, if you want persistent jenkins use files present in master-Persistent
```
kubectl apply -f .
```

check jenkins-master pod is up and running or not 
```
NAME                                            READY   STATUS    RESTARTS   AGE   IP            NODE          NOMINATED NODE   READINESS GATES
pod/jenkins-master-deployment-b8cf57cdc-4cxhk   1/1     Running   0          12m   10.244.1.20   kube-node-1   <none>           <none>

NAME                             TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)                        AGE   SELECTOR
service/jenkins-master-service   NodePort   10.96.78.113   <none>        80:32147/TCP,50000:30930/TCP   12m   app=jenkins-master,group=jenkins,version=latest

NAME                                        READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS       IMAGES                              SELECTOR
deployment.apps/jenkins-master-deployment   1/1     1            1           12m   jenkins-master   deekshithsn/jenkinskubernetes:4.0   app=jenkins-master,group=jenkins,version=latest

NAME                                                  DESIRED   CURRENT   READY   AGE   CONTAINERS       IMAGES                              SELECTOR
replicaset.apps/jenkins-master-deployment-b8cf57cdc   1         1         1       12m   jenkins-master   deekshithsn/jenkinskubernetes:4.0   app=jenkins-master,group=jenkins,pod-template-hash=b8cf57cdc,version=latest
```

as you can see jenkins-master pod is running on kube-node-1 so to access jenkins get node ip and service port in my case it is 32147
```
http://kube-node-1_ip:service_port
```

Once after jenkins up and running, navigate to Manage Jenkins --> Configure System ( make sure usage set to only build jobs with label expresions matching this node ) --> cloud 

