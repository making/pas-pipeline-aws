#!/bin/bash
# http://docs.pivotal.io/platform-automation/v2.1/configuration-management/configure-env.html

set -eo pipefail
export OM_TARGET=$(terraform output --state=${TERRAFORM_STATE:-terraform-state}/terraform.tfstate ops_manager_dns)
cat <<EOF
target: ${OM_TARGET}
connect-timeout: 5
request-timeout: 1800
skip-ssl-validation: true
username: ${OM_USERNAME}
password: ${OM_PASSWORD}
decryption-passphrase: ${OM_DECRYPTION_PASSPHRASE}
EOF