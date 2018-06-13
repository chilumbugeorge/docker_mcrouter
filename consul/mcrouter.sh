#!/bin/bash
echo `date`
#stat=$(echo "stats" | nc  localhost 5000 > /dev/null 2>&1  && echo "ok" || echo "fail")
C=$(ps -ef |grep mcrouter |grep '5000')
if [[ "$C" != "" ]]; then
    echo "mcrouter is active and running"
    exit 0
else
    echo "mcrouter has been stopped and not running"
    exit 2
fi
