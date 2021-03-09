variable "resource_group_name" {
    description = "The resource group name."
}

variable "resource_group_location" {
  description = "The location of the environment."
}

variable "resource_prefix" {
    description = "The prefix for all the resources."
}

variable "resource_suffix" {
    description = "The suffix for all the resources."
}

variable "number_of_instances" {
    description = "The number of agents to run"
}

variable "azdo_org_path" {
    description = "The azdo org path url"
}

variable "azdo_pat" {
    description = "The azdo PAT"
}

# Acronyms

# Bastion

variable "azure_bastion_acrn" {
    description = "3 letters acronym for azure bastion resource name."
    default = "bas"
}

variable "bastion_ip_configuration_acrn" {
    description = "3 letters acronym for bastion ip configuration resource name."
    default = "pip"
}

# Azure pipelines

variable "azure_pipelines_vm_acrn" {
    description = "3 letters acronym for azure pipelines vm resource name."
    default = "apl"
}

variable "azurerm_user_assigned_identity_acrn" {
    description = "3 letters acronym for the azurerm user assigned identity resource name."
    default = "umi"
}

variable "azurerm_network_interface_acrn" {
    description = "3 letters acronym for the azurerm network interface resource name."
    default = "nic"
}

variable "azurerm_virtual_machine_extension_acrn" {
    description = "3 letters acronym for the azurerm virtual machine extension resource name."
    default = "ext"
}

# Keyvault

variable "key_vault_acrn" {
    description = "3 letters acronym for the keyvault resource name."
    default = "akv"
}

variable "keyvault_private_endpoint_acrn" {
    description = "3 letters acronym for the keyvault private endpoint resource name"
    default = "kpe"
}

variable "keyvault_private_service_connection_acrn" {
    description = "3 letters acronym for the keyvault private service connection resource name"
    default = "kps"
}

# Virtual Network

variable "virtual_network_acrn" {
    description = "3 letters acronym for the vnet resource name."
    default = "vnt"
}

variable "azurern_subnet_cluster_acrn" {
    description = "3 letters acronym for the azurern subnet cluster resource name."
    default = "scv"
}
