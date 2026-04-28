# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/production/site-modules/profile/manifests/profile_a.pp

# @summary Profile A: parent profile for application stack sub-profiles.
#
# This profile groups related sub-profiles together.
# It delegates all resource management to its sub-profiles
# rather than declaring resources directly.
#
class profile::profile_a {
  # Sub-profile that manages module_1 (file resources) and module_2 (httpd + chrony)
  include profile::profile_a_1

  # Sub-profile that manages module_1 (file resources) only
  include profile::profile_a_2
}
