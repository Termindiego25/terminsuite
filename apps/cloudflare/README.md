# Cloudflared tunnel setup (with Docker Secrets)

## 🧩 Overview

Cloudflared, part of Cloudflare’s Zero Trust suite, enables secure tunnels that connect private applications to the Cloudflare network without exposing internal IPs or opening firewall ports.  
In TerminSuite, this tunnel acts as the **main entry point** to the entire self-hosted ecosystem, routing all external traffic through Cloudflare’s secure global edge before reaching your Raspberry Pi devices.

---

## ⚙️ Directory structure

```
cloudflared/
├─ docker-compose.yaml
├─ secrets/
│  └─ cf_token.txt
````

- `docker-compose.yaml`: Docker Compose file defining the Cloudflared container.
- `secrets/cf_token.txt`: File containing your Cloudflare Tunnel token (used as a Docker Secret).

---

## 🔐 Token management with Docker Secrets

Instead of environment variables, TerminSuite uses **Docker Secrets** for secure credential storage.  
This ensures that sensitive data (like your Cloudflare token) is never exposed in plain text within environment variables or logs.

### 1. Obtain the tunnel token

1. Log in to [Cloudflare Dashboard](https://dash.cloudflare.com).
2. Go to **Zero Trust → Networks → Tunnels**.
3. Click **Create a tunnel** → choose **Cloudflared**.
4. Select **Docker** as the environment.
5. Copy the `$token` shown in the command example.

### 2. Store the token as a secret

Edit the file `secrets/cf_token.txt` and replace all its content —including the comments— with your actual token.
The file must contain only the token string (no comments, headers, or extra spaces).

> ⚠️ **Security note:**
> Never commit the real token to GitHub.
> You can use a placeholder or an example token when sharing configuration publicly.

---

## 🚀 Deployment steps

1. **Prepare the secret file**

   ```bash
   echo "YOUR_CLOUDFLARED_TUNNEL_TOKEN_HERE" > secrets/cf_token.txt
   ```

2. **Start the container**

   ```bash
   docker compose up -d
   ```

3. **Verify the connection**

   ```bash
   docker logs -f cloudflared
   ```

   You should see log lines confirming a successful connection to Cloudflare.

---

## 🌐 Routing applications

Once the tunnel is active, configure routes to expose internal services:

1. Go to **Zero Trust → Networks → Tunnels → Your Tunnel**.
2. Click **Configure** → **Public Hostnames**.
3. Add a new **Public Hostname**:

   * **Subdomain:** e.g. `app`
   * **Domain:** e.g. `domain.com`
   * **Type:** `HTTPS`
   * **URL:** Internal service address (e.g. `traefik`)
4. Save the configuration — Cloudflare will automatically create the DNS record.

---

## 🧠 Notes

* In TerminSuite, Cloudflared runs on the same Raspberry Pi as **Traefik**.
* It forwards all external traffic through Cloudflare to the local reverse proxy.
* Ensure both containers share a Docker network (`cloudflared_net`).

---

## 📚 Official Documentation

🔗 [Cloudflare Tunnel Documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/)

---

**Maintainer:** Termindiego25
**Part of:** [TerminSuite Project](https://github.com/Termindiego25/terminsuite)