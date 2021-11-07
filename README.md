# terraform-azure-atomic-red-team
---
Module used for using Terraform to build and deploy a windows environment that creates a virtual machine and installs and executes atomic red team commands to mimic red teaming.

# Example Usage
---

    module "atomic" {
      source  = "app.terraform.io/DFW1N/atomic/azurerm"
      version = "1.0.1"
    }
