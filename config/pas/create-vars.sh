#!/bin/bash
set -eo pipefail

export SINGLETON_AVAILABILITY_ZONE=$(terraform output --state=${TF_DIR}/terraform.tfstate --json azs | jq -r '.value[0]')
export AVAILABILITY_ZONES=$(terraform output --state=${TF_DIR}/terraform.tfstate --json azs | jq -r '.value | map({name: .})' | tr -d '\n' | tr -d '"')
export AVAILABILITY_ZONE_NAMES=$(terraform output --state=${TF_DIR}/terraform.tfstate azs | tr -d '\n' | tr -d '"')
export SYSTEM_DOMAIN=$(terraform output --state=${TF_DIR}/terraform.tfstate sys_domain)
export PAS_MAIN_NETWORK_NAME=pas-deployment
export PAS_SERVICES_NETWORK_NAME=pas-services
export APPS_DOMAIN=$(terraform output --state=${TF_DIR}/terraform.tfstate apps_domain)
export SYSTEM_DOMAIN=$(terraform output --state=${TF_DIR}/terraform.tfstate sys_domain)
export WEB_TARGET_GROUPS=$(terraform output --state=${TF_DIR}/terraform.tfstate web_target_groups | tr -d '\n')
export SSH_TARGET_GROUPS=$(terraform output --state=${TF_DIR}/terraform.tfstate ssh_target_groups | tr -d '\n')
export TCP_TARGET_GROUPS=$(terraform output --state=${TF_DIR}/terraform.tfstate tcp_target_groups | tr -d '\n')
export ACCESS_KEY_ID=$(terraform output --state=${TF_DIR}/terraform.tfstate ops_manager_iam_user_access_key)
export SECRET_ACCESS_KEY=$(terraform output --state=${TF_DIR}/terraform.tfstate ops_manager_iam_user_secret_key)
export S3_ENDPOINT=https://s3.$(terraform output --state=${TF_DIR}/terraform.tfstate region).amazonaws.com
export S3_REGION=$(terraform output --state=${TF_DIR}/terraform.tfstate region)
export PAS_BUILDPACKS_BUCKET=$(terraform output --state=${TF_DIR}/terraform.tfstate pas_buildpacks_bucket)
export PAS_DROPLETS_BUCKET=$(terraform output --state=${TF_DIR}/terraform.tfstate pas_droplets_bucket)
export PAS_PACKAGES_BUCKET=$(terraform output --state=${TF_DIR}/terraform.tfstate pas_packages_bucket)
export PAS_RESOURCES_BUCKET=$(terraform output --state=${TF_DIR}/terraform.tfstate pas_resources_bucket)
export PAS_BUILDPACKS_BACKUP_BUCKET=$(terraform output --state=${TF_DIR}/terraform.tfstate pas_buildpacks_backup_bucket)
export PAS_DROPLETS_BACKUP_BUCKET=$(terraform output --state=${TF_DIR}/terraform.tfstate pas_droplets_backup_bucket)
export PAS_PACKAGES_BACKUP_BUCKET=$(terraform output --state=${TF_DIR}/terraform.tfstate pas_packages_backup_bucket)
export PAS_RESOURCES_BACKUP_BUCKET=$(terraform output --state=${TF_DIR}/terraform.tfstate pas_resources_backup_bucket)
export BLOBSTORE_KMS_KEY_ID=$(terraform output --state=${TF_DIR}/terraform.tfstate blobstore_kms_key_id)
export RDS_ADDRESS=$(terraform output --state=${TF_DIR}/terraform.tfstate rds_address)
export RDS_PORT=$(terraform output --state=${TF_DIR}/terraform.tfstate rds_port)
export RDS_USERNAME=$(terraform output --state=${TF_DIR}/terraform.tfstate rds_username)
export RDS_PASSWORD=$(terraform output --state=${TF_DIR}/terraform.tfstate rds_password)
curl -L -J -O https://s3.amazonaws.com/rds-downloads/rds-ca-2015-${S3_REGION}.pem
curl -L -J -O https://s3.amazonaws.com/rds-downloads/rds-ca-2015-root.pem
cat rds-ca-2015-${S3_REGION}.pem rds-ca-2015-root.pem > combined.pem
export RDS_CA=$(cat combined.pem | sed 's/^/  /')
if [ "${CERT_PEM}" == "" ];then
	CERTIFICATES=`om --env env/"${ENV_FILE}" generate-certificate -d "*.$APPS_DOMAIN *.$SYSTEM_DOMAIN *.mesh.$APPS_DOMAIN *.uaa.$SYSTEM_DOMAIN *.login.$SYSTEM_DOMAIN"`
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

cat <<EOF
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
