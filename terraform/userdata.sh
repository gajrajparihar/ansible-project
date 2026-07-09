#!/bin/bash
set -euxo pipefail

# Update packages
dnf update -y

# Install Ansible
dnf install -y ansible

# Verify installation
ansible --version > /home/ec2-user/ansible-version.txt

# Optional: Install Git
dnf install -y git

# Optional: Install Python pip
dnf install -y python3-pip

# Change ownership
chown ec2-user:ec2-user /home/ec2-user/ansible-version.txt