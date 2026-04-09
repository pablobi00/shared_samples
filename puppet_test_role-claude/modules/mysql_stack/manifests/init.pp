# modules/mysql_stack/manifests/init.pp
#
# MODULE: mysql_stack
# -------------------------------------------------------
# Component module that manages MySQL (community edition).
#
# Compatible with: Rocky Linux 8/9 and AlmaLinux 8/9
# Package name on both distros: mysql-server
# Service name on both distros: mysqld
# -------------------------------------------------------

class mysql_stack (

  # Root password pulled from Hiera at: mysql_stack::root_password
  # In a real lab you would encrypt this with hiera-eyaml.
  String $root_password = 'Ch4ng3M3!',

) {

  # -------------------------------------------------------
  # RESOURCE: Package
  # Installs mysql-server (provides both server and client tools).
  # -------------------------------------------------------
  package { 'mysql-server':
    ensure => installed,  # Install if absent; no-op if already installed
  }

  # -------------------------------------------------------
  # RESOURCE: Service
  # Ensures mysqld is running and enabled at boot.
  # -------------------------------------------------------
  service { 'mysqld':
    ensure  => running,        # Service must be in a running state
    enable  => true,           # Auto-start on reboot
    require => Package['mysql-server'],  # Can't start without the package
  }

  # -------------------------------------------------------
  # RESOURCE: Exec
  # Run mysqladmin to set the root password after the first install.
  # "unless" prevents this from running every 30 minutes — it only
  # fires when the password has NOT been set yet.
  # -------------------------------------------------------
  exec { 'set-mysql-root-password':
    command => "/usr/bin/mysqladmin -u root password '${root_password}'",
    # Only run if login with empty password works (i.e. first-time setup)
    unless  => "/usr/bin/mysqladmin -u root -p'${root_password}' status",
    require => Service['mysqld'],  # MySQL must be running before we can connect
  }

}
