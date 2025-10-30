#!/bin/bash
# backup_passbolt-db
# ============================================================
# TerminSuite - Passbolt Database Backup Script
# ============================================================
# Description:
#   Backup Passbolt configuration, users and resources data.
#
#   Logs are written to /apps/passbolt/backup_passbolt-db.log
#   and contain timestamps for traceability.
#
# Usage:
#   bash /apps/passbolt/backup_passbolt-db.sh
# ============================================================

set -euo pipefail

# === Variables ===
LOG_FILE="/apps/passbolt/backup_passbolt-db.log"

# Start logging
{
  echo "===== [$(date '+%Y-%m-%d %H:%M:%S')] Starting Passbolt Database Backup ====="

  docker exec passbolt_db mariadb-dump \
  -u"$DB_USERNAME" -p"$DB_PASSWORD" "$DB_DATABASE" \
  > /apps/passbolt/secrets/bk.sql

  echo "→ Backup completed successfully."
  echo "===== [$(date '+%Y-%m-%d %H:%M:%S')] Backup finished ====="
} >> "$LOG_FILE" 2>&1

exit 0