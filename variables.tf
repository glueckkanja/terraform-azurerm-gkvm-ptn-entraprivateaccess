variable "scale_set_subnet_id" {
  type        = string
  description = "The ID of the subnet where the Windows Virtual Machine Scale Set will be deployed."
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID in which the resources will be created."
}

variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID in which the resources will be created."
}

variable "create_gsa_owner_group" {
  type        = bool
  default     = true
  description = "If set to true, a new group for GSA owners will be created. If set to false, an existing group ID should be provided."
}

variable "create_resource_group" {
  type        = bool
  default     = false
  description = "If set to true, a new resource group will be created. If set to false, an existing resource group will be used."
}

variable "debug_mode" {
  type        = bool
  default     = false
  description = "If set to true, enables debug mode which adds a public IP address to the virtual machine scale set."
}

variable "diagnostic_settings" {
  type = map(object({
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
  default     = {}
  description = <<DESCRIPTION
A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

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
DESCRIPTION  
  nullable    = false

  validation {
    condition     = alltrue([for _, v in var.diagnostic_settings : contains(["Dedicated", "AzureDiagnostics"], v.log_analytics_destination_type)])
    error_message = "Log analytics destination type must be one of: 'Dedicated', 'AzureDiagnostics'."
  }
  validation {
    condition = alltrue(
      [
        for _, v in var.diagnostic_settings :
        v.workspace_resource_id != null || v.storage_account_resource_id != null || v.event_hub_authorization_rule_resource_id != null || v.marketplace_partner_resource_id != null
      ]
    )
    error_message = "At least one of `workspace_resource_id`, `storage_account_resource_id`, `marketplace_partner_resource_id`, or `event_hub_authorization_rule_resource_id`, must be set."
  }
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "gsa_owner_group_id" {
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"
  description = "The ID of the group that will be assigned as GSA owner. This is only used if `create_gsa_owner_group` is set to false."
}

variable "gsa_owner_group_members" {
  type        = list(string)
  default     = []
  description = "The members of the GSA Owner group."
}

variable "key_vault_accesstoken_secret_name" {
  type        = string
  default     = "access-token"
  description = "The name of the secret in the Key Vault that will store the access token."
}

variable "key_vault_admin_password_secret_name" {
  type        = string
  default     = "admin-password"
  description = "The name of the secret in the Key Vault that will store the admin password."
}

variable "key_vault_enable_rbac_authorization" {
  type        = bool
  default     = true
  description = "If set to true, enables RBAC authorization for the Key Vault."
}

variable "key_vault_name" {
  type        = string
  default     = "kv-gsa"
  description = "The name of the Key Vault where secrets will be stored."
}

variable "key_vault_purge_protection_enabled" {
  type        = bool
  default     = true
  description = "If set to true, enables purge protection for the Key Vault."
}

variable "key_vault_sku" {
  type        = string
  default     = "standard"
  description = "The SKU of the Key Vault. Possible values are 'standard' and 'premium'."
}

variable "key_vault_tenantid_secret_name" {
  type        = string
  default     = "tenant-id"
  description = "The name of the secret in the Key Vault that will store the tenant ID."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Azure region where the resource should be deployed."
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

variable "resource_group_name" {
  type        = string
  default     = "rg-gsa"
  description = "The name of the resource group which will be created, if `create_resource_group` is set to true. The name of an existing resource group which should be used to deploy the resources, if `create_resource_group` is set to false."
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
  nullable    = false
}

variable "scale_set_instances" {
  type        = number
  default     = 2
  description = "The number of instances in the Windows Virtual Machine Scale Set."
}

variable "scale_set_name" {
  type        = string
  default     = "vmss-gsa"
  description = "The name of the Windows Virtual Machine Scale Set."
}

variable "scale_set_sku" {
  type        = string
  default     = "Standard_D2s_v3"
  description = "The SKU of the Windows Virtual Machine Scale Set."
}

variable "scale_set_username" {
  type        = string
  default     = "adminuser"
  description = "The username for the Windows Virtual Machine Scale Set."
}

variable "spn_id" {
  type        = string
  default     = ""
  description = "The service principal ID that will be assigned roles in the Key Vault. If not set, no role assignments will be created for the service principal."
}

variable "storage_account_name" {
  type        = string
  default     = "stgsa"
  description = "The name of the Storage Account."
}

variable "storage_account_replication_type" {
  type        = string
  default     = "LRS"
  description = "The replication type of the Storage Account. Possible values are 'LRS', 'GRS', 'RAGRS', 'ZRS', 'GZRS', and 'RAGZRS'."
}

variable "storage_account_tier" {
  type        = string
  default     = "Standard"
  description = "The tier of the Storage Account. Possible values are 'Standard' and 'Premium'."
}

# tflint-ignore: terraform_unused_declarations
variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}
