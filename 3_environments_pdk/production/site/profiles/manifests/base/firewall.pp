# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/production/site/profiles/manifests/base/firewall.pp

# @summary Base profile: enables firewalld and opens SSH access.
#
# What this profile does:
#   1. Installs and starts the firewalld service on RHEL nodes.
#   2. Permanently allows SSH (port 22) through the firewall.
#   3. Reloads firewalld to activate the rule.
#
# Applies to: all RHEL nodes in the production environment.
#
class profiles::base::firewall {

  # Install the firewalld package (usually pre-installed on RHEL 8/9).
  package { 'firewalld':
    ensure => installed,
  }

  # Enable firewalld so it starts on boot, and start it now if not running.
  service { 'firewalld':
    ensure  => running,
    enable  => true,
    require => Package['firewalld'],
  }

  # Permanently allow SSH through the default firewall zone.
  # 'unless' skips this if SSH is already in the allowed services list.
  exec { 'firewall-allow-ssh':
    command => '/usr/bin/firewall-cmd --permanent --add-service=ssh',
    unless  => '/usr/bin/firewall-cmd --query-service=ssh',
    require => Service['firewalld'],
    notify  => Exec['firewall-reload-base'],
  }

  # Reload firewalld to apply permanent rule changes.
  # Runs only when notified (refreshonly), not on every Puppet run.
  exec { 'firewall-reload-base':
    command     => '/usr/bin/firewall-cmd --reload',
    refreshonly => true,
    require     => Service['firewalld'],
  }

}
