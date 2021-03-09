variable "bastion_name" {
    description = "The bastion resource name"
}

variable "bastion_public_ip_name" {
    description = "The bastion public ip resource name"
}

variable "bastion_resource_group_name" {
    description = "The resource group to put the bastion resource in"
}

variable "bastion_location" {
    description = "The location for the bastion resource"
}

variable "subnet_id" {
    description = "The subnet id for the bastion resource to exist in"
}
