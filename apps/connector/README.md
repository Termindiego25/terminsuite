# Connector Setup (TerminSuite SSH Tunnel Service)

## 🧭 Overview

The **Connector** service provides a secure, persistent SSH bridge between the internal TerminSuite infrastructure and remote Raspberry Pi nodes hosting additional components.
It uses **AutoSSH** to automatically maintain tunnels and reconnect if a connection drops.

---

## 🧱 Architecture

```
[Connector] ── SSH ──► [Remote RPi5 Nodes] → Remote Services
```

* The Connector establishes and maintains SSH tunnels to other Raspberry Pi devices in the TerminSuite cluster.
* Each tunnel forwards specific remote service ports to the local Docker network.
* **AutoSSH** ensures tunnels remain active and automatically restarts them if they fail.

---

## 📁 Directory Structure

```
/connector
├── docker-compose.yaml   # Docker stack definition
├── Dockerfile            # Build configuration
├── entrypoint.sh         # Startup script for SSH tunnels
└── ssh/
    ├── config            # SSH host definitions
    ├── rpi5b.key         # Private key for RPi5-B (600 perms)
    └── rpi5c.key         # Private key for RPi5-C (600 perms)
```

---

## 🚀 Deployment

### 1. Build and run

```bash
docker compose up -d
```

### 2. Verify tunnels

Inside the container:

```bash
docker exec -it connector bash
ps aux | grep autossh
```

You should see two `autossh` processes running, one for each Raspberry Pi.

### 3. Validate port forwarding

On the host:

```bash
netstat -tulnp | grep 11443
```

The ports defined in `entrypoint.sh` should appear as listening on `0.0.0.0`.

---

## 🔐 Security Recommendations

* Keep all SSH private keys with `chmod 600`.
* Allow connections only from trusted internal IP ranges.
* Rotate SSH keys periodically.
* Consider using `ProxyJump` in the SSH config if a central bastion host is implemented.

---

**Maintainer:** [Termindiego25](https://github.com/Termindiego25)
**Part of:** [TerminSuite Project](https://github.com/Termindiego25/terminsuite)