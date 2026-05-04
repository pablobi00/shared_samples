# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/production/modules/module_2/manifests/init.pp

# @summary Module 2: manages the httpd web server and chrony time synchronization.
#
# Also sets the system timezone to America/Vancouver (Vancouver, B.C.)
# and configures chrony using a static config file that enforces
# 24-hour time display and YYYY.mm.dd date formatting via locale settings.
#
class module_2 {

  # ── httpd ────────────────────────────────────────────────────────────────

  # Install the Apache HTTP server package.
  package { 'httpd':
    ensure => installed,
  }

  # Ensure httpd is running and starts automatically on boot.
  service { 'httpd':
    ensure  => running,
    enable  => true,
    require => Package['httpd'],
  }

  # ── System timezone (Vancouver, B.C.) ────────────────────────────────────

  # Set the system timezone by symlinking /etc/localtime to the
  # America/Vancouver zone file. This ensures all system logs and
  # chrony operate in Pacific Time.
  file { '/etc/localtime':
    ensure => link,
    target => '/usr/share/zoneinfo/America/Vancouver',
  }

  # Write /etc/timezone so tools like 'date' and 'timedatectl' report
  # the correct zone name in text form.
  file { '/etc/timezone':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "America/Vancouver\n",
  }

  # Set the system locale to Canadian English, which uses:
  #   - 24-hour clock  (HH:MM:SS)
  #   - YYYY.mm.dd date format
  file { '/etc/locale.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "LANG=en_CA.UTF-8\nLC_TIME=en_CA.UTF-8\n",
  }

  # ── chrony ───────────────────────────────────────────────────────────────

  # Install the chrony NTP package.
  package { 'chrony':
    ensure => installed,
  }

  # Deploy the chrony configuration file from this module's files/ directory.
  # The config points at Canadian NTP pool servers (best latency for Vancouver).
  # Changing this file notifies the chronyd service to reload its configuration.
  file { '/etc/chrony.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/module_2/chrony_config',
    require => Package['chrony'],
    notify  => Service['chronyd'],
  }

  # Ensure chronyd is running and starts automatically on boot.
  service { 'chronyd':
    ensure  => running,
    enable  => true,
    require => Package['chrony'],
  }

}
