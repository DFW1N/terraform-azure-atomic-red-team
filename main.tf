########################################################################################################################################
#                                                                                                                                      #
#       ________  ________  ___  ___  ________  _______           ________  _________  ________  _____ ______   ___  ________          #
#      |\   __  \|\_____  \|\  \|\  \|\   __  \|\  ___ \         |\   __  \|\___   ___\\   __  \|\   _ \  _   \|\  \|\   ____\         # 
#      \ \  \|\  \\|___/  /\ \  \\\  \ \  \|\  \ \   __/|        \ \  \|\  \|___ \  \_\ \  \|\  \ \  \\\__\ \  \ \  \ \  \___|         # 
#       \ \   __  \   /  / /\ \  \\\  \ \   _  _\ \  \_|/__       \ \   __  \   \ \  \ \ \  \\\  \ \  \\|__| \  \ \  \ \  \            #
#        \ \  \ \  \ /  /_/__\ \  \\\  \ \  \\  \\ \  \_|\ \       \ \  \ \  \   \ \  \ \ \  \\\  \ \  \    \ \  \ \  \ \  \____       #
#         \ \__\ \__\\________\ \_______\ \__\\ _\\ \_______\       \ \__\ \__\   \ \__\ \ \_______\ \__\    \ \__\ \__\ \_______\     #
#          \|__|\|__|\|_______|\|_______|\|__|\|__|\|_______|        \|__|\|__|    \|__|  \|_______|\|__|     \|__|\|__|\|_______|     #
#                          ________  _______   ________          _________  _______   ________  _____ ______                           #
#                         |\   __  \|\  ___ \ |\   ___ \        |\___   ___\\  ___ \ |\   __  \|\   _ \  _   \                         #
#                         \ \  \|\  \ \   __/|\ \  \_|\ \       \|___ \  \_\ \   __/|\ \  \|\  \ \  \\\__\ \  \                        #
#                          \ \   _  _\ \  \_|/_\ \  \ \\ \           \ \  \ \ \  \_|/_\ \   __  \ \  \\|__| \  \                       #
#                           \ \  \\  \\ \  \_|\ \ \  \_\\ \           \ \  \ \ \  \_|\ \ \  \ \  \ \  \    \ \  \                      #
#                            \ \__\\ _\\ \_______\ \_______\           \ \__\ \ \_______\ \__\ \__\ \__\    \ \__\                     #
#                             \|__|\|__|\|_______|\|_______|            \|__|  \|_______|\|__|\|__|\|__|     \|__|                     #                                                                                                                    
#                                                                                                                                      #
#                                             Project:          Azure Terraform Atomic Red Team                                        #
#                                             Creator:          Sacha Roussakis-Notter (DFW1N)                                         #
#                                             Creation Date:    Sunday, November 7th 2021, 10:16 pm                                    #
#                                                                                                                                      #
########################################################################################################################################

####################
## Resource Group ##
####################

resource "azurerm_resource_group" "rg-atomic-red-team" {
  name                         = "rg-atomic-red-teaming"
  location                     = "Australia East"
  
  tags = {
    modules                    = "atomic-red-team"
    author                     = "Sacha Roussakis-Notter (DFW1N)"
    repo                       = "https://github.com/DFW1N/terraform-azure-atomic-red-team"
    assessment                 = "red-teaming-activity"
  }
}

#####################
## Storage Account ##
#####################

resource "azurerm_storage_account" "atomic-sa" {
  depends_on                   = [random_string.random-atomic-strings]
  name                         = "atomicsa${random_string.random-atomic-strings.result}"
  resource_group_name          = azurerm_resource_group.rg-atomic-red-team.name
  location                     = azurerm_resource_group.rg-atomic-red-team.location
  account_tier                 = "Standard"
  account_replication_type     = "GRS"
  min_tls_version              = "TLS1_2" 
  
  tags = {
    modules                    = "atomic-red-team"
    author                     = "Sacha Roussakis-Notter (DFW1N)"
    repo                       = "https://github.com/DFW1N/terraform-azure-atomic-red-team"
    assessment                 = "red-teaming-activity"
  }
}

