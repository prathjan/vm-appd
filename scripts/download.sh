#!/bin/bash
echo $1
download="$(curl --location --request GET 'https://devnet.saas.appdynamics.com/zero/v1beta/install/downloadCommand?javaVersion=latest&machineVersion=latest&infraVersion=latest&zeroVersion=latest&multiline=false' \
--header "Authorization: Bearer ${1}" --data-raw '')"
echo $download

#END
