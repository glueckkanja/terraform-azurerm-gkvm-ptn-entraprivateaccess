resource "azurerm_resource_group" "main" {
  count = var.create_resource_group ? 1 : 0

  location = local.location
  name     = var.resource_group_name
  tags     = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Storing the Script in a Storage Account
resource "azurerm_storage_account" "this" {
  account_replication_type = local.storage_account_replication_type
  account_tier             = local.storage_account_tier
  location                 = local.location
  name                     = local.storage_account_name
  resource_group_name      = local.resource_group_name
  tags                     = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_storage_container" "this" {
  name                  = "scripts"
  container_access_type = "blob"
  storage_account_name  = azurerm_storage_account.this.name
}

resource "azurerm_storage_blob" "this" {
  name                   = "InstallEntraPrivateAccess.ps1.zip"
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = azurerm_storage_container.this.name
  type                   = "Block"
  source                 = "InstallEntraPrivateAccess.ps1.zip"
}

# Storing the Secrets in a Key Vault
resource "azurerm_key_vault" "this" {
  location                  = local.location
  name                      = local.key_vault_name
  resource_group_name       = local.resource_group_name
  sku_name                  = local.key_vault_sku
  tenant_id                 = local.tenant_id
  enable_rbac_authorization = local.key_vault_enable_rbac_authorization
  purge_protection_enabled  = local.key_vault_purge_protection_enabled
  tags                      = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "random_password" "admin_password" {
  length           = 16
  override_special = "!#$%&*()-_=+[]{}<>:?"
  special          = true
}

resource "azurerm_key_vault_secret" "admin_password" {
  key_vault_id = azurerm_key_vault.this.id
  name         = local.key_vault_admin_password_secret_name
  value        = random_password.admin_password.result

  depends_on = [
    azurerm_role_assignment.gsa_kv_grp_secret,
    azurerm_role_assignment.gsa_kv_grp_cert,
    azurerm_role_assignment.gsa_kv_vmss_contrib,
    azurerm_role_assignment.gsa_kv_spn_secret,
    azurerm_role_assignment.gsa_kv_spn_cert,
    azurerm_role_assignment.gsa_kv_grp_contrib
  ]
}

resource "azurerm_key_vault_secret" "accesstoken" {
  key_vault_id = azurerm_key_vault.this.id
  name         = local.key_vault_accesstoken_secret_name
  value        = "placeholder"

  depends_on = [
    azurerm_role_assignment.gsa_kv_grp_secret,
    azurerm_role_assignment.gsa_kv_grp_cert,
    azurerm_role_assignment.gsa_kv_vmss_contrib,
    azurerm_role_assignment.gsa_kv_spn_secret,
    azurerm_role_assignment.gsa_kv_spn_cert,
    azurerm_role_assignment.gsa_kv_grp_contrib
  ]

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "azurerm_key_vault_secret" "tenant_id" {
  key_vault_id = azurerm_key_vault.this.id
  name         = local.key_vault_tenantid_secret_name
  value        = local.tenant_id

  depends_on = [
    azurerm_role_assignment.gsa_kv_grp_secret,
    azurerm_role_assignment.gsa_kv_grp_cert,
    azurerm_role_assignment.gsa_kv_vmss_contrib,
    azurerm_role_assignment.gsa_kv_spn_secret,
    azurerm_role_assignment.gsa_kv_spn_cert,
    azurerm_role_assignment.gsa_kv_grp_contrib
  ]
}

# AVM
resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = azurerm_windows_virtual_machine_scale_set.this.id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  principal_type                         = each.value.principal_type
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = format("/subscriptions/%s/resourceGroups/%s", local.subscription_id, local.resource_group_name)
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
}


resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings

  name                           = each.value.name != null ? each.value.name : "diag-gsa"
  target_resource_id             = azurerm_windows_virtual_machine_scale_set.this.id
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  log_analytics_destination_type = each.value.log_analytics_destination_type
  log_analytics_workspace_id     = each.value.workspace_resource_id
  partner_solution_id            = each.value.marketplace_partner_resource_id
  storage_account_id             = each.value.storage_account_resource_id

  dynamic "enabled_log" {
    for_each = each.value.log_categories

    content {
      category = enabled_log.value
    }
  }
  dynamic "enabled_log" {
    for_each = each.value.log_groups

    content {
      category_group = enabled_log.value
    }
  }
  dynamic "metric" {
    for_each = each.value.metric_categories

    content {
      category = metric.value
    }
  }
}
