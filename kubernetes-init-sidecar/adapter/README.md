## Execute below commands to replicate the scenario 

  - kubectl exec -it webserver bashbash
  - apt update && apt install curl -y
  - curl localhost/nginx_status
  - curl localhost:9113/metrics
  
