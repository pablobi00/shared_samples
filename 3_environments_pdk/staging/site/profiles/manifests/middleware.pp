# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/staging/site/profiles/manifests/middleware.pp

# @summary Staging profile: configures a middleware (application tier) node.
#
# What this profile does:
#   1. Includes the shared webserver profile (Apache httpd).
#   2. Installs Java 21 OpenJDK.
#   3. Installs Python 3 and pip, then installs FastAPI + Uvicorn via pip.
#   4. Deploys a systemd unit file and starts the FastAPI service.
#   5. Adds the Confluent repository and installs Kafka (confluent-kafka package).
#   6. Starts and enables the Kafka service.
#
# Applies to: middleware RHEL nodes in the staging environment.
#
class profiles::middleware {

  # Look up the Java package name from Hiera (see data/common.yaml).
  $java_package             = lookup('profiles::middleware::java_package',             String, 'first', 'java-21-openjdk')
  # Look up the Confluent major version for Kafka from Hiera.
  $confluent_major_version  = lookup('profiles::middleware::confluent_major_version',  String, 'first', '7.6')

  # --- Web Server ---

  # Include the shared web server profile (Apache httpd).
  include profiles::webserver

  # --- Java ---

  # Install Java 21 OpenJDK. Java is required by both Kafka and Java applications.
  package { $java_package:
    ensure => installed,
  }

  # --- Python FastAPI Service ---

  # Install Python 3 interpreter.
  package { 'python3':
    ensure => installed,
  }

  # Install pip - the Python package installer needed to install FastAPI.
  package { 'python3-pip':
    ensure  => installed,
    require => Package['python3'],
  }

  # Install FastAPI and Uvicorn using pip.
  # FastAPI is the Python web framework; Uvicorn is its ASGI application server.
  # 'unless' skips this if FastAPI is already installed (idempotent).
  exec { 'install-fastapi':
    command => '/usr/bin/pip3 install fastapi uvicorn',
    unless  => '/usr/bin/pip3 show fastapi',
    require => Package['python3-pip'],
    notify  => Service['fastapi'],
  }

  # Deploy a systemd unit file so the FastAPI app runs as a managed service.
  # Update ExecStart to point to your actual application module (main:app).
  file { '/etc/systemd/system/fastapi.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @("UNIT_FILE"),
      [Unit]
      Description=FastAPI Application Service
      After=network.target

      [Service]
      Type=simple
      User=nobody
      ExecStart=/usr/bin/uvicorn main:app --host 0.0.0.0 --port 8000
      Restart=on-failure
      RestartSec=5

      [Install]
      WantedBy=multi-user.target
      | UNIT_FILE
    require => Exec['install-fastapi'],
    notify  => Service['fastapi'],
  }

  # Enable and start the FastAPI service.
  service { 'fastapi':
    ensure  => running,
    enable  => true,
    require => File['/etc/systemd/system/fastapi.service'],
  }

  # --- Apache Kafka via Confluent Platform ---

  # Add the Confluent yum repository so dnf/yum can find Kafka packages.
  # The version comes from Hiera (data/common.yaml) so you update it in one place.
  yumrepo { 'confluent':
    ensure   => present,
    name     => 'confluent',
    descr    => "Confluent Platform ${confluent_major_version}",
    baseurl  => "https://packages.confluent.io/rpm/${confluent_major_version}",
    gpgcheck => 1,
    gpgkey   => "https://packages.confluent.io/rpm/${confluent_major_version}/archive.key",
    enabled  => 1,
  }

  # Install the Confluent Kafka package (includes Kafka broker and tools).
  package { 'confluent-kafka':
    ensure  => installed,
    require => [Yumrepo['confluent'], Package[$java_package]],
  }

  # Enable and start the Kafka broker service.
  service { 'confluent-kafka':
    ensure  => running,
    enable  => true,
    require => Package['confluent-kafka'],
  }

}
