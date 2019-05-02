#!/bin/bash

# Check Variables And Set Defaults
[ "${USERNAME}" == "" ] && echo "Variable USERNAME is a required parameter!" && exit 1
[ "${PASSWORD}" == "" ] && echo "Variable USERNAME is a required parameter!" && exit 1
[ "${DOMAINS}" == "" ] && echo "Variable USERNAME is a required parameter!" && exit 1
INTERVAL=${INTERVAL:-"30"}

# Generate And Load Hashs
expectScriptHash=$(sha256sum "/usr/local/bin/noip2_create.exp" | awk '{print $1}')
currentHash=$(echo "${expectScriptHash}|${USERNAME}|${PASSWORD}|${DOMAINS}|${INTERVAL}" | sha256sum | awk '{print $1}')
[ -f "/config/config.sha256" ] && breadcrumb=$(cat "/config/config.sha256") || breadcrumb=""

# Build noip2 Config If Required.
if [[ "${currentHash}" == "${breadcrumb}" ]]
then
  echo "Settings have not changed, so no need to regenerate the binary config file."
else
  if ! expect "/usr/local/bin/noip2_create.exp" "${USERNAME}" "${PASSWORD}" "${DOMAINS}" "${INTERVAL}"
  then
    echo "Failed to create noip2 configuration file /config/noip2.conf - Exiting."
    exit 2
  fi
  echo -n "$currentHash" > "/config/config.sha256"
fi

# Start noip2

chmod 660 /config/noip2.conf
/usr/bin/noip2 -d -c /config/noip2.conf

# Infinate Loop To Hold Container Running
echo
while true
do
  echo "-----"
  echo
  output=$(/usr/bin/noip2 -c /config/noip2.conf -S 2>&1)
  echo "${output}"
  echo "${output}" | grep "1 noip2 process active" > /dev/null || exit 1
  echo
  ! sleep 60 && exit 1
done
