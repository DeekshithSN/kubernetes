# Basic troubleshooting techniques

## Chapter Goals
1. Kubernetes Techniques
2. Looking at Log files
3. Executing commands in a container

### Overview
Sometimes things don't work as they should in your deployments, and you'd like to take a closer look to debug issues or understand what's going on. There are 3 techniques I use from a day to day basis when I work with kubernetes. Let me show you what these are.

### Kubernetes Techniques
When things are not deploying as expected, or things seem to be taking a while, I describe the deployments and pods associated with the deployments to look for errors.

Let's run the helloworld application that is bundled with this section by typing `kubectl create -f helloworld-with-bad-pod.yaml`.

As it's starting up, we can run a `kubectl get deployments` and a `kubectl describe deployment bad-helloworld-deployment`.

We notice that we have 0 available pods in the deployment that signals that there is something going on with the pod.

If we introspect pods with a `kubectl get pods`, we see that the `bad-helloworld-deployment` pod is in an image pull backoff state and isn't ready.

Describing the pod with `kubectl describe pod bad-helloworld-deployment-7bb4b7466-f6nkm`, will show me that kubernetes is having trouble pull the pod from the repository, either because it doesn't exist, or because we're missing the repository credentials.

### Looking at log files
Another technique I end up using a lot to track pod progress is looking at the log files for a pod. If you write your logs to standard out, you can get to them by the command `kubectl logs <pod_name>`. This will return the log statements that are being written by your application in the pod.

### Executing commands in a container
Finally, sometimes it is necessary to exec into the actual container running the pod to look for errors, or state. To do this, run the exec command `kubectl exec -it <pod-name> -c <container-name> /bin/bash` where -it is an interactive terminal and -c is the flag to specify the container name. Finally we want a bash style terminal.

This drops us into the container, and we can introspect into the details of our application.
