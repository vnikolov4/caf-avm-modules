variable "root_management_group_id" {
  description = <<EOT
Optional explicit root management group ID.
If null, the module assumes the tenant root management group (tenant ID).
Example: "/providers/Microsoft.Management/managementGroups/<root-id>"
EOT
  type    = string
  default = null
}

variable "management_groups" {
  description = <<EOT
Map of management groups to create.

Key = logical name (and MG name)
Value = {
  display_name = string
  parent_key   = string   # "root" or key of another MG in this map
}
Example:

management_groups = {
  platform = {
    display_name = "Platform"
    parent_key   = "root"
  }
  landingzones = {
    display_name = "Landing Zones"
    parent_key   = "root"
  }
  prod = {
    display_name = "Prod"
    parent_key   = "landingzones"
  }
}
EOT

  type = map(object({
    display_name = string
    parent_key   = string
  }))
}

variable "role_assignments" {
  description = <<EOT
List of RBAC assignments to management groups.

Each item:
{
  management_group_key = string  # key from management_groups
  principal_id         = string  # object ID of AAD security group/service principal
  role_definition_name = string  # e.g. "Reader", "Contributor", "Owner"
}

Example:

role_assignments = [
  {
    management_group_key = "platform"
    principal_id         = "00000000-0000-0000-0000-000000000001"
    role_definition_name = "Reader"
  }
]
EOT

  type = list(object({
    management_group_key = string
    principal_id         = string
    role_definition_name = string
  }))

  default = []
}
