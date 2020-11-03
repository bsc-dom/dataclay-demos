import os
import tempfile
import uuid
from flask import Flask, request
from logging.config import dictConfig

dictConfig({
    'version': 1,
    'formatters': {'default': {
        'format': '[%(asctime)s] %(levelname)s in %(module)s: %(message)s',
    }},
    'handlers': {'wsgi': {
        'class': 'logging.StreamHandler',
        'stream': 'ext://flask.logging.wsgi_errors_stream',
        'formatter': 'default'
    }},
    'root': {
        'level': 'INFO',
        'handlers': ['wsgi']
    }
})

app = Flask(__name__)

CERTIFICATE_AUTHORITY_CERT=os.getenv("CERTIFICATE_AUTHORITY_CERT")
CERTIFICATE_AUTHORITY_KEY=os.getenv("CERTIFICATE_AUTHORITY_KEY")
VALID_DAYS=int(os.getenv("VALID_DAYS"))
SIGNED_CERTS=os.getenv("SIGNED_CERTS")
SIGN_REQUESTS=os.getenv("SIGN_REQUESTS")

@app.route('/sign_certificate', methods=['POST'])
def sign_certificate():
    csr_json = request.get_json()
    csr = csr_json["csr"]
    cert_id = uuid.uuid4()
    cert_path = f"{SIGNED_CERTS}/{cert_id}.crt"
    csr_path = f"{SIGN_REQUESTS}/{cert_id}.csr"
    csr_file = open(csr_path, "w")
    # in case $ is used instead of \n (see cat -A)
    csr = csr.replace('$','\n')
    app.logger.info("Received sign request: \n %s", csr)
    csr_file.write(csr)
    csr_file.close()

    cmd = f"openssl x509 -req -in {csr_path} -CA {CERTIFICATE_AUTHORITY_CERT} \
        -CAkey {CERTIFICATE_AUTHORITY_KEY} -CAcreateserial -out {cert_path} \
         -days {VALID_DAYS} -sha256"
    app.logger.info("Calling %s", cmd)
    os.system(cmd)
    with open(cert_path, 'r') as cert_file:
        data = cert_file.read()
        return {"csr":data}
    return None

@app.route('/get_certificate_authority', methods=['GET'])
def get_certificate_authority():
    with open(f"{CERTIFICATE_AUTHORITY_CERT}", 'r') as cert_file:
        data = cert_file.read()
        return {"cert":data}
    return None