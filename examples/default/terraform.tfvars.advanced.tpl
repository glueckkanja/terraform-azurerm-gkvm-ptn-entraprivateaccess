# GSA_GENERAL_OPTIONS
subscription_id         = "99f3ac34-3b27-4667-918c-c6953312cea8"
tenant_id               = "00000000-0000-0000-0000-000000000000"
location                = "westeurope"
create_resource_group   = false
resource_group_name     = "gsa-weu"
create_gsa_owner_group  = false
gsa_owner_group_id      = "00000000-0000-0000-0000-000000000000"
spn_id                  = "00000000-0000-0000-0000-000000000000"
debug_mode              = false

# AVM_GENERAL_OPTIONS
lock = {
  kind = "CanNotDelete"
  name = "Lock-GSA"
}

# SCALE_SET_OPTIONS
scale_set_name      = "vmss-gsa"
scale_set_sku       = "Standard_D2s_v3"
scale_set_instances = 2
scale_set_username  = "adminuser"
scale_set_subnet_id = "/subscriptions/d379e727-8520-429b-8caa-086d16c31cc6/resourceGroups/rg-gsa-pa-network-we-dev/providers/Microsoft.Network/virtualNetworks/vnet-gsa-pa-network-we-dev/subnets/snet-private-access-we-dev"

# KEY_VAULT_OPTIONS
key_vault_name                        = "kv-gsa"
key_vault_sku                         = "standard"
key_vault_purge_protection_enabled    = true
key_vault_enable_rbac_authorization   = true
key_vault_tenantid_secret_name        = "tenant-id"
key_vault_accesstoken_secret_name     = "access-token"
key_vault_admin_password_secret_name  = "admin-password"

# STORAGE_ACCOUNT_OPTIONS
storage_account_name              = "stgsa"
storage_account_tier              = "Standard"
storage_account_replication_type  = "LRS"

tags = {
  "environment" = "dev"
  "landingzone" = "90_appzones"
  "workload"    = "gsa"
}
