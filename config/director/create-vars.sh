#!/bin/bash
set -eo pipefail

export ACCESS_KEY_ID=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.ops_manager_iam_user_access_key.value')
export SECRET_ACCESS_KEY=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.ops_manager_iam_user_secret_key.value')
export SECURITY_GROUP=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.vms_security_group_id.value')
export KEY_PAIR_NAME=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.ops_manager_ssh_public_key_name.value')
export SSH_PRIVATE_KEY=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.ops_manager_ssh_private_key.value' | sed 's/^/  /')
export REGION=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.region.value')
## Director
export OPS_MANAGER_BUCKET=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.ops_manager_bucket.value')
export OM_TRUSTED_CERTS=$(echo "$OM_TRUSTED_CERTS" | sed 's/^/  /')
## Networks
export AVAILABILITY_ZONES=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.azs.value | map({name: .})' | tr -d '\n' | tr -d '"')
export INFRASTRUCTURE_NETWORK_NAME=pas-infrastructure
export INFRASTRUCTURE_IAAS_IDENTIFIER_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_ids.value[0]')
export INFRASTRUCTURE_NETWORK_CIDR_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_cidrs.value[0]')
export INFRASTRUCTURE_RESERVED_IP_RANGES_0=$(echo $INFRASTRUCTURE_NETWORK_CIDR_0 | sed 's|0/28$|0|g')-$(echo $INFRASTRUCTURE_NETWORK_CIDR_0 | sed 's|0/28$|4|g')
export INFRASTRUCTURE_DNS_0=10.0.0.2
export INFRASTRUCTURE_GATEWAY_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_gateways.value[0]')
export INFRASTRUCTURE_AVAILABILITY_ZONES_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_availability_zones.value[0]')
export INFRASTRUCTURE_IAAS_IDENTIFIER_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_ids.value[1]')
export INFRASTRUCTURE_NETWORK_CIDR_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_cidrs.value[1]')
export INFRASTRUCTURE_RESERVED_IP_RANGES_1=$(echo $INFRASTRUCTURE_NETWORK_CIDR_1 | sed 's|16/28$|16|g')-$(echo $INFRASTRUCTURE_NETWORK_CIDR_1 | sed 's|16/28$|20|g')
export INFRASTRUCTURE_DNS_1=10.0.0.2
export INFRASTRUCTURE_GATEWAY_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_gateways.value[1]')
export INFRASTRUCTURE_AVAILABILITY_ZONES_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_availability_zones.value[1]')
export INFRASTRUCTURE_IAAS_IDENTIFIER_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_ids.value[2]')
export INFRASTRUCTURE_NETWORK_CIDR_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_cidrs.value[2]')
export INFRASTRUCTURE_RESERVED_IP_RANGES_2=$(echo $INFRASTRUCTURE_NETWORK_CIDR_2 | sed 's|32/28$|32|g')-$(echo $INFRASTRUCTURE_NETWORK_CIDR_2 | sed 's|32/28$|36|g')
export INFRASTRUCTURE_DNS_2=10.0.0.2
export INFRASTRUCTURE_GATEWAY_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_gateways.value[2]')
export INFRASTRUCTURE_AVAILABILITY_ZONES_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.infrastructure_subnet_availability_zones.value[2]')
export DEPLOYMENT_NETWORK_NAME=pas-deployment
export DEPLOYMENT_IAAS_IDENTIFIER_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_ids.value[0]')
export DEPLOYMENT_NETWORK_CIDR_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_cidrs.value[0]')
export DEPLOYMENT_RESERVED_IP_RANGES_0=$(echo $DEPLOYMENT_NETWORK_CIDR_0 | sed 's|0/24$|0|g')-$(echo $DEPLOYMENT_NETWORK_CIDR_0 | sed 's|0/24$|4|g')
export DEPLOYMENT_DNS_0=10.0.0.2
export DEPLOYMENT_GATEWAY_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_gateways.value[0]')
export DEPLOYMENT_AVAILABILITY_ZONES_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_availability_zones.value[0]')
export DEPLOYMENT_IAAS_IDENTIFIER_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_ids.value[1]')
export DEPLOYMENT_NETWORK_CIDR_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_cidrs.value[1]')
export DEPLOYMENT_RESERVED_IP_RANGES_1=$(echo $DEPLOYMENT_NETWORK_CIDR_1 | sed 's|0/24$|0|g')-$(echo $DEPLOYMENT_NETWORK_CIDR_1 | sed 's|0/24$|4|g')
export DEPLOYMENT_DNS_1=10.0.0.2
export DEPLOYMENT_GATEWAY_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_gateways.value[1]')
export DEPLOYMENT_AVAILABILITY_ZONES_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_availability_zones.value[1]')
export DEPLOYMENT_IAAS_IDENTIFIER_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_ids.value[2]')
export DEPLOYMENT_NETWORK_CIDR_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_cidrs.value[2]')
export DEPLOYMENT_RESERVED_IP_RANGES_2=$(echo $DEPLOYMENT_NETWORK_CIDR_2 | sed 's|0/24$|0|g')-$(echo $DEPLOYMENT_NETWORK_CIDR_2 | sed 's|0/24$|4|g')
export DEPLOYMENT_DNS_2=10.0.0.2
export DEPLOYMENT_GATEWAY_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_gateways.value[2]')
export DEPLOYMENT_AVAILABILITY_ZONES_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.pas_subnet_availability_zones.value[2]')
export SERVICES_NETWORK_NAME=pas-services
export SERVICES_IAAS_IDENTIFIER_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_ids.value[0]')
export SERVICES_NETWORK_CIDR_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_cidrs.value[0]')
export SERVICES_RESERVED_IP_RANGES_0=$(echo $SERVICES_NETWORK_CIDR_0 | sed 's|0/24$|0|g')-$(echo $SERVICES_NETWORK_CIDR_0 | sed 's|0/24$|3|g')
export SERVICES_DNS_0=10.0.0.2
export SERVICES_GATEWAY_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_gateways.value[0]')
export SERVICES_AVAILABILITY_ZONES_0=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_availability_zones.value[0]')
export SERVICES_IAAS_IDENTIFIER_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_ids.value[1]')
export SERVICES_NETWORK_CIDR_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_cidrs.value[1]')
export SERVICES_RESERVED_IP_RANGES_1=$(echo $SERVICES_NETWORK_CIDR_1 | sed 's|0/24$|0|g')-$(echo $SERVICES_NETWORK_CIDR_1 | sed 's|0/24$|3|g')
export SERVICES_DNS_1=10.0.0.2
export SERVICES_GATEWAY_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_gateways.value[1]')
export SERVICES_AVAILABILITY_ZONES_1=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_availability_zones.value[1]')
export SERVICES_IAAS_IDENTIFIER_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_ids.value[2]')
export SERVICES_NETWORK_CIDR_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_cidrs.value[2]')
export SERVICES_RESERVED_IP_RANGES_2=$(echo $SERVICES_NETWORK_CIDR_2 | sed 's|0/24$|0|g')-$(echo $SERVICES_NETWORK_CIDR_2 | sed 's|0/24$|3|g')
export SERVICES_DNS_2=10.0.0.2
export SERVICES_GATEWAY_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_gateways.value[2]')
export SERVICES_AVAILABILITY_ZONES_2=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.services_subnet_availability_zones.value[2]')
export SINGLETON_AVAILABILITY_NETWORK=$INFRASTRUCTURE_NETWORK_NAME
export SINGLETON_AVAILABILITY_ZONE=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.azs.value[0]')
## vm extensions
export WEB_LB_SECURITY_GROUP=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[4].resources["aws_security_group.web_lb"].primary.attributes.name')
export VMS_SECURITY_GROUP=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[1].resources["aws_security_group.vms_security_group"].primary.attributes.name')
export WEB_TARGET_GROUPS=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.web_target_groups.value' | tr -d '\n')
export SSH_TARGET_GROUPS=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.ssh_target_groups.value' | tr -d '\n')
export TCP_TARGET_GROUPS=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.tcp_target_groups.value' | tr -d '\n')
export ISTIO_TARGET_GROUPS=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[0].outputs.istio_target_groups.value' | tr -d '\n')

