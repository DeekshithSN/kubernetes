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

# ALLOW traffic from some pods in another namespace

Since Kubernetes v1.11, it is possible to combine `podSelector` and `namespaceSelector`
with an `AND` (intersection) operation.

:warning: This feature is available on Kubernetes v1.11 or after.  Most networking
plugins do not yet support this feature. Make sure to test this policy after you
deploy it to make sure it is working correctly.

## Example

Start a `web` application:

    kubectl run --generator=run-pod/v1 web --image=nginx \
        --labels=app=web --expose --port 80

Create a `other` namespace and label it:

    kubectl create namespace other
    kubectl label namespace/other team=operations

The following manifest restricts traffic to only pods with label `type=monitoring` in namespaces labelled `team=operations`. Save it to `web-allow-all-ns-monitoring.yaml` and apply to the cluster:

```yaml
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: web-allow-all-ns-monitoring
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: web
  ingress:
    - from:
      - namespaceSelector:     # chooses all pods in namespaces labelled with team=operations
          matchLabels:
            team: operations  
        podSelector:           # chooses pods with type=monitoring
          matchLabels:
            type: monitoring
```

```sh
$ kubectl apply -f web-allow-all-ns-monitoring.yaml
networkpolicy.networking.k8s.io/web-allow-all-ns-monitoring created
```

## Try it out

Query this web server from `default` namespace, *without* labelling the application `type=monitoring`, observe it is **blocked**:

```sh
$ kubectl run --generator=run-pod/v1 test-$RANDOM --rm -i -t --image=alpine -- sh
If you don't see a command prompt, try pressing enter.
/ # wget -qO- --timeout=2 http://web.default
wget: download timed out

(traffic blocked)
```

Query this web server from `default` namespace, labelling the application `type=monitoring`, observe it is **blocked**:

```sh
kubectl run --generator=run-pod/v1 test-$RANDOM --labels type=monitoring --rm -i -t --image=alpine -- sh
If you don't see a command prompt, try pressing enter.
/ # wget -qO- --timeout=2 http://web.default
wget: download timed out

(traffic blocked)
```

Query this web server from `other` namespace, *without* labelling the application `type=monitoring`, observe it is **blocked**:

```sh
$ kubectl run --generator=run-pod/v1 test-$RANDOM --namespace=other --rm -i -t --image=alpine -- sh
If you don't see a command prompt, try pressing enter.
/ # wget -qO- --timeout=2 http://web.default
wget: download timed out

(traffic blocked)
```

Query this web server from `other` namespace, labelling the application `type=monitoring`, observe it is **allowed**:

```sh
kubectl run --generator=run-pod/v1 test-$RANDOM --namespace=other --labels type=monitoring --rm -i -t --image=alpine -- sh
If you don't see a command prompt, try pressing enter.
/ # wget -qO- --timeout=2 http://web.default
<!DOCTYPE html>
<html>
<head>
...
(traffic allowed)
```

## Cleanup

    kubectl delete networkpolicy web-allow-all-ns-monitoring
    kubectl delete namespace other
    kubectl delete pod web
    kubectl delete service web
-------------------------------------------------
## ALLOW traffic from some pods or from another namespace

change network policy as below 

```yaml
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: web-allow-all-ns-monitoring
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: web
  ingress:
    - from:
      - namespaceSelector:     # chooses all pods in namespaces labelled with team=operations
          matchLabels:
            team: operations  
      - podSelector:           # chooses pods with type=monitoring
          matchLabels:
            type: monitoring
```

now any pod has label monitoring  or pods in namespace labeled operations will be accesable ( basically its a or operation )

---------------------------------------------



```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - ipBlock:
        cidr: 172.17.0.0/16
        except:
        - 172.17.1.0/24
    - namespaceSelector:
        matchLabels:
          project: myproject
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - protocol: TCP
      port: 6379
  egress:
  - to:
    - ipBlock:
        cidr: 10.0.0.0/24
    ports:
    - protocol: TCP
      port: 5978
```
