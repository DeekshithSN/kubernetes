- kubectl taint nodes node1 dedicated=devs:NoSchedule
- kubectl taint nodes node-2 dedicated=tests:NoSchedule

- kubectl label nodes node1 dedicated=devs
- kubectl label nodes node-2 dedicated=devs
