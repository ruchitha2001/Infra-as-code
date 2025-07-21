#!/bin/bash
HOST="$1"
PEM_FILE="$2"

VERSION="1.9.1"

ssh -i $PEM_FILE -o StrictHostKeyChecking=no ubuntu@$HOST << EOF
  wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz
  tar -xzf node_exporter-${VERSION}.linux-amd64.tar.gz
  sudo mv node_exporter-${VERSION}.linux-amd64/node_exporter /usr/local/bin/
  sudo useradd -rs /bin/false node_exporter || true
  echo "[Unit]
  Description=Node Exporter
  [Service]
  User=node_exporter
  ExecStart=/usr/local/bin/node_exporter
  [Install]
  WantedBy=default.target" | sudo tee /etc/systemd/system/node_exporter.service
  sudo systemctl daemon-reexec
  sudo systemctl enable node_exporter
  sudo systemctl start node_exporter
EOF