#####################
## Virtual Network ##
#####################

resource "azurerm_virtual_network" "atomic-vnet" {
  depends_on                   = [azurerm_network_security_group.atomic-nsg]
  name                         = "virtualNetwork1"
  location                     = azurerm_resource_group.rg-atomic-red-team.location
  resource_group_name          = azurerm_resource_group.rg-atomic-red-team.name
  address_space                = ["10.0.0.0/16"]
  dns_servers                  = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name                       = "atomic-snet"
    address_prefix                      = "10.0.3.0/24"
    security_group             = azurerm_network_security_group.atomic-nsg.id
  }

  tags = {
    modules                    = "atomic-red-team"
    author                     = "Sacha Roussakis-Notter (DFW1N)"
    repo                       = "https://github.com/DFW1N/terraform-azure-atomic-red-team"
    assessment                 = "red-teaming-activity"
  }
}

############################
## Network Security Group ##
############################

resource "azurerm_network_security_group" "atomic-nsg" {
  name                         = "AtomicRedTeamNetworkSecurityGroup"
  location                     = azurerm_resource_group.rg-atomic-red-team.location
  resource_group_name          = azurerm_resource_group.rg-atomic-red-team.name
  
  security_rule {
    name                       = "AtomicAllowAll"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    modules                    = "Atomic-Red-Team"
    author                     = "Sacha Roussakis-Notter (DFW1N)"
    repo                       = "https://github.com/DFW1N/terraform-azure-atomic-red-team"
    assessment                 = "red-teaming-activity"
  }
}

#############################
## Azure Public IP Address ##
#############################

resource "azurerm_public_ip" "atomic-pip" {
  name                         = "atomic-public-ip"
  resource_group_name          = azurerm_resource_group.rg-atomic-red-team.name
  location                     = azurerm_resource_group.rg-atomic-red-team.location
  allocation_method            = "Dynamic"

  tags = {
    modules                    = "atomic-red-team"
    author                     = "Sacha Roussakis-Notter (DFW1N)"
    repo                       = "https://github.com/DFW1N/terraform-azure-atomic-red-team"
    assessment                 = "red-teaming-activity"
  }

}

###################
## Random String ##
###################

resource "random_string" "random-atomic-strings" {
  length                       = 8
  special                      = false
  lower                        = true
  upper                        = false
  number                       = true
}

#######################################
## Virtual Machine Network Interface ##
#######################################

resource "azurerm_network_interface" "atomic-nic-interface" {
  depends_on                   = [azurerm_public_ip.atomic-pip]
  name                         = "atomic-win-${random_string.random-atomic-strings.result}-vm-nic"
  resource_group_name          = azurerm_resource_group.rg-atomic-red-team.name
  location                     = azurerm_resource_group.rg-atomic-red-team.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.atomic-snet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.atomic-pip.id
  }

  tags = {
    modules                    = "atomic-red-team"
    author                     = "Sacha Roussakis-Notter (DFW1N)"
    repo                       = "https://github.com/DFW1N/terraform-azure-atomic-red-team"
    assessment                 = "red-teaming-activity"
  }
}

#############################
## Windows Virtual Machine ##
#############################

resource "azurerm_windows_virtual_machine" "atomic-windows-vm" {
  name                = "atomic-winsvr10-vm"
  resource_group_name = azurerm_resource_group.rg-atomic-red-team.name
  location            = azurerm_resource_group.rg-atomic-red-team.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.atomic-nic-interface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  
  tags = {
    modules                    = "atomic-red-team"
    author                     = "Sacha Roussakis-Notter (DFW1N)"
    repo                       = "https://github.com/DFW1N/terraform-azure-atomic-red-team"
    assessment                 = "red-teaming-activity"
  }
}
