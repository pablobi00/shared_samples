# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/production/modules/module_3/manifests/init.pp

# @summary Module 3: manages a default MariaDB server installation.
#
# Installs mariadb-server and mariadb client packages, then ensures
# the mariadb service is running and enabled at boot.
# No custom databases, users, or configuration are applied — this is
# a plain default installation suitable for further customisation.
#
class module_3 {

  # Install the MariaDB server package (provides the database daemon).
  package { 'mariadb-server':
    ensure => installed,
  }

  # Install the MariaDB client package (provides the 'mysql' CLI tool).
  package { 'mariadb':
    ensure  => installed,
    require => Package['mariadb-server'],
  }

  # Ensure the mariadb service is running and starts automatically on boot.
  # It requires the server package to be installed first.
  service { 'mariadb':
    ensure  => running,
    enable  => true,
    require => Package['mariadb-server'],
  }

}
