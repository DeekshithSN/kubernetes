kubectl -n kube-system create rolebinding premissive-rolebinding --clusterrole=permissive-cr --group=system:authenticated

kubectl -n psp-test create rolebinding restrictive-rolebinding --clusterrole=restrictive-cr --group=system:authenticated


After which update the configs in /etc/kubernetes/manifests/kube-apiserver.yaml

```
add PodSecurityPolicy , in the line  - --enable-admission-plugins=NodeRestriction

```
