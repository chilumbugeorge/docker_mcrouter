#!/bin/bash
nc -z 127.0.0.1 5000
echo `date`
stat=$(echo "stats" | nc  localhost 5000 > /dev/null 2>&1  && echo "ok" || echo "fail")
if [[ "$stat" != *"ok"* ]]; then
    echo "mcrouter has been stopped and not running"
    exit 2
else
    echo "mcrouter is active and running"
    exit 0
fi
