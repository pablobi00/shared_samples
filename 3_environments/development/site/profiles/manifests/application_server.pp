# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/development/site/profiles/manifests/application_server.pp

# @summary Development profile: configures a RHEL application server.
#
# What this profile does:
#   1. Installs and starts Apache httpd (web server).
#   2. Installs and initializes PostgreSQL (database server).
#   3. Installs Java 21 OpenJDK (required for Java applications).
#
# This profile is included by roles::application_server, which also applies
# the RHEL base profiles for NTP, firewall, and common tools.
#
# Applies to: RHEL application server nodes in the development environment.
#
class profiles::application_server {

  # Look up package names from Hiera so they can be overridden per node if needed.
  $java_package       = lookup('profiles::application_server::java_package',       String, 'first', 'java-21-openjdk')
  $postgresql_package = lookup('profiles::application_server::postgresql_package', String, 'first', 'postgresql-server')

  # --- Web Server ---

  # Install the Apache HTTP server package for RHEL.
  package { 'httpd':
    ensure => installed,
  }

  # Enable Apache to start on boot and start it now if not already running.
  service { 'httpd':
    ensure  => running,
    enable  => true,
    require => Package['httpd'],
  }

  # --- Database ---

  # Install the PostgreSQL server package.
  # The actual package name (e.g. postgresql-server) comes from Hiera.
  package { $postgresql_package:
    ensure => installed,
  }

  # Initialize the PostgreSQL database cluster.
  # This creates the data directory and default config files.
  # 'creates' prevents re-running if the data directory already exists.
  exec { 'postgresql-initdb':
    command => '/usr/bin/postgresql-setup --initdb',
    creates => '/var/lib/pgsql/data/PG_VERSION',
    require => Package[$postgresql_package],
  }

  # Enable and start the PostgreSQL service.
  service { 'postgresql':
    ensure  => running,
    enable  => true,
    require => Exec['postgresql-initdb'],
  }

  # --- Java Runtime ---

  # Install Java 21 OpenJDK.
  # Java 21 is the latest Long-Term Support (LTS) release as of 2025.
  package { $java_package:
    ensure => installed,
  }

}
