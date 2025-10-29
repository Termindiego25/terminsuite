# Unbound setup (TerminSuite Recursive DNS Resolver)

## 🧭 Overview

**Unbound** is a validating, recursive, and caching DNS resolver.
Within **TerminSuite**, it acts as the **secure upstream DNS backend** for **Pi-hole**, ensuring **privacy**, **DNSSEC validation**, and **independent recursive resolution** (without relying on third-party DNS providers).

This setup uses the **mvance/unbound** Docker image, configured for **hardened DNS recursion**, **DNSSEC validation**, and **low-latency caching**.

---

## 📁 Directory structure

```
unbound/
├─ docker-compose.yaml
└─ unbound/
   ├─ unbound.conf
   ├─ root.hints
```

| File                  | Description                                                      |
| --------------------- | ---------------------------------------------------------------- |
| `docker-compose.yaml` | Defines and runs the Unbound container service.                  |
| `unbound.conf`        | Core configuration file with security and performance tuning.    |
| `root.hints`          | List of root DNS servers (for true recursive resolution).        |

---

## 🔧 Configuration overview

The configuration defines Unbound as a **recursive-only** resolver that listens on port `5335`.
It enforces **DNSSEC validation**, **query name minimization**, and **strict access control**.

### Key parameters

| Parameter                        | Purpose                                                                        |
| -------------------------------- | ------------------------------------------------------------------------------ |
| `interface` and `port`           | Defines listening interfaces and custom port for Pi-hole integration (`5335`). |
| `auto-trust-anchor-file`         | Enables DNSSEC validation using the root key file (`var/root.key`).            |
| `hide-identity` / `hide-version` | Prevents fingerprinting of the resolver.                                       |
| `qname-minimisation`             | Reduces data exposure to upstream servers.                                     |
| `access-control`                 | Restricts usage to trusted networks only (local, Pi-hole, or internal).        |
| `root-hints`                     | Defines the list of authoritative root servers used for full recursion.        |

### DNSSEC trust anchor

The trust anchor file is automatically managed under:

```
/opt/unbound/etc/unbound/var/root.key
```

You can force a refresh inside the container with:

```bash
unbound-anchor -a /opt/unbound/etc/unbound/var/root.key
```

---

## 🛠️ Deployment

1. **Start the container:**

   ```bash
   docker compose up -d
   ```

2. **Check logs:**

   ```bash
   docker logs -f unbound
   ```

3. **Validate recursion and DNSSEC:**

   ```bash
   drill @127.0.0.1 -p 5335 example.com
   drill -D @127.0.0.1 -p 5335 dnssec-failed.org
   ```

   If the second query fails with `SERVFAIL`, DNSSEC validation is active ✅.

---

## 🔐 Security & network considerations

* Unbound must run in **standard Docker mode (rootful)** — **not** in Docker Rootless.
  Rootless mode restricts network and socket capabilities, which can break recursive resolution and DNSSEC validation.
* Access to Unbound is limited to trusted internal networks (Pi-hole, LAN, or Docker bridge).
* Logs are set at verbosity level `2` for operational monitoring; reduce this in production if desired.

---

## 🕓 Root hints maintenance

The file `root.hints` provides the authoritative root server list and should be updated every few months.

### Manual update:

```bash
curl -fsSL https://www.internic.net/domain/named.root -o unbound/root.hints
```

### Optional automation:

You can automate this with a cron task:

```bash
@monthly curl -fsSL https://www.internic.net/domain/named.root -o /apps/unbound/unbound/root.hints && docker restart unbound
```

---

## 🧠 Notes

* **Healthcheck** ensures that DNS queries resolve correctly and that DNSSEC validation works as expected.
* The resolver runs isolated in its own network (`unbound_net`), and Pi-hole connects internally via Docker or bridge.
* The configuration prioritizes **privacy, validation, and stability** over minimal latency.

---

## 📚 References

* 🔗 [Unbound Documentation](https://nlnetlabs.nl/documentation/unbound/unbound.conf/)
* 🔗 [mvance/unbound Docker Image](https://hub.docker.com/r/mvance/unbound)
* 🔗 [Pi-hole + Unbound Guide](https://docs.pi-hole.net/guides/unbound/)

---

**Maintainer:** Termindiego25
**Part of:** [TerminSuite Project](https://github.com/Termindiego25/terminsuite)