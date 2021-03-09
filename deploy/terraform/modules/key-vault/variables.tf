variable "key_vault_name" {
    description = "The key vault name."
}

variable "key_vault_resource_group_name" {
    description = "The key vault resource group name."
}

variable "key_vault_location" {
    description = "The key vault location."
}

variable "key_vault_tenant_id" {
    description = "The key vault tenant."
}

variable "sku_name" {
    default     = "standard"
    description = "The SKU for Key Vault. Acceptable values are: standard, premium."
}

variable "subnet_id" {
    description = "The subnet id"
}

variable "vnet_id" {
    description = "The vnet id"
}

variable "keyvault_private_endpoint_name" {
    description = "The keyvault private endpoint resource name"
}

variable "keyvault_private_service_connection_name" {
    description = "The keyvault private service connection resource name"
}
