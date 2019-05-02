#!/bin/bash

## Simple Process Healthcheck For noip2

output=$(/usr/bin/noip2 -c /config/noip2.conf -S 2>&1)
echo "$output" | grep "1 noip2 process active" > /dev/null
