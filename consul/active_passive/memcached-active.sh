#!/bin/bash
nc -z 127.0.0.1 11211
echo `date`
if [ "$?" -ne 0 ]; then
    curl -s --upload-file /etc/consul.d/scripts/inactive.json http://127.0.0.1:8500/v1/agent/service/register
    echo "Cannot connect to memcached."
    exit 2
else
    stat=$(service memcached status | grep "running");
    if [[ "$stat" != *"* memcached is running"* ]]; then
        curl -s --upload-file /etc/consul.d/scripts/inactive.json http://127.0.0.1:8500/v1/agent/service/register
        echo "memcached has been stopped and not running"
        exit 2
    else
        curl -s --upload-file /etc/consul.d/scripts/active.json http://127.0.0.1:8500/v1/agent/service/register
        echo "memcached is active and running"
        exit 0
    fi
fi
