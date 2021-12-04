# Install wrk for load testing ( very light weight load testing utility )

apk add --no-cache wrk

# simulate some load
wrk -c 5 -t 5 -d 99999 -H "Connection: Close" http://application-cpu
