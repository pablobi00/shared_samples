# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/production/site/roles/manifests/middleware.pp

# @summary Role: RHEL middleware (application tier) node for the production environment.
#
# A role defines WHAT a node IS by assembling profiles.
# This role is assigned to all production middleware nodes.
#
# Profiles included:
#   profiles::base::ntp      - chrony NTP + timezone (America/Vancouver) + date format
#   profiles::base::firewall - firewalld enabled + SSH allowed
#   profiles::base::packages - net-tools (netstat), iftop, curl, wget
#   profiles::middleware     - Apache httpd, Java 21, Python FastAPI, Kafka
#
# Node naming convention (see manifests/site.pp): prod-middleware-<name>.example.com
#
class roles::middleware {

  # Apply the RHEL base NTP profile.
  include profiles::base::ntp

  # Apply the RHEL base firewall profile.
  include profiles::base::firewall

  # Apply the RHEL base packages profile.
  include profiles::base::packages

  # Apply the middleware profile (web server + Java + FastAPI + Kafka).
  include profiles::middleware

}
