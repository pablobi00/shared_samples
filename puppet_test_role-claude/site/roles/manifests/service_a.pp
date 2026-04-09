# site/roles/manifests/service_a.pp
#
# ROLE: roles::service_a
# -------------------------------------------------------
# A Role is the TOP level of the Roles & Profiles pattern.
# It answers the question: "What is this machine FOR?"
#
# Rules for roles:
#   1. A node gets exactly ONE role.
#   2. A role does nothing itself — it only includes profiles.
#   3. No Hiera lookups, no resource declarations here.
# -------------------------------------------------------

class roles::service_a {

  # Include the profile that describes HOW this role is built.
  # profiles::frontend_linux will pull in Apache + MySQL.
  include profiles::frontend_linux

}
