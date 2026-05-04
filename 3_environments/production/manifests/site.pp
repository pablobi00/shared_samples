# site.pp - Production environment
# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/production/manifests/site.pp
#
# This is the main manifest. Puppet reads this file first on every agent run.
# It decides WHICH role a node gets based on the node's certificate name.
#
# In Puppet Enterprise, you can also assign roles in the PE Console instead.

# --- Frontend nodes (web tier, RHEL) ---
# Example certnames: prod-frontend-01.example.com
node /^prod-frontend/ {
  include roles::frontend
}

# --- Middleware nodes (app tier, RHEL) ---
# Example certnames: prod-middleware-01.example.com
node /^prod-middleware/ {
  include roles::middleware
}

# --- Backend nodes (database tier, RHEL) ---
# Example certnames: prod-backend-01.example.com
node /^prod-backend/ {
  include roles::backend
}

# --- Default catch-all ---
node default {
  notify { 'no-role-assigned':
    message => "Node ${trusted['certname']} has no role assigned in site.pp. Please classify it in the PE Console.",
  }
}
