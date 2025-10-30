#!/bin/bash
# backup_keycloak-realms
# ============================================================
# TerminSuite - Keycloak Realms Backup Script
# ============================================================
# Description:
#   Exports all Keycloak realms and user data into the import
#   directory inside the Keycloak container. The script is
#   designed to be run periodically (e.g., via cron) to ensure
#   consistent backups of configuration and user accounts.
#
#   Logs are written to /apps/keycloak/backup_keycloak-realms.log
#   and contain timestamps for traceability.
#
# Usage:
#   bash /apps/keycloak/backup_keycloak-realms.sh
# ============================================================

set -euo pipefail

# === Variables ===
LOG_FILE="/apps/keycloak/backup_keycloak-realms.log"
DOCKER_COMPOSE_FILE="/apps/keycloak/docker-compose.yaml"

# Start logging
{
  echo "===== [$(date '+%Y-%m-%d %H:%M:%S')] Starting Keycloak Realms Backup ====="

  # Run Keycloak export
  echo "→ Exporting realms and users..."
  docker compose -f "$DOCKER_COMPOSE_FILE" run --rm -u root \
    keycloak_server export --dir /opt/keycloak/data/import \
    --users realm_file --verbose

  echo "→ Backup completed successfully."
  echo "===== [$(date '+%Y-%m-%d %H:%M:%S')] Backup finished ====="
} >> "$LOG_FILE" 2>&1

exit 0