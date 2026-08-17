#!/usr/bin/env bash
# setup-server.sh — Bootstrap a fresh Ubuntu 22.04 server for deployment
# Run once after provisioning: ssh root@SERVER_IP "bash -s" < scripts/setup-server.sh

set -euo pipefail

echo "=== Server Bootstrap Script ==="
echo "Running on: $(hostname) | $(date)"

# Update system
apt-get update -y && apt-get upgrade -y

# Install essentials
apt-get install -y curl git ufw fail2ban unattended-upgrades

# Install Docker
curl -fsSL https://get.docker.com | sh
systemctl enable docker
systemctl start docker

# Install Docker Compose plugin
apt-get install -y docker-compose-plugin

# Create app user
useradd -m -s /bin/bash deploy || true
usermod -aG docker deploy

# Setup app directory
mkdir -p /opt/app
chown deploy:deploy /opt/app

# Configure UFW firewall
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

echo "Server bootstrap complete!"
echo "Next: copy docker-compose.prod.yml to /opt/app/ and run: docker compose up -d"