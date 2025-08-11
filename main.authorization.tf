# GSA Owner Group
resource "azuread_group" "gsa_owner" {
  count = var.create_gsa_owner_group ? 1 : 0

  display_name = "gsa-owner"

  security_enabled = true

  lifecycle {
    ignore_changes = [
      members,
      owners
    ]
  }
}

# Role Assignments
resource "azurerm_role_assignment" "gsa_kv_vmss_secret" {
  principal_id         = azurerm_windows_virtual_machine_scale_set.this.identity[0].principal_id
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets Officer"
}

resource "azurerm_role_assignment" "gsa_kv_vmss_cert" {
  principal_id         = azurerm_windows_virtual_machine_scale_set.this.identity[0].principal_id
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Certificates Officer"
}

resource "azurerm_role_assignment" "gsa_sa_vmss_data_owner" {
  principal_id         = azurerm_windows_virtual_machine_scale_set.this.identity[0].principal_id
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Owner"
}

resource "azurerm_role_assignment" "gsa_sa_grp_data_owner" {
  principal_id         = local.gsa_owner_group_id
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
}

resource "azurerm_role_assignment" "gsa_kv_grp_secret" {
  principal_id         = local.gsa_owner_group_id
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets Officer"
}

resource "azurerm_role_assignment" "gsa_kv_grp_cert" {
  principal_id         = local.gsa_owner_group_id
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Certificates Officer"
}

resource "azurerm_role_assignment" "gsa_kv_spn_secret" {
  count = local.spn_id != "" ? 1 : 0

  principal_id         = local.spn_id
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets Officer"
}

resource "azurerm_role_assignment" "gsa_kv_spn_cert" {
  count = local.spn_id != "" ? 1 : 0

  principal_id         = local.spn_id
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Certificates Officer"
}
