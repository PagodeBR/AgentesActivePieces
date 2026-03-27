Adicione um novo step (passo) a um fluxo existente no ActivePieces.

## Passos

1. **Identificar o fluxo**: Se o usuário não informou o ID do fluxo, liste os fluxos disponíveis e peça para escolher.

2. **Entender o novo step**:
   - Qual é a ação? (ex: enviar email, postar no Slack, escrever no Google Sheets)
   - Qual peça será usada?
   - Onde inserir? (após qual step existente)
   - Quais dados do fluxo serão usados nesse step?

3. **Buscar o fluxo atual** para entender a estrutura existente:
   ```
   GET ${ACTIVEPIECES_BASE_URL}/api/v1/flows/{id}
   Authorization: Bearer ${ACTIVEPIECES_API_KEY}
   ```

4. **Adicionar o step** via operação `ADD_ACTION`:
   ```
   POST ${ACTIVEPIECES_BASE_URL}/api/v1/flows/{id}
   Authorization: Bearer ${ACTIVEPIECES_API_KEY}
   Content-Type: application/json

   {
     "type": "ADD_ACTION",
     "request": {
       "parentStep": "nome_do_step_anterior",
       "stepLocationRelativeToParent": "AFTER",
       "action": {
         "name": "nome_do_novo_step",
         "type": "PIECE",
         "displayName": "Nome descritivo do step",
         "settings": {
           "pieceName": "@activepieces/piece-nome",
           "pieceVersion": "~0.x.0",
           "actionName": "nome_da_action",
           "input": {
             "campo": "valor ou {{step_anterior.propriedade}}"
           }
         }
       }
     }
   }
   ```

5. **Confirmar adição**: Informe ao usuário que o step foi adicionado com sucesso e mostre a estrutura atualizada do fluxo.

## Tipos de step disponíveis

| Tipo | Uso |
|------|-----|
| `PIECE` | Usar uma integração nativa (Slack, Gmail, etc.) |
| `CODE` | Código JavaScript customizado |
| `BRANCH` | Lógica condicional (if/else) |
| `LOOP_ON_ITEMS` | Iterar sobre uma lista |

## Para steps do tipo CODE
```json
{
  "name": "processar_dados",
  "type": "CODE",
  "displayName": "Processar e transformar dados",
  "settings": {
    "sourceCode": {
      "code": "export const code = async (inputs) => { return { resultado: inputs.valor * 2 }; }",
      "packageJson": "{}"
    },
    "input": {
      "valor": "{{trigger.body.numero}}"
    }
  }
}
```
