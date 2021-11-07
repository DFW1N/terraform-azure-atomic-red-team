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

# terraform-azure-atomic-red-team
---
Module used for using Terraform to build and deploy a windows environment that creates a virtual machine and installs and executes atomic red team commands to mimic red teaming.

# Module Usage
---

    module "atomic" {
      source  = "app.terraform.io/DFW1N/atomic/azurerm"
      version = "1.0.1"
    }

# Usage Example
---

    module "atomic" {
      source  = "app.terraform.io/DFW1N/atomic/azurerm"
      version = "1.0.1"
      admin_password = "yourstring"
      admin_password = "yourstring"
    }

## Arguments
---
| Name | Type | Required | Description |
| --- | --- | --- | --- |
| `is_custom_image` | `bool` | true | Defaults to `false`. Defines whether a custom image is to be used to deploy the VM or not. | 
| `image_id` | `string` | false | If deploying from a custom VM Image. The ID of the Custom Azure VM Image the new VM should be deployed from. |
| `rg_name` | `string` | true | The name of the Resource group where the new VM will be deployed. |
| `location` | `string` | true| The Azure Region where the VM will be deployed. |
| `subnet_id` | `string` | true | The ID of the Azure Subnet where the main NIC of the VM will be created. |
| `vm_name` | `string` | true | The name to assign to the new Virtual machine. |
| `admin_username` | `string` | true | The username for the Admin User Account. |
| `admin_password` | `string` | true | The password to assign to the new Admin username. |
| `diagnostics_storage_account_name` | `string` | true | The storage account to use for VM Boot diagnostics. |
