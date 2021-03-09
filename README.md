# Pipelines Hosted Agents

This repository creates Azure Pipelines Hosted Agents using Terraform.

## Getting Started

1. Clone the repository
1. Change directory to ``` deploy/terraform ```
1. Create an id_rsa and id_rsa.pub using ``` ssh-keygen ```
1. Execute ``` ./run-terraform.sh -u azure-dev-ops-org-url -p azure-dev-ops-project-name ```

> Where ``` azure-dev-ops-org-url ``` is like https://dev.azure.com/Org and ``` azure-dev-ops-project-name ``` is the project name inside that organization.

## Requirements for Agent Virtual Machines

Ensure to go into the ``` deploy/terraform ``` folder and run ``` ssh-keygen ``` so there is an id_rsa.pub file in the same directory as ``` main.tf ```

## FAQ

Q: Should I do any of this in production?

A: Please use common sense - this is an example of how to do things. There are a lot of gaps in terms of securing access tokens, personal access tokens and ssh keys. In production we'd want to ensure that all of these are in a secure location. So be sure to run your own risk assessments.

Q: I noticed that we are creating an id_rsa and an id_rsa.pub, what are these for?

A: Azure Bastion requires a private key to connect to the VM that has a public key associated with it. So because of this, we want to keep that private key locally (better yet, in a password manager or something else).

Q: I noticed that we are generating a personal access token when ``` run-terraform.sh ``` is executed. Is this safe?

A: Not sure, we essentially re-use the Azure CLI OAuth token for management.core.azure.com and it allows us to create a PAT from it. We also store this locally on your file system as pat.out so that we don't have to create a new one every time the run-terraform.sh is run. I'd love to see better ways to manage this - please make a PR if you know the answer.
