# Termin-Suite

This repository provides a comprehensive technical setup for a **Raspberry Pi 5 network** configured with **Docker containers** to manage a suite of open-source applications. Designed for secure and efficient operation, the network includes services for **authentication**, **cloud storage**, **media streaming**, **password management**, and **intrusion detection**. This setup leverages Docker Compose for simplified deployment, configuration, and maintenance across a containerized environment. Below, the technical specification details the infrastructure, interconnections, and connection flow, showcasing centralized authentication and traffic management integration.

### Technical Specification for Raspberry Pi 5 Network with Docker Containers

This network setup across Raspberry Pi devices is configured as follows:

#### 1. **Device Infrastructure**

   - **RPi5-4GB (Entry Node and Network Services)**:
     - **[Cloudflared](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks)**: Establishes a secure tunnel for incoming external connections, enabling remote access to the network without exposing services directly.
     - **[Traefik](https://doc.traefik.io/traefik)**: Serves as a reverse proxy, efficiently routing incoming requests to the appropriate services based on predefined rules.
     - **[Pi-hole](https://docs.pi-hole.net)**: Functions as an internal DNS server, filtering unwanted content and enhancing privacy by blocking ads and trackers.
     - **IDS tap**: Captures network traffic for real-time intrusion detection, forwarding data to the **IDS/NIDS/IPS node** on the third Raspberry Pi for comprehensive analysis.

   - **RPi5-4GB (Authentication and Identity Management Node)**:
     - **OpenLDAP**: Provides a directory service for managing identity and access control across applications.
     - **FreeRADIUS**: Authenticates users connecting to the WiFi network, validating credentials against OpenLDAP to ensure centralized access control.
     - **[Keycloak](https://www.keycloak.org/guides)**: Manages Single Sign-On (SSO) authentication for all applications, using OpenLDAP for user validation.
     - **[Passbolt](https://www.passbolt.com/docs/hosting)**: A secure password management tool that enables secure storage and sharing of passwords within the network.

   - **RPi5-8GB (Storage, Media, and Security Processing Node)**:
     - **[Nextcloud](https://docs.nextcloud.com/server/latest/admin_manual)**: Offers cloud storage (NAS) for internal file access and synchronization, enabling secure and flexible file management.
     - **[Emby](https://emby.media/support/articles/Home.html)**: Acts as a DLNA media server, providing media streaming capabilities across the network.
     - **IDS/NIDS/IPS Node**: Receives traffic data captured by the **IDS tap** on the first device, providing intrusion detection, analysis, and prevention for enhanced network security.

#### 2. **Device Interconnection**

   - The Raspberry Pi devices are linked through an **unmanaged switch**, which consolidates internal device connections and directs network traffic to the central network router.
   - The **network router** serves as the primary gateway to the internet and acts as a firewall, controlling and securing traffic flow between the internal network and external connections.

#### 3. **Connection and Authentication Flow**

   - **External Traffic Entry**: External connections are initiated through the **Cloudflared** tunnel, providing a secure entry point for the network while hiding internal services from direct exposure.
   - **Traffic Routing**: Incoming traffic is routed by **Traefik**, which acts as a reverse proxy, efficiently directing requests to designated applications based on routing rules.
   - **Application Authentication**: Applications requiring authentication delegate this to **Keycloak**, which validates user credentials through **OpenLDAP** to centralize identity management.
   - **WiFi Authentication**: Users connecting to the network's WiFi are authenticated through **FreeRADIUS**, also using **OpenLDAP** for credential verification.
   - **Container Network**: Docker’s internal network handles communication between containers, isolating them from external access. **Cloudflared** serves as the only external entry point.
   - **Security Processing**: The **IDS tap** on the first device captures network traffic data, which is then forwarded to the **IDS/NIDS/IPS node** on the third Raspberry Pi for comprehensive threat analysis and response.
