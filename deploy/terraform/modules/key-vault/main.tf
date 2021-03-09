data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault" "kv" {
    name                        = var.key_vault_name
    resource_group_name         = var.key_vault_resource_group_name
    location                    = var.key_vault_location
    tenant_id                   = var.key_vault_tenant_id

    sku_name = var.sku_name

    network_acls {
        default_action = "Allow"
        bypass         = "None"
    }
}

resource "azurerm_key_vault_access_policy" "azdokvap" {
    key_vault_id = azurerm_key_vault.kv.id

    tenant_id = data.azurerm_subscription.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
        "get", "list", "set",
    ]
}

resource "azurerm_private_dns_zone" "kv" {
    name                = "privatelink.vaultcore.azure.net"
    resource_group_name = var.key_vault_resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv" {
    name                  = "kv"
    resource_group_name   = var.key_vault_resource_group_name
    private_dns_zone_name = azurerm_private_dns_zone.kv.name
    virtual_network_id    = var.vnet_id
}
