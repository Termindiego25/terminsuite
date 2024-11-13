# Termin-Suite: Raspberry Pi Network with Open-Source Applications

This repository outlines the technical setup of a network of Raspberry Pi 5 devices configured with Docker containers to manage a suite of open-source applications. The network is designed to support secure and efficient operations with services for authentication, storage, DNS, traffic inspection, and media streaming. Each device has a specific role within a security-focused architecture that leverages centralized authentication, traffic filtering, and Docker Secrets to enhance security and efficiency.

---

## Technical Specification for the Raspberry Pi Network

This network consists of four Raspberry Pi 5 devices, each with specific responsibilities for managing network security, application traffic, DNS filtering, and identity management:

### 1. **Device Infrastructure**

   - **RPi5-4GB (Point of Entry: Network Security and Filtering)**:
     - **[Cloudflared](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks)**: Establishes a secure tunnel for incoming external connections, enabling remote access to the network without exposing services directly.
     - **ModSecurity**: Acts as a Web Application Firewall (WAF) to filter and block malicious web traffic based on predefined security rules.
     - **IDS tap**: Captures network traffic for real-time intrusion detection, forwarding data to the **IDS/NIDS/IPS node** for in-depth and comprehensive analysis.

   - **RPi5-4GB (Internal Routing and DNS)**:
     - **[Traefik](https://doc.traefik.io/traefik)**: Serves as a reverse proxy, efficiently routing incoming requests to the appropriate services based on predefined rules.
     - **[Pi-hole](https://docs.pi-hole.net)**: Functions as a DNS server, filtering unwanted content and enhancing privacy by blocking ads and trackers.

   - **RPi5-4GB (Identity and Access Management)**:
     - **OpenLDAP**: Provides a directory service for identity management, handling centralized user records for authentication purposes.
     - **FreeRADIUS**: Authenticates users connecting to the WiFi, validating credentials against OpenLDAP.
     - **[Keycloak](https://www.keycloak.org/guides)**: Manages Single Sign-On (SSO) for applications, centralizing authentication and validating users through OpenLDAP.
     - **[Passbolt](https://www.passbolt.com/docs/hosting)**: Serves as a secure password manager for storing and managing passwords, enhancing credential security across the network.

   - **RPi5-8GB (Storage, Media, and Security Processing)**:
     - **[Nextcloud](https://docs.nextcloud.com/server/latest/admin_manual)**: Offers cloud storage (NAS) for internal file access and synchronization, enabling secure and flexible file management.
     - **[Emby](https://emby.media/support/articles/Home.html)**: Acts as a DLNA media server, providing media streaming capabilities across the network.
     - **IDS/NIDS/IPS Node**: Receives and processes network traffic data from the **IDS tap** on the entry device, providing comprehensive intrusion detection and prevention.

### 2. Device Interconnection

   - **Router**: Acts as the primary internet gateway and firewall, regulating traffic flow between the internal network and the internet.
   - **Unmanaged Switch**: Aggregates connections from each Raspberry Pi, facilitating efficient traffic management within the local network.

### 3. Connection Flow

   - **External Traffic Entry**: Traffic enters the network through **Cloudflared** on the entry device, creating a secure point of entry.
   - **Traffic Filtering and Inspection**: Incoming traffic is filtered by **ModSecurity (WAF)** and monitored by the **IDS tap** before being routed internally.
   - **Internal Routing and DNS Resolution**: Within the network, **Traefik** manages request routing, while **Pi-hole** provides DNS filtering and ad-blocking.

### 4. **Authentication and Application Access**
   - **SSO Authentication**: **Keycloak** provides centralized SSO authentication, referencing **OpenLDAP** for user validation.
   - **WiFi Access Authentication**: Users connecting via WiFi are authenticated by **FreeRADIUS**, which also uses **OpenLDAP** for credential verification.
   - **Password Management**: **Passbolt** stores and manages passwords securely, ensuring encrypted access to sensitive credentials.

### 5. **Security Enhancements and Best Practices**
   - **Docker Rootless**: To follow the principle of least privilege and reduce security risks, it is recommended to run Docker in **rootless mode**. This configuration minimizes the potential for privilege escalation attacks and enhances the security of the container environment. For setup details, refer to the [Rootless Docker Installation Guide](https://docs.docker.com/engine/security/rootless).
   - **Docker Secrets**: To securely handle credentials and sensitive information, this setup makes use of **Docker Secrets**. By storing sensitive data encrypted and making it available only to necessary services, Docker Secrets reduces exposure risks. For more information, see the [Docker Secrets documentation](https://docs.docker.com/engine/swarm/secrets).
