# terraform-azure-atomic-red-team
---
Module used for using Terraform to build and deploy a windows environment that creates a virtual machine and installs and executes atomic red team commands to mimic red teaming.

# Example Usage
---

    module "atomic" {
      source  = "app.terraform.io/DFW1N/atomic/azurerm"
      version = "1.0.1"
    }

## Arguments
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
