#!/bin/bash
# =============================================================================
# Cria o fluxo: Webhook → Gmail no ActivePieces
# Variáveis esperadas no body do webhook: nome, email, mensagem
# =============================================================================

BASE_URL="https://cloud.activepieces.com"
API_KEY="HA1Zg3KjqHGFPg6RxHuX5LuzGYg8TKT7Isj9t0VlMBWgrpxV2psnvu5fXYaytkbhwwJBIBjD"
PROJECT_ID="wBolfTQgC9sIMOLP6hRE1"

AUTH="Authorization: Bearer $API_KEY"
CT="Content-Type: application/json"

echo "==> [1/4] Criando fluxo com trigger Webhook..."

FLOW=$(curl -sf -X POST "$BASE_URL/api/v1/flows" \
  -H "$AUTH" -H "$CT" \
  -d "{
    \"displayName\": \"Webhook → Gmail\",
    \"projectId\": \"$PROJECT_ID\"
  }")

if [ $? -ne 0 ]; then
  echo "ERRO: Falha ao criar o fluxo. Verifique sua API key e conexão."
  exit 1
fi

FLOW_ID=$(echo "$FLOW" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
echo "    Fluxo criado! ID: $FLOW_ID"

# -----------------------------------------------------------------------
echo "==> [2/4] Configurando trigger Webhook..."

curl -sf -X POST "$BASE_URL/api/v1/flows/$FLOW_ID" \
  -H "$AUTH" -H "$CT" \
  -d '{
    "type": "UPDATE_TRIGGER",
    "request": {
      "name": "trigger",
      "type": "PIECE_TRIGGER",
      "displayName": "Receber Webhook",
      "settings": {
        "pieceName": "@activepieces/piece-webhook",
        "pieceVersion": "~0.1.0",
        "triggerName": "catch_hook",
        "input": {}
      },
      "valid": true
    }
  }' > /dev/null

echo "    Trigger configurado."

# -----------------------------------------------------------------------
echo "==> [3/4] Adicionando step: Enviar email pelo Gmail..."

# IMPORTANTE: Substitua CONNECTION_ID pelo ID da sua conexão Gmail.
# Para descobrir, rode:
#   curl -s "$BASE_URL/api/v1/connections" -H "Authorization: Bearer $API_KEY" | jq '.data[] | {id, name}'

GMAIL_CONNECTION_ID="SUBSTITUA_PELO_ID_DA_SUA_CONEXAO_GMAIL"

curl -sf -X POST "$BASE_URL/api/v1/flows/$FLOW_ID" \
  -H "$AUTH" -H "$CT" \
  -d "{
    \"type\": \"ADD_ACTION\",
    \"request\": {
      \"parentStep\": \"trigger\",
      \"stepLocationRelativeToParent\": \"AFTER\",
      \"action\": {
        \"name\": \"enviar_email\",
        \"type\": \"PIECE\",
        \"displayName\": \"Enviar Email pelo Gmail\",
        \"settings\": {
          \"pieceName\": \"@activepieces/piece-gmail\",
          \"pieceVersion\": \"~0.4.0\",
          \"actionName\": \"send_email\",
          \"input\": {
            \"to\": \"victor.cassianonau@gmail.com\",
            \"subject\": \"Claude Code\",
            \"body\": \"<p><strong>Nome:</strong> {{trigger.body.nome}}</p><p><strong>Email:</strong> {{trigger.body.email}}</p><p><strong>Mensagem:</strong> {{trigger.body.mensagem}}</p>\",
            \"senderName\": \"ActivePieces\"
          },
          \"inputUiInfo\": {},
          \"connectionExternalId\": \"$GMAIL_CONNECTION_ID\"
        },
        \"valid\": true
      }
    }
  }" > /dev/null

echo "    Step Gmail adicionado."

# -----------------------------------------------------------------------
echo "==> [4/4] Publicando e ativando o fluxo..."

curl -sf -X POST "$BASE_URL/api/v1/flows/$FLOW_ID" \
  -H "$AUTH" -H "$CT" \
  -d '{"type": "LOCK_AND_PUBLISH", "request": {}}' > /dev/null

curl -sf -X POST "$BASE_URL/api/v1/flows/$FLOW_ID" \
  -H "$AUTH" -H "$CT" \
  -d '{"type": "CHANGE_STATUS", "request": {"status": "ENABLED"}}' > /dev/null

echo "    Fluxo publicado e ativo!"

# -----------------------------------------------------------------------
echo ""
echo "✅ FLUXO CRIADO COM SUCESSO!"
echo "   ID do fluxo : $FLOW_ID"
echo "   Dashboard   : $BASE_URL/projects/$PROJECT_ID/flows/$FLOW_ID"
echo ""
echo "⚠️  PRÓXIMO PASSO: Conecte sua conta Gmail"
echo "   1. Acesse o dashboard no link acima"
echo "   2. No step 'Enviar Email pelo Gmail', clique em 'Connect'"
echo "   3. Autorize sua conta Google"
echo "   4. O fluxo estará pronto para uso!"
echo ""
echo "📬 COMO TESTAR:"
echo "   Copie a URL do webhook no dashboard e envie um POST:"
echo '   curl -X POST "<WEBHOOK_URL>" \'
echo '     -H "Content-Type: application/json" \'
echo '     -d '"'"'{"nome":"João","email":"joao@exemplo.com","mensagem":"Olá!"}'"'"
