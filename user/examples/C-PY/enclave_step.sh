#!/bin/bash

start_server="./server/attestation_service server/provisioning_key"

### Start gramine's secret_provisioning_server on port 4433 ###
RA_TLS_ALLOW_DEBUG_ENCLAVE_INSECURE=1 RA_TLS_ALLOW_OUTDATED_TCB_INSECURE=1 $start_server &

### save attestation service pid ###
SERVER_PID=$!

#process_label=$(head -n 1 process_label.txt)
ssh -q ${CSP_SERVER} bash <<-EOF
	echo -e "\n### Connected to CSP server ###\n"
	cd ${CSP_PATH}
	./gramine.sh
	exit
EOF
echo -e "\n### Disconnected from CSP server ### \n"

kill ${SERVER_PID}