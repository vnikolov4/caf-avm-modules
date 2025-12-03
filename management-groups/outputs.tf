output "management_group_ids" {
  description = "Map of management group IDs keyed by logical name."
  value       = { for k, mg in azurerm_management_group.this : k => mg.id }
}

output "management_group_names" {
  description = "Map of management group names keyed by logical name."
  value       = { for k, mg in azurerm_management_group.this : k => mg.name }
}

output "role_assignment_ids" {
  description = "Map of role assignment IDs keyed by index."
  value       = { for k, ra in azurerm_role_assignment.this : k => ra.id }
}
