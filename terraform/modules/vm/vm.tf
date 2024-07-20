resource "azurerm_network_interface" "test" {
  name                = "udacity-project-3-NIC"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip
  }
}

resource "azurerm_linux_virtual_machine" "test" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group
  size                  = "Standard_B2s"
  admin_username        = var.admin_username
#  source_image_id       = var.packer_image
  disable_password_authentication = true

  network_interface_ids = [azurerm_network_interface.test.id]
  admin_ssh_key {
    username   = var.admin_username
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDS88gCj7A1id/VEdaE0BRAGAfXIuue6b+p+/XKMtcuus4O+EIBhk3/A+ddQ60OfOZ/KhHVCy4pHXfkC7IdXJ2AbL2alwFXjWyBNoMvxAz9laleRctzNheR4om+vC+TclzXl8ZOAXlhN8tdUohH/dNrOW2QT+xeIcluobD/qmWCwfi+/OxExdZLQkpw2g3VmeAXhzqnXItKpNUCRgFZhetxBQ+inQE6tVZSIz1U5CiT1apthRPPfNIO3NkpAEC1tSiTfg0HA+6uQUgozwqy5KzvkDcsRkKXp8p7wrPjTAwFxBlxYZ5jdS9ifYFl4WdOfdGey70LOvb7ZzAkI+dITUaP1QRm2m6dbEOp5M0rhFe6UfYXM/3F2tzrFzytv1aktF7aplZY8Jv0moaxmBSs89vRMaYv0B8jSem6few3Jhs7/JNfBP3G5TwFBdrRoyYLF+cXkuQlOzxqHcrw52gu52icw0UMmbUUfV4+ARLUd1EIJ7kikDITWTmWzZSTwoJ6fIc= odl_user@SandboxHost-638570262085077533"
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