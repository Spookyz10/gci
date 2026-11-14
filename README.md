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
| PW8 | `pw8` | Cap do field, até 5000 | Rodízio entre fields liberados do world atual |
| Platinum | `platinum` | Sempre 1 | Anti liberado com grama; senão main |
| Moonstone | `moonstone` | Sempre 1 | Anti liberado com grama; senão main |

O tier PW8 é fixo e não depende do tier do jogador. A verificação de progresso
se aplica à liberação dos fields. Cap positivo, sozinho, não libera um field:
o hub consulta upgrades, resets e condições de acesso encontradas no cliente.
Quando não consegue confirmar uma área, não envia para ela.

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
Compras usam o upgrade selecionado no jogo ou a SurfaceGui que contém esse upgrade.

Mostrar máquinas suspende `TabManager.ShowHideTabs()` de forma reversível e
usa posições originais mapeadas. Máquinas sem posição confirmada ficam intactas;
não é criada uma galeria nem terreno adicional. A restauração guarda pivôs de
modelos e CFrames individuais de peças, incluindo modelos aninhados, além dos
estados Enabled/Visible alterados. Falhas são informadas e seus registros ficam
disponíveis para nova tentativa, em vez de serem descartados silenciosamente.

## Outros recursos

- Daily, hourly e anti-AFK automáticos.
- Compra máxima do upgrade selecionado e dos upgrades da mesma superfície.
- Velocidade local, auto win e tempLuck de Grasslands.
- Solarians, Planet Run, charts e atalhos de World 1 e World 2.

## Verificação

`tests/StudioHarness.luau` foi executado no Studio com 38 verificações. Os
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
