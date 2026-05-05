# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/development/site/roles/manifests/developer_system.pp

# @summary Role: Windows developer workstation.
#
# A role defines WHAT a node IS by assembling profiles.
# This role is assigned to all Windows desktop nodes in development.
#
# Profiles included:
#   profiles::base_windows::ntp      - timezone (Pacific/Vancouver), Windows Time service
#   profiles::base_windows::firewall - Windows Defender Firewall + SSH rule
#   profiles::base_windows::packages - Chocolatey, curl, wget
#   profiles::developer_system       - Visual Studio Code
#
# Node naming convention (see manifests/site.pp): dev-win-<name>.example.com
#
class roles::developer_system {

  # Apply the Windows base profile for NTP and timezone.
  include profiles::base_windows::ntp

  # Apply the Windows base profile for firewall and SSH access.
  include profiles::base_windows::firewall

  # Apply the Windows base profile for common tools (curl, wget via Chocolatey).
  include profiles::base_windows::packages

  # Apply the developer workstation profile (Visual Studio Code).
  # This profile depends on Chocolatey being installed by base_windows::packages.
  include profiles::developer_system

}
