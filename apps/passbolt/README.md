# Passbolt — TerminSuite Password Manager

Passbolt is an **open-source, self-hosted password manager** built for teams and enterprises.
Within **TerminSuite**, Passbolt provides **secure credential management** for shared accounts and secrets, integrated with **Keycloak** for **Single Sign-On (SSO)** and **SCIM provisioning**.

---

## 🧭 Overview

| Component                | Description                                                       |
| ------------------------ | ----------------------------------------------------------------- |
| **Passbolt Server**      | Core web application and API handling user access and encryption. |
| **MariaDB**              | Database backend for storing Passbolt configuration and metadata. |
| **Docker Secrets**       | Secure storage of database credentials and GPG keys.              |
| **Keycloak Integration** | Provides SSO (OpenID Connect) and user synchronization via SCIM.  |

---

## 📁 Directory Structure

```
/passbolt
├── backup_passbolt-db.sh
├── docker-compose.yaml
├── mariadb.env
├── passbolt.env
└── secrets/
    ├── credentials/
    │   ├── db_database.txt
    │   ├── db_username.txt
    │   └── db_password.txt
    ├── gpg/
    │   ├── serverkey.asc
    │   └── serverkey_private.asc
    ├── passbolt.sql
    └── subscription_key.txt         # Only required for PRO version
```

---

## 🔧 Configuration

### Environment Files

| File                    | Purpose                                                       |
| ----------------------- | ------------------------------------------------------------- |
| `passbolt.env`          | Main configuration for Passbolt (URL, GPG, email, SSO, LDAP). |
| `mariadb.env`           | MariaDB service configuration (port, credentials, DB name).   |
| `secrets/credentials/*` | Docker secrets for database authentication.                   |
| `secrets/gpg/*`         | GPG keys used by Passbolt for encryption/decryption.          |

All secrets are mounted as **Docker Secrets** for secure runtime injection.

---

## 🔐 Reverse Proxy (Traefik)

Define the Traefik site under:

```
/apps/traefik/conf/sites/passbolt.yaml
```

Example configuration:

```yaml
http:
  routers:
    passbolt:
      entryPoints:
        - websecure
      rule: "Host(`passbolt.domain.com`)"
      service: passbolt
      tls:
        certresolver: cloudflare

  services:
    passbolt:
      loadBalancer:
        servers:
          - url: "http://connector:11443"  # Internal SSH tunnel port
```

---

## 🚀 Deployment

### 1. Prepare secrets

Ensure all required secrets are stored in `/passbolt/secrets`.

> ⚠️ Each secret file must contain **only** the value — no extra spaces, newlines, or comments.

### 2. Initialize database

Optionally include an initial SQL dump at:

```
/passbolt/secrets/passbolt.sql
```

This will be automatically imported on first container startup.

### 3. Deploy service

```bash
cd /passbolt
docker compose up -d
```

Once deployed, Passbolt will be accessible internally at:

```
https://passbolt.domain.com
```

---

## 🔒 Security

* All credentials and keys are loaded via **Docker Secrets**.
* The service is bound to `127.0.0.1` to enforce **reverse-proxy-only** access.
* GPG keys are mandatory for Passbolt encryption/decryption.
* Database traffic remains isolated within the internal Docker network `passbolt_net`.

---

## 💾 Database Backup and Recovery

A scheduled backup script is provided at:

```
/apps/passbolt/backup_passbolt-db.sh
```

### Usage

```bash
chmod +x /apps/passbolt/backup_passbolt-db.sh
/apps/passbolt/backup_passbolt-db.sh
```

> The dump is saved at `/apps/passbolt/secrets/bk.sql`.
> To restore, rename it to `passbolt.sql` before redeploying the container.

---

## 🧩 Keycloak Integration

### 🔐 Single Sign-On (SSO)

Passbolt supports **OpenID Connect SSO** via Keycloak.

#### Steps

1. In **Passbolt Web UI → Organization Settings → Authentication → Single Sign-On**:

   * Select **OpenID** as provider.
   * Copy the **Redirect URL** displayed there.
2. In **Keycloak Admin Console → Clients → Create**:

   * Client type: `OpenID Connect`
   * Client ID: `passbolt`
   * Enable **Client authentication**.
   * Enable **Authentication flows**: `Standard flow` and `Service accounts roles`.
   * Root URL: `https://passbolt.domain.com`
   * Valid redirect URIs: `$REDIRECT_URL_FROM_PASSBOLT`
   * Web Origins: `https://passbolt.domain.com`
3. After creation:

   * Copy the **Client ID** (from *Settings* tab).
   * Copy the **Client Secret** (from *Credentials* tab).
4. Go to **Realm Settings → OpenID Endpoint Configuration** and copy its URL.
5. Back in Passbolt → **Organization Settings → Authentication → Single Sign-On**:

   * Login URL: `$OPENID_ENDPOINT_CONFIGURATION_FROM_KEYCLOAK` (everything **before** `.well-known`)
   * OpenID Configuration Path: `$OPENID_ENDPOINT_CONFIGURATION_FROM_KEYCLOAK` (from `.well-known` onward)
   * Scope: `openid email profile`
   * Application (Client) ID: `$CLIENT_ID_FROM_KEYCLOAK`
   * Secret: `$CLIENT_SECRET_FROM_KEYCLOAK`
6. Ensure the following line is set in your `.env`:

```env
PASSBOLT_PLUGINS_SSO_PROVIDER_OAUTH2_ENABLED=true
```

---

### 👥 Directory Sync (SCIM)

> 🧩 *Requires Passbolt PRO.*

To synchronize users and groups from Keycloak via SCIM:

1. In **Passbolt Web UI → Organization Settings → User Provisioning → SCIM**:

   * Enable SCIM.
   * Copy **SCIM URL** and **Secret Token**.
   * Set **SCIM User**.

2. In **Keycloak → User Federation → Add new provider → Keycloak-scim-outbound**:

   * UI display name: `Passbolt`
   * SCIM Base URL: `$SCIM_URL_FROM_PASSBOLT`
   * SCIM Token: `$SECRET_TOKEN_FROM_PASSBOLT`
   * userNameStrategy: `email`

Users will now be automatically provisioned and synchronized via SCIM.

---

## 🧰 Maintenance

| Action            | Command                                       |
| ----------------- | --------------------------------------------- |
| Rebuild image     | `docker compose build passbolt_server`        |
| Update containers | `docker compose pull && docker compose up -d` |
| View logs         | `docker logs -f passbolt_server`              |

---

## 📚 References

* 🔗 [Passbolt Official Documentation](https://www.passbolt.com/docs/)
* 🔗 [Passbolt Docker Repository](https://github.com/passbolt/passbolt_docker)
* 🔗 [SCIM User Provisioning Guide](https://www.passbolt.com/docs/admin/user-provisioning/scim/)

---

**Maintainer:** Termindiego25
**Part of:** [TerminSuite Project](https://github.com/Termindiego25/terminsuite)