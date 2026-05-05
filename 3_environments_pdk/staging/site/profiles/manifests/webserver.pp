# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/staging/site/profiles/manifests/webserver.pp

# @summary Shared profile: installs and starts Apache httpd.
#
# This is a reusable profile that both the frontend and middleware profiles
# include with 'include profiles::webserver'.
#
# Including a profile from another profile is fine in Puppet -
# Puppet ensures a class is only applied once even if included multiple times.
#
# Applies to: frontend and middleware RHEL nodes in staging.
#
class profiles::webserver {

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

}
