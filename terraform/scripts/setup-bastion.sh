#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y awscli curl jq unzip
curl -LO "https://dl.k8s.io/release/v1.27.0/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
