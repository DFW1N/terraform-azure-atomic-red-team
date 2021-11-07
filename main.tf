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
#                                             ManagedBy:        Sacha Roussakis-Notter (DFW1N)                                         #
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
  name                         = "atomic-virtual-network"
  location                     = azurerm_resource_group.rg-atomic-red-team.location
  resource_group_name          = azurerm_resource_group.rg-atomic-red-team.name
  address_space                = ["10.0.0.0/16"]
  dns_servers                  = ["8.8.8.8", "8.8.4.4"]

  tags = {
    modules                    = "atomic-red-team"
    author                     = "Sacha Roussakis-Notter (DFW1N)"
    repo                       = "https://github.com/DFW1N/terraform-azure-atomic-red-team"
    assessment                 = "red-teaming-activity"
  }
}

####################
## Network Subnet ##
####################

resource "azurerm_subnet" "atomic-snet" {
  name                 = "atomic-snet"
  resource_group_name  = azurerm_resource_group.rg-atomic-red-team.name
  virtual_network_name = azurerm_virtual_network.atomic-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  }

################################
## Network Subnet Association ##
################################

resource "azurerm_subnet_network_security_group_association" "atomic-snet-association" {
  subnet_id                 = azurerm_subnet.atomic-snet.id
  network_security_group_id = azurerm_network_security_group.atomic-nsg.id
}

############################
## Network Security Group ##
############################

resource "azurerm_network_security_group" "atomic-nsg" {
  name                         = "AtomicRedTeamNetworkSecurityGroup"
  location                     = azurerm_resource_group.rg-atomic-red-team.location
  resource_group_name          = azurerm_resource_group.rg-atomic-red-team.name
  
  security_rule {
    name                       = "Allow_RDP_Atomic"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "3389"
    destination_port_range     = "0.0.0.0/0"
    source_address_prefix      = "0.0.0.0/0"
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
  name                = "atomic-win-vm"
  resource_group_name = azurerm_resource_group.rg-atomic-red-team.name
  location            = azurerm_resource_group.rg-atomic-red-team.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "Pgknqjkglerlk2346236%@#$@F"
  network_interface_ids = [
    azurerm_network_interface.atomic-nic-interface.id,
  ]

  os_disk {
    name                 = "atomic-win-vm-osdisk" 
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  boot_diagnostics {
    storage_account_uri   = azurerm_storage_account.atomic-sa.primary_blob_endpoint
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

##############################
# VIRTUAL MACHINE EXTENSTION #
##############################

resource "azurerm_virtual_machine_extension" "Atomic-Win-Extenstion" {
  name                 = "Azure_Choco_Install_Extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.atomic-windows-vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<SETTINGS
  {
    "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.tf.rendered)}')) | Out-File -filepath install.ps1\" && powershell -ExecutionPolicy Unrestricted -File install.ps1"
  }
  SETTINGS
}

#####################
# POWERSHELL SCRIPT #
#####################

data "template_file" "tf" {
    template = "${file("${path.module}/install.ps1")}"
} 