# OpenLDAP setup (TerminSuite Directory Service)

## 🧭 Overview

OpenLDAP is a lightweight, open-source directory service that provides centralized user and group management.
Within **TerminSuite**, it acts as the **core identity backend**, serving as the primary user database for services like **Keycloak** (SSO), **FreeRADIUS**, and other components that require LDAP authentication.

This setup uses the **Bitnami OpenLDAP** image, secured with **Docker Secrets** to protect administrative credentials and a set of **custom LDIF files** defining your directory structure.

---

## 📁 Directory structure

```
openldap/
├─ docker-compose.yaml
├─ openldap.env
├─ secrets/
│  ├─ admin_username.txt
│  └─ admin_password.txt
├─ data/
│  └─ ... (persistent LDAP database)
└─ ldif/
   ├─ 00-base.ldif
   ├─ 10-users.ldif
   └─ 20-groups.ldif
```

* `docker-compose.yaml`: Defines the OpenLDAP container and its secrets.
* `openldap.env`: Contains non-sensitive environment variables.
* `secrets/`: Stores Docker Secrets for secure credentials.
* `ldif/`: Contains the initial LDAP structure definitions.
* `data/`: Persistent volume for the database.

---

## 🧬 LDAP tree structure

The LDAP base (`dc=domain,dc=com`) is organized as follows:

```
dc=domain,dc=com
├── ou=people
│   ├── uid=openldap
│   └── uid=person
└── ou=groups
    ├── cn=admins
    └── cn=users
```

---

## 🔐 Secure credentials with Docker Secrets

Sensitive credentials are stored as **Docker Secrets**, never exposed in environment variables or logs.

### 1️⃣ Create the secrets

```bash
mkdir -p secrets
echo "openldap" > secrets/admin_username.txt
echo "STRONG_PASSWORD_HERE" > secrets/admin_password.txt
```

### 2️⃣ Verify permissions

```bash
chmod 600 secrets/*.txt
```

### 3️⃣ Define them in `docker-compose.yaml` (see below)

---

## 📂 Custom LDIF files

Each `.ldif` file defines a specific part of the directory:

| File             | Description                                                               |
| ---------------- | ------------------------------------------------------------------------- |
| `00-base.ldif`   | Defines the base domain (`dc=domain,dc=com`) and OUs `people` / `groups`. |
| `10-users.ldif`  | Defines users with their attributes and passwords.                        |
| `20-groups.ldif` | Defines groups and memberships.                                           |

All LDIFs are imported automatically during the **first container startup**.

---

## 🚀 Deployment steps

1. **Build secrets and environment**

   ```bash
   mkdir -p secrets data
   echo "openldap" > secrets/admin_username.txt
   echo "YOUR_STRONG_PASSWORD" > secrets/admin_password.txt
   chmod 600 secrets/*.txt
   ```

2. **Start the container**

   ```bash
   docker compose up -d
   ```

3. **Verify startup**

   ```bash
   docker logs -f openldap
   ```

4. **Connect to the LDAP server**

   ```bash
   ldapsearch -x -H ldap://localhost:1389 \
     -D "cn=openldap,dc=domain,dc=com" \
     -w YOUR_STRONG_PASSWORD \
     -b "dc=domain,dc=com"
   ```

---

## 🌐 Integration points

* **Keycloak** — Identity broker (SSO) using LDAP backend
* **FreeRADIUS** — Network access authentication via LDAP
* **Passbolt / others** — Centralized authentication using the same directory

---

## 🧠 Notes

* LDIFs are **read-only** inside the container.
* The LDAP database is persisted under `./data`.
* Admin credentials are stored securely via **Docker Secrets**.
* The service runs in an isolated network: `openldap_net`.

---

## 📚 Official Documentation

🔗 [Bitnami OpenLDAP Docs](https://hub.docker.com/r/bitnami/openldap)
🔗 [OpenLDAP Project](https://www.openldap.org/)

---

**Maintainer:** Termindiego25
**Part of:** [TerminSuite Project](https://github.com/Termindiego25/terminsuite)