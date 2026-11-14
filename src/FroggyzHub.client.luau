local Players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
assert(player, "Execute no cliente")
local guiParent = player:WaitForChild("PlayerGui")
local old = guiParent:FindFirstChild("FroggyzHub")
if old then
	old:Destroy()
end
local alive = true
local connections = {}
local originals = {}
local visibility = {}
local modules = {}
local collecting = false
local autoWin = false
local combatLuck = 0
local luckOriginal
local fieldChoice
local function module(name)
	if modules[name] then
		return modules[name]
	end
	local object = replicatedStorage:FindFirstChild(name)
	assert(object and object:IsA("ModuleScript"), "Módulo indisponível: " .. name)
	modules[name] = require(object)
	return modules[name]
end
local function create(class, props, parent)
	local object = Instance.new(class)
	for key, value in pairs(props) do
		object[key] = value
	end
	object.Parent = parent
	return object
end
local green = Color3.fromRGB(132, 241, 157)
local ink = Color3.fromRGB(21, 28, 27)
local root = create(
	"ScreenGui",
	{ Name = "FroggyzHub", ResetOnSpawn = false, DisplayOrder = 100, ZIndexBehavior = Enum.ZIndexBehavior.Sibling },
	guiParent
)
local window = create("Frame", {
	Size = UDim2.fromScale(0.92, 0.82),
	Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = ink,
	BorderSizePixel = 0,
}, root)
create("UISizeConstraint", { MaxSize = Vector2.new(740, 580), MinSize = Vector2.new(240, 210) }, window)
create("UICorner", { CornerRadius = UDim.new(0, 16) }, window)
local title = create("TextLabel", {
	Text = "FROGGYZ HUB",
	Font = Enum.Font.GothamBold,
	TextSize = 20,
	TextColor3 = green,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(18, 8),
	Size = UDim2.new(1, -130, 0, 40),
	TextXAlignment = Enum.TextXAlignment.Left,
}, window)
local function button(parent, text, callback)
	local b = create("TextButton", {
		Text = text,
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextColor3 = Color3.fromRGB(236, 244, 238),
		BackgroundColor3 = Color3.fromRGB(42, 56, 49),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 46),
		AutoButtonColor = true,
	}, parent)
	create("UICorner", { CornerRadius = UDim.new(0, 9) }, b)
	table.insert(
		connections,
		b.Activated:Connect(function()
			callback(b)
		end)
	)
	return b
end
local status = create("TextLabel", {
	Text = "Pronto • recursos remotos dependem do servidor",
	Font = Enum.Font.Gotham,
	TextSize = 12,
	TextColor3 = green,
	BackgroundTransparency = 1,
	TextWrapped = true,
	Size = UDim2.new(1, -28, 0, 42),
	Position = UDim2.new(0, 14, 1, -46),
}, window)
local function report(message)
	if alive then
		status.Text = tostring(message)
	end
end
local function action(fn)
	return function(b)
		task.spawn(function()
			local ok, err = pcall(fn, b)
			if not ok then
				report("Erro: " .. tostring(err):sub(1, 180))
			end
		end)
	end
end
local tabs = create("ScrollingFrame", {
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(12, 54),
	Size = UDim2.new(1, -24, 0, 48),
	CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.X,
	ScrollBarThickness = 2,
	ScrollingDirection = Enum.ScrollingDirection.X,
}, window)
create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8) }, tabs)
local body = create(
	"Frame",
	{ BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 112), Size = UDim2.new(1, -28, 1, -164) },
	window
)
local pages = {}
local function page(name)
	local p = create("ScrollingFrame", {
		Name = name,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 4,
		Visible = false,
	}, body)
	create("UIListLayout", { Padding = UDim.new(0, 9), SortOrder = Enum.SortOrder.LayoutOrder }, p)
	create("UIPadding", { PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 10) }, p)
	pages[name] = p
	local tab = button(tabs, name, function()
		for _, v in pairs(pages) do
			v.Visible = false
		end
		p.Visible = true
	end)
	tab.Size = UDim2.fromOffset(110, 42)
	return p
end
local function label(parent, text)
	return create("TextLabel", {
		Text = text,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextColor3 = Color3.fromRGB(181, 197, 186),
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 54),
	}, parent)
end
local function input(parent, placeholder, value)
	local box = create("TextBox", {
		PlaceholderText = placeholder,
		Text = value or "",
		ClearTextOnFocus = false,
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = green,
		BackgroundColor3 = Color3.fromRGB(31, 41, 36),
		Size = UDim2.new(1, 0, 0, 46),
		BorderSizePixel = 0,
	}, parent)
	create("UICorner", { CornerRadius = UDim.new(0, 9) }, box)
	return box
end
local function event(payload)
	local remotes = replicatedStorage:FindFirstChild("Remotes")
	local remote = remotes and remotes:FindFirstChild("GenericEvent")
	assert(remote and remote:IsA("RemoteEvent"), "GenericEvent indisponível")
	remote:FireServer(payload)
	report("Solicitação enviada: " .. tostring(payload.id) .. " • efeito não confirmado")
