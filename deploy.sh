#!/bin/bash
echo "📦 Realizando backup manual antes do deploy..."
docker exec pg-backup /backup-scripts/backup.sh

echo "🛑 Parando containers..."
docker compose down

echo "🚀 Subindo containers com build..."
docker compose up --build -d

echo "✅ Deploy concluído com sucesso!"