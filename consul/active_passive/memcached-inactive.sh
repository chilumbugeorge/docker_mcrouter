#!/bin/bash
nc -z 127.0.0.1 11211
echo `date`
A=$(echo "stats" | nc  10.1.4.249 11211 > /dev/null 2>&1  && echo "ok" || echo "fail");

if [[ "$A" != *"ok"* ]]; then
    curl -s --upload-file /etc/consul.d/scripts/active.json http://127.0.0.1:8500/v1/agent/service/register
    echo "memcached-test-1 is down. memcached-test-2 is now active."
    exit 0
else    
     curl -s --upload-file /etc/consul.d/scripts/inactive.json http://127.0.0.1:8500/v1/agent/service/register
     echo "memcached-test-1 is Active. memcached-test-2 is in passive mode."
     exit 0
fi
if [ "$?" -ne 0 ]; then
    echo "Cannot connect to memcached."
    exit 2
else
    stat=$(service memcached status | grep "running");
    if [[ "$stat" != *"* memcached is running"* ]]; then
        echo "memcached has been stopped and not running"
        exit 2
    else
        echo "memcached is up and running"
        exit 0
    fi
fi