cat <<EOF > vars.yml
access_key_id: ${ACCESS_KEY_ID}
secret_access_key: ${SECRET_ACCESS_KEY}
security_group: ${SECURITY_GROUP}
key_pair_name: ${KEY_PAIR_NAME}
ssh_private_key: |
${SSH_PRIVATE_KEY}
region: ${REGION}
ops_manager_bucket: ${OPS_MANAGER_BUCKET}
infrastructure_network_name: ${INFRASTRUCTURE_NETWORK_NAME}
om_trusted_certs: ${OM_TRUSTED_CERTS}
# infrastructure
infrastructure_network_name: ${INFRASTRUCTURE_NETWORK_NAME}
infrastructure_iaas_identifier_0: ${INFRASTRUCTURE_IAAS_IDENTIFIER_0}
infrastructure_network_cidr_0: ${INFRASTRUCTURE_NETWORK_CIDR_0}
infrastructure_reserved_ip_ranges_0: ${INFRASTRUCTURE_RESERVED_IP_RANGES_0}
infrastructure_dns_0: ${INFRASTRUCTURE_DNS_0}
infrastructure_gateway_0: ${INFRASTRUCTURE_GATEWAY_0}
infrastructure_availability_zones_0: ${INFRASTRUCTURE_AVAILABILITY_ZONES_0}
infrastructure_iaas_identifier_1: ${INFRASTRUCTURE_IAAS_IDENTIFIER_1}
infrastructure_network_cidr_1: ${INFRASTRUCTURE_NETWORK_CIDR_1}
infrastructure_reserved_ip_ranges_1: ${INFRASTRUCTURE_RESERVED_IP_RANGES_1}
infrastructure_dns_1: ${INFRASTRUCTURE_DNS_1}
infrastructure_gateway_1: ${INFRASTRUCTURE_GATEWAY_1}
infrastructure_availability_zones_1: ${INFRASTRUCTURE_AVAILABILITY_ZONES_1}
infrastructure_iaas_identifier_2: ${INFRASTRUCTURE_IAAS_IDENTIFIER_2}
infrastructure_network_cidr_2: ${INFRASTRUCTURE_NETWORK_CIDR_2}
infrastructure_reserved_ip_ranges_2: ${INFRASTRUCTURE_RESERVED_IP_RANGES_2}
infrastructure_dns_2: ${INFRASTRUCTURE_DNS_2}
infrastructure_gateway_2: ${INFRASTRUCTURE_GATEWAY_2}
infrastructure_availability_zones_2: ${INFRASTRUCTURE_AVAILABILITY_ZONES_2}
# deployment
deployment_network_name: ${DEPLOYMENT_NETWORK_NAME}
deployment_iaas_identifier_0: ${DEPLOYMENT_IAAS_IDENTIFIER_0}
deployment_network_cidr_0: ${DEPLOYMENT_NETWORK_CIDR_0}
deployment_reserved_ip_ranges_0: ${DEPLOYMENT_RESERVED_IP_RANGES_0}
deployment_dns_0: ${DEPLOYMENT_DNS_0}
deployment_gateway_0: ${DEPLOYMENT_GATEWAY_0}
deployment_availability_zones_0: ${DEPLOYMENT_AVAILABILITY_ZONES_0}
deployment_iaas_identifier_1: ${DEPLOYMENT_IAAS_IDENTIFIER_1}
deployment_network_cidr_1: ${DEPLOYMENT_NETWORK_CIDR_1}
deployment_reserved_ip_ranges_1: ${DEPLOYMENT_RESERVED_IP_RANGES_1}
deployment_dns_1: ${DEPLOYMENT_DNS_1}
deployment_gateway_1: ${DEPLOYMENT_GATEWAY_1}
deployment_availability_zones_1: ${DEPLOYMENT_AVAILABILITY_ZONES_1}
deployment_iaas_identifier_2: ${DEPLOYMENT_IAAS_IDENTIFIER_2}
deployment_network_cidr_2: ${DEPLOYMENT_NETWORK_CIDR_2}
deployment_reserved_ip_ranges_2: ${DEPLOYMENT_RESERVED_IP_RANGES_2}
deployment_dns_2: ${DEPLOYMENT_DNS_2}
deployment_gateway_2: ${DEPLOYMENT_GATEWAY_2}
deployment_availability_zones_2: ${DEPLOYMENT_AVAILABILITY_ZONES_2}
# services
services_network_name: ${SERVICES_NETWORK_NAME}
services_iaas_identifier_0: ${SERVICES_IAAS_IDENTIFIER_0}
services_network_cidr_0: ${SERVICES_NETWORK_CIDR_0}
services_reserved_ip_ranges_0: ${SERVICES_RESERVED_IP_RANGES_0}
services_dns_0: ${SERVICES_DNS_0}
services_gateway_0: ${SERVICES_GATEWAY_0}
services_availability_zones_0: ${SERVICES_AVAILABILITY_ZONES_0}
services_iaas_identifier_1: ${SERVICES_IAAS_IDENTIFIER_1}
services_network_cidr_1: ${SERVICES_NETWORK_CIDR_1}
services_reserved_ip_ranges_1: ${SERVICES_RESERVED_IP_RANGES_1}
services_dns_1: ${SERVICES_DNS_1}
services_gateway_1: ${SERVICES_GATEWAY_1}
services_availability_zones_1: ${SERVICES_AVAILABILITY_ZONES_1}
services_iaas_identifier_2: ${SERVICES_IAAS_IDENTIFIER_2}
services_network_cidr_2: ${SERVICES_NETWORK_CIDR_2}
services_reserved_ip_ranges_2: ${SERVICES_RESERVED_IP_RANGES_2}
services_dns_2: ${SERVICES_DNS_2}
services_gateway_2: ${SERVICES_GATEWAY_2}
services_availability_zones_2: ${SERVICES_AVAILABILITY_ZONES_2}
# vm extensions

web_lb_security_group: ${WEB_LB_SECURITY_GROUP}
vms_security_group: ${VMS_SECURITY_GROUP}
web_target_groups: ${WEB_TARGET_GROUPS}
ssh_target_groups: ${SSH_TARGET_GROUPS}
tcp_target_groups: ${TCP_TARGET_GROUPS}
istio_target_groups: ${ISTIO_TARGET_GROUPS}
EOF