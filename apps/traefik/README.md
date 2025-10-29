# 🚦 TerminSuite - Traefik Reverse Proxy

## 🧭 Overview

Traefik is the **reverse proxy and entrypoint gateway** for TerminSuite.
It securely routes all incoming connections (proxied through **Cloudflared**) to the corresponding internal services running in Docker containers.

This configuration:

* Uses **Cloudflare DNS-01 challenge** for automatic SSL certificate issuance.
* Includes **strict TLS policies** and **security headers**.
* Integrates with the Docker socket to dynamically detect services.

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
    └── sites/                # (Optional) Virtual host definitions
```

---

## ⚙️ Deployment

### 1️⃣ Configure the Cloudflare Token

Traefik uses the **Cloudflare DNS-01 challenge** to automatically issue and renew SSL certificates via Let's Encrypt.
To do this, you must create a **Cloudflare API Token** with limited permissions.

#### Steps to create the API Token:

1. Go to your [Cloudflare Dashboard → My Profile → API Tokens](https://dash.cloudflare.com/profile/api-tokens).
2. Click on **“Create Token”**.
3. Choose **“Use template”** from the **“Edit zone DNS”** API token template or create a custom token.
4. Under **Permissions**, select:
   * Zone → DNS → Edit
5. Under **Zone Resources**, select:
   * Include → All zones (or specific zone)
6. Click **Continue to summary → Create Token**.
7. Copy the generated token and save it as `CF_DNS_API_TOKEN` inside your environment file.

Example:

```bash
CF_DNS_API_TOKEN=your-cloudflare-token
```

> ⚠️ Keep this token secret. It grants permission to modify DNS records in your Cloudflare account.

---

### 2️⃣ Configure Environment Variables

The `traefik.env` file must contain your **Cloudflare DNS API token**:

```bash
CF_DNS_API_TOKEN=BW1xXHqOd7Nj
```

> ⚠️ The token must have **Zone:DNS:Edit** permissions within Cloudflare.

---

### 3️⃣ Deploy the Container

From the `traefik` directory:

```bash
docker compose up -d
```

This will:
* Start the Traefik service.
* Automatically connect to the shared `cloudflared_net` network.
* Request certificates via the Cloudflare DNS-01 challenge.
* Expose HTTPS on port `4433` (for internal routing).

---

### 4️⃣ Verify Logs

You can check that Traefik is running properly with:

```bash
docker logs -f traefik
```

If successful, you should see:

```
... Successfully obtained new certificate from ACME provider ...
```

---

## 🧹 Cleanup

To stop and remove the container:

```bash
docker compose down -v
```

To remove all data (including certificates):

```bash
rm -rf ssl/
```

---

## 🔐 Security Features

### TLS Configuration (`conf/tls.yaml`)

* Enforces **TLS 1.2+**
* Uses **strong cipher suites**
* Enforces **SNI strict mode**
* Prefers modern elliptic curves (`P384`, `P521`)

### Security Headers (`conf/headers.yaml`)

* Denies iframe embedding (`FrameDeny`)
* Enables `XSS`, `CSP`, and `HSTS` protections
* Applies restrictive `ReferrerPolicy` and `PermissionsPolicy`
* Enforces HTTPS-only transport for all subdomains

---

## 📚 Official Documentation

* 🔗 [Traefik Documentation](https://doc.traefik.io/traefik/)
* 🔗 [Cloudflare DNS-01 Challenge Docs](https://doc.traefik.io/traefik/https/acme/#dnschallenge)
* 🔗 [Cloudflare API Tokens Guide](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)

---

**Maintainer:** Termindiego25
**Part of:** [TerminSuite Project](https://github.com/Termindiego25/terminsuite)