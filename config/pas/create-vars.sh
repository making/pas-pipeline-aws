#!/bin/bash
set -eo pipefail

export SINGLETON_AVAILABILITY_ZONE=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.azs.value[0]')
export AVAILABILITY_ZONES=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.azs.value | map({name: .})' | tr -d '\n' | tr -d '"')
export AVAILABILITY_ZONE_NAMES=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.azs.value' | tr -d '\n' | tr -d '"')
export SYSTEM_DOMAIN=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.sys_domain.value')
export PAS_MAIN_NETWORK_NAME=pas-deployment
export PAS_SERVICES_NETWORK_NAME=pas-services
export APPS_DOMAIN=`echo ${OM_TARGET} | sed 's/pcf/apps/g'`
export SYSTEM_DOMAIN=`echo ${OM_TARGET} | sed 's/pcf/sys/g'`
export WEB_TARGET_GROUPS=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.web_target_groups.value')
export SSH_TARGET_GROUPS=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.ssh_target_groups.value')
export TCP_TARGET_GROUPS=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.tcp_target_groups.value')
export ACCESS_KEY_ID=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.ops_manager_iam_user_access_key.value')
export SECRET_ACCESS_KEY=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.ops_manager_iam_user_secret_key.value')
export S3_ENDPOINT=https://s3.$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.region.value').amazonaws.com
export S3_REGION=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.region.value')
export PAS_BUILDPACKS_BUCKET=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.pas_buildpacks_bucket.value')
export PAS_DROPLETS_BUCKET=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.pas_droplets_bucket.value')
export PAS_PACKAGES_BUCKET=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.pas_packages_bucket.value')
export PAS_RESOURCES_BUCKET=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.pas_resources_bucket.value')
export PAS_BUILDPACKS_BACKUP_BUCKET=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.pas_buildpacks_backup_bucket.value')
export PAS_DROPLETS_BACKUP_BUCKET=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.pas_droplets_backup_bucket.value')
export PAS_PACKAGES_BACKUP_BUCKET=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.pas_packages_backup_bucket.value')
export PAS_RESOURCES_BACKUP_BUCKET=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.pas_resources_backup_bucket.value')
export BLOBSTORE_KMS_KEY_ID=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.blobstore_kms_key_id.value')
export RDS_ADDRESS=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.rds_address.value')
export RDS_PORT=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.rds_port.value')
export RDS_USERNAME=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.rds_username.value')
export RDS_PASSWORD=$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.rds_password.value')
curl -L -J -O https://s3.amazonaws.com/rds-downloads/rds-ca-2015-$(cat terraform-state/terraform.tfstate | jq -r '.modules[0].outputs.region.value').pem
curl -L -J -O https://s3.amazonaws.com/rds-downloads/rds-ca-2015-root.pem
cat rds-ca-2015-ap-northeast-1.pem rds-ca-2015-root.pem > combined.pem
export RDS_CA=$(cat combined.pem | sed 's/^/  /')
if [ "${CERT_PEM}" == "" ];then
	CERTIFICATES=`om generate-certificate -d "*.$APPS_DOMAIN *.$SYSTEM_DOMAIN *.uaa.$SYSTEM_DOMAIN *.login.$SYSTEM_DOMAIN"`
	CERT_PEM=`echo $CERTIFICATES | jq -r '.certificate'`
	KEY_PEM=`echo $CERTIFICATES | jq -r '.key'`
fi
export CERT_PEM=`cat <<EOF | sed 's/^/  /'
${CERT_PEM}
EOF
`
export KEY_PEM=`cat <<EOF | sed 's/^/  /'
${KEY_PEM}
EOF
`

export WEB_LB_SECURITY_GROUP=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[4].resources["aws_security_group.web_lb"].primary.attributes.name')
export VMS_SECURITY_GROUP=$(cat $TF_DIR/terraform.tfstate | jq -r '.modules[2].resources["aws_security_group.vms_security_group"].primary.attributes.name')


cat <<EOF > vars.yml
cert_pem: |
${CERT_PEM}
key_pem: |
${KEY_PEM}
availability_zone_names: ${AVAILABILITY_ZONE_NAMES}
pas_main_network_name: ${PAS_MAIN_NETWORK_NAME}
pas_services_network_name: ${PAS_SERVICES_NETWORK_NAME}
availability_zones: ${AVAILABILITY_ZONES}
singleton_availability_zone: ${SINGLETON_AVAILABILITY_ZONE}
apps_domain: ${APPS_DOMAIN}
system_domain: ${SYSTEM_DOMAIN}
web_target_groups: ${WEB_TARGET_GROUPS}
ssh_target_groups: ${SSH_TARGET_GROUPS}
tcp_target_groups: ${TCP_TARGET_GROUPS}
access_key_id: ${ACCESS_KEY_ID}
secret_access_key: ${SECRET_ACCESS_KEY}
s3_endpoint: ${S3_ENDPOINT}
s3_region: ${S3_REGION}
pas_buildpacks_bucket: ${PAS_BUILDPACKS_BUCKET}
pas_droplets_bucket: ${PAS_DROPLETS_BUCKET}
pas_packages_bucket: ${PAS_PACKAGES_BUCKET}
pas_resources_bucket: ${PAS_RESOURCES_BUCKET}
# pas_buildpacks_backup_bucket: ${PAS_BUILDPACKS_BACKUP_BUCKET}
# pas_droplets_backup_bucket: ${PAS_DROPLETS_BACKUP_BUCKET}
# pas_packages_backup_bucket: ${PAS_PACKAGES_BACKUP_BUCKET}
# pas_resources_backup_bucket: ${PAS_RESOURCES_BACKUP_BUCKET}
blobstore_kms_key_id: ${BLOBSTORE_KMS_KEY_ID}
rds_address: ${RDS_ADDRESS}
rds_port: ${RDS_PORT}
rds_username: ${RDS_USERNAME}
rds_password: ${RDS_PASSWORD}
rds_ca: |
${RDS_CA}
smtp_from: ${SMTP_FROM}
smtp_address: ${SMTP_ADDRESS}
smtp_port: ${SMTP_PORT}
smtp_username: ${SMTP_USERNAME}
smtp_password: ${SMTP_PASSWORD}
smtp_enable_starttls: ${SMTP_ENABLE_STARTTLS}
web_lb_security_group: ${WEB_LB_SECURITY_GROUP}
vms_security_group: ${VMS_SECURITY_GROUP}
EOF
