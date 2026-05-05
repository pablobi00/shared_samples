# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/development/site/profiles/manifests/base_windows/packages.pp

# @summary Base Windows profile: installs common tools on Windows desktops.
#
# What this profile does:
#   1. Ensures the Chocolatey package manager is installed (required for Windows packages).
#   2. Installs curl (standalone, consistent behavior across Windows versions).
#   3. Installs wget for Windows.
#
# Notes on Linux-equivalent tools:
#   - netstat : built into Windows (run 'netstat' in cmd or PowerShell - no install needed).
#   - iftop   : no direct Windows equivalent. Use 'netstat -e' or Resource Monitor instead.
#
# Applies to: Windows desktop nodes (developer_system role in development).
# Requires: The Chocolatey provider for Puppet ('chocolatey/chocolatey' from Puppet Forge).
#
class profiles::base_windows::packages {

  # Chocolatey is the Windows package manager used here to install software.
  # It must be installed first before managing any other packages with it.
  package { 'chocolatey':
    ensure   => installed,
    provider => chocolatey,
  }

  # curl for Windows - provides consistent HTTP transfer behavior.
  # Windows 10/11 include a basic curl.exe, but this version is more complete.
  package { 'curl':
    ensure   => installed,
    provider => chocolatey,
    require  => Package['chocolatey'],
  }

  # wget for Windows via Chocolatey.
  package { 'wget':
    ensure   => installed,
    provider => chocolatey,
    require  => Package['chocolatey'],
  }

}
