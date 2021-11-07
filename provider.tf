provider "azurerm" {
  features {}
}

  terraform {
    backend "azurerm" {
      resource_group_name  = "packer-image"
      storage_account_name = "fsdamlgngkef"
      container_name       = "terraformstate"
      key                  = "atomic.terraform.tfstate"
      subscription_id = "1d8e3845-11a6-41c1-979e-3b0f59a7c6b2"
      client_id       = "428b8a2a-884a-4f0d-9afa-5c599758e3f7"
      client_secret   = "0UJmdk_q.2UImU0yuLvm3~~14PHkt92tm_"
      tenant_id       = "b3cdedb1-1a1a-4ea8-9f6f-8323d01e2e0b"
    }
  }
