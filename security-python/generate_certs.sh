#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
IFS=$'\r\n' GLOBIGNORE='*' command eval  "MACHINES=($(cat $SCRIPTDIR/machines.txt))"

rm -rf $SCRIPTDIR/ca-certs #sanity check
rm -rf $SCRIPTDIR/dataclay/certs #sanity check

###### CERTIFICATE AUTHORITY ###### 

pushd $SCRIPTDIR/app/ca-certs
echo "Generating self-signed CA..."
openssl genrsa -out dataclay-ca.key 4096
openssl req -x509 -new -nodes -key dataclay-ca.key -subj "/C=ES/ST=CAT/O=BSC/CN=dataclay-ca" -sha256 -days 1024 -out dataclay-ca.crt

###### HOST CERTIFICATE ###### 
for MACHINE in ${MACHINES[@]}; do	
	rm -rf $SCRIPTDIR/app/certs #sanity check
	mkdir -p $SCRIPTDIR/app/$MACHINE/certs
	pushd $SCRIPTDIR/app/$MACHINE/certs
	# NOTE: we use dataclay-agent name in certificates to not modify dataclay/prop/global.properties per each machine
	echo "Generating $MACHINE certificate..."
	openssl genrsa -out dataclay-agent.key 2048
	openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in dataclay-agent.key -out dataclay-agent.pem
	echo "${MACHINE} create a sign request" 
	openssl req -new -sha256 -key dataclay-agent.key -subj "/C=ES/ST=CAT/O=BSC/CN=$MACHINE" -out dataclay-agent.csr
	popd 
done 

###### CERTIFICATE AUTHORITY SIGNS ALL CERTIFICATES ###### 
for MACHINE in ${MACHINES[@]}; do	
	pushd $SCRIPTDIR/app/ca-certs
	echo "CA signs $MACHINE certificate..."
	openssl x509 -req -in $SCRIPTDIR/app/$MACHINE/certs/dataclay-agent.csr -CA dataclay-ca.crt -CAkey dataclay-ca.key -CAcreateserial -out $SCRIPTDIR/app/$MACHINE/certs/dataclay-agent.crt -days 500 -sha256
	popd
done