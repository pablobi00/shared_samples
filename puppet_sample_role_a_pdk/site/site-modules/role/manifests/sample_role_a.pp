# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/production/site-modules/role/manifests/sample_role_a.pp

# @summary Role: sample_role_a
#
# Top-level role for nodes in the "sample_role_a" group.
# Roles only include profiles — no direct resources are declared here.
#
class role::sample_role_a {
  # Include the primary application profile (which includes sub-profiles a_1 and a_2)
  include profile::profile_a

  # Include the supporting services profile (httpd, chrony, mariadb)
  include profile::profile_b
}
