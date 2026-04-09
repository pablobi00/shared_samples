# Puppet Enterprise: service-a (frontend-linux) role + profile

This repo scaffold provides **roles & profiles** to deploy **Apache + MySQL** on **Rocky Linux** and **AlmaLinux** nodes using Puppet Enterprise.

It follows the *roles and profiles* method recommended by Puppet documentation. (See: Puppet Core docs – “The roles and profiles method”.)

## What you get

- `role::service_a` — the role class to assign in Puppet Enterprise.
- `profile::service_a` — installs/configures Apache and MySQL and creates a sample vhost + database.
- `Puppetfile` — pulls supported Forge modules:
  - `puppetlabs-apache` (Apache web server)
  - `puppetlabs-mysql` (MySQL service)

## Directory layout

```
puppet_test/
  site/
    Puppetfile
    environment.conf
    hiera.yaml
    data/
      common.yaml
      role/
        service-a.yaml
    site-modules/
      profile/
        manifests/
          service_a.pp
        metadata.json
      role/
        manifests/
          service_a.pp
        metadata.json
```

## How to use in Puppet Enterprise (high level)

1. Put the `site/` directory contents into your control-repo environment (e.g., `production/`).
2. Deploy with Code Manager / r10k.
3. In the PE console, **Node groups**:
   - Create or select the node group named **`frontend-linux`**.
   - Add the class **`role::service_a`** to that group.

### Facts / Hiera (optional)

The provided `hiera.yaml` supports role-based data if you set a fact named `role` (e.g., `role=service-a`). If you don't use that fact, everything falls back to `data/common.yaml`.

## Security note

`data/common.yaml` includes placeholder passwords. For real environments, store secrets using **eyaml** or an external secrets backend.

