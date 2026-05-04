# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/production/site-modules/profile/manifests/profile_b.pp

# @summary Profile B: supporting services profile.
#
# Manages the web/time services from module_2 and the database
# from module_3. Used for nodes that act as application back-ends.
#
class profile::profile_b {
  # module_2: manages the httpd web server and chrony time synchronization service
  include module_2

  # module_3: manages a default MariaDB database server installation
  include module_3
}
