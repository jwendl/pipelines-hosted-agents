variable "vm_name" {
    description = "The virtual machine name"
}

variable "vm_resource_group_name" {
    description = "The virtual machine resource group name"
}

variable "vm_resource_group_id" {
    description = "The azure resource id for the resource group"
}

variable "vm_location" {
    description = "The virtual machine location"
}

variable "vm_subnet_id" {
    description = "The virtual machine subnet azure resource id"
}

variable "vm_size" {
    description = "The virtual machine vm size"
}

variable "vm_root_user" {
    description = "The virtual machine root user"
}

variable "vm_user_pub_key_path" {
    description = "The virtual machine user public key"
}

variable "azdo_keyvault_name" {
    description = "The name of the keyvault for the azdo pat"
}

variable "azdo_key_vault_id" {
    description = "The keyvault id where the azdo pat is"
}

variable "azurerm_user_assigned_identity_name" {
    description = "The azurerm user assigned identity resource name"
}

variable "azurerm_network_interface_name" {
    description = "The azurerm network interface resource name"
}

variable "azurerm_virtual_machine_extension_name" {
    description = "The azurerm virtual machine extension resource name"
}

variable "azdo_org_path" {
    description = "The Azure DevOps Org Path"
}

variable "azdo_pat" {
    description = "The Azure DevOps PAT"
}

variable "number_of_instances" {
    description = "The number of instances to install"
}
