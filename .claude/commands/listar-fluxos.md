Liste todos os fluxos existentes no projeto ActivePieces.

## Passos

1. **Buscar fluxos via API**:
   ```
   GET ${ACTIVEPIECES_BASE_URL}/api/v1/flows?projectId=${ACTIVEPIECES_PROJECT_ID}
   Authorization: Bearer ${ACTIVEPIECES_API_KEY}
   ```

2. **Apresentar de forma organizada** com as seguintes informações para cada fluxo:
   - **Nome** (`displayName`)
   - **ID** (`id`)
   - **Status** (`status`): ENABLED, DISABLED, ou DRAFT
   - **Última atualização** (`updated`)
   - **Número de steps** (contar a partir de `version.trigger` + actions)

3. **Agrupar por status**: Mostre primeiro os fluxos ENABLED, depois DISABLED, depois DRAFT.

4. **Oferecer próximas ações**: Após listar, pergunte se o usuário deseja:
   - Ver detalhes de algum fluxo específico
   - Editar algum fluxo
   - Criar um novo fluxo
   - Ativar/desativar algum fluxo

## Formato de saída esperado

```
## Fluxos Ativos (ENABLED)
| Nome | ID | Última atualização |
|------|----|--------------------|
| Nome do fluxo | abc123 | 2024-01-15 |

## Fluxos Inativos (DISABLED)
...

## Rascunhos (DRAFT)
...
```
