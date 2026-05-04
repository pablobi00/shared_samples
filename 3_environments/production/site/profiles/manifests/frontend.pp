# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/production/site/profiles/manifests/frontend.pp

# @summary Production profile: configures a frontend (web tier) node.
#
# What this profile does:
#   1. Includes the shared webserver profile (Apache httpd).
#   2. Opens port 80  (HTTP) through the firewall.
#   3. Opens port 8080 (alternate HTTP) through the firewall.
#
# The base firewall profile (profiles::base::firewall) already manages firewalld
# and SSH. This profile only adds the web ports on top of that.
#
# Applies to: frontend RHEL nodes in the production environment.
#
class profiles::frontend {

  # Include the shared web server profile (installs and starts Apache httpd).
  include profiles::webserver

  # --- Firewall rules for web traffic ---

  # Open TCP port 80 (standard HTTP) permanently.
  exec { 'firewall-allow-port-80':
    command => '/usr/bin/firewall-cmd --permanent --add-port=80/tcp',
    unless  => '/usr/bin/firewall-cmd --query-port=80/tcp',
    notify  => Exec['firewall-reload-frontend'],
  }

  # Open TCP port 8080 (alternate HTTP, often used for app servers or proxies).
  exec { 'firewall-allow-port-8080':
    command => '/usr/bin/firewall-cmd --permanent --add-port=8080/tcp',
    unless  => '/usr/bin/firewall-cmd --query-port=8080/tcp',
    notify  => Exec['firewall-reload-frontend'],
  }

  # Reload firewalld so the new port rules take effect.
  exec { 'firewall-reload-frontend':
    command     => '/usr/bin/firewall-cmd --reload',
    refreshonly => true,
  }

}
