Useful Links:

How to Install and Configure an NFS Server on Ubuntu 18.04 : https://www.tecmint.com/install-nfs-server-on-ubuntu/

## NFS Server :

```
- sudo apt update
- sudo apt install nfs-kernel-server
- sudo mkdir -p /mnt/nfs_share
- sudo chown -R nobody:nogroup /mnt/nfs_share/
- sudo vim /etc/exports
- insert this content to /etc/exports 
    /mnt/nfs_share  *(rw,sync,no_subtree_check)
  if you face any security issues then use below content 
   /mnt/nfs_share  *(rw,sync,no_subtree_check,insecure)
- sudo exportfs -a
- to check exports 
     sudo exportfs -v or showmount -e 
- sudo systemctl restart nfs-kernel-server
```
## NFS Client ( in worker nodes ) :

```
- sudo apt install nfs-common
- showmount -e nfs-server-ip
- To verify the mount 
    mount -t nfs ipaddress:/mnt/nfs_share/ /mnt
    mount | grep nfs_share
    umount /mnt

```










