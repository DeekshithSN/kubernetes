Useful Links:

How to Install and Configure an NFS Server on Ubuntu 18.04 : https://www.tecmint.com/install-nfs-server-on-ubuntu/
yamls files Ref. : https://github.com/justmeandopensource/kubernetes/tree/master/yamls

NFS Server :

sudo apt update
sudo apt install nfs-kernel-server
sudo mkdir -p /mnt/nfs_share
sudo chown -R nobody:nogroup /mnt/nfs_share/
sudo vim /etc/exports
sudo exportfs -a
sudo systemctl restart nfs-kernel-server

NFS Client :

sudo apt install nfs-common












