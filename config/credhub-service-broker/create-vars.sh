#!/bin/bash
set -eo pipefail

export SINGLETON_AVAILABILITY_ZONE=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.azs.value[0]')
export AVAILABILITY_ZONES=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.azs.value | map({name: .})' | tr -d '\n' | tr -d '"')
export AVAILABILITY_ZONE_NAMES=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.azs.value' | tr -d '\n' | tr -d '"')
export PAS_MAIN_NETWORK_NAME=pas-deployment
export PAS_SERVICES_NETWORK_NAME=pas-services

cat <<EOF > vars.yml
availability_zone_names: ${AVAILABILITY_ZONE_NAMES}
pas_main_network_name: ${PAS_MAIN_NETWORK_NAME}
pas_services_network_name: ${PAS_SERVICES_NETWORK_NAME}
availability_zones: ${AVAILABILITY_ZONES}
singleton_availability_zone: ${SINGLETON_AVAILABILITY_ZONE}
EOF
