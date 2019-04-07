#!/bin/bash
set -eo pipefail

export ACCESS_KEY_ID=$(terraform output --state=${TF_DIR}/terraform.tfstate ops_manager_iam_user_access_key)
export SECRET_ACCESS_KEY=$(terraform output --state=${TF_DIR}/terraform.tfstate ops_manager_iam_user_secret_key)
export SECURITY_GROUP=$(terraform output --state=${TF_DIR}/terraform.tfstate vms_security_group_id)
export KEY_PAIR_NAME=$(terraform output --state=${TF_DIR}/terraform.tfstate ops_manager_ssh_public_key_name)
export SSH_PRIVATE_KEY=$(terraform output --state=${TF_DIR}/terraform.tfstate ops_manager_ssh_private_key | sed 's/^/  /')
export REGION=$(terraform output --state=${TF_DIR}/terraform.tfstate region)
## Director
export OPS_MANAGER_BUCKET=$(terraform output --state=${TF_DIR}/terraform.tfstate ops_manager_bucket)
export OM_TRUSTED_CERTS=$(echo "$OM_TRUSTED_CERTS" | sed 's/^/  /')
## Networks
export AVAILABILITY_ZONES=$(terraform output --state=${TF_DIR}/terraform.tfstate -json azs | jq -r '.value | map({name: .})' | tr -d '\n' | tr -d '"')
export INFRASTRUCTURE_NETWORK_NAME=pas-infrastructure
export INFRASTRUCTURE_IAAS_IDENTIFIER_0=$(terraform output --state=${TF_DIR}/terraform.tfstate -json infrastructure_subnet_ids | jq -r '.value[0]')
export INFRASTRUCTURE_NETWORK_CIDR_0=$(terraform output --state=${TF_DIR}/terraform.tfstate -json infrastructure_subnet_cidrs | jq -r '.value[0]')
export INFRASTRUCTURE_RESERVED_IP_RANGES_0=$(echo $INFRASTRUCTURE_NETWORK_CIDR_0 | sed 's|0/28$|0|g')-$(echo $INFRASTRUCTURE_NETWORK_CIDR_0 | sed 's|0/28$|4|g')
export INFRASTRUCTURE_DNS_0=10.0.0.2
export INFRASTRUCTURE_GATEWAY_0=$(terraform output --state=${TF_DIR}/terraform.tfstate -json infrastructure_subnet_gateways | jq -r '.value[0]')
export INFRASTRUCTURE_AVAILABILITY_ZONES_0=$(terraform output --state=${TF_DIR}/terraform.tfstate -json infrastructure_subnet_availability_zones | jq -r '.value[0]')
export INFRASTRUCTURE_IAAS_IDENTIFIER_1=$(terraform output --state=${TF_DIR}/terraform.tfstate -json infrastructure_subnet_ids | jq -r '.value[1]')
export INFRASTRUCTURE_NETWORK_CIDR_1=$(terraform output --state=${TF_DIR}/terraform.tfstate -json infrastructure_subnet_cidrs | jq -r '.value[1]')
export INFRASTRUCTURE_RESERVED_IP_RANGES_1=$(echo $INFRASTRUCTURE_NETWORK_CIDR_1 | sed 's|16/28$|16|g')-$(echo $INFRASTRUCTURE_NETWORK_CIDR_1 | sed 's|16/28$|20|g')
export INFRASTRUCTURE_DNS_1=10.0.0.2
export INFRASTRUCTURE_GATEWAY_1=$(terraform output --state=${TF_DIR}/terraform.tfstate -json infrastructure_subnet_gateways | jq -r '.value[1]')
export INFRASTRUCTURE_AVAILABILITY_ZONES_1=$(terraform output --state=${TF_DIR}/terraform.tfstate -json infrastructure_subnet_availability_zones | jq -r '.value[1]')
export INFRASTRUCTURE_IAAS_IDENTIFIER_2=$(terraform output --state=${TF_DIR}/terraform.tfstate -json infrastructure_subnet_ids | jq -r '.value[2]')
export INFRASTRUCTURE_NETWORK_CIDR_2=$(terraform output --state=${TF_DIR}/terraform.tfstate -json infrastructure_subnet_cidrs | jq -r '.value[2]')
export INFRASTRUCTURE_RESERVED_IP_RANGES_2=$(echo $INFRASTRUCTURE_NETWORK_CIDR_2 | sed 's|32/28$|32|g')-$(echo $INFRASTRUCTURE_NETWORK_CIDR_2 | sed 's|32/28$|36|g')
export INFRASTRUCTURE_DNS_2=10.0.0.2
export INFRASTRUCTURE_GATEWAY_2=$(terraform output --state=${TF_DIR}/terraform.tfstate -json infrastructure_subnet_gateways | jq -r '.value[2]')
export INFRASTRUCTURE_AVAILABILITY_ZONES_2=$(terraform output --state=${TF_DIR}/terraform.tfstate -json infrastructure_subnet_availability_zones | jq -r '.value[2]')
export DEPLOYMENT_NETWORK_NAME=pas-deployment
export DEPLOYMENT_IAAS_IDENTIFIER_0=$(terraform output --state=${TF_DIR}/terraform.tfstate -json pas_subnet_ids | jq -r '.value[0]')
export DEPLOYMENT_NETWORK_CIDR_0=$(terraform output --state=${TF_DIR}/terraform.tfstate -json pas_subnet_cidrs | jq -r '.value[0]')
export DEPLOYMENT_RESERVED_IP_RANGES_0=$(echo $DEPLOYMENT_NETWORK_CIDR_0 | sed 's|0/24$|0|g')-$(echo $DEPLOYMENT_NETWORK_CIDR_0 | sed 's|0/24$|4|g')
export DEPLOYMENT_DNS_0=10.0.0.2
export DEPLOYMENT_GATEWAY_0=$(terraform output --state=${TF_DIR}/terraform.tfstate -json pas_subnet_gateways | jq -r '.value[0]')
export DEPLOYMENT_AVAILABILITY_ZONES_0=$(terraform output --state=${TF_DIR}/terraform.tfstate -json pas_subnet_availability_zones | jq -r '.value[0]')
export DEPLOYMENT_IAAS_IDENTIFIER_1=$(terraform output --state=${TF_DIR}/terraform.tfstate -json pas_subnet_ids | jq -r '.value[1]')
export DEPLOYMENT_NETWORK_CIDR_1=$(terraform output --state=${TF_DIR}/terraform.tfstate -json pas_subnet_cidrs | jq -r '.value[1]')
export DEPLOYMENT_RESERVED_IP_RANGES_1=$(echo $DEPLOYMENT_NETWORK_CIDR_1 | sed 's|0/24$|0|g')-$(echo $DEPLOYMENT_NETWORK_CIDR_1 | sed 's|0/24$|4|g')
export DEPLOYMENT_DNS_1=10.0.0.2
export DEPLOYMENT_GATEWAY_1=$(terraform output --state=${TF_DIR}/terraform.tfstate -json pas_subnet_gateways | jq -r '.value[1]')
export DEPLOYMENT_AVAILABILITY_ZONES_1=$(terraform output --state=${TF_DIR}/terraform.tfstate -json pas_subnet_availability_zones | jq -r '.value[1]')
export DEPLOYMENT_IAAS_IDENTIFIER_2=$(terraform output --state=${TF_DIR}/terraform.tfstate -json pas_subnet_ids | jq -r '.value[2]')
export DEPLOYMENT_NETWORK_CIDR_2=$(terraform output --state=${TF_DIR}/terraform.tfstate -json pas_subnet_cidrs | jq -r '.value[2]')
export DEPLOYMENT_RESERVED_IP_RANGES_2=$(echo $DEPLOYMENT_NETWORK_CIDR_2 | sed 's|0/24$|0|g')-$(echo $DEPLOYMENT_NETWORK_CIDR_2 | sed 's|0/24$|4|g')
export DEPLOYMENT_DNS_2=10.0.0.2
export DEPLOYMENT_GATEWAY_2=$(terraform output --state=${TF_DIR}/terraform.tfstate -json pas_subnet_gateways | jq -r '.value[2]')
export DEPLOYMENT_AVAILABILITY_ZONES_2=$(terraform output --state=${TF_DIR}/terraform.tfstate -json pas_subnet_availability_zones | jq -r '.value[2]')
export SERVICES_NETWORK_NAME=pas-services
export SERVICES_IAAS_IDENTIFIER_0=$(terraform output --state=${TF_DIR}/terraform.tfstate -json services_subnet_ids | jq -r '.value[0]')
export SERVICES_NETWORK_CIDR_0=$(terraform output --state=${TF_DIR}/terraform.tfstate -json services_subnet_cidrs | jq -r '.value[0]')
export SERVICES_RESERVED_IP_RANGES_0=$(echo $SERVICES_NETWORK_CIDR_0 | sed 's|0/24$|0|g')-$(echo $SERVICES_NETWORK_CIDR_0 | sed 's|0/24$|3|g')
export SERVICES_DNS_0=10.0.0.2
export SERVICES_GATEWAY_0=$(terraform output --state=${TF_DIR}/terraform.tfstate -json services_subnet_gateways | jq -r '.value[0]')
export SERVICES_AVAILABILITY_ZONES_0=$(terraform output --state=${TF_DIR}/terraform.tfstate -json services_subnet_availability_zones | jq -r '.value[0]')
export SERVICES_IAAS_IDENTIFIER_1=$(terraform output --state=${TF_DIR}/terraform.tfstate -json services_subnet_ids | jq -r '.value[1]')
export SERVICES_NETWORK_CIDR_1=$(terraform output --state=${TF_DIR}/terraform.tfstate -json services_subnet_cidrs | jq -r '.value[1]')
export SERVICES_RESERVED_IP_RANGES_1=$(echo $SERVICES_NETWORK_CIDR_1 | sed 's|0/24$|0|g')-$(echo $SERVICES_NETWORK_CIDR_1 | sed 's|0/24$|3|g')
export SERVICES_DNS_1=10.0.0.2
export SERVICES_GATEWAY_1=$(terraform output --state=${TF_DIR}/terraform.tfstate -json services_subnet_gateways | jq -r '.value[1]')
export SERVICES_AVAILABILITY_ZONES_1=$(terraform output --state=${TF_DIR}/terraform.tfstate -json services_subnet_availability_zones | jq -r '.value[1]')
export SERVICES_IAAS_IDENTIFIER_2=$(terraform output --state=${TF_DIR}/terraform.tfstate -json services_subnet_ids | jq -r '.value[2]')
export SERVICES_NETWORK_CIDR_2=$(terraform output --state=${TF_DIR}/terraform.tfstate -json services_subnet_cidrs | jq -r '.value[2]')
export SERVICES_RESERVED_IP_RANGES_2=$(echo $SERVICES_NETWORK_CIDR_2 | sed 's|0/24$|0|g')-$(echo $SERVICES_NETWORK_CIDR_2 | sed 's|0/24$|3|g')
export SERVICES_DNS_2=10.0.0.2
export SERVICES_GATEWAY_2=$(terraform output --state=${TF_DIR}/terraform.tfstate -json services_subnet_gateways | jq -r '.value[2]')
export SERVICES_AVAILABILITY_ZONES_2=$(terraform output --state=${TF_DIR}/terraform.tfstate -json services_subnet_availability_zones | jq -r '.value[2]')
## vm extensions
export WEB_LB_SECURITY_GROUP=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[] | select(.resources["aws_security_group.web_lb"] != null).resources["aws_security_group.web_lb"].primary.attributes.name')
export SSH_LB_SECURITY_GROUP=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[] | select(.resources["aws_security_group.ssh_lb"] != null).resources["aws_security_group.ssh_lb"].primary.attributes.name')
export TCP_LB_SECURITY_GROUP=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[] | select(.resources["aws_security_group.tcp_lb"] != null).resources["aws_security_group.tcp_lb"].primary.attributes.name')
export TCP_LB_SECURITY_GROUP=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[] | select(.resources["aws_security_group.tcp_lb"] != null).resources["aws_security_group.istio_lb"].primary.attributes.name')
export VMS_SECURITY_GROUP=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[] | select(.resources["aws_security_group.vms_security_group"] != null).resources["aws_security_group.vms_security_group"].primary.attributes.name')
export WEB_TARGET_GROUPS="[$(terraform output --state=${TF_DIR}/terraform.tfstate web_target_groups | tr -d '\n')]"
export SSH_TARGET_GROUPS="[$(terraform output --state=${TF_DIR}/terraform.tfstate ssh_target_groups | tr -d '\n')]"
export TCP_TARGET_GROUPS="[$(terraform output --state=${TF_DIR}/terraform.tfstate tcp_target_groups | tr -d '\n')]"
export ISTIO_TARGET_GROUPS="[$(terraform output --state=${TF_DIR}/terraform.tfstate istio_target_groups | tr -d '\n')]"

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
istio_lb_security_group: ${ISTIO_LB_SECURITY_GROUP}
vms_security_group: ${VMS_SECURITY_GROUP}
web_target_groups: ${WEB_TARGET_GROUPS}
ssh_target_groups: ${SSH_TARGET_GROUPS}
tcp_target_groups: ${TCP_TARGET_GROUPS}
istio_target_groups: ${ISTIO_TARGET_GROUPS}
EOF