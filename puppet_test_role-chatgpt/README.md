# service-a demo control repo

This demo/lab example provides:

- A **role** named `role::service_a`
- A **profile** named `profile::frontend_linux`
- Apache deployment with the `httpd` package
- MySQL-compatible database deployment with the `mariadb-server` package
- Support for **Rocky Linux** and **AlmaLinux**

## Why MariaDB instead of MySQL?

On Rocky Linux and AlmaLinux, the default built-in repository typically provides **MariaDB** rather than Oracle MySQL.
MariaDB is commonly used as a MySQL-compatible database for labs and demos because it avoids adding extra repositories.

## Directory layout

- `manifests/site.pp` → assigns the role
- `modules/role/manifests/service_a.pp` → role class
- `modules/profile/manifests/frontend_linux.pp` → implementation profile
- `data/common.yaml` → Hiera data
- `hiera.yaml` → Hiera configuration
- `environment.conf` → Puppet environment module path

## Example apply command

```bash
sudo puppet apply manifests/site.pp
```
