resource "azurerm_windows_virtual_machine_scale_set" "this" {
  count = local.scale_set_orchestration_mode == "Uniform" ? 1 : 0

  admin_password      = local.scale_set_password
  admin_username      = local.scale_set_username
  instances           = local.scale_set_instances
  location            = local.location
  name                = local.scale_set_name
  resource_group_name = local.resource_group_name
  sku                 = local.scale_set_sku
  tags                = var.tags

  network_interface {
    name    = "default"
    primary = true

    ip_configuration {
      name      = "gsa"
      primary   = true
      subnet_id = local.scale_set_subnet_id

      dynamic "public_ip_address" {
        for_each = local.debug_mode ? [1] : []

        content {
          name = "gsa-pip"
        }
      }
    }
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  identity {
    type = "SystemAssigned"
  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  depends_on = [
    azurerm_key_vault.this
  ]

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_user_assigned_identity" "vmss_uai" {
  count = local.scale_set_orchestration_mode == "Flexible" ? 1 : 0

  location            = local.location
  name                = local.scale_set_uai_name
  resource_group_name = local.resource_group_name
}

resource "azurerm_orchestrated_virtual_machine_scale_set" "this" {
  count = local.scale_set_orchestration_mode == "Flexible" ? 1 : 0

  location                    = local.location
  name                        = local.scale_set_name
  platform_fault_domain_count = local.scale_set_platform_fault_domain_count
  resource_group_name         = local.resource_group_name
  instances                   = local.scale_set_instances
  sku_name                    = local.scale_set_sku
  tags                        = var.tags

  identity {
    identity_ids = [azurerm_user_assigned_identity.vmss_uai[0].id]
    type         = "UserAssigned"
  }
  network_interface {
    name    = "default"
    primary = true

    ip_configuration {
      name      = "gsa"
      primary   = true
      subnet_id = local.scale_set_subnet_id

      dynamic "public_ip_address" {
        for_each = local.debug_mode ? [1] : []

        content {
          name = "gsa-pip"
        }
      }
    }
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  os_profile {
    windows_configuration {
      admin_password = local.scale_set_password
      admin_username = local.scale_set_username
    }
  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  depends_on = [
    azurerm_key_vault.this
  ]

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_virtual_machine_scale_set_extension" "this" {
  name                         = "GSA-DSC-Extension"
  publisher                    = "Microsoft.Powershell"
  type                         = "DSC"
  type_handler_version         = "2.83"
  virtual_machine_scale_set_id = local.scale_set_orchestration_mode == "Flexible" ? azurerm_orchestrated_virtual_machine_scale_set.this[0].id : azurerm_windows_virtual_machine_scale_set.this[0].id
  settings = jsonencode({
    "ModulesUrl" : "${azurerm_storage_account.this.primary_blob_endpoint}scripts/InstallEntraPrivateAccess.ps1.zip",
    "ConfigurationFunction" : "InstallEntraPrivateAccess.ps1\\InstallEntraPrivateAccess",
    "Properties" : "KeyVaultName=${local.key_vault_name},SecretNameTenantId=${local.key_vault_tenantid_secret_name},SecretNameAccessToken=${local.key_vault_accesstoken_secret_name}",
    "WmfVersion" : "latest",
    "Privacy" : {
      "DataCollection" : "Enable"
    }
  })

  depends_on = [
    azurerm_windows_virtual_machine_scale_set.this,
    azurerm_orchestrated_virtual_machine_scale_set.this,
    azurerm_key_vault.this,
    azurerm_storage_account.this,
    azurerm_role_assignment.gsa_kv_vmss_secret,
    azurerm_role_assignment.gsa_kv_vmss_cert,
    azurerm_role_assignment.gsa_sa_vmss_data_owner
  ]
}
