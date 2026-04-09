# @summary Role: service-a
#
# In Puppet class naming, dashes aren't allowed, so the *class* is role::service_a.
# You can still name the node group "service-a" in Puppet Enterprise.
#
class role::service_a {
  include profile::service_a
}
