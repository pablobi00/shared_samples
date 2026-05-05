# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/production/site/profiles/manifests/backend.pp

# @summary Production profile: configures a backend (database tier) node.
#
# What this profile does:
#   1. Installs the PostgreSQL server package.
#   2. Initializes the database cluster (creates data directory and config files).
#   3. Enables and starts the PostgreSQL service.
#   4. Opens the PostgreSQL port (5432) in the firewall for app server access.
#
# Applies to: backend RHEL nodes in the production environment.
#
class profiles::backend {

  # Look up the PostgreSQL package name from Hiera (see data/common.yaml).
  $postgresql_package = lookup('profiles::backend::postgresql_package', String, 'first', 'postgresql-server')

  # Install the PostgreSQL server package.
  package { $postgresql_package:
    ensure => installed,
  }

  # Initialize the PostgreSQL database cluster on first run.
  # 'creates' points to a file that only exists after initialization.
  exec { 'postgresql-initdb':
    command => '/usr/bin/postgresql-setup --initdb',
    creates => '/var/lib/pgsql/data/PG_VERSION',
    require => Package[$postgresql_package],
  }

  # Enable PostgreSQL to start on boot and start it now.
  service { 'postgresql':
    ensure  => running,
    enable  => true,
    require => Exec['postgresql-initdb'],
  }

  # --- Firewall rules ---

  # Open TCP port 5432 (PostgreSQL default port) permanently.
  exec { 'firewall-allow-postgresql':
    command => '/usr/bin/firewall-cmd --permanent --add-service=postgresql',
    unless  => '/usr/bin/firewall-cmd --query-service=postgresql',
    notify  => Exec['firewall-reload-backend'],
  }

  # Reload firewalld to activate the new port rule.
  exec { 'firewall-reload-backend':
    command     => '/usr/bin/firewall-cmd --reload',
    refreshonly => true,
  }

}
