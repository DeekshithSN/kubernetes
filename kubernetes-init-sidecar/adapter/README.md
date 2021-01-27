## Execute below commands to replicate the scenario 

  - kubectl exec -it webserver bash
  - apt update && apt install curl -y
  - curl localhost/nginx_status
  - curl localhost:9113/metrics
  
for more details refer https://www.magalix.com/blog/the-adapter-pattern
