# This profile manages Apache and a MySQL-compatible database service.
# For Rocky Linux and AlmaLinux demo systems, the default package in the OS repository
# is usually MariaDB, which is commonly used as a MySQL-compatible server.
# This keeps the lab simple because no extra vendor repository is required.
class profile::frontend_linux (
  # This parameter controls the text shown on the Apache test page.
  String $site_message = lookup('profile::frontend_linux::site_message', { default_value => 'Demo environment managed by Puppet.' }),
) {

  # Fail early if the server is not in the RedHat family.
  if $facts['os']['family'] != 'RedHat' {
    fail('This demo profile only supports RedHat-family systems such as Rocky Linux and AlmaLinux.')
  }

  # Fail early if the operating system name is not Rocky or AlmaLinux.
  if !($facts['os']['name'] in ['Rocky', 'AlmaLinux']) {
    fail('This demo profile only supports Rocky Linux and AlmaLinux.')
  }

  # Install the Apache web server package.
  package { 'httpd':
    # Ensure the package is installed.
    ensure => installed,
  }

  # Install the MariaDB server package.
  # This provides a MySQL-compatible database service for the demo.
  package { 'mariadb-server':
    # Ensure the package is installed.
    ensure => installed,
  }

  # Manage a simple Apache home page file.
  file { '/var/www/html/index.html':
    # Ensure the file exists.
    ensure  => file,
    # Set the file owner.
    owner   => 'root',
    # Set the group owner.
    group   => 'root',
    # Set simple read permissions.
    mode    => '0644',
    # Build the page content directly in the manifest for a small demo.
    content => "<html>\n  <body>\n    <h1>service-a</h1>\n    <p>${site_message}</p>\n    <p>Operating system: ${facts['os']['name']} ${facts['os']['release']['major']}</p>\n  </body>\n</html>\n",
    # Require Apache to be installed first.
    require => Package['httpd'],
  }

  # Ensure the Apache service is enabled and running.
  service { 'httpd':
    # Make sure the service is running now.
    ensure     => running,
    # Make sure the service starts at boot.
    enable     => true,
    # Restart the service automatically if the page file changes.
    subscribe  => File['/var/www/html/index.html'],
    # Require the package before managing the service.
    require    => Package['httpd'],
  }

  # Ensure the MariaDB service is enabled and running.
  service { 'mariadb':
    # Make sure the service is running now.
    ensure  => running,
    # Make sure the service starts at boot.
    enable  => true,
    # Require the database package before managing the service.
    require => Package['mariadb-server'],
  }
}
