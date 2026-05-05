# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/development/site/profiles/manifests/developer_system.pp

# @summary Development profile: configures a Windows developer workstation.
#
# What this profile does:
#   1. Installs Visual Studio Code using Chocolatey.
#
# This profile is included by roles::developer_system, which also applies
# the base_windows profiles for NTP, firewall, and common tools.
#
# Applies to: Windows desktop nodes in the development environment.
# Requires: Chocolatey package manager (managed by profiles::base_windows::packages).
#
class profiles::developer_system {

  # Visual Studio Code - the primary code editor for developers.
  # Chocolatey installs the latest stable release by default.
  # 'require' ensures Chocolatey is installed before trying to install vscode.
  package { 'vscode':
    ensure   => installed,
    provider => chocolatey,
    require  => Package['chocolatey'],
  }

}
