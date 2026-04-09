# site/profiles/manifests/frontend_linux.pp
#
# PROFILE: profiles::frontend_linux
# -------------------------------------------------------
# A Profile sits between a Role and the component modules.
# It answers the question: "What technology stack does this role need?"
#
# Rules for profiles:
#   1. A role can include many profiles.
#   2. Profiles CAN look up data from Hiera.
#   3. Profiles include component modules (like apache_stack, mysql_stack).
# -------------------------------------------------------

class profiles::frontend_linux {

  # Include the Apache component module.
  # apache_stack::init.pp handles package install + service management.
  include apache_stack

  # Include the MySQL component module.
  # mysql_stack::init.pp handles package install + service management.
  include mysql_stack

}
