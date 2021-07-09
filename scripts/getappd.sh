#!/bin/bash


function parse_input() {
  # jq reads from stdin so we don't have to set up any inputs, but let's validate the outputs
  eval "$(jq -r '@sh "export APP_NAME=\(.appname)  ACC_KEY=\(.accesskey) JVER=\(.jver)"')"
  if [[ -z "${APP_NAME}" ]]; then export APP_NAME=none; fi
  if [[ -z "${ACC_KEY}" ]]; then export ACC_KEY=none; fi
  if [[ -z "${JVER}" ]]; then export JVER=none; fi
}








#function parse_input() {
  # jq reads from stdin so we don't have to set up any inputs, but let's validate the outputs
#  eval "$(jq -r '@sh "export APP_NAME=\(.appname) ACC_KEY=\(.accesskey)"')"
  #eval "$(jq -r '@sh "export APP_NAME=\(.appname) ACC_KEY=\(.accesskey) CL_SECRT=\(.clsecrt) JAVA_VER=\(.javaver)"')"
#  if [[ -z "${APP_NAME}" ]]; then export APP_NAME=none; fi
#  if [[ -z "${ACC_KEY}" ]]; then export ACC_KEY=none; fi
#  if [[ -z "${CL_SECRT}" ]]; then export CL_SECRT=none; fi
#  if [[ -z "${JAVA_VER}" ]]; then export JAVA_VER=none; fi
#}

parse_input

#content=$(curl -s --location --request POST 'https://devnet.saas.appdynamics.com/auth/v1/oauth/token' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'grant_type=client_credentials' --data-urlencode 'client_id=devclient@devnet' --data-urlencode 'client_secret=${CL_SECRT}' | jq '.access_token') 
content=$(curl -s --location --request POST 'https://devnet.saas.appdynamics.com/auth/v1/oauth/token' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'grant_type=client_credentials' --data-urlencode 'client_id=devclient@devnet' --data-urlencode 'client_secret=52961b11-dd9d-42ee-8426-917f4adb8e75' | jq '.access_token') 

temp="${content%\"}"
temp="${temp#\"}"
#echo "$temp"

#download="$(curl -s --location --request GET 'https://devnet.saas.appdynamics.com/zero/v1beta/install/downloadCommand?javaVersion=latest&machineVersion=latest&infraVersion=latest&zeroVersion=latest&multiline=false' \
download="$(curl -s --location --request GET "https://devnet.saas.appdynamics.com/zero/v1beta/install/downloadCommand?javaVersion=${JVER}&machineVersion=latest&infraVersion=latest&zeroVersion=latest&multiline=false" \
--header "Authorization: Bearer ${temp}" --data-raw '')"

#install="$(curl -s --location --request GET "https://devnet.saas.appdynamics.com/zero/v1beta/install/installCommand?sudo=true&multiline=false&application="yyy"&accessKey="yyy"&serviceUrl=https://devnet.saas.appdynamics.com" \
#--header "Authorization: Bearer ${temp}" --data-raw '')"


install="$(curl -s --location --request GET "https://devnet.saas.appdynamics.com/zero/v1beta/install/installCommand?sudo=true&multiline=false&application=${APP_NAME}&accessKey=${ACC_KEY}&serviceUrl=https://devnet.saas.appdynamics.com" \
--header "Authorization: Bearer ${temp}" --data-raw '')"


#echo -n "{\"download\":\"testing\", \"install\":\"testing2\"}"
echo -n "{\"download\":${download}, \"install\":${install}}" | tr -d ']['


#echo
#echo "WITHOUT"
#echo $download | tr -d ']['
#END
