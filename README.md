# Froggyz Hub

Hub Luau para World 1 e World 2, com três abas diretas e suporte a mouse e toque.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Spookyz10/gci/main/src/FroggyzHub.client.luau"))()
```

K mostra ou oculta o hub. Arraste pelo cabeçalho. O botão Froggyz funciona no
telefone. Fechar pelo × encerra eventos e tarefas e desfaz as alterações locais.

## Farm

O seletor possui exatamente três modos, mutuamente exclusivos:

| Modo | Identifier | Quantidade | Field |
| --- | --- | --- | --- |
| PW8 | `pw8` | Cap do field, até 5000; 5000 se cap inicial ainda não disponível | Rodízio entre fields liberados do world atual |
| Platinum | `platinum` | Sempre 1 | Anti liberado com grama; senão main |
| Moonstone | `moonstone` | Sempre 1 | Anti liberado com grama; senão main |

O tier PW8 é fixo e não depende do tier do jogador. A verificação de progresso
se aplica à liberação dos fields. Cap positivo, sozinho, não libera um field:
o hub consulta upgrades, resets e condições de acesso encontradas no cliente.
Quando não consegue confirmar uma área, não envia para ela.

Os campos iniciais main e jungle são reconhecidos pelo world sem depender de
slotLoaded ou de cap calculado. Valores de world em texto são normalizados.

Platinum e Moonstone usam World 1. Existe no máximo um InvokeServer pendente.
Trocar de modo espera esse pedido terminar antes de enviar o próximo. PW8 tem
cadência de 0,2 s e especiais de 0,08 s, limitados também pela resposta do servidor.
O painel distingue pedidos enviados, retornos positivos e recusas/erros.

O botão de teste pausa o farm e envia uma única chamada `main / pw8 / 100`.
O mesmo teste está disponível isoladamente:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Spookyz10/gci/main/tests/Collect100.client.luau"))()
```

Execute o teste isolado com o auto farm desligado. O resultado é impresso no console.

## Lojas e mapa

As lojas do place são SurfaceGuis ligadas às máquinas. O hub mantém essa
estrutura: não transforma lojas em janelas nem muda o parent dos seus widgets.
Os atalhos focam a câmera na superfície e permitem voltar à câmera anterior.
As compras continuam pelos botões nativos do jogo. Os botões de compra do hub foram removidos.

Mostrar máquinas suspende `TabManager.ShowHideTabs()` de forma reversível e
usa posições originais mapeadas. Máquinas sem posição confirmada ficam intactas;
não é criada uma galeria nem terreno adicional. A restauração guarda pivôs de
modelos e CFrames individuais de peças, incluindo modelos aninhados, além dos
estados Enabled/Visible alterados. Falhas são informadas e seus registros ficam
disponíveis para nova tentativa, em vez de serem descartados silenciosamente.

O botão separado Revelar upgrades ocultos fica em World 1 e World 2.
Mostrar máquinas também revela objetos de upgrades existentes no catálogo e no PlayerGui.
Eventos de Visible mantêm esses objetos disponíveis sem loop por frame.
Os nós do chart recebem prereqs vazios e condições locais liberadas; níveis,
moedas e progresso do save não são falsificados. Fechar desconecta
os eventos e devolve condições e estados originais. Isso não comprova aceitação
de compras pelo servidor nem cria widgets ausentes do cliente.

O botão de restaurar mapa foi removido. A limpeza ao fechar continua interna.
O hub consulta tabelas já ativas por getgc, sem requerer módulos novamente no
jogo publicado. Também aceita tabelas de upvalues e caches do registry.
Sem acesso a essas APIs, usa compatibilidade para mapa, widgets, farm e rewards.
Nesse modo, o world é estimado pela posição em World 1/2. O farm confirma o campo
inicial, campos visitados nesta sessão e campos com grama visível em Workspace.GrassObjects.
A leitura da grama ocorre no máximo uma vez por segundo. Visitas ficam memorizadas
até fechar o hub; isso não equivale à leitura completa dos desbloqueios do save.
O cap de referência é 5000, não um cap lido do save.
Claims são tentados a cada 10 segundos sem alegar que o timer está pronto.
As máquinas são mantidas por eventos de CFrame, sem parar o script geral do jogo.
O detector percorre SurfaceGuis dentro das máquinas e associadas às suas peças,
inclusive SurfaceGuis aninhadas em PlayerGui. Ativa ShopContainer/PrestigeMenu e
desativa Lock/Locked, preservando a navegação entre páginas internas das lojas.
Encontra Identifier tanto direto no widget quanto em Variables.Identifier.
Widgets no cap ficam ocultos usando dados nativos quando disponíveis ou os
valores/indicadores locais de Level, LevelCap, MaxedDisplay e Cost. Os eventos
acompanham mudanças desses indicadores, sem revelar novamente um widget maxed.
O painel de farm mostra Field: Anti Realm (anti) ou Field: Normal (main), e a lista
de fields que entram no rodízio PW8. Especiais preferem anti apenas com grama atual.
Revelar widgets não altera prereqs internos nesse modo. Ações que precisam de
GalaxyGen, Solarians ou outros módulos continuam indisponíveis sem acesso nativo.
Para o controlador de mapa, hookfunction também cobre referências da função
capturadas antes da execução do hub, quando disponível no executor.
Daily e hourly usam o estado nativo, com checagem a cada segundo e cooldown de
10 segundos entre tentativas. Contadores representam tentativas, não pagamentos.
Após usar versões anteriores, reconecte uma vez para eliminar listeners extras
que aquelas versões possam ter inicializado; apagar elementos visuais não os encerra.

## Outros recursos

- Daily, hourly e anti-AFK automáticos.
- Velocidade local, auto win e tempLuck de Grasslands.
- Solarians, Planet Run, charts e atalhos de World 1 e World 2.

## Verificação

`tests/StudioHarness.luau` cobre regressões de field, visibilidade e restauração. Os
fixtures usam SurfaceGuis reais com Adornees, modelos aninhados e progresso de
fields, em vez de representar as lojas como ScreenGuis. O layout dos três modos
é medido em uma SurfaceGui temporária de 360 × 760 pixels no engine, removida
ao final. O teste cobre exclusão entre farms, quantidade unitária, preferência
por Anti, bloqueios com cap positivo, retorno falso, compras, câmera e restauração.

Os remotes e serviços de gameplay são simulados no harness. O arquivo aberto
no Studio é uma exportação sem os handlers originais do servidor. Isso valida
o comportamento do cliente; aceitação dos pedidos e ganhos persistentes ainda
exigem teste contra o servidor original. Retorno positivo não comprova ganho salvo.

O código usa camelCase e PascalCase, sem comentários. As evidências e o place
exportado permanecem fora do Git.
