#!/bin/bash

declare -A containers

while IFS== read -r key value; do
    containers[$key]=${value}
    C=$(sudo docker run -td -i -d -v /data1/${key//[[:blank:]]/}:/opt/mcrouter -v /proc:/writable-proc --sysctl net.core.somaxconn=4096 --hostname $key --name $key mcrouter:0.36 bash)
    echo $key "Container created:" $C
done < "/opt/Docker_mcrouter/upgrade/containers.txt"
exit
