#!/bin/bash

set -e

ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    SSM_URL="https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb"
elif [ "$ARCH" = "aarch64" ]; then
    SSM_URL="https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_arm64/amazon-ssm-agent.deb"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

if [ "$EUID" -ne 0 ]; then 
    SUDO="sudo"
else
    SUDO=""
fi

if systemctl is-active --quiet amazon-ssm-agent 2>/dev/null; then
    echo "SSM Agent already running"
    exit 0
fi

$SUDO apt-get update -y

cd /tmp
wget -q "$SSM_URL" -O amazon-ssm-agent.deb
$SUDO dpkg -i amazon-ssm-agent.deb
rm -f amazon-ssm-agent.deb

$SUDO systemctl enable amazon-ssm-agent
$SUDO systemctl start amazon-ssm-agent

sleep 3

if systemctl is-active --quiet amazon-ssm-agent; then
    echo "SSM Agent installed successfully"
else
    echo "SSM Agent failed to start"
    exit 1
fi
