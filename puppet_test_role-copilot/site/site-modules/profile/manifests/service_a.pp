# @summary Service A technology stack (Apache + MySQL) for Rocky/Alma Linux.
#
# This profile wraps supported component modules:
# - puppetlabs-apache
# - puppetlabs-mysql
#
class profile::service_a (
  Integer $apache_port        = lookup('profile::service_a::apache_port', Integer, 'first', 80),
  Stdlib::Absolutepath $docroot = lookup('profile::service_a::docroot', Stdlib::Absolutepath, 'first', '/var/www/service-a'),
  String $servername          = lookup('profile::service_a::servername', String, 'first', $facts['fqdn']),

  String $mysql_root_password = lookup('profile::service_a::mysql_root_password', String, 'first', 'ChangeMe-Root'),
  String $app_db_name         = lookup('profile::service_a::app_db_name', String, 'first', 'service_a'),
  String $app_db_user         = lookup('profile::service_a::app_db_user', String, 'first', 'servicea'),
  String $app_db_password     = lookup('profile::service_a::app_db_password', String, 'first', 'ChangeMe-App'),

  Enum['default','mariadb'] $mysql_flavor = lookup('profile::service_a::mysql_flavor', Enum['default','mariadb'], 'first', 'default'),
) {

  # ---------- Apache ----------
  class { 'apache':
    default_vhost => false,
  }

  file { $docroot:
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0755',
  }

  file { "${docroot}/index.html":
    ensure  => file,
    owner   => 'apache',
    group   => 'apache',
    mode    => '0644',
    content => "<html><body><h1>service-a is up</h1></body></html>
",
  }

  apache::vhost { 'service-a':
    port     => $apache_port,
    docroot  => $docroot,
    servername => $servername,
    options  => ['Indexes','FollowSymLinks'],
    override => ['All'],
    access_log_file => 'service-a_access.log',
    error_log_file  => 'service-a_error.log',
  }

  # ---------- MySQL ----------
  # NOTE: For production, store secrets using eyaml or an external secrets backend.
  $root_pw = Sensitive($mysql_root_password)

  if $mysql_flavor == 'mariadb' {
    class { 'mysql::server':
      root_password => $root_pw,
      package_name  => 'mariadb-server',
      service_name  => 'mariadb',
      restart       => true,
    }
  } else {
    class { 'mysql::server':
      root_password => $root_pw,
      restart       => true,
    }
  }

  mysql::db { $app_db_name:
    user     => $app_db_user,
    password => Sensitive($app_db_password),
    host     => 'localhost',
    grant    => ['ALL'],
    charset  => 'utf8mb4',
    collate  => 'utf8mb4_unicode_ci',
    require  => Class['mysql::server'],
  }

}
