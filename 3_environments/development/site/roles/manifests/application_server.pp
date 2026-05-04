# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/development/site/roles/manifests/application_server.pp

# @summary Role: RHEL application server for the development environment.
#
# A role defines WHAT a node IS by assembling profiles.
# This role is assigned to all RHEL application server nodes in development.
#
# Profiles included:
#   profiles::base::ntp      - chrony NTP + timezone (America/Vancouver) + date format
#   profiles::base::firewall - firewalld enabled + SSH allowed
#   profiles::base::packages - net-tools (netstat), iftop, curl, wget
#   profiles::application_server - Apache httpd, PostgreSQL, Java 21
#
# Node naming convention (see manifests/site.pp): dev-app-<name>.example.com
#
class roles::application_server {

  # Apply the RHEL base NTP profile (chrony, timedatectl, date format).
  include profiles::base::ntp

  # Apply the RHEL base firewall profile (firewalld, SSH rule).
  include profiles::base::firewall

  # Apply the RHEL base packages profile (netstat, iftop, curl, wget).
  include profiles::base::packages

  # Apply the application server profile (Apache httpd, PostgreSQL, Java 21).
  include profiles::application_server

}
