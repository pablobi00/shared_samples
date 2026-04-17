# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/production/site-modules/profile/manifests/profile_a_2.pp

# @summary Profile A-2: includes module_1 only.
#
# This sub-profile handles nodes that need only the file resources
# from module_1 (no web server or time services).
#
class profile::profile_a_2 {
  # module_1: manages /etc/hosts, a template file, and an inline-content file
  include module_1
}
