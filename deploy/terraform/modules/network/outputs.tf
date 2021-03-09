output "vnet_id" {
    value = azurerm_virtual_network.vnet.id
}

output "cluster_subnet_id" {
    value = azurerm_subnet.cluster.id
}

output "bastion_subnet_id" {
    value = azurerm_subnet.bastion.id
}
