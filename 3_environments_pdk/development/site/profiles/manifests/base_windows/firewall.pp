# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/development/site/profiles/manifests/base_windows/firewall.pp

# @summary Base Windows profile: enables Windows Defender Firewall and allows SSH.
#
# What this profile does:
#   1. Enables Windows Defender Firewall on all network profiles (Domain, Private, Public).
#   2. Allows inbound SSH (port 22) for remote management via OpenSSH.
#
# Applies to: Windows desktop nodes (developer_system role in development).
# Requires: Windows 10/11 with OpenSSH server feature installed.
#
class profiles::base_windows::firewall {

  # Enable the Windows Defender Firewall on all three network profiles.
  # Domain   = corporate network, Private = home/trusted, Public = unknown networks.
  exec { 'enable-windows-firewall':
    command  => 'Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True',
    provider => powershell,
  }

  # Allow inbound SSH connections (TCP port 22) through the firewall.
  # 'unless' checks if the rule already exists before creating it.
  exec { 'firewall-allow-ssh':
    command  => 'New-NetFirewallRule -DisplayName "Allow SSH" -Direction Inbound -Protocol TCP -LocalPort 22 -Action Allow',
    unless   => 'if (Get-NetFirewallRule -DisplayName "Allow SSH" -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }',
    provider => powershell,
    require  => Exec['enable-windows-firewall'],
  }

}
