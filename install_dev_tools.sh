#!/bin/bash

# Works on Debian/Ubuntu (apt), Fedora (dnf), and RHEL/CentOS (yum)
# detect package manager
if command -v apt > /dev/null 2>&1; then
  PKG="apt"
  UPDATE="sudo apt update"
  INSTALL="sudo apt install -y"
elif command -v dnf > /dev/null 2>&1; then
  PKG="dnf"
  UPDATE="sudo dnf check-update"
  INSTALL="sudo dnf install -y"
else
  PKG="yum"
  UPDATE="sudo yum check-update"
  INSTALL="sudo yum install -y"
fi

# update packages
$UPDATE

# Docker
if ! docker --version > /dev/null 2>&1; then
  if [ "$PKG" = "apt" ]; then
    $INSTALL docker.io
  else
    $INSTALL docker
  fi
  sudo systemctl start docker
  sudo systemctl enable docker
fi

# Docker Compose (works everywhere)
if ! docker compose version > /dev/null 2>&1; then
  sudo mkdir -p /usr/local/lib/docker/cli-plugins
  sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
    -o /usr/local/lib/docker/cli-plugins/docker-compose
  sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
fi

# Python
if ! python3 --version > /dev/null 2>&1; then
  $INSTALL python3
fi

# pip
if ! pip3 --version > /dev/null 2>&1; then
  $INSTALL python3-pip
fi

# Django
if ! python3 -m django --version > /dev/null 2>&1; then
  pip3 install django
fi