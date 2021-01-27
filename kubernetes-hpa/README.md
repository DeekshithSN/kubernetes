##  First we need to setup metric server, follow steps in below post

    https://stackoverflow.com/questions/54106725/docker-kubernetes-mac-autoscaler-unable-to-find-metrics
    
##  Run below commands to HPA
    
    kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
    
##  Run below commands to put load on php-apache pod 

    kubectl run --generator=run-pod/v1 -it --rm load-generator --image=busybox /bin/sh

    while true; do wget -q -O- http://php-apache.default.svc.cluster.local; done
