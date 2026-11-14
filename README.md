# Froggyz Hub

Hub Luau independente, com foco em World 1 e World 2. Interface responsiva,
navegação por sistema, busca de máquinas e compras pelo contexto do jogo.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Spookyz10/gci/main/src/FroggyzHub.client.luau"))()
```

O carregador requer `game:HttpGet` e `loadstring` disponíveis no ambiente.
No próprio projeto do Studio, o conteúdo de `src/FroggyzHub.client.luau` também
pode ser usado como LocalScript em StarterPlayerScripts.

## Interface

- **K** mostra ou oculta a janela; o botão Froggyz funciona no telefone.
- Arraste pelo cabeçalho com mouse ou toque. A janela fica dentro da tela.
- Geral reúne automações, compras e ajustes. As abas de world têm seções por sistema.
- Ao abrir uma loja nativa, o hub sai da frente e oferece compras num painel flutuante.
- Fechar pelo **×** encerra tarefas, desconecta eventos e restaura mudanças locais.

## Geral

- Daily e hourly são solicitados automaticamente quando os timers locais indicam
  elegibilidade, com verificação a cada 30 segundos e após carregar o save.
- Anti-AFK conecta ao evento Idled automaticamente. Ambientes que bloqueiam
  VirtualUser exibem uma mensagem de falha.
- Auto collect percorre os fields de World 1 e World 2, além dos compartilhados,
  com cap positivo. Não exige selecionar campo. O lote usa o cap atualizado,
  limitado a 5000; o tier segue a cadeia `nextTier` do catálogo.
- Cada field tem no máximo um pedido pendente. Retornos positivos permitem
  novo pedido após 0,2 s desde o anterior; recusas e erros aguardam 2 segundos.
- Compras usam o upgrade selecionado no jogo ou os objetos da loja aberta.
  Não é preciso conhecer IDs. Compras em grupo têm intervalo de 0,1 s.
- Velocidade local configurável, com restauração do valor anterior.

## Acesso e máquinas

O jogo usa `TabManager.ShowHideTabs()` para esconder interfaces e mover
máquinas para Y=200000. O hub substitui essa função enquanto o acesso está
ativo e restaura a implementação original ao desativar ou encerrar.
Não há loop reabrindo menus nem hooks globais de propriedades.

O catálogo incorpora 99 posições extraídas de chamadas literais do controlador
original. Máquinas ocultas com posição conhecida voltam ao local do mapa;
as demais, quando de tamanho compatível, ficam numa área ao lado do field.
Portas e barreiras têm uma ação separada para remoção local. Pivôs e displays
alterados são restaurados ao encerrar. Isso não concede progresso no servidor.

## World 1

- Grasslands: auto win pelo caminho local `GalaxyGen.EnemyDead()`, conclusão
  manual e `tempLuck` configurável antes da solicitação de recompensa.
- Solarians: alocação até o cap em todas as funções, recall, suspensão das
  condições locais de visibilidade e acesso a Restoration e Souls.
- Planet Run: coleta de bits pelas posições SpawnPos e solicitação de conclusão
  com o mínimo de tempo do catálogo da fase atual.
- Singularity Chart: compra de nós abaixo do cap e com pré-requisitos locais
  atendidos, descobrindo IDs internamente.
- Acesso a Planetary, Planetoids, Supernova, Constellation, Dark Matter e demais
  menus encontrados no PlayerGui. Resets continuam a exigir confirmação nativa.

## World 2

- Coleta multifield compartilhada com Geral.
- Máquinas e interfaces, Temple Chart e atalhos de progressão.
- Gauntlet: solicitação da maior ou menor sala disponível e acesso às áreas
  e aos artefatos pelos seletores nativos.

## Verificação e limites

`tests/StudioHarness.luau` recebe uma função que executa o hub com serviços
simulados. O harness foi executado no Studio com instâncias reais fora do
DataModel, cobrindo 42 verificações: navegação, dimensões móveis, coleta de
ambos os worlds, limite de lote, pedidos pendentes, backoff, compras por loja,
resgates, anti-AFK, tecla K, charts, posições de máquinas, barreiras e limpeza.
StyLua valida a sintaxe Luau e a formatação de fonte e testes.

O place aberto é uma exportação sem as implementações originais dos handlers
do servidor. A análise confirma os protocolos do cliente e os comportamentos
locais; aceitação de tiers, luck, vitórias, compras, fases e recompensas exige
teste no jogo com o servidor original. Retorno positivo de coleta não prova
por si só que uma recompensa foi persistida.

As evidências originais permanecem em `evidence/`, ignoradas pelo Git. O
repositório distribui o hub, documentação e testes, sem incluir o place exportado.
