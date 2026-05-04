# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/production/site/roles/manifests/frontend.pp

# @summary Role: RHEL frontend (web tier) node for the production environment.
#
# A role defines WHAT a node IS by assembling profiles.
# This role is assigned to all production frontend nodes.
#
# Profiles included:
#   profiles::base::ntp      - chrony NTP + timezone (America/Vancouver) + date format
#   profiles::base::firewall - firewalld enabled + SSH allowed
#   profiles::base::packages - net-tools (netstat), iftop, curl, wget
#   profiles::frontend       - Apache httpd + firewall rules for ports 80 and 8080
#
# Node naming convention (see manifests/site.pp): prod-frontend-<name>.example.com
#
class roles::frontend {

  # Apply the RHEL base NTP profile.
  include profiles::base::ntp

  # Apply the RHEL base firewall profile.
  include profiles::base::firewall

  # Apply the RHEL base packages profile.
  include profiles::base::packages

  # Apply the frontend profile (Apache httpd + ports 80 and 8080).
  include profiles::frontend

}
