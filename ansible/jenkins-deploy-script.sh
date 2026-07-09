#!/bin/bash

set -euo pipefail
export AWS_REGION="eu-central-1"

echo "===================================="
echo "Ansible Deployment"
echo "Build Number : ${BUILD_NUMBER:-N/A}"
echo "Triggered By : ${BUILD_USER_ID:-SYSTEM}"
echo "Workspace    : ${WORKSPACE:-N/A}"
echo "===================================="

# Use Jenkins workspace instead of a hardcoded path
ANSIBLE_DIR="${WORKSPACE}/ansible"

if [[ ! -d "$ANSIBLE_DIR" ]]; then
    echo "ERROR: Ansible directory not found: $ANSIBLE_DIR"
    exit 1
fi
cd "$ANSIBLE_DIR"
echo "Current directory:"
pwd
# Set permission for .pem file
chmod 400 terraform-project.pem

echo "Verifying inventory..."
ansible-inventory --list >/dev/null

echo "Testing connectivity..."
ansible app -m ping

echo "Deploying application..."
ansible-playbook -l app \
	tomcat_install.yml \
    deploy_war.yml \
    tomcat_restart.yml \
    -e "app_version=${APP_VERSION}"

echo "===================================="
echo "Deployment completed successfully"
echo "===================================="

