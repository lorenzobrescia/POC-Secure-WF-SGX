#!/bin/bash

ssh -q ${CSP_SERVER} bash <<-EOF
cd ${CSP_PATH}
echo -e "\nStart cleaning CSP machine..."
./clean.sh
echo -e "CSP machine: cleaning done"
exit
EOF