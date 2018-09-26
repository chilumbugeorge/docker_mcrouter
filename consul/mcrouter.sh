#!/bin/bash
P=$(ps -ef |grep mcrouter |grep '5000');
if [[ "$P" != "" ]]; then
    echo "mcrouter is active and running"
    exit 0
else
    echo "mcrouter has stopped and and not running"
    exit 2
fi
