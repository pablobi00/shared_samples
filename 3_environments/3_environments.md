# 3_environments — Puppet Demo Structure

## Directory layout (same pattern for all 3 environments)

```
3_environments/
├── development/
│   ├── environment.conf          ← tells Puppet where to find modules
│   ├── hiera.yaml                ← 3-level data lookup (node → OS → common)
│   ├── data/common.yaml          ← Hiera data (NTP servers, package names)
│   ├── manifests/site.pp         ← node classification by certname pattern
│   └── site/
│       ├── profiles/manifests/
│       │   ├── base/             ← RHEL base (ntp, firewall, packages)
│       │   ├── base_windows/     ← Windows base (ntp, firewall, packages)
│       │   ├── developer_system.pp
│       │   └── application_server.pp
│       └── roles/manifests/
│           ├── developer_system.pp
│           └── application_server.pp
├── staging/  (frontend, middleware, backend)
└── production/ (frontend, middleware, backend)
```

---

## Key design decisions explained

| Decision | Why |
|---|---|
| **Roles & Profiles pattern** | Roles assemble profiles. Profiles configure one technology. Roles never declare resources directly. |
| **Windows base profiles are separate** (`base_windows/`) | Developer machines are Windows; mixing OS logic inside a single base profile would be harder to read for beginners. |
| **`profiles::webserver` shared profile** | Both `frontend` and `middleware` need Apache. Puppet applies it only once even if included twice. |
| **Hiera for package names and versions** | Kafka version, Java package, PostgreSQL package all come from `data/common.yaml` via `lookup()`. Change the version in one place, it applies to all nodes. |
| **`unless` on every `exec`** | Makes commands idempotent — Puppet checks first, and only runs the command if the state is wrong. |

---

## Base profiles (all 3 environments, RHEL nodes)

- `site/profiles/manifests/base/ntp.pp` — installs `chrony`, starts `chronyd`, calls `timedatectl set-timezone America/Vancouver`, calls `timedatectl set-ntp true`, deploys `/etc/profile.d/datetime_format.sh` with `LC_TIME=en_CA.UTF-8` (YYYY.MM.DD, 24h)
- `site/profiles/manifests/base/firewall.pp` — installs/starts `firewalld`, opens SSH permanently
- `site/profiles/manifests/base/packages.pp` — `net-tools` (netstat), `iftop`, `curl`, `wget`

> **Note on "YYY.MM.DD"** — interpreted as `YYYY.MM.DD` (4-digit year). If a 3-digit year was intentional, update the `LC_TIME` locale or the registry value on Windows accordingly.

---

## Development environment

### Profiles

| Profile | File | What it configures |
|---|---|---|
| `profiles::base::ntp` | `base/ntp.pp` | chrony, timedatectl timezone + NTP, date format (RHEL) |
| `profiles::base::firewall` | `base/firewall.pp` | firewalld, SSH rule (RHEL) |
| `profiles::base::packages` | `base/packages.pp` | net-tools, iftop, curl, wget (RHEL) |
| `profiles::base_windows::ntp` | `base_windows/ntp.pp` | w32time, Pacific timezone, date format (Windows) |
| `profiles::base_windows::firewall` | `base_windows/firewall.pp` | Windows Defender Firewall, SSH rule (Windows) |
| `profiles::base_windows::packages` | `base_windows/packages.pp` | Chocolatey, curl, wget (Windows) |
| `profiles::developer_system` | `developer_system.pp` | Visual Studio Code via Chocolatey |
| `profiles::application_server` | `application_server.pp` | Apache httpd, PostgreSQL, Java 21 |

### Roles

| Role | Node pattern (certname) | OS | Profiles assembled |
|---|---|---|---|
| `roles::developer_system` | `dev-win-*` | Windows | base_windows::ntp, base_windows::firewall, base_windows::packages, developer_system |
| `roles::application_server` | `dev-app-*` | RHEL | base::ntp, base::firewall, base::packages, application_server |

---

## Staging environment

### Profiles

| Profile | File | What it configures |
|---|---|---|
| `profiles::base::ntp` | `base/ntp.pp` | chrony, timedatectl timezone + NTP, date format |
| `profiles::base::firewall` | `base/firewall.pp` | firewalld, SSH rule |
| `profiles::base::packages` | `base/packages.pp` | net-tools, iftop, curl, wget |
| `profiles::webserver` | `webserver.pp` | Apache httpd (shared, included by frontend and middleware) |
| `profiles::frontend` | `frontend.pp` | includes webserver + opens ports 80 and 8080 |
| `profiles::middleware` | `middleware.pp` | includes webserver + Java 21 + Python FastAPI + Kafka |
| `profiles::backend` | `backend.pp` | PostgreSQL + opens port 5432 |

### Roles

| Role | Node pattern (certname) | Profiles assembled |
|---|---|---|
| `roles::frontend` | `stg-frontend-*` | base::ntp, base::firewall, base::packages, frontend |
| `roles::middleware` | `stg-middleware-*` | base::ntp, base::firewall, base::packages, middleware |
| `roles::backend` | `stg-backend-*` | base::ntp, base::firewall, base::packages, backend |

---

## Production environment

### Profiles

| Profile | File | What it configures |
|---|---|---|
| `profiles::base::ntp` | `base/ntp.pp` | chrony, timedatectl timezone + NTP, date format |
| `profiles::base::firewall` | `base/firewall.pp` | firewalld, SSH rule |
| `profiles::base::packages` | `base/packages.pp` | net-tools, iftop, curl, wget |
| `profiles::webserver` | `webserver.pp` | Apache httpd (shared, included by frontend and middleware) |
| `profiles::frontend` | `frontend.pp` | includes webserver + opens ports 80 and 8080 |
| `profiles::middleware` | `middleware.pp` | includes webserver + Java 21 + Python FastAPI + Kafka |
| `profiles::backend` | `backend.pp` | PostgreSQL + opens port 5432 |

### Roles

| Role | Node pattern (certname) | Profiles assembled |
|---|---|---|
| `roles::frontend` | `prod-frontend-*` | base::ntp, base::firewall, base::packages, frontend |
| `roles::middleware` | `prod-middleware-*` | base::ntp, base::firewall, base::packages, middleware |
| `roles::backend` | `prod-backend-*` | base::ntp, base::firewall, base::packages, backend |

---

## Forge modules required

Install these into each environment's `modules/` directory before applying to nodes.

| Module | Used by |
|---|---|
| `chocolatey/chocolatey` | `base_windows::packages`, `developer_system` |
| PowerShell provider (built into PE agent for Windows) | All `base_windows` profiles |
