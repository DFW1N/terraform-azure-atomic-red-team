######################################################################################################################################
                                                              __¦¦¦¦¦¦¦¦¦¦¦__ 
                                                         _¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦_ 
              ¦¦¦¦¦¦+ ¦¦¦¦¦¦¦+ ¦¦¦¦¦+ ¦¦¦¦¦¦¦¦+¦¦+  ¦+  _¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦_    ¦¦¦¦¦¦¦+¦¦¦¦¦¦+  ¦¦¦¦¦¦+ ¦¦¦+   ¦¦¦+ 
              ¦¦+--¦¦+¦¦+----+¦¦+--¦¦++--¦¦+--+¦¦¦  ¦¦ ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦   ¦¦+----+¦¦+--¦¦+¦¦+---¦¦+¦¦¦¦+ ¦¦¦¦¦ 
              ¦¦¦  ¦¦¦¦¦¦¦¦+  ¦¦¦¦¦¦¦¦   ¦¦¦   ¦¦¦¦¦¦¦¯¦¦¦¦¦¦¦¦¯¯¯¦¦¦¦¦¦¦¦¦¯¯¦¦¦¦¦¦¦¦¦  ¦¦¦¦¦+  ¦¦¦¦¦¦++¦¦¦   ¦¦¦¦¦+¦¦¦¦+¦¦¦ 
              ¦¦¦  ¦¦¦¦¦+--+  ¦¦+--¦¦¦   ¦¦¦   ¦¦+--¦¦ ¦¦¦¦¦¯¯      ¯¦¦¦¦       ¦¦¦¦¦¯¦ ¦¦+--+  ¦¦+--¦¦+¦¦¦   ¦¦¦¦¦¦+¦¦++¦¦¦ 
              ¦¦¦¦¦¦++¦¦¦¦¦¦¦+¦¦¦  ¦¦¦   ¦¦¦   ¦¦¦  ¦¦  ¦¦          _¦¦¦_         ¯¦¦   ¦¦¦     ¦¦¦  ¦¦¦+¦¦¦¦¦¦++¦¦¦ +-+ ¦¦¦ 
              +-----+ +------++-+  +-+   +-+   +-+  ++ ¦¦¦         ¦¦¦__¦¦          ¦   +-+     +-+  +-+ +-----+ +-+     +-+ 
                                                       ¯¦¯         ¦¦¦¦¦¦¦          ¦¦ 
                                                       ¦¦         _¦¯   ¯¦¦_         ¦_ 
                                                       ¦¦¦ ¦    _¦¦      ¦¦¦¦_______¦¦¦ 
                                                      ¦¦¯ ¯¯¦¯¯_¦¦¦   _   ¦¦¦  ¯¯¯   ¦¦¦ 
                                                      ¦_       ¦¦¦¦¦_¦¦¦__¦¦¯¦¦¦      ¦¦ 
                                                     ¯ ¯¯¯¯___¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦_¦¦¦___ 
                                                             ¯¦¦¦¦¯¯¯_ _  ¯¦¦¦¦ ¦¦¯¦¯¯ 
                                                              ¯ __¦¦¯¦¯¯¯¦¦¦_ ¯ 
                                                             __¯¯             _ 

                                                 ¦¦+    ¦¦+¦¦+¦¦¦¦¦¦¦¦+¦¦+  ¦¦+¦¦+¦¦¦+   ¦¦+ 
                                                 ¦¦¦    ¦¦¦¦¦¦+--¦¦+--+¦¦¦  ¦¦¦¦¦¦¦¦¦¦+  ¦¦¦ 
                                                 ¦¦¦ ¦+ ¦¦¦¦¦¦   ¦¦¦   ¦¦¦¦¦¦¦¦¦¦¦¦¦+¦¦+ ¦¦¦ 
                                                 ¦¦¦¦¦¦+¦¦¦¦¦¦   ¦¦¦   ¦¦+--¦¦¦¦¦¦¦¦¦+¦¦+¦¦¦ 
                                                 +¦¦¦+¦¦¦++¦¦¦   ¦¦¦   ¦¦¦  ¦¦¦¦¦¦¦¦¦ +¦¦¦¦¦ 
                                                  +--++--+ +-+   +-+   +-+  +-++-++-+  +---+ 
#####################################################################################################################################

####################
## Resource Group ##
####################

resource "azurerm_resource_group" "rg-atomic-red-team" {
  name                = "rg-atomic-red-team"
  location            = "West Europe"
  tags = {
    modules           = "atomic-red-team"
    author            = "Sacha Roussakis-Notter (DFW1N)"
    repo              = "https://github.com/DFW1N/terraform-azure-atomic-red-team"
    assessment        = "red-teaming-activity"
  }
}

#####################
## Virtual Network ##
#####################

resource "azurerm_virtual_network" "atomic-vnet" {
  depends_on          = [azurerm_network_security_group.atomic-nsg]
  name                = "virtualNetwork1"
  location            = azurerm_resource_group.rg-atomic-red-team.location
  resource_group_name = azurerm_resource_group.rg-atomic-red-team.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name              = "atomic-snet"
    address_prefix    = "10.0.3.0/24"
    security_group    = azurerm_network_security_group.atomic-nsg.id
  }

  tags = {
    modules           = "atomic-red-team"
    author            = "Sacha Roussakis-Notter (DFW1N)"
    repo              = "https://github.com/DFW1N/terraform-azure-atomic-red-team"
  }
}

############################
## Network Security Group ##
############################

resource "azurerm_network_security_group" "atomic-nsg" {
  name                = "AtomicRedTeamNetworkSecurityGroup"
  location            = azurerm_resource_group.rg-atomic-red-team.location
  resource_group_name = azurerm_resource_group.rg-atomic-red-team.name
}
