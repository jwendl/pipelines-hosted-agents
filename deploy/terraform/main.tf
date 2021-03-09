data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "rg" {
    name     = var.resource_group_name
    location = var.resource_group_location
}

module "network" {
    source                      = "./modules/network"
    vnet_name                   = "${var.resource_prefix}${var.virtual_network_acrn}${var.resource_suffix}"
    net_resource_group_name     = azurerm_resource_group.rg.name
    net_location                = azurerm_resource_group.rg.location
    subnet_cluster_name         = "${var.resource_prefix}${var.azurern_subnet_cluster_acrn}${var.resource_suffix}"
}

module "key_vault" {
    source                                    = "./modules/key-vault"
    key_vault_name                            = "${var.resource_prefix}${var.key_vault_acrn}${var.resource_suffix}"
    key_vault_resource_group_name             = azurerm_resource_group.rg.name
    key_vault_location                        = azurerm_resource_group.rg.location
    key_vault_tenant_id                       = data.azurerm_subscription.current.tenant_id
    vnet_id                                   = module.network.vnet_id
    subnet_id                                 = module.network.cluster_subnet_id
    keyvault_private_endpoint_name            = "${var.resource_prefix}${var.keyvault_private_endpoint_acrn}${var.resource_suffix}"
    keyvault_private_service_connection_name  = "${var.resource_prefix}${var.keyvault_private_service_connection_acrn}${var.resource_suffix}"
}

module "bastion" {
    source                      = "./modules/bastion"
    bastion_name                = "${var.resource_prefix}${var.azure_bastion_acrn}${var.resource_suffix}"
    bastion_public_ip_name      = "${var.resource_prefix}${var.bastion_ip_configuration_acrn}${var.resource_suffix}"
    bastion_resource_group_name = azurerm_resource_group.rg.name
    bastion_location            = azurerm_resource_group.rg.location
    subnet_id                   = module.network.bastion_subnet_id
}

module "agents" {
    source                                  = "./modules/agents"
    vm_name                                 = "${var.resource_prefix}${var.azure_pipelines_vm_acrn}${var.resource_suffix}"
    vm_resource_group_id                    = azurerm_resource_group.rg.id
    vm_resource_group_name                  = azurerm_resource_group.rg.name
    vm_location                             = azurerm_resource_group.rg.location
    vm_subnet_id                            = module.network.cluster_subnet_id
    vm_size                                 = "Standard_D8_v3"
    vm_root_user                            = "adminuser"
    vm_user_pub_key_path                    = "id_rsa.pub"
    azdo_key_vault_id                       = module.key_vault.key_vault_id
    azdo_keyvault_name                      = module.key_vault.key_vault_name
    azurerm_user_assigned_identity_name     = "${var.resource_prefix}${var.azurerm_user_assigned_identity_acrn}${var.resource_suffix}"
    azurerm_network_interface_name          = "${var.resource_prefix}${var.azurerm_network_interface_acrn}${var.resource_suffix}"
    azurerm_virtual_machine_extension_name  = "${var.resource_prefix}${var.azurerm_virtual_machine_extension_acrn}${var.resource_suffix}"
    number_of_instances                     = var.number_of_instances
    azdo_org_path                           = var.azdo_org_path
    azdo_pat                                = var.azdo_pat
}
