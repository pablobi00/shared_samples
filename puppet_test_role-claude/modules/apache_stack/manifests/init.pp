# modules/apache_stack/manifests/init.pp
#
# MODULE: apache_stack
# -------------------------------------------------------
# This is a COMPONENT MODULE. It manages one specific technology: Apache.
# init.pp is the MAIN class of every module — it runs automatically
# when you write "include apache_stack".
#
# Compatible with: Rocky Linux 8/9 and AlmaLinux 8/9
# Package name on both distros: httpd
# Service name on both distros: httpd
# -------------------------------------------------------

class apache_stack (

  # This parameter is looked up from Hiera automatically.
  # Hiera key: apache_stack::port (defined in data/common.yaml)
  Integer $port = 80,  # Default to port 80 if Hiera has no value

) {

  # -------------------------------------------------------
  # RESOURCE: Package
  # Makes sure the 'httpd' package is installed on the node.
  # -------------------------------------------------------
  package { 'httpd':
    ensure => installed,  # Install it if missing; do nothing if already present
  }

  # -------------------------------------------------------
  # RESOURCE: File — drop a minimal httpd config
  # -------------------------------------------------------
  file { '/etc/httpd/conf.d/puppet_managed.conf':
    ensure  => file,           # This must be a regular file (not a dir or symlink)
    owner   => 'root',         # Owned by root user
    group   => 'root',         # Owned by root group
    mode    => '0644',         # Read-only for everyone except root (rw-r--r--)
    content => "# Managed by Puppet — do not edit manually\nListen ${port}\n",
    # "require" means: install the package BEFORE creating this file
    require => Package['httpd'],
    # "notify" means: if this file changes, restart the service
    notify  => Service['httpd'],
  }

  # -------------------------------------------------------
  # RESOURCE: Service
  # Makes sure the httpd service is running and starts on boot.
  # -------------------------------------------------------
  service { 'httpd':
    ensure  => running,       # The service must be running right now
    enable  => true,          # Start automatically on system boot
    # Depend on the package — don't try to start a service that isn't installed
    require => Package['httpd'],
  }

}
