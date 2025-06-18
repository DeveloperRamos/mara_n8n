#!/bin/bash
set -e

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_NAME="n8n_backup_$TIMESTAMP.sql"
ARCHIVE_NAME="$BACKUP_NAME.tar.gz"
BACKUP_DIR="/var/backups"
BACKUP_FILE="$BACKUP_DIR/$BACKUP_NAME"
ARCHIVE_FILE="$BACKUP_DIR/$ARCHIVE_NAME"
MAX_BACKUPS=7

echo "📦 Criando dump SQL..."
PGPASSWORD=$POSTGRES_PASSWORD pg_dump -h $POSTGRES_HOST -U $POSTGRES_USER -d $POSTGRES_DB > "$BACKUP_FILE"

echo "🗜️ Compactando em tar.gz..."
tar -czf "$ARCHIVE_FILE" -C "$BACKUP_DIR" "$BACKUP_NAME"
rm "$BACKUP_FILE"

echo "✅ Backup pronto: $ARCHIVE_FILE"

# 🧹 Limpeza de backups antigos
cd "$BACKUP_DIR"
BACKUP_COUNT=$(ls -1tr n8n_backup_*.tar.gz | wc -l)

if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
  DELETE_COUNT=$((BACKUP_COUNT - MAX_BACKUPS))
  echo "🗑️ Removendo $DELETE_COUNT backup(s) antigo(s)..."
  ls -1tr n8n_backup_*.tar.gz | head -n "$DELETE_COUNT" | xargs rm -f
fi

# ✉️ Enviando log por e-mail
LOG_CONTENT=$(tail -n 50 /var/log/backup/last.log)
echo "$LOG_CONTENT" | mail -s "📬 Backup n8n $TIMESTAMP" -r "$SMTP_FROM" "$SMTP_TO"

echo "📨 Log enviado para $SMTP_TO"
