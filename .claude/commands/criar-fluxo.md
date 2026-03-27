Você vai criar um novo fluxo de automação no ActivePieces.

## Passos

1. **Entender o objetivo**: Se o usuário não descreveu o fluxo em detalhes, pergunte:
   - Qual é o evento que inicia o fluxo? (webhook, agendamento, trigger de alguma ferramenta)
   - Quais ações devem acontecer? Em que ordem?
   - Quais integrações são necessárias? (Slack, Gmail, Google Sheets, etc.)
   - Existe alguma lógica condicional? (se X então Y, senão Z)

2. **Confirmar antes de criar**: Apresente um resumo do fluxo que vai ser criado e peça confirmação do usuário.

3. **Verificar conexões**: Antes de criar o fluxo, verifique via API quais conexões já estão configuradas:
   ```
   GET ${ACTIVEPIECES_BASE_URL}/api/v1/connections
   Authorization: Bearer ${ACTIVEPIECES_API_KEY}
   ```

4. **Criar o fluxo**: Use a API do ActivePieces para criar o fluxo:
   ```
   POST ${ACTIVEPIECES_BASE_URL}/api/v1/flows
   Authorization: Bearer ${ACTIVEPIECES_API_KEY}
   Content-Type: application/json
   ```

5. **Adicionar steps**: Para cada ação, adicione um step ao fluxo usando a operação `ADD_ACTION`:
   ```
   POST ${ACTIVEPIECES_BASE_URL}/api/v1/flows/{id}
   ```

6. **Confirmar criação**: Mostre ao usuário o ID do fluxo criado e um link para visualizá-lo no dashboard.

## Estrutura de trigger por tipo

### Webhook
```json
{
  "name": "trigger",
  "type": "PIECE_TRIGGER",
  "settings": {
    "pieceName": "@activepieces/piece-webhook",
    "triggerName": "catch_hook",
    "input": {}
  }
}
```

### Agendamento (Schedule)
```json
{
  "name": "trigger",
  "type": "PIECE_TRIGGER",
  "settings": {
    "pieceName": "@activepieces/piece-schedule",
    "triggerName": "cron_expression",
    "input": {
      "cronExpression": "0 9 * * 1-5"
    }
  }
}
```

## Lembre-se
- Use nomes descritivos para os steps (ex: `buscar_dados`, `enviar_notificacao`)
- Referencie dados de steps anteriores com `{{nome_do_step.propriedade}}`
- Valide o fluxo após criação antes de publicar
