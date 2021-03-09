resource "azurerm_public_ip" "pip" {
    name                = var.bastion_public_ip_name
    resource_group_name = var.bastion_resource_group_name
    location            = var.bastion_location
    allocation_method   = "Static"
    sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
    name                = var.bastion_name
    resource_group_name = var.bastion_resource_group_name
    location            = var.bastion_location

    ip_configuration {
        name                 = var.bastion_public_ip_name
        subnet_id            = var.subnet_id
        public_ip_address_id = azurerm_public_ip.pip.id
    }
}
