# Froggyz Hub

Interface Luau responsiva para o projeto aberto no Roblox Studio.

Em desenvolvimento. O repositório remoto deverá ser público, conforme solicitado.
O script distribuível ficará em `src/FroggyzHub.client.luau`.

## Estado da análise

O arquivo aberto é uma exportação com código do cliente. `ServerScriptService` e
`ServerStorage` não contêm scripts; nenhuma ocorrência de `OnServerEvent` ou
`OnServerInvoke` foi encontrada nos fontes. Os scripts Workspace.GamerScript e
Workspace.GrassSpawner são comentários de exportação, sem implementação.

Por isso, os parâmetros enviados pelo cliente estão confirmados, mas a aceitação
de valores alterados e seus efeitos persistentes ainda não foram verificados.

As evidências locais em `evidence/` são referências da análise, não componentes
do hub e não devem ser publicadas junto com ele.

## Pontos mapeados

| Fluxo | Evidência | Validação do servidor a verificar |
| --- | --- | --- |
| Coleta | ColliderFollowPlayer:213 e :468 envia `cut`, `field`, `identifier`, `quantity`; lote normal a cada 0,2 s, limitado localmente a 5000 | Campo desbloqueado, tier, crescimento, cap, frequência e quantidade efetivamente disponível |
| Upgrades | BuyUpgrade:15 e :25 envia `buyUpgrade`, `upgradeId`, `mode`, `x` | Pré-requisitos, nível máximo, custo calculado e débito atômico |
| Itens | BuyUpgrade:234 envia `addItem`, `int`, `level`, `quantity` | Origem autorizada, quantidade e prevenção de repetição |
| Dungeons | BuyUpgrade:226 envia `completeDungeon`, dungeon e difficulty | Sessão ativa, vitória e recompensa única |
| Batalhas | BuyUpgrade:365 envia `defeatGLEnemy`, enemyId, enemyLevel, difficulty, tempLuck | Resultado autoritativo e sorte calculada no servidor |
| Planet Run | ClientCollections:140/:164/:187 envia `stopPRTimer` com timer local | Cronômetro do servidor e trajetória válida |
| Daily/hourly | Botões enviam `dailyReward`/`hourlyReward` | Elegibilidade pelo relógio do servidor e resgate atômico |
| Saves | LoadSlot, RecoverData e Reserved recebem seleções do cliente | Propriedade do slot, índices, acesso e limites de frequência |

`EarnGrass` modifica dados locais, mas isso por si só não comprova alteração
da economia persistida. As compras e a coleta atuais usam remotes.

## Entrega

A URL raw e a loadstring só serão registradas depois da publicação e verificação
do arquivo remoto. Não há URL publicada neste momento.
