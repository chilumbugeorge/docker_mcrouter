#!/bin/bash
declare -A containers

while IFS== read -r key value; do
    containers[$key]=${value}
    M=$(sudo docker top $key | grep mcrouter | awk '{print $2}'| cut -d. -f1,2,3,4|sort -u);
#    X=$(sudo docker top $key | grep memcached_exporter | awk '{print $2}'| cut -d. -f1,2,3,4|sort -u);
    KM=$(sudo kill $M);
 #   KX=$(sudo kill $X);
    echo -e $key " MCROUTER  pid $M Killed [Ok]";
  #  echo -e $key " REDIS_EXPORTER  pid $X Killed [Ok]";
    printf "\n"
done < "/opt/Docker_mcrouter/upgrade/containers.txt"
exit
