#!/bin/sh
###### CERTIFICATE AUTHORITY ######
if [ ! -f "${CERTIFICATE_AUTHORITY_CERT}" ]; then
  echo "Generating self-signed CA..."
  openssl genrsa -out ${CERTIFICATE_AUTHORITY_KEY} ${RSA_KEY_NUMBITS}
  openssl req -x509 -new -nodes -key ${CERTIFICATE_AUTHORITY_KEY} \
    -subj "/C=${COUNTRY}/ST=${STATE}/O=${ORGANIZATION}/CN=${ROOT_CN}" \
    -sha256 -days ${VALID_DAYS} -out ${CERTIFICATE_AUTHORITY_CERT}

  echo "Certificate authority:"
  cat ${CERTIFICATE_AUTHORITY_CERT}
fi

exec flask run

