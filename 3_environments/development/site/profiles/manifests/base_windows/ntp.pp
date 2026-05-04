# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/development/site/profiles/manifests/base_windows/ntp.pp

# @summary Base Windows profile: configures NTP and timezone for Windows desktops.
#
# What this profile does:
#   1. Starts the Windows Time service (w32time) - the built-in Windows NTP client.
#   2. Configures w32time to sync from public NTP pool servers.
#   3. Sets the system timezone to Pacific Standard Time (covers America/Vancouver).
#   4. Sets the date display format to YYYY.MM.DD and 24-hour clock via registry.
#
# Applies to: Windows desktop nodes (developer_system role in development).
# Requires: The Puppet agent must run with Administrator privileges on Windows.
#
class profiles::base_windows::ntp {

  # Start the Windows Time service and set it to start automatically on boot.
  # w32time is Windows' built-in NTP client - no extra software needed.
  service { 'w32time':
    ensure => running,
    enable => true,
  }

  # Configure w32time to sync from public NTP pool servers.
  # 'unless' checks if the config already exists before applying.
  exec { 'configure-ntp-servers':
    command   => 'w32tm /config /manualpeerlist:"0.pool.ntp.org,1.pool.ntp.org" /syncfromflags:manual /reliable:YES /update',
    unless    => 'w32tm /query /peers | findstr /I "pool.ntp.org"',
    provider  => powershell,
    require   => Service['w32time'],
  }

  # Force an immediate time sync after changing the NTP config.
  exec { 'resync-time':
    command  => 'w32tm /resync /force',
    provider => powershell,
    require  => Exec['configure-ntp-servers'],
  }

  # Set timezone to Pacific Standard Time.
  # This covers America/Vancouver (PST/PDT depending on daylight saving).
  # 'unless' skips the command if the timezone is already correct.
  exec { 'set-timezone-pacific':
    command  => 'Set-TimeZone -Id "Pacific Standard Time"',
    unless   => 'if ((Get-TimeZone).Id -eq "Pacific Standard Time") { exit 0 } else { exit 1 }',
    provider => powershell,
  }

  # Set the system short date format to YYYY.MM.DD for the default user profile.
  # This writes to the system-level registry key used as the template for new users.
  exec { 'set-date-format':
    command  => 'Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones" -Name "sShortDate" -Value "yyyy.MM.dd" -ErrorAction SilentlyContinue; reg load "HKU\DefaultUser" "C:\Users\Default\NTUSER.DAT"; reg add "HKU\DefaultUser\Control Panel\International" /v sShortDate /t REG_SZ /d "yyyy.MM.dd" /f; reg unload "HKU\DefaultUser"',
    provider => powershell,
    require  => Exec['set-timezone-pacific'],
  }

  # Set 24-hour time format for the default user profile.
  exec { 'set-time-format-24h':
    command  => 'reg load "HKU\DefaultUser" "C:\Users\Default\NTUSER.DAT"; reg add "HKU\DefaultUser\Control Panel\International" /v sTimeFormat /t REG_SZ /d "HH:mm:ss" /f; reg add "HKU\DefaultUser\Control Panel\International" /v sShortTime /t REG_SZ /d "HH:mm" /f; reg unload "HKU\DefaultUser"',
    provider => powershell,
    require  => Exec['set-date-format'],
  }

}
