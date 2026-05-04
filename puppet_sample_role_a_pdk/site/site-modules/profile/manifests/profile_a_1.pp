# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/production/site-modules/profile/manifests/profile_a_1.pp

# @summary Profile A-1: includes module_1 and module_2.
#
# This sub-profile handles nodes that need both the file resources
# from module_1 and the web/time services from module_2.
#
class profile::profile_a_1 {
  # module_1: manages /etc/hosts, a template file, and an inline-content file
  include module_1

  # module_2: manages the httpd web server and chrony time synchronization service
  include module_2
}
