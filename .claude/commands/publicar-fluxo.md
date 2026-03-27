Publique e ative um fluxo no ActivePieces.

## Passos

1. **Identificar o fluxo**: Se o usuário não informou o ID, liste os fluxos com status DISABLED ou DRAFT.

2. **Verificar o fluxo antes de publicar**:
   ```
   GET ${ACTIVEPIECES_BASE_URL}/api/v1/flows/{id}
   Authorization: Bearer ${ACTIVEPIECES_API_KEY}
   ```

   Verifique:
   - O trigger está configurado corretamente?
   - Todos os steps têm as informações necessárias?
   - As conexões referenciadas existem e estão ativas?

3. **Alertar sobre problemas** encontrados e confirmar com o usuário se deve prosseguir.

4. **Publicar o fluxo** (criar uma versão publicada):
   ```
   POST ${ACTIVEPIECES_BASE_URL}/api/v1/flows/{id}
   Authorization: Bearer ${ACTIVEPIECES_API_KEY}
   Content-Type: application/json

   {
     "type": "LOCK_AND_PUBLISH",
     "request": {}
   }
   ```

5. **Ativar o fluxo** (mudar status para ENABLED):
   ```
   POST ${ACTIVEPIECES_BASE_URL}/api/v1/flows/{id}
   Authorization: Bearer ${ACTIVEPIECES_API_KEY}
   Content-Type: application/json

   {
     "type": "CHANGE_STATUS",
     "request": {
       "status": "ENABLED"
     }
   }
   ```

6. **Confirmar ativação**: Informe ao usuário que o fluxo está ativo e, se for um webhook trigger, mostre a URL do webhook para configurar no serviço externo.

## Para obter a URL do webhook após publicação

Se o trigger for do tipo webhook, busque a URL gerada:
```
GET ${ACTIVEPIECES_BASE_URL}/api/v1/flows/{id}
```
A URL estará em `version.trigger.settings.webhookUrl` ou similar.

## Aviso importante
Antes de publicar, confirme com o usuário que:
- O fluxo foi testado e está funcionando corretamente
- As conexões com serviços externos estão válidas
- O fluxo não vai causar ações indesejadas ao ser ativado
