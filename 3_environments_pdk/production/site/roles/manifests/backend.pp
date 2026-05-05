# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/production/site/roles/manifests/backend.pp

# @summary Role: RHEL backend (database tier) node for the production environment.
#
# A role defines WHAT a node IS by assembling profiles.
# This role is assigned to all production backend nodes.
#
# Profiles included:
#   profiles::base::ntp      - chrony NTP + timezone (America/Vancouver) + date format
#   profiles::base::firewall - firewalld enabled + SSH allowed
#   profiles::base::packages - net-tools (netstat), iftop, curl, wget
#   profiles::backend        - PostgreSQL + firewall rule for port 5432
#
# Node naming convention (see manifests/site.pp): prod-backend-<name>.example.com
#
class roles::backend {

  # Apply the RHEL base NTP profile.
  include profiles::base::ntp

  # Apply the RHEL base firewall profile.
  include profiles::base::firewall

  # Apply the RHEL base packages profile.
  include profiles::base::packages

  # Apply the backend profile (PostgreSQL + port 5432 firewall rule).
  include profiles::backend

}
