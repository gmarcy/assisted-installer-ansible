#!/usr/bin/env bash

set -o pipefail

app_id=$( ansible-vault view ~/.ssh/.ansible/.secrets/$1 ) # App ID secret name as first argument
pem=$( ansible-vault view ~/.ssh/.ansible/.secrets/$2 ) # private key secret name as second argument

now=$(date +%s)
iat=$((${now} - 60)) # Issues 60 seconds in the past
exp=$((${now} + 600)) # Expires 10 minutes in the future

b64enc() { openssl base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n'; }

header_json='{
    "typ":"JWT",
    "alg":"RS256"
}'
# Header encode
header=$( echo -n "${header_json}" | b64enc )

payload_json='{
    "iat":'"${iat}"',
    "exp":'"${exp}"',
    "iss":'"${app_id}"'
}'
# Payload encode
payload=$( echo -n "${payload_json}" | b64enc )

# Signature
header_payload="${header}"."${payload}"
signature=$( 
    openssl dgst -sha256 -sign <(echo -n "${pem}") \
    <(echo -n "${header_payload}") | b64enc 
)

# Create JWT
JWT="${header_payload}"."${signature}"
printf '%s\n' "$JWT"
