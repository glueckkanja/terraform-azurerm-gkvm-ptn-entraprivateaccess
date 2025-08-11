<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-gkvm-ptn-entraprivateaccess

This is the Glueckkanja Verified Module for the Deployment of Entra Private Access with Terraform.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9, < 2.0)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (~> 3.5)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.39)

- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (~> 0.3)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.7)

## Resources

The following resources are used by this module:

- [azuread_group.gsa_owner](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) (resource)
- [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) (resource)
- [azurerm_key_vault_secret.accesstoken](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_key_vault_secret.admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_key_vault_secret.tenant_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) (resource)
- [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) (resource)
- [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_role_assignment.gsa_kv_grp_cert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.gsa_kv_grp_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.gsa_kv_spn_cert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.gsa_kv_spn_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.gsa_kv_vmss_cert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.gsa_kv_vmss_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.gsa_sa_grp_data_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.gsa_sa_vmss_data_owner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) (resource)
- [azurerm_storage_blob.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) (resource)
- [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) (resource)
- [azurerm_virtual_machine_scale_set_extension.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension) (resource)
- [azurerm_windows_virtual_machine_scale_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine_scale_set) (resource)
- [modtm_telemetry.telemetry](https://registry.terraform.io/providers/azure/modtm/latest/docs/resources/telemetry) (resource)
- [random_password.admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [random_uuid.telemetry](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) (resource)
- [azurerm_client_config.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [modtm_module_source.telemetry](https://registry.terraform.io/providers/azure/modtm/latest/docs/data-sources/module_source) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_scale_set_subnet_id"></a> [scale\_set\_subnet\_id](#input\_scale\_set\_subnet\_id)

Description: The ID of the subnet where the Windows Virtual Machine Scale Set will be deployed.

Type: `string`

### <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)

Description: The Azure subscription ID in which the resources will be created.

Type: `string`

### <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id)

Description: The Azure Active Directory tenant ID in which the resources will be created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_create_gsa_owner_group"></a> [create\_gsa\_owner\_group](#input\_create\_gsa\_owner\_group)

Description: If set to true, a new group for GSA owners will be created. If set to false, an existing group ID should be provided.

Type: `bool`

Default: `true`

### <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group)

Description: If set to true, a new resource group will be created. If set to false, an existing resource group will be used.

Type: `bool`

Default: `false`

### <a name="input_debug_mode"></a> [debug\_mode](#input\_debug\_mode)

Description: If set to true, enables debug mode which adds a public IP address to the virtual machine scale set.

Type: `bool`

Default: `false`

### <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings)

Description: A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
- `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.

Type:

```hcl
map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_gsa_owner_group_id"></a> [gsa\_owner\_group\_id](#input\_gsa\_owner\_group\_id)

Description: The ID of the group that will be assigned as GSA owner. This is only used if `create_gsa_owner_group` is set to false.

Type: `string`

Default: `"00000000-0000-0000-0000-000000000000"`

### <a name="input_gsa_owner_group_members"></a> [gsa\_owner\_group\_members](#input\_gsa\_owner\_group\_members)

Description: The members of the GSA Owner group.

Type: `list(string)`

Default: `[]`

### <a name="input_key_vault_accesstoken_secret_name"></a> [key\_vault\_accesstoken\_secret\_name](#input\_key\_vault\_accesstoken\_secret\_name)

Description: The name of the secret in the Key Vault that will store the access token.

Type: `string`

Default: `"access-token"`

### <a name="input_key_vault_admin_password_secret_name"></a> [key\_vault\_admin\_password\_secret\_name](#input\_key\_vault\_admin\_password\_secret\_name)

Description: The name of the secret in the Key Vault that will store the admin password.

Type: `string`

Default: `"admin-password"`

### <a name="input_key_vault_enable_rbac_authorization"></a> [key\_vault\_enable\_rbac\_authorization](#input\_key\_vault\_enable\_rbac\_authorization)

Description: If set to true, enables RBAC authorization for the Key Vault.

Type: `bool`

Default: `true`

### <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name)

Description: The name of the Key Vault where secrets will be stored.

Type: `string`

Default: `"kv-gsa"`

### <a name="input_key_vault_purge_protection_enabled"></a> [key\_vault\_purge\_protection\_enabled](#input\_key\_vault\_purge\_protection\_enabled)

Description: If set to true, enables purge protection for the Key Vault.

Type: `bool`

Default: `true`

### <a name="input_key_vault_sku"></a> [key\_vault\_sku](#input\_key\_vault\_sku)

Description: The SKU of the Key Vault. Possible values are 'standard' and 'premium'.

Type: `string`

Default: `"standard"`

### <a name="input_key_vault_tenantid_secret_name"></a> [key\_vault\_tenantid\_secret\_name](#input\_key\_vault\_tenantid\_secret\_name)

Description: The name of the secret in the Key Vault that will store the tenant ID.

Type: `string`

Default: `"tenant-id"`

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the resource should be deployed.

Type: `string`

Default: `"westeurope"`

### <a name="input_lock"></a> [lock](#input\_lock)

Description: Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.

Type:

```hcl
object({
    kind = string
    name = optional(string, null)
  })
```

Default: `null`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The name of the resource group which will be created, if `create_resource_group` is set to true. The name of an existing resource group which should be used to deploy the resources, if `create_resource_group` is set to false.

Type: `string`

Default: `"rg-gsa"`

### <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments)

Description: A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_scale_set_instances"></a> [scale\_set\_instances](#input\_scale\_set\_instances)

Description: The number of instances in the Windows Virtual Machine Scale Set.

Type: `number`

Default: `2`

### <a name="input_scale_set_name"></a> [scale\_set\_name](#input\_scale\_set\_name)

Description: The name of the Windows Virtual Machine Scale Set.

Type: `string`

Default: `"vmss-gsa"`

### <a name="input_scale_set_sku"></a> [scale\_set\_sku](#input\_scale\_set\_sku)

Description: The SKU of the Windows Virtual Machine Scale Set.

Type: `string`

Default: `"Standard_D2s_v3"`

### <a name="input_scale_set_username"></a> [scale\_set\_username](#input\_scale\_set\_username)

Description: The username for the Windows Virtual Machine Scale Set.

Type: `string`

Default: `"adminuser"`

### <a name="input_spn_id"></a> [spn\_id](#input\_spn\_id)

Description: The service principal ID that will be assigned roles in the Key Vault. If not set, no role assignments will be created for the service principal.

Type: `string`

Default: `""`

### <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name)

Description: The name of the Storage Account.

Type: `string`

Default: `"stgsa"`

### <a name="input_storage_account_replication_type"></a> [storage\_account\_replication\_type](#input\_storage\_account\_replication\_type)

Description: The replication type of the Storage Account. Possible values are 'LRS', 'GRS', 'RAGRS', 'ZRS', 'GZRS', and 'RAGZRS'.

Type: `string`

Default: `"LRS"`

### <a name="input_storage_account_tier"></a> [storage\_account\_tier](#input\_storage\_account\_tier)

Description: The tier of the Storage Account. Possible values are 'Standard' and 'Premium'.

Type: `string`

Default: `"Standard"`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (Optional) Tags of the resource.

Type: `map(string)`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_next_steps"></a> [next\_steps](#output\_next\_steps)

Description: The Next Steps to take after the deployment.

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: The ID of Windows Virtual Machine Scale Set

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->