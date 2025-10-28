# TerminSuite: Configuring Emby Server

## About Emby
Emby is a media server designed to organize, stream, and manage your personal media content (movies, series, music, etc) across multiple devices. It offers powerful transcoding capabilities, user access control, and DLNA support, and integrates well into home-lab environments.

---

## Docker Compose Configuration

### Mounting Media Folders
To make your media content available to Emby, you need to mount the folders containing your films, series, or music into the container:

- Replace `$storage_path` with the **absolute path** to your local media directory on the volumes section.
- You can mount multiple folders by specifying unique container destinations to avoid overlap (e.g. `/mnt/movies`, `/mnt/series`, `/mnt/media1`, etc).

### Enabling DLNA and Wake-On-LAN
To enable **DLNA** and **Wake-On-LAN**, your container must operate in **host network mode**. Modify the `docker-compose.yaml`:
```yaml
network_mode: host
```

### Hardware Acceleration

- #### Intel HD Graphics (VAAPI)
    For systems using Intel GPUs, enable VAAPI support:
    ```yaml
    devices:
    - /dev/dri:/dev/dri
    ```

- #### NVIDIA GPUs (NVDEC/NVENC)
    For systems using NVIDIA GPUs, enable NVDEC/NVENC support:
    ```yaml
    runtime: nvidia
    devices:
    - /dev/dri:/dev/dri
    ```
    > 🛈 Make sure `nvidia-container-runtime` is installed and configured properly.

---

## Environment Variables

### Setting GID for Media Folder Access
To ensure Emby has correct permissions to read your media files:

1. Identify the owner of your media folders:
   ```bash
   getent passwd $user | cut -d: -f3
   ```
2. Replace the result in the `emby.env` under `GIDLIST`.

### Enabling GPU Acceleration (amd64 only)
If you're using VAAPI/NVDEC/NVENC:

1. Get the `video` group GID:
   ```bash
   getent group video | cut -d: -f3
   ```
2. Get the `render` group GID:
   ```bash
   getent group render | cut -d: -f3
   ```
3. Replace the result in the `emby.env` under `GIDLIST`.

---

## Running the Server

1. Launch Emby using Docker Compose:
   ```bash
   docker compose -f $path/docker-compose.yaml up -d
   ```
2. If using Traefik, connect Traefik’s container to the Emby network (check Traefik's section) and restart Traefik.

3. Access Emby at:
   ```
   http://<docker_host>:8096
   ```
   or through your **Cloudflare Tunnel** if configured.

---

## Securing the Web Interface (HTTPS)

Before enabling HTTPS (port `8920`), it is **recommended** to first start Emby using the default **HTTP port `8096`**.

This allows you to:

- Access the **web interface** without SSL issues.
- Properly configure the **SSL certificate** in Emby.
- Verify that the setup works correctly before enforcing **HTTPS**.

### How to enable HTTPS in Emby

1. Convert your existing certificate and private key to **PKCS #12** format using OpenSSL:
   ```bash
   openssl pkcs12 -inkey $PRIVKEY_PATH -in $CERT_PATH -export -out $OUTPUT_PATH
   ```
   > Replace `$PRIVKEY_PATH`, `$CERT_PATH`, and `$OUTPUT_PATH` accordingly. You can leave the export password **empty** if desired.

2. Open the Emby web interface at `http://<docker_host>:8096` and go to:
   ```
   Emby server Dashboard > Network
   ```

3. Fill in the following fields:
   - **External domain**: `emby.yourdomain.com`
   - **Custom SSL certificate path**: Absolute path to your `.pfx` file (`$OUTPUT_PATH`)
   - **Certificate password**: Password you set during the export step (leave empty if none)
   - **Secure connection mode**: 
     - Set to `Preferred but not required` or `Required for all remote connections` for strict enforcement.

4. Make sure the certificate file is readable by Emby:
   - Recommended permission: `644`
   - File must be accessible by the user running the container or by any group ID specified in the `GIDLIST` environment variable.

5. Restart the Emby container.

6. Once restarted, access Emby securely at:
   ```
   https://<docker_host>:8920
   ```
   or through your **Cloudflare Tunnel** if configured.

---

With this basic setup, Emby Server will be ready to manage and stream your media collection locally or remotely. For advanced options and custom configurations, such as parental controls, user management, transcoding settings, and plugin integration, refer to [Emby’s official documentation](https://emby.media/support/articles/Home.html).