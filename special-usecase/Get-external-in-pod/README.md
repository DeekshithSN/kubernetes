kubectl run nginx-cline --image=nginx -i -t --rm --restart=Never --\
  bash -ic "while sleep 1; do curl http://nginxsvc; done"


```
kubectl api-resources
kubectl api-versions
```
