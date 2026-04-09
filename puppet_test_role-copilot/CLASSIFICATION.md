# Puppet Enterprise classification notes

**Goal:** classify Rocky/Alma nodes in the **frontend-linux** node group with the **service-a** role.

## Node group
- Node group name: `frontend-linux`
- Class to add:
  - `role::service_a`

## Optional: role fact for role data
If you want to use `data/role/service-a.yaml`, set a custom fact named `role` with value `service-a` on those nodes.

Example (Linux) custom fact file:
- `/etc/puppetlabs/facter/facts.d/role.txt`
  - contents: `role=service-a`

