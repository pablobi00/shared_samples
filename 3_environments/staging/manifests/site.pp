# site.pp - Staging environment
# Absolute path in Puppet Enterprise:
# /etc/puppetlabs/code/environments/staging/manifests/site.pp
#
# This is the main manifest. Puppet reads this file first on every agent run.
# It decides WHICH role a node gets based on the node's certificate name.
#
# In Puppet Enterprise, you can also assign roles in the PE Console instead.

# --- Frontend nodes (web tier, RHEL) ---
# Example certnames: stg-frontend-01.example.com
node /^stg-frontend/ {
  include roles::frontend
}

# --- Middleware nodes (app tier, RHEL) ---
# Example certnames: stg-middleware-01.example.com
node /^stg-middleware/ {
  include roles::middleware
}

# --- Backend nodes (database tier, RHEL) ---
# Example certnames: stg-backend-01.example.com
node /^stg-backend/ {
  include roles::backend
}

# --- Default catch-all ---
node default {
  notify { 'no-role-assigned':
    message => "Node ${trusted['certname']} has no role assigned in site.pp. Please classify it in the PE Console.",
  }
}
