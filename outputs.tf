output "next_steps" {
  description = "The Next Steps to take after the deployment."
  value       = "1 - Update the Access Token in the Key Vault Secret. 2 - Upgrade the VMSS Instances to apply the DSC Extension."
}

output "resource_id" {
  description = "The ID of Windows Virtual Machine Scale Set"
  value       = azurerm_windows_virtual_machine_scale_set.this.id
}
