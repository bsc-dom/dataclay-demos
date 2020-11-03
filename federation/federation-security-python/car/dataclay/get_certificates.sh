#!/bin/sh
set -e
CERTIFICATES_DIR=/ssl/
mkdir -p ${CERTIFICATES_DIR}
if [ -f "${CERTIFICATES_DIR}/dataclay-agent.crt" ]; then
  echo "Certificate already exists!"
  exit 0
fi


echo "Certificate Authority is located at: $CERTIFICATE_AUTHORITY_HOST"

echo "Generating my certificate..."
openssl genrsa -out ${CERTIFICATES_DIR}/dataclay-agent.key 2048
openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt \
  -in ${CERTIFICATES_DIR}/dataclay-agent.key -out ${CERTIFICATES_DIR}/dataclay-agent.pem

echo "Create a sign request"
openssl req -new -sha256 -key ${CERTIFICATES_DIR}/dataclay-agent.key \
  -subj "/C=ES/ST=CAT/O=BSC/CN=proxy" -out ${CERTIFICATES_DIR}/dataclay-agent.csr

echo "Request authority to sign"
printf "{\"csr\":\"%s\"}" "$(cat -A ${CERTIFICATES_DIR}/dataclay-agent.csr)" > ${CERTIFICATES_DIR}/csr_post_request.json
cat ${CERTIFICATES_DIR}/csr_post_request.json
curl --retry 10 --retry-connrefused \
    --header "Content-Type: application/json" --request POST  \
    --data @${CERTIFICATES_DIR}/csr_post_request.json \
    http://${CERTIFICATE_AUTHORITY_HOST}:5000/sign_certificate > result_json.txt

# post process result
cat result_json.txt
jq '.csr' < result_json.txt > ${CERTIFICATES_DIR}/dataclay-agent.crt
sed -i 's/\\n/\n/g' ${CERTIFICATES_DIR}/dataclay-agent.crt
sed -i 's/"//g' ${CERTIFICATES_DIR}/dataclay-agent.crt

echo " ** Signed certificate : ** "
cat ${CERTIFICATES_DIR}/dataclay-agent.crt

echo "Get CA certificate"
curl --header "Content-Type: application/json" --request GET \
  http://$CERTIFICATE_AUTHORITY_HOST:5000/get_certificate_authority > result_json.txt

# post process result
cat result_json.txt
jq '.cert' < result_json.txt > ${CERTIFICATES_DIR}/dataclay-ca.crt
sed -i 's/\\n/\n/g' ${CERTIFICATES_DIR}/dataclay-ca.crt
sed -i 's/"//g' ${CERTIFICATES_DIR}/dataclay-ca.crt

echo " ** CA certificate : ** "
cat ${CERTIFICATES_DIR}/dataclay-ca.crt

