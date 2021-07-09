#!/bin/bash
content=$(curl --location --request POST 'https://devnet.saas.appdynamics.com/auth/v1/oauth/token' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'grant_type=client_credentials' --data-urlencode 'client_id=devclient@devnet' --data-urlencode 'client_secret=52961b11-dd9d-42ee-8426-917f4adb8e75' | jq '.access_token')
echo $content
#END