end
local general = page("Geral")
general.Visible = true
label(
	general,
	"Coleta adaptativa usa objetos locais do field selecionado. O servidor pode rejeitar pedidos. Nenhuma confirmação de recompensa é presumida."
)
local collectButton
collectButton = button(
	general,
	"Auto collect: OFF",
	action(function(b)
		collecting = not collecting
		b.Text = "Auto collect: " .. (collecting and "ON" or "OFF")
	end)
)
local speed = input(general, "Velocidade (16–200)", "32")
button(
	general,
	"Aplicar velocidade",
	action(function()
		local value = tonumber(speed.Text)
		assert(value and value == value and value >= 16 and value <= 200, "Use velocidade entre 16 e 200")
		local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		assert(humanoid, "Personagem indisponível")
		if originals[humanoid] == nil then
			originals[humanoid] = humanoid.WalkSpeed
		end
		humanoid.WalkSpeed = value
		report("Velocidade local aplicada")
	end)
)
button(
	general,
	"Mostrar menus de upgrades / resets",
	action(function()
		local count = 0
		for _, v in ipairs(guiParent:GetDescendants()) do
			if
				not v:IsDescendantOf(root)
				and v:IsA("GuiObject")
				and (v.Name == "ShopContainer" or v.Name == "PrestigeMenu")
			then
				local current = v
				while current and current ~= guiParent do
					if current:IsA("GuiObject") then
						if visibility[current] == nil then
							visibility[current] = current.Visible
						end
						current.Visible = true
					elseif current:IsA("ScreenGui") then
						if visibility[current] == nil then
							visibility[current] = current.Enabled
						end
						current.Enabled = true
					end
					current = current.Parent
				end
				count += 1
			end
		end
		report(tostring(count) .. " menus expostos localmente; pré-requisitos continuam no servidor")
	end)
)
local function restore()
	for object, value in pairs(visibility) do
		if object.Parent then
			if object:IsA("ScreenGui") then
				object.Enabled = value
			else
				object.Visible = value
			end
		end
	end
	table.clear(visibility)
	for humanoid, value in pairs(originals) do
		if humanoid.Parent then
			humanoid.WalkSpeed = value
		end
	end
	table.clear(originals)
