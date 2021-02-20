# If you want to use gcp disk as your voulme type before creating pv or pvc follow below steps 


**Assumptions**
- kuberenetes installation type is kubeadm 

### steps 

- The Kubernetes cloud-config file needs to be configured. The file can be found at /etc/kubernetes/cloud-config and the following content is enough to get the cloud provider to work and if file is not present create the same. file should be configured in all the nodes:

```
[Global]
project-id = "<google-project-id>"
```
to get project id, In gcp portal click on select project dropdown you will be able to see the project id 




### if you dont follow, you might end up with below error 

![20](https://user-images.githubusercontent.com/29688323/108596039-69b37280-73a8-11eb-9dd8-9f689a85e6c2.JPG)
