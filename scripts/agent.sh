#!/bin/bash
content=$(curl --location --request POST 'https://devnet.saas.appdynamics.com/auth/v1/oauth/token' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'grant_type=client_credentials' --data-urlencode 'client_id=devclient@devnet' --data-urlencode 'client_secret=52961b11-dd9d-42ee-8426-917f4adb8e75' | jq '.access_token')

temp="${content%\"}"
temp="${temp#\"}"
echo "$temp"

download="$(curl --location --request GET 'https://devnet.saas.appdynamics.com/zero/v1beta/install/downloadCommand?javaVersion=latest&machineVersion=latest&infraVersion=latest&zeroVersion=latest&multiline=false' \
--header "Authorization: Bearer ${temp}" --data-raw '')"

install="$(curl --location --request GET "https://devnet.saas.appdynamics.com/zero/v1beta/install/installCommand?sudo=true&multiline=false&application=${1}&accessKey=${2}&serviceUrl=https://devnet.saas.appdynamics.com" \
--header "Authorization: Bearer ${temp}" --data-raw '')"

echo -n "{\"download\":\"${download}\", \"install\":\"${install}\"}"

#END