end
button(
	general,
	"Restaurar menus e velocidade",
	action(function()
		restore()
		report("Configurações locais restauradas")
	end)
)
button(
	general,
	"Resgatar daily",
	action(function()
		event({ id = "dailyReward" })
	end)
)
button(
	general,
	"Resgatar hourly",
	action(function()
		event({ id = "hourlyReward" })
	end)
)
local upgrade = input(general, "ID do upgrade (catálogo do jogo)")
button(
	general,
	"Comprar máximo do upgrade",
	action(function()
		assert(#upgrade.Text > 0 and #upgrade.Text < 100, "Informe o ID do upgrade")
		event({ id = "buyUpgrade", mode = "max", upgradeId = upgrade.Text })
	end)
)
local worldIds = { 1, 2 }
local okFields, fields = pcall(function()
	return module("Fields").Fields
end)
if okFields then
	local seen = { [1] = true, [2] = true }
	for _, f in pairs(fields) do
		if type(f.world) == "number" and f.world > 0 and not seen[f.world] then
			seen[f.world] = true
			table.insert(worldIds, f.world)
		end
	end
end
table.sort(worldIds)
for _, worldId in ipairs(worldIds) do
	local p = page("World " .. worldId)
	label(p, "Selecione o field para a coleta. Cap e crescimento exibidos são dados recebidos pelo cliente.")
	if okFields then
		local keys = {}
		for id, f in pairs(fields) do
			if f.world == worldId then
				table.insert(keys, id)
			end
		end
		table.sort(keys)
		for _, id in ipairs(keys) do
			local f = fields[id]
			button(p, (f.display or id) .. " [" .. id .. "]", function()
				fieldChoice = id
				report("Field: " .. id .. " • cap " .. tostring(f.max) .. " • growth " .. tostring(f.growSpeed))
			end)
		end
	end
	if worldId == 1 then
		local luckInput = input(p, "Grasslands tempLuck", "1000")
		button(
			p,
			"Aplicar luck nas battles",
			action(function()
				local value = tonumber(luckInput.Text)
				assert(value and value == value and value >= 0 and value <= 1000000000, "Luck: use 0 a 1000000000")
				combatLuck = value
				report("tempLuck configurada: " .. value .. " • aceitação depende do servidor")
			end)
		)
		button(
			p,
			"Auto win: OFF",
			action(function(b)
				autoWin = not autoWin
				b.Text = "Auto win: " .. (autoWin and "ON" or "OFF")
			end)
		)
		button(
			p,
			"Vencer battle atual",
			action(function()
				local galaxy = module("GalaxyGen")
				assert(galaxy.CombatState.fighting and galaxy.CombatState.enemyObj, "Nenhuma battle ativa")
				galaxy.CombatState.playerStats.tempLuck = combatLuck
				galaxy.EnemyDead()
				report("EnemyDead executado • confira a recompensa no jogo")
			end)
		)
		label(
			p,
			"Grasslands: o protocolo envia enemyId, enemyLevel, difficulty e tempLuck. Vitória e luck alteradas ainda precisam de verificação no servidor."
		)
		button(
			p,
			"Iniciar battles",
			action(function()
				event({ id = "startFight" })
			end)
		)
		button(
			p,
			"Parar battles",
			action(function()
				event({ id = "stopFight" })
			end)
		)
	end
end
local misc = page("Misc")
label(
	misc,
	"Auto win usa EnemyDead do jogo. Luck altera tempLuck antes do pedido de recompensa. Persistência depende da validação do servidor."
)
button(
	misc,
	"Diagnóstico",
	action(function()
		local data = module("Data").ImportantData.Stats
		report(
			"World "
				.. tostring(data.world)
				.. " • tier "
				.. tostring(data.currentTier)
				.. " • field "
				.. tostring(fieldChoice or "não selecionado")
		)
	end)
)
local reopen = button(root, "FROGGYZ", function()
	window.Visible = not window.Visible
end)
reopen.Size = UDim2.fromOffset(112, 44)
reopen.Position = UDim2.new(0, 12, 1, -56)
local minimize = button(window, "—", function()
	window.Visible = false
end)
minimize.Size = UDim2.fromOffset(42, 36)
minimize.Position = UDim2.new(1, -98, 0, 10)
local close = button(window, "×", function()
	root:Destroy()
end)
close.Size = UDim2.fromOffset(42, 36)
close.Position = UDim2.new(1, -50, 0, 10)
table.insert(
	connections,
	root.Destroying:Connect(function()
		alive = false
		collecting = false
		autoWin = false
		if luckOriginal and modules.GalaxyGen then
			modules.GalaxyGen.CombatState.playerStats.tempLuck = luckOriginal
		end
		restore()
		for _, c in ipairs(connections) do
			c:Disconnect()
		end
	end)
)
table.insert(
	connections,
	userInputService.InputBegan:Connect(function(key, processed)
		if not processed and key.KeyCode == Enum.KeyCode.RightShift then
			window.Visible = not window.Visible
		end
	end)
)
task.spawn(function()
	while alive do
		task.wait(0.25)
		if collecting and alive then
			local ok, err = pcall(function()
				assert(okFields, "Fields indisponível")
				assert(fieldChoice and fields[fieldChoice], "Selecione um field na aba World")
				local f = fields[fieldChoice]
				local stats = module("Data").ImportantData.Stats
				assert(f.world == stats.world or f.world == -1 or f.world == 0, "Field pertence a outro world")
				local quantity = 0
				for object in pairs(f.objects or {}) do
					if
						typeof(object) == "Instance"
						and object.Parent
						and object.Name == "g"
						and object.Transparency < 1
					then
						quantity += 1
					end
				end
				quantity = math.min(quantity, math.max(0, tonumber(f.max) or 0), 5000)
				if quantity < 1 then
					report("Aguardando grass no field " .. fieldChoice)
					return
				end
				local identifier = f.defaultId == "tier" and stats.currentTier or f.defaultId
				if identifier == "tier2" then
					error("Tier World 2 requer mapeamento; coleta não enviada")
				end
				local remotes = replicatedStorage:FindFirstChild("Remotes")
				local remote = remotes and remotes:FindFirstChild("GenericFunction")
				assert(remote and remote:IsA("RemoteFunction"), "GenericFunction indisponível")
				local response = remote:InvokeServer({
					id = "cut",
					field = fieldChoice,
					identifier = identifier,
					quantity = quantity,
				})
				report("cut • " .. fieldChoice .. " • " .. quantity .. " • retorno " .. tostring(response))
			end)
			if not ok then
				collecting = false
				collectButton.Text = "Auto collect: OFF"
				report(tostring(err):sub(1, 180))
			end
		end
	end
end)
report("Froggyz Hub pronto • selecione um field")
task.spawn(function()
	while alive do
		task.wait(0.2)
		if autoWin and alive then
			local ok, err = pcall(function()
				local galaxy = module("GalaxyGen")
				local combat = galaxy.CombatState
				if combat.fighting and combat.enemyObj then
					if luckOriginal == nil then
						luckOriginal = combat.playerStats.tempLuck
					end
					combat.playerStats.tempLuck = combatLuck
					galaxy.EnemyDead()
					report("Auto win • vitória local solicitada")
				end
			end)
			if not ok then
				autoWin = false
				report(tostring(err):sub(1, 180))
			end
		end
	end
end)
