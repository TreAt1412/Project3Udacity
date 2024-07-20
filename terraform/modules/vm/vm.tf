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
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDLkBDdBheiaJeavFjF4FulotUZ36RWlF65Wx2ooe+JoLlkjChAs41UCYOdm8trT6v3NNdwl32WK3bhMIzdvwZ+XO9A62QEI+19EUbWOkWTU71TC9kL7JY4bFLy4+gf83p5JpCSOXbryq3L5XQqZLW2cwZVdFmL37jHh2cVmGV46rJ7hkTksvrhHQ3D71yz773Jd+mlQoIP4GxzuNGSfRp7qJ7pM678EfAfbmsP68Oi11yT14O79PGtoajtM/O6J2cs9M8SSlofcz6SJQlrMix89Q/Aa10Net7gdhJhXTOJDQBgvbh/5BUjzYcVF+akcTjn7DLxzFopRO8/CmPPRi3 dovietanh74@gmail.com"
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