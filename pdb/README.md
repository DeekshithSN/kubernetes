# follow below steps to replicate 

to know more about PodDisruptionBudget refer - 

## kubectl get all
```
NAME                                READY   STATUS    RESTARTS   AGE
pod/nginx-deploy-598b589c46-4p4gj   1/1     Running   0          5s
pod/nginx-deploy-598b589c46-5jdz9   1/1     Running   0          5s
pod/nginx-deploy-598b589c46-nzbpg   1/1     Running   0          5s
pod/nginx-deploy-598b589c46-x7xmf   1/1     Running   0          5s
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   20d
NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-deploy   4/4     4            4           5s
NAME                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-deploy-598b589c46   4         4         4       5s
```
## kubectl get pdb
```
NAME      MIN AVAILABLE   MAX UNAVAILABLE   ALLOWED DISRUPTIONS   AGE
pdbdemo   2               N/A               2                     13s
```
## kubectl get nodes 
```
NAME          STATUS   ROLES                  AGE   VERSION
kube-master   Ready    control-plane,master   20d   v1.20.1
kube-node-1   Ready    <none>                 20d   v1.20.1
```
## kubectl drain kube-node-1 --ignore-daemonsets
```
node/kube-node-1 cordoned
WARNING: ignoring DaemonSet-managed Pods: kube-system/kube-flannel-ds-amd64-xqr7d, kube-system/kube-proxy-p9snx
evicting pod default/nginx-deploy-598b589c46-5jdz9
evicting pod default/nginx-deploy-598b589c46-x7xmf
evicting pod default/nginx-deploy-598b589c46-4p4gj
evicting pod default/nginx-deploy-598b589c46-nzbpg
error when evicting pods/"nginx-deploy-598b589c46-x7xmf" -n "default" (will retry after 5s): Cannot evict pod as it would violate the pod's disruption budget.
error when evicting pods/"nginx-deploy-598b589c46-4p4gj" -n "default" (will retry after 5s): Cannot evict pod as it would violate the pod's disruption budget.
evicting pod default/nginx-deploy-598b589c46-x7xmf
error when evicting pods/"nginx-deploy-598b589c46-x7xmf" -n "default" (will retry after 5s): Cannot evict pod as it would violate the pod's disruption budget.
evicting pod default/nginx-deploy-598b589c46-4p4gj
error when evicting pods/"nginx-deploy-598b589c46-4p4gj" -n "default" (will retry after 5s): Cannot evict pod as it would violate the pod's disruption budget.
```
## kubectl get nodes
```
NAME          STATUS                     ROLES                  AGE   VERSION
kube-master   Ready                      control-plane,master   20d   v1.20.1
kube-node-1   Ready,SchedulingDisabled   <none>                 20d   v1.20.1
```
## kubectl get po
```
NAME                                READY   STATUS    RESTARTS   AGE
pod/nginx-deploy-598b589c46-4p4gj   1/1     Running   0          82s
pod/nginx-deploy-598b589c46-84lc6   0/1     Pending   0          24s
pod/nginx-deploy-598b589c46-gw9jm   0/1     Pending   0          24s
pod/nginx-deploy-598b589c46-x7xmf   1/1     Running   0          82s
```
## kubectl uncordon kube-node-1
```
node/kube-node-1 uncordoned
```
## kubectl get nodes
```
NAME          STATUS   ROLES                  AGE   VERSION
kube-master   Ready    control-plane,master   20d   v1.20.1
kube-node-1   Ready    <none>                 20d   v1.20.1
```
## kubectl get pods 
```
NAME                            READY   STATUS    RESTARTS   AGE
nginx-deploy-598b589c46-4p4gj   1/1     Running   0          2m25s
nginx-deploy-598b589c46-84lc6   1/1     Running   0          87s
nginx-deploy-598b589c46-gw9jm   1/1     Running   0          87s
nginx-deploy-598b589c46-x7xmf   1/1     Running   0          2m25s
```
