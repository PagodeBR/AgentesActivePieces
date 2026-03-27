Analise um fluxo existente no ActivePieces e sugira melhorias.

## Passos

1. **Identificar o fluxo**: Se o usuário não informou o ID, liste os fluxos disponíveis.

2. **Buscar o fluxo completo**:
   ```
   GET ${ACTIVEPIECES_BASE_URL}/api/v1/flows/{id}
   Authorization: Bearer ${ACTIVEPIECES_API_KEY}
   ```

3. **Buscar histórico de execuções** para identificar falhas:
   ```
   GET ${ACTIVEPIECES_BASE_URL}/api/v1/flow-runs?flowId={id}&limit=10
   Authorization: Bearer ${ACTIVEPIECES_API_KEY}
   ```

4. **Analisar os seguintes aspectos**:

   ### Estrutura
   - O trigger está correto para o caso de uso?
   - Os steps estão em ordem lógica?
   - Existem steps desnecessários ou redundantes?

   ### Dados e Templates
   - As referências `{{step.propriedade}}` estão corretas?
   - Existe tratamento para casos onde dados podem estar vazios/nulos?
   - Os dados estão sendo transformados adequadamente entre steps?

   ### Performance
   - O fluxo pode ser otimizado em número de steps?
   - Existem chamadas API desnecessárias?

   ### Confiabilidade
   - Existem pontos de falha sem tratamento de erro?
   - Steps críticos têm fallbacks?

   ### Segurança
   - Credenciais estão usando conexões configuradas (não hardcoded)?
   - Dados sensíveis estão sendo expostos em logs?

5. **Apresentar relatório** com:
   - Resumo do fluxo (o que ele faz)
   - Pontos fortes
   - Problemas identificados (classificados por severidade: 🔴 crítico, 🟡 atenção, 🟢 sugestão)
   - Sugestões de melhoria com exemplos práticos

6. **Perguntar** se o usuário quer que alguma melhoria seja aplicada automaticamente.
