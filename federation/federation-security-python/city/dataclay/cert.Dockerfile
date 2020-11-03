FROM alpine:3
RUN apk --no-cache --update add openssl jq curl
## External info
ARG CERTIFICATE_AUTHORITY_HOST=127.0.0.1
ARG CERTIFICATES_DIR=/ssl
ENV CERTIFICATES_DIR=$CERTIFICATES_DIR \
    CERTIFICATE_AUTHORITY_HOST=$CERTIFICATE_AUTHORITY_HOST
# Get certificates from certificate authority
COPY ./get_certificates.sh .
# Run
ENTRYPOINT ["./get_certificates.sh"]

