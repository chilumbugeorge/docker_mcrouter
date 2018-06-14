#!/bin/bash
declare -A containers

while IFS== read -r key value; do
    containers[$key]=${value}
     mc=${key::-2}
     C=$(sudo docker cp /opt/Docker_mcrouter/mcrouter/${mc//[[:blank:]]/}".conf" ${key//[[:blank:]]/}:/etc/mcrouter.conf);
     echo $key ":updated mcrouter.conf"
done < "/opt/Docker_mcrouter/upgrade/containers.txt"

X=$(uuidgen | awk '{print tolower($0)}')
while IFS== read -r key value; do
    containers[$key]=${value}
     S=$(sudo docker exec -t $key sed -i -e 's/00000000-0000-0000-000-00000000/'$X'/g' /etc/init/consul.conf);
     S=$(sudo docker exec -t $key sed -i -e 's/ip_address/'${value//[[:blank:]]/}'/g' /etc/init/consul.conf);
     echo $key ":consul script updated appropriately"
done < "/opt/Docker_mcrouter/upgrade/containers.txt"
printf "\n"

while IFS== read -r key value; do
    containers[$key]=${value}
    service=${key::-2}
    SJ=$(sudo docker exec -t $key sed -i -e 's/mcrouter-name/'${service//[[:blank:]]/}'/g' /etc/consul.d/services.json);
    echo $key ":Consul Service updates appropriately"
done < "/opt/Docker_mcrouter/upgrade/containers.txt"
