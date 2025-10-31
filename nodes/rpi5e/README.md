# TerminSuite - Node rpi5e (Analysis & Correlation)

## Table of Contents
- [Overview](#overview)
- [Service Overview](#service-overview)
- [Integration & Network Role](#integration--network-role)
- [Falco Integration](#falco-integration)
- [Performance & Resources](#performance--resources)
- [Related Nodes](#related-nodes)

---

## 🧭 Overview
**rpi5e** is the **central analysis node** for TerminSuite.  
It aggregates logs, correlates events, and performs intrusion detection across the entire network.

---

## 📚 Service Overview

| Service | Description | Docker Mode | Notes |
|----------|--------------|--------------|-------|
| **IDS/NIDS/IDP Stack (e.g. Suricata, Zeek, Wazuh)** | Advanced network and host intrusion detection | Rootless | Analyses and classifies traffic |
| **Logstash** | Central log collector and processor | Rootless | Integrates Falco and Cynet inputs |
| **Falco** | Local node security monitoring | Normal | Protects node integrity |

---

## 🔧 Integration & Network Role
Receives logs and Falco alerts from all nodes (a–f).  
Acts as the **correlation hub** for the TerminSuite monitoring architecture.  
Provides data to visualization or alerting systems (future Grafana/ELK stack).

---

## 🔐 Falco Integration
Local Falco instance monitors the analysis stack itself.  
Falco data from all other nodes is received and processed by **Logstash**, avoiding redundant Falco server layers.

---

## 🚀 Performance & Resources
- **Memory:** 16GB RAM (required for parallel IDS + log processing)  
- **CPU:** High under correlation and alert enrichment  
- **Docker:** Rootless (IDS, Logstash) + Normal (Falco)

---

## 🌐 Related Nodes
- [rpi5a - DNS & Firewall](../rpi5a/README.md)  
- [rpi5b - Gateway & Proxy](../rpi5b/README.md)  
- [rpi5c - Authentication & Identity](../rpi5c/README.md)  
- [rpi5d - Storage & Media](../rpi5d/README.md) 
- [rpi5f - Tap & Collector](../rpi5f/README.md)

---

**Maintainer:** Termindiego25
**Part of:** [TerminSuite Project](https://github.com/Termindiego25/terminsuite)