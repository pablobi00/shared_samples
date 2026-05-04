# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/staging/site/profiles/manifests/base/ntp.pp

# @summary Base profile: configures NTP using chrony and sets the timezone.
#
# What this profile does:
#   1. Installs chrony (the NTP daemon recommended for RHEL 8+).
#   2. Starts and enables the chronyd service.
#   3. Uses timedatectl to set the timezone to America/Vancouver.
#   4. Uses timedatectl to enable NTP clock synchronization.
#   5. Sets the system date format to YYYY.MM.DD with a 24-hour clock.
#
# Applies to: all RHEL nodes in the staging environment.
#
class profiles::base::ntp {

  # Look up the timezone from Hiera data (data/common.yaml).
  $timezone = lookup('profiles::base::ntp::timezone', String, 'first', 'America/Vancouver')

  # Install chrony - the modern NTP implementation for RHEL 8 and 9.
  package { 'chrony':
    ensure => installed,
  }

  # Enable and start the chronyd daemon so the system clock stays accurate.
  service { 'chronyd':
    ensure  => running,
    enable  => true,
    require => Package['chrony'],
  }

  # Set the system timezone using timedatectl.
  # 'unless' makes this command idempotent: skip if already correct.
  exec { 'set-timezone':
    command => "/usr/bin/timedatectl set-timezone ${timezone}",
    unless  => "/usr/bin/timedatectl | /usr/bin/grep -q 'Time zone: ${timezone}'",
    require => Service['chronyd'],
  }

  # Tell timedatectl to activate NTP synchronization via chronyd.
  exec { 'enable-ntp-sync':
    command => '/usr/bin/timedatectl set-ntp true',
    unless  => '/usr/bin/timedatectl | /usr/bin/grep -q "NTP service: active"',
    require => Exec['set-timezone'],
  }

  # Deploy a profile.d script to set the date/time display format system-wide.
  # LC_TIME=en_CA.UTF-8 gives YYYY.MM.DD date format and 24-hour clock.
  file { '/etc/profile.d/datetime_format.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "# Set date format to YYYY.MM.DD and 24-hour clock (en_CA locale).\nexport LC_TIME='en_CA.UTF-8'\n",
  }

}
