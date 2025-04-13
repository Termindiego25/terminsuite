# TerminSuite: Raspberry Pi Network with Open-Source Applications

TerminSuite is a technical setup leveraging Raspberry Pi 5 devices and Docker containers to host a suite of open-source applications. It supports secure operations with centralized authentication, DNS filtering, traffic monitoring, and media services, designed for small-to-medium environments like home labs or small businesses.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Device Infrastructure](#2-device-infrastructure)
3. [Device Interconnection](#3-device-interconnection)
4. [Connection Flow](#4-connection-flow)
5. [Authentication and Application Access](#5-authentication-and-application-access)
6. [Security Overview](#6-security-overview)
7. [Security Enhancements and Best Practices](#7-security-enhancements-and-best-practices)

---

## 1. Introduction

TerminSuite provides a robust, open-source platform for managing network security and application delivery using Raspberry Pi 5 devices. The setup includes advanced security features such as centralized authentication, DNS filtering, and traffic monitoring. With the use of Docker containers, it ensures flexible deployment and scalability, making it suitable for various use cases, including home labs, small businesses, or educational environments.

## 2. Device Infrastructure

- **RPi5-4GB (Tap of Nzyme)**:

  - **IDS tap**: Captures network traffic for real-time intrusion detection, forwarding data to the **IDS/NIDS/IPS node** for in-depth analysis.
  - **Falco**: Provides host-level intrusion detection and monitors the system for unusual activity.

- **RPi5-4GB (Point of Entry: Network Security and Filtering)**:

  - **[Cloudflared](https://github.com/Termindiego25/terminsuite/blob/main/cloudflare)**: Establishes a secure tunnel for incoming external connections, enabling remote access to the network without exposing services directly.
  - **ModSecurity**: Acts as a Web Application Firewall (WAF) to filter and block malicious web traffic based on predefined security rules.
  - **[Traefik](https://doc.traefik.io/traefik/)**: Serves as a reverse proxy, efficiently routing incoming requests to the appropriate services based on predefined rules.
  - **[Pi-hole](https://docs.pi-hole.net/)**: Functions as a DNS server, filtering unwanted content and enhancing privacy by blocking ads and trackers.
  - **Falco**: Monitors container and host-level security events.

- **RPi5-4GB (Identity and Access Management)**:

  - **OpenLDAP**: Provides a directory service for identity management, handling centralized user records for authentication purposes.
  - **FreeRADIUS**: Authenticates users connecting to the WiFi, validating credentials against OpenLDAP.
  - **[Keycloak](https://www.keycloak.org/guides)**: Manages Single Sign-On (SSO) for applications, centralizing authentication and validating users through OpenLDAP.
  - **[Passbolt](https://www.passbolt.com/docs/hosting)**: Serves as a secure password manager for storing and managing passwords, enhancing credential security across the network.
  - **Falco**: Ensures monitoring of the host and containers to detect anomalies.

- **RPi5-8GB (Media, Storage, and Radio)**:

  - **[Nextcloud](https://docs.nextcloud.com/server/latest/admin_manual)**: Offers cloud storage (NAS) for internal file access and synchronization, enabling secure and flexible file management.
  - **[Emby](https://github.com/Termindiego25/terminsuite/blob/main/emby)**: Acts as a DLNA media server, providing media streaming capabilities across the network.
  - **AzuraCast**: Powers a fully-featured online radio station, automating music playback and supporting live broadcasts.
  - **Falco**: Monitors for any suspicious activity on the system and its containers.

- **RPi5-16GB (Security and SIEM)**:

  - **TheHive**: Provides incident response management.
  - **Cortex**: Enables automated analysis and enrichment of security incidents.
  - **ElasticSearch**: Supports TheHive and Cortex with powerful indexing and search capabilities.
  - **Nzyme Node**: Processes and analyzes data from the IDS tap.
  - **Falco**: Adds additional monitoring for host and container security.

## 3. Device Interconnection

- **Router**: Acts as the primary internet gateway and firewall, regulating traffic flow between the internal network and the internet. The router is configured with a mirrored port to send all network traffic to the **RPi5-4GB (Tap of Nzyme)** for monitoring.
- **Unmanaged Switch**: Aggregates connections from each Raspberry Pi (except the tap device), facilitating efficient traffic management within the local network.

## 4. Connection Flow

- **External Traffic Entry**: Traffic enters the network through **Cloudflared** on the entry device, creating a secure point of entry.
- **Traffic Filtering and Inspection**: Incoming traffic is filtered by **ModSecurity (WAF)** and monitored by the **IDS tap** before being routed internally.
- **Internal Routing and DNS Resolution**: Within the network, **Traefik** manages request routing, while **Pi-hole** provides DNS filtering and ad-blocking.
- **Media and Radio Services**: Requests to the media server **Emby** or the online radio **AzuraCast** are routed internally through **Traefik** for seamless access.



## 5. Authentication and Application Access

- **SSO Authentication**: **Keycloak** provides centralized SSO authentication, referencing **OpenLDAP** for user validation.
- **WiFi Access Authentication**: Users connecting via WiFi are authenticated by **FreeRADIUS**, which also uses **OpenLDAP** for credential verification.
- **Password Management**: **Passbolt** stores and manages passwords securely, ensuring encrypted access to sensitive credentials.
- **File Access and Media Streaming**: **Nextcloud** provides secure file storage and sharing, while **Emby** offers DLNA-compatible media streaming for authorized users.

## 6. Security Overview

This architecture integrates multiple layers of security to protect the network and its applications:

- **Intrusion Detection and Prevention**:

  - **Nzyme**: Monitors network traffic, capturing and analyzing packets to identify potential intrusions. The **IDS tap** collects data, which is then processed by the **Nzyme Node** for actionable insights.
  - **Falco**: Operates on each Raspberry Pi to detect suspicious activity at the host and container levels, providing an additional layer of intrusion detection.

- **Web Application Protection**:

  - **ModSecurity**: Filters web traffic through predefined rules, blocking malicious requests and protecting web applications from threats such as SQL injection and XSS.

- **Centralized Incident Response and Log Analysis**:

  - **TheHive and Cortex**: Streamline incident response with investigation, correlation, and automated analysis tools. They leverage **ElasticSearch** for powerful log indexing and searching capabilities, enabling efficient log aggregation and detailed analysis.

## 7. Security Enhancements and Best Practices

- **Falco Deployment**: Unlike other applications in this setup, **Falco** is installed directly on the operating system of each Raspberry Pi rather than as a Docker container. This approach is preferred because it allows Falco to have direct access to system events and kernel-level activities, enabling it to monitor host-level activity more effectively without the limitations of containerized environments.

- **Docker Rootless**: To follow the principle of least privilege and reduce security risks, it is recommended to run Docker in **rootless mode**. This configuration minimizes the potential for privilege escalation attacks and enhances the security of the container environment. For setup details, refer to the [Rootless Docker Installation Guide](https://docs.docker.com/engine/security/rootless/).

- **Docker Secrets**: To securely handle credentials and sensitive information, this setup makes use of **Docker Secrets**. By storing sensitive data encrypted and making it available only to necessary services, Docker Secrets reduces exposure risks. For more information, see the [Docker Secrets documentation](https://docs.docker.com/engine/swarm/secrets/).
