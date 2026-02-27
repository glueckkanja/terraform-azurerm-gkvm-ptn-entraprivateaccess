output "next_steps" {
  description = "The Next Steps to take after the deployment."
  value       = "1 - Update the Access Token in the Key Vault Secret. 2 - Upgrade the VMSS Instances to apply the DSC Extension."
}

output "resource_id" {
  description = "The ID of Windows Virtual Machine Scale Set"
  value       = local.scale_set_orchestration_mode == "Flexible" ? azurerm_orchestrated_virtual_machine_scale_set.this[0].id : azurerm_windows_virtual_machine_scale_set.this[0].id
}

output "resource" {
  description = "The whole Windows Virtual Machine Scale Set"
  value       = local.scale_set_orchestration_mode == "Flexible" ? azurerm_orchestrated_virtual_machine_scale_set.this[0] : azurerm_windows_virtual_machine_scale_set.this[0]
}
