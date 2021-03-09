#!/bin/bash

# Validation
if [[ -z "${azdoOrgPath}" ]]; then
    echo "azdoOrgPath environment variable not set"
    exit 1
fi

if [[ -z "${azdoPat}" ]]; then
    echo "azdoPat environment variable not set"
    exit 1
fi

if [[ -z "${azdoAgentName}" ]]; then
    echo "azdoAgentName environment variable not set"
    exit 1
fi

# Install Docker
echo "Installing Docker"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update Ubuntu
echo "Updating Ubuntu"
DEBIAN_FRONTEND=noninteractive apt-get update --quiet
DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes --quiet
DEBIAN_FRONTEND=noninteractive sudo apt-get install docker-ce docker-ce-cli containerd.io --yes --quiet
DEBIAN_FRONTEND=noninteractive sudo apt-get install unzip --yes --quiet
sudo groupadd docker 2> error.log
sudo usermod -aG docker adminuser

# Install Azure CLI
echo "Installing Azure CLI"
curl -sL https://aka.ms/InstallAzureCLIDeb | DEBIAN_FRONTEND=noninteractive bash
az login --identity
az aks install-cli 2> error.log

# Install Helm
echo "Installing Helm"
wget -q https://get.helm.sh/helm-v3.3.4-linux-amd64.tar.gz
tar -xf helm-v3.3.4-linux-amd64.tar.gz
sudo cp linux-amd64/helm /usr/local/bin

# Install Terraform
echo "Installing Terraform"
wget -q https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip
unzip terraform_0.14.7_linux_amd64.zip
sudo cp terraform /usr/local/bin

# Install .NET Core
echo "Installing .NET Core"
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
DEBIAN_FRONTEND=noninteractive sudo dpkg -i packages-microsoft-prod.deb
DEBIAN_FRONTEND=noninteractive sudo apt-get update --quiet
DEBIAN_FRONTEND=noninteractive sudo apt-get install apt-transport-https dotnet-sdk-5.0 --yes --quiet

# Download Agent
echo "Downloading Azdo Agent"
su - adminuser -c 'wget -q https://vstsagentpackage.azureedge.net/agent/2.183.1/vsts-agent-linux-x64-2.183.1.tar.gz'
su - adminuser -c 'tar -xf vsts-agent-linux-x64-2.183.1.tar.gz'

# Configure Agent
echo "Configuring Azdo Agent"
su - adminuser -c './config.sh --unattended --url "${azdoOrgPath}" --auth pat --token "${azdoPat}" --pool "Reverse Proxy Pool" --agent "${azdoAgentName}" --acceptTeeEula | DEBIAN_FRONTEND=noninteractive bash'
su - adminuser -c 'sudo ./svc.sh install'
su - adminuser -c 'sudo ./svc.sh start'
