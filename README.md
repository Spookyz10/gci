# Froggyz Hub

Interface Luau responsiva para o projeto aberto no Roblox Studio.

Script distribuível: `src/FroggyzHub.client.luau`. Interface responsiva com abas
Geral, mundos descobertos no catálogo e Misc; botão flutuante para reabrir.
Right Shift também alterna a janela no computador.

Inclui auto collect com limite de 5000 por pedido a cada 0,2 s mais o tempo de
resposta do servidor, tier automático pela cadeia `nextTier`, override de tier e
quantidade, velocidade local, menus de upgrades/resets, compra máxima por ID,
daily/hourly, auto win local de Grasslands e `tempLuck` configurável.
O limite de 5000 é o encontrado no cliente, não um máximo aceito pelo servidor.
Auto win chama `GalaxyGen.EnemyDead()`; recompensa persistente não foi confirmada.
Menus sobrepostos podem ser restaurados pelo botão próprio ou fechando o hub.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Spookyz10/gci/main/src/FroggyzHub.client.luau"))()
```

Esse carregador requer um ambiente com `game:HttpGet` e `loadstring` habilitados.
Para usar como código do próprio jogo no Studio, copie o conteúdo para um
LocalScript em StarterPlayerScripts.

## Verificação

- Parser/formatador StyLua 2.6.0 em modo Luau.
- Construção isolada no Studio, sem inserir a interface no jogo: abas Geral,
  World 1, World 2, World 8, World 9 e Misc detectadas no catálogo real.
- Harness com jogador e remote simulados: coleta enviou exatamente
  `{id="cut", field="main", identifier="top", quantity=120}` com cap 120 e
  cadeia de três tiers; a interface foi destruída e conexões limpas ao encerrar.
- Não foi feito teste contra os handlers originais, ausentes nesta exportação.

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

Repositório de destino informado pelo usuário: https://github.com/Spookyz10/gci.
Somente o hub, este documento e `.gitignore` são distribuídos. A pasta de
evidências permanece local.
