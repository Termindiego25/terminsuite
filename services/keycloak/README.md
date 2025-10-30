# Keycloak — TerminSuite Identity and Access Management

Keycloak provides centralized **authentication and identity management** for TerminSuite, integrating with **OpenLDAP** as the user directory and supporting **SCIM provisioning** via a custom outbound plugin.

---

## 🧭 Overview

| Component                | Description                                                         |
| ------------------------ | ------------------------------------------------------------------- |
| **Keycloak**             | Core IAM server handling authentication, realms, and SSO.           |
| **PostgreSQL**           | Backend database storing realms, configurations, and user metadata. |
| **SCIM Plugin**          | Custom extension enabling outbound SCIM 2.0 provisioning.           |
| **OpenLDAP Integration** | External directory used for account synchronization.                |

---

## 📁 Directory Structure

```
/apps/keycloak
├── backup_keycloak-realms.sh
├── docker-compose.yaml          # Docker stack definition
├── Dockerfile                   # Custom Keycloak image build
├── keycloak.env                 # Keycloak environment variables
├── postgresql.env               # Database environment variables
├── providers/                   # Plugin JARs (SCIM, custom extensions)
│   └── keycloak-scim-outbound-1.0.0-SNAPSHOT.jar
├── secrets/
│   └── credentials/             # Secure database credentials
│       ├── db_database.txt
│       ├── db_username.txt
│       └── db_password.txt
└── secrets/realms/              # Predefined realm imports
```

---

## 🔧 Configuration

### Environment Files

* `keycloak.env` — Keycloak runtime and SSL configuration
* `postgresql.env` — PostgreSQL connection parameters
* Secrets (database credentials) are securely loaded from `secrets/credentials/` and mapped as Docker secrets

> Note: Keycloak currently does **not** support Docker Secrets directly; variables are passed via `.env` substitution.

---

## 🔒 Integration with OpenLDAP

Keycloak connects to OpenLDAP through the shared Docker network `openldap_net`.

### Steps to configure LDAP

1. Navigate to **Keycloak Admin Console → User Federation → Add provider → LDAP**
2. Configure:

   * **Connection URL:** `ldap://openldap:1389`
   * **Bind DN:** `cn=admin,dc=termin,dc=lan`
   * **Bind Credential:** LDAP admin password
   * **Users DN:** `ou=people,dc=termin,dc=lan`
   * **Username LDAP attribute:** `uid`
   * **RDN LDAP attribute:** `uid`
   * **UUID LDAP attribute:** `entryUUID`
   * **User object classes:** `inetOrgPerson, organizationalPerson`
3. Enable:

   * ✅ *Use Truststore SPI*
   * ✅ *Import Users*
   * ✅ *Sync Registrations*
4. Save and **test the connection**.

Once configured, Keycloak authenticates users directly against OpenLDAP and synchronizes user attributes automatically.

---

## 🌐 SCIM Outbound Plugin

The [Keycloak SCIM Outbound Provider](https://github.com/Termindiego25/keycloak-scim-outbound) allows provisioning of users and groups to external systems that support **SCIM 2.0**.

### Installation

Place the plugin JAR in:

```
/apps/keycloak/providers/
```

and rebuild the container image:

```bash
docker compose build keycloak_server
```

### Configuration

1. Start Keycloak and log in as an admin.
2. Go to **Realm Settings → Events**.
3. Add `keycloak-scim-outbound` to the list of **Event listeners**.
4. For each connected SCIM-compatible application, configure a **User Federation Provider**.

Provisioning will automatically synchronize user creation, updates, and deletions to connected systems.

---

## 🚀 Deployment

### Start the stack

```bash
docker compose up -d
```

### Verify

Check that both containers are running:

```bash
docker ps | grep keycloak
```

Access Keycloak through your Cloudflare-protected domain:

```
https://keycloak.domain.com
```

---

## 🧰 Maintenance

### View logs

```bash
docker logs -f keycloak_server
```

### Update or rebuild

```bash
docker compose pull && docker compose up -d
```

To rebuild custom images (for plugin or server updates):

```bash
docker compose build keycloak_server
```

---

## 💾 Realm Backup and Recovery

To ensure the Keycloak configuration and realm data are preserved, a backup script is included at:

```
/apps/keycloak/backup_keycloak-realms.sh
```

### Script Overview

This script exports all realms and user data from the running Keycloak container into the `/opt/keycloak/data/import` directory, which is mounted on the host system. It can be scheduled via **cron** or executed manually.

#### 🧩 Usage

Run the backup manually:

```bash
bash /apps/keycloak/backup_keycloak-realms.sh
```

Or schedule it with `cron` (e.g., daily at 2 AM):

```bash
0 2 * * * /apps/keycloak/backup_keycloak-realms.sh
```

#### 📦 Output

The exported realms are stored under:

```
/apps/keycloak/secrets/realms/
```

These files can be re-imported automatically when Keycloak starts, thanks to the mounted volume and the `--import-realm` startup flag defined in the `docker-compose.yaml`.

---

## 🧱 Networking

| Network        | Purpose                                                |
| -------------- | ------------------------------------------------------ |
| `keycloak_net` | Internal communication between Keycloak and PostgreSQL |
| `openldap_net` | Shared network with OpenLDAP for user synchronization  |

---

## 🔐 Reverse Proxy (Traefik)

Keycloak is exposed **internally** via port `12443`, and **externally** through Traefik using Cloudflare SSL certificates.

Corresponding site definition:

```
/apps/traefik/conf/sites/keycloak.yaml
```

---

## 📚 References

* 🔗 [Keycloak Official Documentation](https://www.keycloak.org/documentation)
* 🔗 [PostgreSQL Docker Hub](https://hub.docker.com/_/postgres)
* 🔗 [Keycloak SCIM outbound plugin](https://github.com/Termindiego25/keycloak-scim-outbound)

---

**Maintainer:** Termindiego25
**Part of:** [TerminSuite Project](https://github.com/Termindiego25/terminsuite)