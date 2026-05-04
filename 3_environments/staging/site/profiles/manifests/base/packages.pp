# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/staging/site/profiles/manifests/base/packages.pp

# @summary Base profile: installs common network and monitoring tools.
#
# Installs these tools on every RHEL node in staging:
#   - netstat (net-tools): shows active connections and listening ports.
#   - iftop              : live bandwidth monitor per connection.
#   - curl               : command-line HTTP client.
#   - wget               : command-line file downloader.
#
class profiles::base::packages {

  # net-tools provides the netstat command on RHEL 8+.
  package { 'net-tools':
    ensure => installed,
  }

  # iftop shows real-time bandwidth usage by connection.
  package { 'iftop':
    ensure => installed,
  }

  # curl transfers data to/from URLs from the command line.
  package { 'curl':
    ensure => installed,
  }

  # wget downloads files non-interactively from the web.
  package { 'wget':
    ensure => installed,
  }

}
