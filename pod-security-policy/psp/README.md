kubectl -n kube-system create rolebinding premissive-rolebinding --clusterrole=permissive-cr --group=system:authenticated

kubectl -n psp-test create rolebinding restrictive-rolebinding --clusterrole=restrictive-cr --group=system:authenticated
