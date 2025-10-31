# TerminSuite - Node rpi5f (Tap & Collector)

## Table of Contents
- [Overview](#overview)
- [Service Overview](#service-overview)
- [Integration & Network Role](#integration--network-role)
- [Falco Integration](#falco-integration)
- [Performance & Resources](#performance--resources)
- [Related Nodes](#related-nodes)

---

## 🧭 Overview
**rpi5f** operates as a **dedicated network tap**, capturing traffic from a mirrored router port.  
It sends network telemetry and wireless metrics to the analysis node.

---

## 📚 Service Overview

| Service | Description | Docker Mode | Notes |
|----------|--------------|--------------|-------|
| **Nzyme Tap** | Passive network, Wi-Fi and Bluetooth collector | Rootless | Sends captured data to Nzyme server |
| **Falco** | Local runtime security and process monitor | Normal | Protects against local tampering |

---

## 🔧 Integration & Network Role
This node connects to a mirrored port on the router, feeding captured data into the **IDS/Logstash pipeline (rpi5e)**.  
It remains **isolated** to prevent interference or feedback loops.

---

## 🔐 Falco Integration
Falco supervises the Nzyme process and ensures that capture operations remain stable.  
Its telemetry does **not duplicate** Nzyme data — Falco audits the system, not the network.

---

## 🚀 Performance & Resources
- **Memory:** 2GB RAM (ample for capture workloads)  
- **CPU:** Very low  
- **Docker:** Rootless (Nzyme Tap) + Normal (Falco)

---

## 🌐 Related Nodes
- [rpi5a - DNS & Firewall](../rpi5a/README.md)  
- [rpi5b - Gateway & Proxy](../rpi5b/README.md)  
- [rpi5c - Authentication & Identity](../rpi5c/README.md)  
- [rpi5d - Storage & Media](../rpi5d/README.md) 
- [rpi5e - Analysis & Correlation](../rpi5e/README.md)

---

**Maintainer:** Termindiego25
**Part of:** [TerminSuite Project](https://github.com/Termindiego25/terminsuite)