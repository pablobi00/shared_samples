# site.pp - Development environment
# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/development/manifests/site.pp
#
# This is the main manifest. Puppet reads this file first on every agent run.
# It decides WHICH role a node gets based on the node's certificate name.
#
# In Puppet Enterprise, you can also assign roles in the PE Console instead.
# Using the Console is preferred for larger environments.

# --- Developer workstations (Windows desktops) ---
# Any node whose certname starts with "dev-win" gets the developer_system role.
# Example certnames: dev-win-alice.example.com, dev-win-bob.example.com
node /^dev-win/ {
  include roles::developer_system
}

# --- Application servers (RHEL nodes) ---
# Any node whose certname starts with "dev-app" gets the application_server role.
# Example certnames: dev-app-01.example.com, dev-app-02.example.com
node /^dev-app/ {
  include roles::application_server
}

# --- Default catch-all ---
# Any node that does not match a pattern above lands here.
# It receives no role and gets a message in the Puppet run report.
node default {
  notify { 'no-role-assigned':
    message => "Node ${trusted['certname']} has no role assigned in site.pp. Please classify it in the PE Console.",
  }
}
