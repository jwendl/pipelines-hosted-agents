data "azurerm_subscription" "current" {
}

resource "azurerm_user_assigned_identity" "umi" {
    name                = var.azurerm_user_assigned_identity_name
    resource_group_name = var.vm_resource_group_name
    location            = var.vm_location
}

resource "azurerm_role_assignment" "umira" {
    scope                            = var.vm_resource_group_id
    role_definition_name             = "Contributor"
    principal_id                     = azurerm_user_assigned_identity.umi.principal_id
    skip_service_principal_aad_check = true
}

resource "azurerm_key_vault_access_policy" "rgkvap" {
    key_vault_id = var.azdo_key_vault_id

    tenant_id = data.azurerm_subscription.current.tenant_id
    object_id = azurerm_user_assigned_identity.umi.principal_id

    secret_permissions = [
        "get", "list", "set",
    ]
}

resource "azurerm_network_interface" "nic" {
    count               = var.number_of_instances
    name                = "${var.azurerm_network_interface_name}-${count.index}"
    resource_group_name = var.vm_resource_group_name
    location            = var.vm_location

    ip_configuration {
        name                          = "internal"
        subnet_id                     = var.vm_subnet_id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_linux_virtual_machine" "vm" {
    count               = var.number_of_instances
    name                = "${var.vm_name}-${count.index}"
    resource_group_name = var.vm_resource_group_name
    location            = var.vm_location 
    size                = var.vm_size
    admin_username      = var.vm_root_user

    network_interface_ids = [
        azurerm_network_interface.nic[count.index].id,
    ]

    admin_ssh_key {
        username   = var.vm_root_user
        public_key = file(var.vm_user_pub_key_path)
    }

    identity {
        type = "UserAssigned"
        identity_ids = [
            azurerm_user_assigned_identity.umi.id
        ]
    }

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }
}

resource "azurerm_virtual_machine_extension" "script" {
    count                = var.number_of_instances    
    name                 = "${var.azurerm_virtual_machine_extension_name}-${count.index}"
    virtual_machine_id   = azurerm_linux_virtual_machine.vm[count.index].id
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"

    settings = <<SETTINGS
        {
            "script": "${base64encode(templatefile("./bootstrap.sh", {
                azdoOrgPath = var.azdo_org_path,
                azdoPat = var.azdo_pat,
                azdoAgentName = azurerm_linux_virtual_machine.vm[count.index].name
            }))}"
        }
    SETTINGS
}
