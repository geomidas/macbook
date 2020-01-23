#!/usr/bin/env bash

# <--- Info ------------------------------------------------------------------>
#
#      Stops all containers
#      Removes all containers
#      Removes all volumes
#      Removes all networks
#
# <--- George Keramidas ------------------------------------------------------->

for container in $(docker ps -qa) ; do 
    docker stop $container
    docker rm $container ; 
done
docker volume rm $(docker volume ls -q) 2>/dev/null
docker network rm $(docker network ls -q) 2>/dev/null
