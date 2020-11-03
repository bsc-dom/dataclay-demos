FROM python:3-alpine

# default variables
ARG COUNTRY="ES"
ARG STATE="CAT"
ARG LOCATION="Barcelona"
ARG ORGANIZATION="BSC"
ARG ROOT_CN="dataclay-ca"
ARG RSA_KEY_NUMBITS="4096"
ARG VALID_DAYS="365"
ARG CERTIFICATE_AUTHORITY_CERT="/certificate-authority/certificates/dataclay-ca.crt"
ARG CERTIFICATE_AUTHORITY_KEY="/certificate-authority/certificates/dataclay-ca.key"
ARG SIGNED_CERTS="/certificate-authority/signed_certificates/"
ARG SIGN_REQUESTS="/certificate-authority/sign_requests/"

ENV COUNTRY=$COUNTRY \
    STATE=$STATE \
    LOCATION=$LOCATION \
    ORGANIZATION=$ORGANIZATION \
    ROOT_CN=$ROOT_CN \
    RSA_KEY_NUMBITS=$RSA_KEY_NUMBITS \
    VALID_DAYS=$VALID_DAYS \
    CERTIFICATE_AUTHORITY_CERT=$CERTIFICATE_AUTHORITY_CERT \
    CERTIFICATE_AUTHORITY_KEY=$CERTIFICATE_AUTHORITY_KEY \
    SIGNED_CERTS=$SIGNED_CERTS \
    SIGN_REQUESTS=$SIGN_REQUESTS

# install openssl
RUN apk add --update --no-cache openssl gcc musl-dev linux-headers

RUN mkdir -p /certificate-authority/certificates
RUN mkdir -p ${SIGNED_CERTS}
RUN mkdir -p ${SIGN_REQUESTS}
WORKDIR /certificate-authority

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
COPY entrypoint.sh entrypoint.sh
COPY app.py app.py

EXPOSE 5000

ENTRYPOINT ["./entrypoint.sh"]
