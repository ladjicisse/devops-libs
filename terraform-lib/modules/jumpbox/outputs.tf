output "vm_id" {
  description = "Jumpbox virtual machine id."
  value       = azurerm_linux_virtual_machine.this.id
}

output "public_ip_address" {
  description = "Jumpbox public IPv4 address."
  value       = azurerm_public_ip.this.ip_address
}

output "private_ip_address" {
  description = "Jumpbox private IPv4 address."
  value       = azurerm_network_interface.this.private_ip_address
}

output "admin_username" {
  description = "Jumpbox Linux administrator username."
  value       = var.admin_username
}

output "ssh_command" {
  description = "SSH command for connecting to the jumpbox."
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.this.ip_address}"
}
