# We assume provider "azurerm" is configured in the root module.
# Do NOT configure provider here (best practice).

data "azurerm_client_config" "current" {}

# Determine effective root MG ID:
# - use explicit var.root_management_group_id if set
# - otherwise derive from tenant ID (default root MG)
locals {
  effective_root_mg_id = coalesce(
    var.root_management_group_id,
    "/providers/Microsoft.Management/managementGroups/${data.azurerm_client_config.current.tenant_id}"
  )

  # Normalize role assignments to a map so we can use for_each
  role_assignments_map = {
    for idx, ra in var.role_assignments : idx => ra
  }
}

# Create management groups
resource "azurerm_management_group" "this" {
  for_each = var.management_groups

  # Name will be the key; you can change to a field if preferred
  name         = each.key
  display_name = each.value.display_name

  parent_management_group_id = (
    each.value.parent_key == "root"
    ? local.effective_root_mg_id
    : azurerm_management_group.this[each.value.parent_key].id
  )
}

# Lookup role definitions by name at the MG scope
data "azurerm_role_definition" "this" {
  for_each = local.role_assignments_map

  name = each.value.role_definition_name
  # Scope must be the management group scope
  scope = azurerm_management_group.this[each.value.management_group_key].id
}

# Create role assignments on management groups for security groups/service principals
resource "azurerm_role_assignment" "this" {
  for_each = local.role_assignments_map

  scope              = azurerm_management_group.this[each.value.management_group_key].id
  role_definition_id = data.azurerm_role_definition.this[each.key].id
  principal_id       = each.value.principal_id
}
