#!/bin/sh

# <--- Info ------------------------------------------------------------------>
#
#     Remove all docker stuff from a rancher installation
#
# <--- George Keramidas ------------------------------------------------------->

# check if the user has root priviledges
if [ "$(id -u)" -ne 0 ] ; then
    echo "Error:   You must be root to run this script."
    exit
fi
docker rm -f "$(docker ps -qa)"
docker volume rm "$(docker volume ls -q)"
cleanupdirs="/var/lib/etcd /etc/kubernetes /etc/cni /opt/cni /var/lib/cni /var/run/calico /opt/rke"
for dir in $cleanupdirs; do
  echo "Removing $dir"
  rm -rf $dir
done
