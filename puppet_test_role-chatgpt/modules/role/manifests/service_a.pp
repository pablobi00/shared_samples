# This class defines the role named service-a.
# A role should stay small and only include the profiles needed by the node.
class role::service_a {
  # Include the frontend-linux profile.
  # The profile contains the actual implementation details.
  include profile::frontend_linux
}
