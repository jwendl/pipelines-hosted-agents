data "azurerm_subscription" "current" {
}

resource "azurerm_virtual_network" "vnet" {
    name                = var.vnet_name
    resource_group_name = var.net_resource_group_name
    location            = var.net_location
    address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "cluster" {
    virtual_network_name  = azurerm_virtual_network.vnet.name
    resource_group_name   = var.net_resource_group_name
    name                  = var.subnet_cluster_name
    address_prefixes      = ["10.1.5.0/24"]

  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "bastion" {
    virtual_network_name  = azurerm_virtual_network.vnet.name
    resource_group_name   = var.net_resource_group_name
    name                  = "AzureBastionSubnet"
    address_prefixes      = ["10.1.6.0/24"]
}
