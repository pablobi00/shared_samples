# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/staging/site/profiles/manifests/frontend.pp

# @summary Staging profile: configures a frontend (web tier) node.
#
# What this profile does:
#   1. Includes the shared webserver profile (Apache httpd).
#   2. Opens port 80  (HTTP) through the firewall.
#   3. Opens port 8080 (alternate HTTP) through the firewall.
#
# The base firewall profile (profiles::base::firewall) already manages firewalld
# and SSH. This profile only adds the web ports on top of that.
#
# Applies to: frontend RHEL nodes in the staging environment.
#
class profiles::frontend {

  # Include the shared web server profile (installs and starts Apache httpd).
  # Puppet is smart enough to apply this class only once, even if included
  # by both this profile and another one in the same catalog.
  include profiles::webserver

  # --- Firewall rules for web traffic ---

  # Open TCP port 80 (standard HTTP) permanently.
  # 'unless' skips the command if port 80 is already in the allowed list.
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
  # 'refreshonly => true' means this only runs when notified above.
  exec { 'firewall-reload-frontend':
    command     => '/usr/bin/firewall-cmd --reload',
    refreshonly => true,
  }

}
