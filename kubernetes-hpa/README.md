##  First we need to setup metric server, follow steps in below post

    https://stackoverflow.com/questions/54106725/docker-kubernetes-mac-autoscaler-unable-to-find-metrics
    https://forum.linuxfoundation.org/discussion/comment/32209 
    
## Formula HPA uses 

   desiredReplicas = ceil[currentReplicas * ( currentMetricValue / desiredMetricValue )]

    
##  Run below commands to HPA
    
    kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
    
##  Run below commands to put load on php-apache pod 

    kubectl run -it --rm load-generator --image=busybox /bin/sh

    while true; do wget -q -O- http://php-apache.default.svc.cluster.local; done


in 1.23 metric-server found at https://github.com/kubernetes-sigs/metrics-server
