## Restricting incoming traffic to Pods

First, run a web server application with label app=hello and expose it internally in the cluster:
```
kubectl run hello-web --labels app=hello \
  --image=gcr.io/google-samples/hello-app:1.0 --port 8080 --expose
```
  
  Next, configure a NetworkPolicy to allow traffic to the hello-web Pods from only the app=foo Pods. Other incoming traffic from Pods that do not have this label, external traffic, and traffic from Pods in other namespaces are blocked.

The following manifest selects Pods with label app=hello and specifies an Ingress policy to allow traffic only from Pods with the label app=foo:

```
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: hello-allow-from-foo
spec:
  policyTypes:
  - Ingress
  podSelector:
    matchLabels:
      app: hello
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: foo
 ```
 
 To apply this policy to the cluster, run the following command:
```
kubectl apply -f hello-allow-from-foo.yaml
```

Validate the Ingress policy
First, run a temporary Pod with the label app=foo and get a shell in the Pod:

```
kubectl run -l app=foo --image=alpine --restart=Never --rm -i -t test-1
```

Make a request to the hello-web:8080 endpoint to verify that the incoming traffic is allowed:

```
wget -qO- --timeout=2 http://hello-web:8080
```

Traffic from Pod app=foo to the app=hello Pods is enabled.

Next, run a temporary Pod with a different label (app=other) and get a shell inside the Pod:

```
kubectl run -l app=other --image=alpine --restart=Never --rm -i -t test-1
```

Make the same request to observe that the traffic is not allowed and therefore the request times out, then exit from the Pod shell:

```
wget -qO- --timeout=2 http://hello-web:8080
```

-------------------------------

## Restricting outgoing traffic from the Pods

The following manifest specifies a network policy controlling the egress traffic from Pods with label app=foo with two allowed destinations:

- Pods in the same namespace with the label app=hello.
- Cluster Pods or external endpoints on port 53 (UDP and TCP).

```
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: foo-allow-to-hello
spec:
  policyTypes:
  - Egress
  podSelector:
    matchLabels:
      app: foo
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: hello
  - ports:
    - port: 53
      protocol: TCP
    - port: 53
      protocol: UDP
```

To apply this policy to the cluster, run the following command:

```
kubectl apply -f foo-allow-to-hello.yaml
```

Validate the egress policy

First, deploy a new web application called hello-web-2 and expose it internally in the cluster:

```
kubectl run hello-web-2 --labels app=hello-2 \
  --image=gcr.io/google-samples/hello-app:1.0 --port 8080 --expose
```
Next, run a temporary Pod with the label app=foo and open a shell inside the container:

```
kubectl run -l app=foo --image=alpine --rm -i -t --restart=Never test-3
```

Validate that the Pod can establish connections to hello-web:8080:

```
wget -qO- --timeout=2 http://hello-web:8080
```

Validate that the Pod cannot establish connections to hello-web-2:8080:

```
wget -qO- --timeout=2 http://hello-web-2:8080
```
-------------------------------------


