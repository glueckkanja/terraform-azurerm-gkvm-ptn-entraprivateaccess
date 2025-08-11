terraform {
  required_version = "~> 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.39"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  subscription_id                 = var.subscription_id
  use_oidc                        = true
  features {}
}

data "azurerm_client_config" "current" {}

module "gsa" {
  source  = "glueckkanja/gkvm-ptn-entraprivateaccess/azurerm"
  version = "0.1.0"

  subscription_id        = var.subscription_id
  tenant_id              = data.azurerm_client_config.current.tenant_id
  create_gsa_owner_group = var.create_gsa_owner_group
  create_resource_group  = var.create_resource_group
  debug_mode             = var.debug_mode
  # AVM Defaults
  diagnostic_settings                  = var.diagnostic_settings
  enable_telemetry                     = var.enable_telemetry
  gsa_owner_group_id                   = var.gsa_owner_group_id
  key_vault_accesstoken_secret_name    = var.key_vault_accesstoken_secret_name
  key_vault_admin_password_secret_name = var.key_vault_admin_password_secret_name
  key_vault_enable_rbac_authorization  = var.key_vault_enable_rbac_authorization
  key_vault_name                       = var.key_vault_name
  key_vault_purge_protection_enabled   = var.key_vault_purge_protection_enabled
  key_vault_sku                        = var.key_vault_sku
  key_vault_tenantid_secret_name       = var.key_vault_tenantid_secret_name
  location                             = var.location
  resource_group_name                  = var.resource_group_name
  role_assignments                     = var.role_assignments
  scale_set_instances                  = var.scale_set_instances
  scale_set_name                       = var.scale_set_name
  scale_set_sku                        = var.scale_set_sku
  scale_set_subnet_id                  = var.scale_set_subnet_id
  scale_set_username                   = var.scale_set_username
  spn_id                               = var.spn_id
  storage_account_name                 = var.storage_account_name
  storage_account_replication_type     = var.storage_account_replication_type
  storage_account_tier                 = var.storage_account_tier
  tags                                 = var.tags
}
