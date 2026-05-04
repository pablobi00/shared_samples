# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/development/site/profiles/manifests/base/packages.pp

# @summary Base profile: installs common network and monitoring tools.
#
# Installs these tools on every RHEL node:
#   - netstat  (via net-tools): shows active network connections and ports.
#   - iftop               : displays live network bandwidth usage per connection.
#   - curl                : transfers data to/from URLs (HTTP, HTTPS, FTP, etc.).
#   - wget                : downloads files from the web non-interactively.
#
# 'ensure => installed' means Puppet installs the package if missing
# and leaves it alone if it is already present (idempotent).
#
# Applies to: RHEL nodes (application_server role in development).
#
class profiles::base::packages {

  # net-tools provides the netstat command on RHEL 8+.
  # netstat shows open ports, listening services, and active connections.
  package { 'net-tools':
    ensure => installed,
  }

  # iftop shows real-time bandwidth usage by host/connection pair.
  # Useful for diagnosing unexpected network traffic.
  package { 'iftop':
    ensure => installed,
  }

  # curl is a command-line HTTP client used for API calls and file transfers.
  package { 'curl':
    ensure => installed,
  }

  # wget downloads files from the web; useful in scripts and automation.
  package { 'wget':
    ensure => installed,
  }

}
