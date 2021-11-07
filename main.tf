##############################################
# Author: Sacha Roussakis-Notter (DFW1N)     #
#                                           
# Th

resource "azurerm_resource_group" "rg-atomic-red-team" {
  name     = "rg-atomic-red-team"
  location = "West Europe"
}
