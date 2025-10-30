# PiHole setup (TerminSuite DNS Server)

## 🧭 Overview  
This service deploys **Pi-hole** as a local DNS and ad-blocking server, integrated with **Unbound** as a recursive DNS resolver.  
This setup removes reliance on public DNS providers (such as Cloudflare or Google) and ensures full privacy and control over DNS queries.

---

## 🔗 Integration with Unbound  
Pi-hole connects to the shared `unbound_net` Docker network to communicate with the Unbound container.  
The upstream resolver is defined via:

```
FTLCONF_DNS_UPSTREAMS=unbound#5335
```

This allows Pi-hole to forward all DNS requests to Unbound, which resolves them recursively from the root DNS servers.

---

## 🔐 Security  
* **Web admin password** is handled through Docker Secrets (`secrets/web_password.txt`).  
* **DNSMASQ_LISTENING=all** enables Pi-hole to listen on all interfaces — make sure to restrict access via firewall rules if exposed to multiple networks.  
* It is **strongly recommended** to access the Pi-hole web interface via **HTTPS** or behind a secure proxy (e.g., Traefik + Cloudflare Tunnel) when accessible remotely.

---

## 📁 Directory structure  
```
/apps/pihole
├── docker-compose.yaml       # Main deployment file
├── pihole.env                # Environment configuration
├── etc-pihole/               # Persistent Pi-hole configuration
├── etc-dnsmasq.d/            # Additional DNS configuration
├── secrets/
│   └── web_password.txt      # Web admin password (Docker Secret)
````

---

## 🚀 Deployment  
1. **Ensure the external Unbound network exists:**  
   ```bash
   docker network create unbound_net
    ```

2. **Create the secret file:**

   ```bash
   echo "strong_password" > secrets/web_password.txt
   chmod 600 secrets/web_password.txt
   ```
3. **Start the stack:**

   ```bash
   docker compose up -d
   ```
4. **Access the web interface:**

   ```
   https://pihole.domain.com/admin
   ```

   * **Password**: read from `secrets/web_password.txt`

---

## 🧠 Notes

* Pi-hole persists configuration and blocklists in `./etc-pihole`.
* Custom ad-lists can be added via the web UI or directly by editing files in `etc-pihole` or `etc-dnsmasq.d`.
* To use Pi-hole as your network DNS, configure your router or clients to point to the Pi-hole host IP address (e.g., `10.18.0.X`).
* Additional environment variables are supported (see official documentation) for advanced configuration (e.g., `ServerIP`, `WEB_PORT`, `DNSMASQ_USER`, etc.).

---

## 📚 References

* 🔗 [Pi-hole Official Documentation](https://docs.pi-hole.net/)
* 🔗 [Pi-hole Docker repo](https://github.com/pi-hole/docker-pi-hole)
* 🔗 [Pi-hole + Unbound Guide](https://docs.pi-hole.net/guides/unbound/)

---

**Maintainer:** Termindiego25
**Part of:** [TerminSuite Project](https://github.com/Termindiego25/terminsuite)