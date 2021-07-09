#!/bin/bash
echo $1 $2 $3
install="$(curl --location --request GET "https://devnet.saas.appdynamics.com/zero/v1beta/install/installCommand?sudo=true&multiline=false&application=${2}&accessKey=${3}&serviceUrl=https://devnet.saas.appdynamics.com" \
--header "Authorization: Bearer ${1}" --data-raw '')"
echo $install


#END
