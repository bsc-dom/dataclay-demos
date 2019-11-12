#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
IFS=$'\r\n' GLOBIGNORE='*' command eval  "MACHINES=($(cat $SCRIPTDIR/machines.txt))"

rm -rf $SCRIPTDIR/ca-certs #sanity check

###### CERTIFICATE AUTHORITY ###### 

mkdir -p $SCRIPTDIR/ca-certs
pushd $SCRIPTDIR/ca-certs
echo "Generating self-signed CA..."
openssl genrsa -out dataclay-ca.key 4096
openssl req -x509 -new -nodes -key dataclay-ca.key -subj "/C=ES/ST=CAT/O=BSC/CN=dataclay-ca" -sha256 -days 1024 -out dataclay-ca.crt
popd 

###### HOST CERTIFICATE ###### 
for MACHINE in ${MACHINES[@]}; do	
	rm -rf $SCRIPTDIR/hosts/$MACHINE/certs #sanity check
	mkdir -p $SCRIPTDIR/hosts/$MACHINE/certs
	pushd $SCRIPTDIR/hosts/$MACHINE/certs
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
	pushd $SCRIPTDIR/ca-certs
	echo "CA signs $MACHINE certificate..."
	openssl x509 -req -in $SCRIPTDIR/hosts/$MACHINE/certs/dataclay-agent.csr -CA dataclay-ca.crt -CAkey dataclay-ca.key -CAcreateserial -out $SCRIPTDIR/hosts/$MACHINE/certs/dataclay-agent.crt -days 500 -sha256
	popd
done

###### CERTIFICATE AUTHORITY PROVIDES ITS CERTIFICATE ###### 
for MACHINE in ${MACHINES[@]}; do	
	echo "CA provides certificate to $MACHINE..."
	cp $SCRIPTDIR/ca-certs/dataclay-ca.crt $SCRIPTDIR/hosts/$MACHINE/certs/dataclay-ca.crt
done 

echo ""
echo " ** Generated certificates : ** "
echo ""
for MACHINE in ${MACHINES[@]}; do	
	echo " $MACHINE certificate : "
	cat $SCRIPTDIR/hosts/$MACHINE/certs/dataclay-agent.crt
	echo " $MACHINE Certificate authority: "
	cat $SCRIPTDIR/hosts/$MACHINE/certs/dataclay-ca.crt

	echo ""
done

