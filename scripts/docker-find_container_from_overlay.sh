#!/usr/bin/env bash

# <--- Info ------------------------------------------------------------------>
#
#  Docker related script
#  Uses an overlay as input. Finds the container it belongs to.
#
# <--- George Keramidas ------------------------------------------------------->

if [ -z "$1" ] ; then
    echo "Please specify the overlay as a parameter"
    echo "For example:"
    echo "./find_container_from_overlay.sh 5780b69a60d58d143ea6cd7fcd9ab275e5a854eb730e6ae463bebc897d93a58a"
else
    # User specifies overlay as a parameter
    overlay="$1"
fi

for cont in $(docker ps | awk '{print $1}' | tail -n +2) ; do 
    docker inspect "${cont}" | grep "${overlay}" | grep 'UpperDir' && \
        echo -e "\nThe container details:" && \
            docker ps | grep "${cont}"
done
