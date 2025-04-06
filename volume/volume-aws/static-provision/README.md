1. create voulume in aws ( imp: zone node --> ebs mapping )

```
aws ec2 create-volume \
  --availability-zone us-east-1c \
  --size 10 \
  --volume-type gp2 \
  --tag-specifications 'ResourceType=volume,Tags=[{Key=Name,Value=eks-static-volume}]'
```

2. Add ebs-csi addon to eks cluster 

3. add below permission to eks nodes 

```
"ec2:AttachVolume",
"ec2:DetachVolume",
"ec2:DescribeVolumes",
"ec2:DescribeInstances"
```