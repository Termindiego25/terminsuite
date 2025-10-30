# Traefik Setup (TerminSuite Reverse Proxy)

## 🧭 Overview

**Traefik** acts as the **reverse proxy and secure entrypoint gateway** for TerminSuite.
It handles incoming connections (proxied through **Cloudflared**) and routes them to internal or remote Dockerized services across the TerminSuite network.

This configuration:

* Uses the **Cloudflare DNS-01 challenge** for automatic SSL/TLS certificate management.
* Applies **strict TLS policies** and **security headers** for enhanced protection.
* Dynamically detects Docker containers through the Docker socket.
* Optionally connects to remote services via preconfigured SSH tunnels (defined in `/conf/sites/`).

---

## 📁 Directory Structure

```
traefik
├── docker-compose.yaml       # Container deployment configuration
├── traefik.yaml              # Core Traefik configuration
├── traefik.env               # Environment variables (Cloudflare API token)
├── ssl/                      # SSL certificate storage (acme.json)
└── conf/                     # Additional middleware and TLS configuration
    ├── headers.yaml
    ├── tls.yaml
    └── sites/                # Individual site/router definitions (e.g. app.domain.com)
```

---

## 🚀 Deployment

### 1️⃣ Configure the Cloudflare Token

Traefik uses the **Cloudflare DNS-01 challenge** to automatically issue and renew SSL certificates via Let’s Encrypt.

#### Steps to create the API Token:

1. Go to your [Cloudflare Dashboard → My Profile → API Tokens](https://dash.cloudflare.com/profile/api-tokens)
2. Click **“Create Token”**
3. Choose the **“Edit zone DNS”** template or create a custom token
4. Under **Permissions**, set:

   * Zone → DNS → Edit
5. Under **Zone Resources**, set:

   * Include → All zones (or the specific zone you’ll use)
6. Click **Continue to summary → Create Token**
7. Copy the generated token

> ⚠️ **Important:** Keep this token private — it grants permission to modify DNS records in your Cloudflare account.

---

### 2️⃣ Configure Environment Variables

Create a `.env` file named `traefik.env` containing your Cloudflare DNS API token:

```bash
CF_DNS_API_TOKEN=$CF_DNS_API_TOKEN
```

> The token must have **Zone:DNS:Edit** permissions in Cloudflare.

---

### 3️⃣ Deploy the Container

From the `traefik` directory:

```bash
docker compose up -d
```

This will:

* Start the Traefik service.
* Connect automatically to the `cloudflared_net` network.
* Request and manage SSL certificates via the Cloudflare DNS-01 challenge.
* Expose HTTPS internally on port `4433` for secure routing.

---

### 4️⃣ Add Site Definitions

Each service (local or remote) is defined through a YAML file inside `conf/sites/`.
For example:

```yaml
http:
  routers:
    app:
      entryPoints:
        - websecure
      rule: "Host(`app.domain.com`)"
      service: app
      tls:
        certresolver: cloudflare

  services:
    app:
      loadBalancer:
        servers:
          - url: "http://$CONTAINER_NAME:$PORT$"
```

This configuration maps the hostname `app.domain.com` to the corresponding service exposed internally (e.g. via the **Connector** container’s SSH tunnels).

---

### 5️⃣ Verify Logs

To confirm proper operation:

```bash
docker logs -f traefik
```

If successful, you should see logs such as:

```
... Successfully obtained new certificate from ACME provider ...
```

---

## 🧹 Cleanup

To stop and remove the container:

```bash
docker compose down -v
```

To remove all stored SSL certificates:

```bash
rm -rf ssl/
```

---

## 🔐 Security Features

### TLS Configuration (`conf/tls.yaml`)

* Enforces **TLS 1.2+**
* Uses **strong cipher suites**
* Enables **SNI strict mode**
* Prefers modern elliptic curves (`P384`, `P521`)

### Security Headers (`conf/headers.yaml`)

* Denies iframe embedding (`FrameDeny`)
* Enables XSS, CSP, and HSTS protections
* Applies restrictive `ReferrerPolicy` and `PermissionsPolicy`
* Enforces HTTPS-only transport for all subdomains

---

## 📚 References

* 🔗 [Traefik Documentation](https://doc.traefik.io/traefik/)
* 🔗 [Cloudflare DNS-01 Challenge Docs](https://doc.traefik.io/traefik/https/acme/#dnschallenge)
* 🔗 [Cloudflare API Tokens Guide](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)
* 🔗 [Traefik File Provider Reference](https://doc.traefik.io/traefik/providers/file/)

---

**Maintainer:** [Termindiego25](https://github.com/Termindiego25)
**Part of:** [TerminSuite Project](https://github.com/Termindiego25/terminsuite)