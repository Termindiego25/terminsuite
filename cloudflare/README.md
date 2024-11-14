# TerminSuite: Configuring Cloudflared Tunnel

## About Cloudflared
Cloudflared, a part of Cloudflare’s Zero Trust suite, creates secure, encrypted tunnels to connect private applications to the internet without exposing server IP addresses or opening firewall ports. This allows for a secure access point by utilizing Cloudflare's global network, acting as a reverse proxy and providing a highly resilient, private access solution for internal services. 

---

## Creating the Tunnel

To create a Cloudflared tunnel, follow these steps, which will establish the connection and integrate it into your Cloudflare environment:

1. Visit [Cloudflare's Dashboard](https://dash.cloudflare.com).
2. Go to **Zero Trust** in the left sidebar to manage Zero Trust services.
3. Under **Zero Trust**, select **Networks**.
4. In the **Networks** submenu, click **Tunnels** to access the tunnel configuration options.
5. Under **Your tunnels**, select **Create a tunnel** to begin.
6. Choose **Cloudflared** from the options.
7. Provide a name to help you identify the tunnel in Cloudflare’s interface.
8. Save the tunnel configuration.
9. Choose **Docker** under **Choose your environment**.
10. Copy the `docker run` command found in **Install and run a connector** to set up Cloudflared in a Docker container.
11. Replace `$token` in the copied command within your `docker-compose.yaml` file.
12. Start the tunnel by running:
   ```bash
   docker compose -f $path/docker-compose.yaml up -d
   ```

---

## Configuring Applications in the Tunnel

After the tunnel is active, configure specific applications to route securely through it. This setup allows Cloudflare to handle routing securely, bypassing exposed ports:

1. If you’re in the setup wizard, proceed to step 5. Otherwise, navigate to **Tunnels**.
2. Click on your tunnel and select **Edit** on the right sidebar.
3. Go to the **Public Hostname** tab.
4. Click **Add a public hostname** to configure access.
5. Define the subdomain (if any) for the application.
6. Select your primary domain for this application.
7. Specify any required path (if any) under **Path** to define routing for subdirectories.
8. Under **Type**, select **HTTP** to route web traffic.
9. Enter either the Docker container name or the internal address and port for the application within your local network.
10. Save the hostname configuration.

With this basic setup, Cloudflare will automatically create a DNS entry and tunnel configuration, enabling secure, direct access to your internal services. For advanced options and custom configurations, such as HTTPS tunnels and SSL certificate management, refer to [Cloudflare's documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks).
