#!/bin/bash

while getopts ":u:p:a:" arg; do
    case $arg in
        u) AzdoOrganizationUrl=$OPTARG;;
        p) AzdoProjectName=$OPTARG;;
    esac
done

usage() {
    script_name=`basename $0`
    echo "Please use ./$script_name -u azdo-organization-url -p azdo-project-name"
}

if [ -z "$AzdoOrganizationUrl" ]; then
    usage
    exit 1
fi
if [ -z "$AzdoProjectName" ]; then
    usage
    exit 1
fi

orgName=$(echo "$AzdoOrganizationUrl" | awk -F/ '{print $4}')
token=$(az account get-access-token)

if [[ -f pat.out ]]; then
    pat=$(<pat.out)
else
    echo "PAT file not found, fetching from azdo"
    pat=$(az rest --method post --uri "https://vssps.dev.azure.com/$orgName/_apis/Tokens/Pats?api-version=6.1-preview" --resource "https://management.core.windows.net/" --body '{ "displayName": "AgentPAT" }' --headers "Content-Type"="application/json" --query patToken.token --output tsv)
    echo $pat > pat.out
fi

AZDO_ORG_SERVICE_URL=$AzdoOrganizationUrl
AZDO_PERSONAL_ACCESS_TOKEN=$pat

terraform init
terraform plan -out tf.plan --var-file values.tfvars -var azdo_org_path=$AzdoOrganizationUrl -var azdo_pat=$pat
terraform apply tf.plan
