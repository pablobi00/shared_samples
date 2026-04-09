# This file is the main entry point for the environment.
# In a real control repo, nodes can be matched here by certname, facts, or external node classifiers.
# For this demo, we assign the service-a role to every node.
node default {
  # Include the role class.
  # A role is a small wrapper class that assigns one or more profiles.
  include role::service_a
}
