#!/bin/sh
set -e

echo "📧 Enviando e-mail de teste..."

echo "Olá! Este é um teste de envio via msmtp + Outlook SMTP a partir do container Docker de backup." | \
mail -s "🧪 Teste de E-mail via Docker (Outlook SMTP)" -r "$SMTP_FROM" "$SMTP_TO"

echo "✅ E-mail de teste enviado com sucesso para $SMTP_TO"