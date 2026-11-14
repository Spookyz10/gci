return function(runHub)
	local testRoot = Instance.new("Folder")
	testRoot.Name = "FroggyzTests"
	local function make(className, name, parent)
		local object = Instance.new(className)
		object.Name = name
		object.Parent = parent
		return object
	end
	local playerGui = make("Folder", "PlayerGui", testRoot)
	local firstWorld = make("ScreenGui", "W1", playerGui)
	local secondWorld = make("ScreenGui", "W2", playerGui)
	local feature = make("Frame", "PrestigeUpgrades", firstWorld)
	local shop = make("Frame", "ShopContainer", feature)
	local locked = make("Frame", "Locked", feature)
	local firstUpgrade = make("Frame", "UpgradeA", shop)
	local secondUpgrade = make("Frame", "UpgradeB", shop)
	local otherShop = make("Frame", "ShopContainer", make("Frame", "OpalUpgrades", secondWorld))
	local foreignUpgrade = make("Frame", "UpgradeC", otherShop)
	local features = make("Folder", "Features", testRoot)
	local hiddenMachine = make("Model", "HiddenMachine", features)
	local machinePart = make("Part", "Base", hiddenMachine)
	machinePart.Anchored = true
	machinePart.Size = Vector3.new(20, 20, 20)
	machinePart.CFrame = CFrame.new(0, 200000, 0)
	local surface = make("SurfaceGui", "Display", machinePart)
	surface.Enabled = false
	local originalPivot = hiddenMachine:GetPivot()
	local nativeMachine = make("Model", "AutomationShop", features)
	local nativePart = make("Part", "Base", nativeMachine)
	nativePart.Anchored = true
	nativePart.CFrame = CFrame.new(0, 200000, 0)
	local door = make("Model", "LockedDoor", features)
	local doorPart = make("Part", "Base", door)
	doorPart.Anchored = true
	doorPart.CFrame = CFrame.new(10, 5, 10)
	local worldTwoFeatures = make("Folder", "W2", features)
	local realFeatures = make("Folder", "Real", features)
	local otherMachine = make("Model", "AutomationShop", realFeatures)
	local otherMachinePart = make("Part", "Base", otherMachine)
	otherMachinePart.Anchored = true
	otherMachinePart.CFrame = CFrame.new(0, 200000, 0)
	local secondMachine = make("Model", "SecondMachine", worldTwoFeatures)
	local secondPart = make("Part", "Base", secondMachine)
	secondPart.Anchored = true
	secondPart.CFrame = CFrame.new(0, 200000, 0)
	local events = {}
	local cuts = {}
	local idleCalls = 0
	local nativeCalls = 0
	local api
	local checks = {}
	local function check(condition, name)
		assert(condition, name)
		table.insert(checks, name)
	end
	local signals = {}
	for _, name in ipairs({ "Heartbeat", "Idled", "InputBegan", "InputChanged", "InputEnded" }) do
		signals[name] = make("BindableEvent", name, testRoot)
	end
	local player = { Idled = signals.Idled.Event, Character = make("Model", "Character", testRoot) }
	local humanoid = make("Humanoid", "Humanoid", player.Character)
	humanoid.WalkSpeed = 16
	function player:WaitForChild(name)
		assert(name == "PlayerGui")
		return playerGui
	end
	local fields = {
		main = {
			world = 1,
			max = 120,
			growSpeed = 4,
			defaultId = "tier",
			spawnArea = { x = Vector2.new(-50, 50), z = Vector2.new(-50, 50), y = 0 },
		},
		anti = { world = 1, max = 9000, defaultId = "basic" },
		jungle = {
			world = 2,
			max = 200,
			defaultId = "tier2",
			spawnArea = { x = Vector2.new(1000, 1100), z = Vector2.new(-50, 50), y = 0 },
		},
		locked = { world = 2, max = 0, defaultId = "basic" },
		otherWorld = { world = 8, max = 50, defaultId = "basic" },
	}
	local stats = {
		slotLoaded = true,
		world = 1,
		currentTier = "basic",
		dailyTimeRemaining = 86400,
		hourlyTimeRemaining = 0,
		upgradeSelected = "a",
		planetRun = "normal",
		planetRunLevel = 1,
		prTimerClient = 1,
	}
	local nativeFunction = function()
		nativeCalls += 1
	end
	local modules = {
		Data = { ImportantData = { Stats = stats } },
		Fields = { Fields = fields },
		GrassTypes = { Types = { basic = { nextTier = "pale" }, pale = { nextTier = "top" }, top = {} } },
		TabManager = { ShowHideTabs = nativeFunction, menus = {} },
		Upgrades = {
			Basic = { a = { object = firstUpgrade }, b = { object = secondUpgrade }, c = { object = foreignUpgrade } },
		},
		PlanetRun = { BitsCreated = {}, Levels = { normal = { levels = { ["1"] = { minTime = 20000 } } } } },
		Solarians = { Bars = { sol = {
			unlockCondition = function()
				return false
			end,
		}, ll = {} } },
		SingularityChart = {
			Upgrades = {
				sol = { world = 1, level = 0, levelCap = 1, prereqs = {} },
				blocked = { world = 1, level = 0, prereqs = { "sol" } },
				temple = { world = 2, level = 0, prereqs = {} },
			},
		},
		GalaxyGen = { CombatState = { fighting = false, playerStats = { tempLuck = 0 } } },
	}
	local remoteEvent = {
		IsA = function(_, className)
			return className == "RemoteEvent"
		end,
		FireServer = function(_, payload)
			table.insert(events, payload)
		end,
	}
	local remoteFunction = {
		IsA = function(_, className)
			return className == "RemoteFunction"
		end,
		InvokeServer = function(_, payload)
			table.insert(cuts, payload)
			task.wait(0.03)
			return payload.field ~= "anti"
		end,
	}
	local remotes = {
		FindFirstChild = function(_, name)
			return name == "GenericEvent" and remoteEvent or name == "GenericFunction" and remoteFunction
		end,
	}
	local replicatedStorage = {
		FindFirstChild = function(_, name)
			if name == "Remotes" then
				return remotes
			end
			if modules[name] then
				return {
					Name = name,
					IsA = function(_, className)
						return className == "ModuleScript"
					end,
				}
			end
		end,
	}
	local services = {
		Players = { LocalPlayer = player },
		ReplicatedStorage = replicatedStorage,
		RunService = { Heartbeat = signals.Heartbeat.Event },
		TweenService = {},
		UserInputService = {
			InputBegan = signals.InputBegan.Event,
			InputChanged = signals.InputChanged.Event,
			InputEnded = signals.InputEnded.Event,
			GetFocusedTextBox = function()
				return nil
			end,
		},
		VirtualUser = {
			CaptureController = function()
				idleCalls += 1
			end,
			Button2Down = function()
				idleCalls += 1
			end,
			Button2Up = function()
				idleCalls += 1
			end,
		},
	}
	local environment = {
		game = {
			GetService = function(_, name)
				assert(services[name], name)
				return services[name]
			end,
		},
		workspace = {
			CurrentCamera = { ViewportSize = Vector2.new(360, 760), CFrame = CFrame.new() },
			FindFirstChild = function(_, name)
				return testRoot:FindFirstChild(name)
			end,
		},
		require = function(object)
			return modules[object.Name]
		end,
	}
	local ok, message = pcall(function()
		api = runHub(environment)
		task.wait()
		check(api.Ui.root.Parent == playerGui, "UI construída")
		api.Ui.resize(Vector2.new(360, 760))
		check(api.Ui.window.Size.X.Offset == 340 and api.Ui.window.Size.Y.Offset == 700, "Layout de telefone 360 x 760")
		api.Ui.resize(Vector2.new(844, 350))
		check(api.Ui.window.Size.Y.Offset == 322, "Layout horizontal curto")
		for _, pair in ipairs({
			{ "Geral", "Início" },
			{ "Geral", "Compras" },
			{ "Geral", "Ajustes" },
			{ "World 1", "Acesso" },
			{ "World 1", "Grasslands" },
			{ "World 1", "Solarians" },
			{ "World 1", "Planet Run" },
			{ "World 1", "Chart" },
			{ "World 2", "Acesso" },
			{ "World 2", "Templo" },
			{ "World 2", "Gauntlet" },
		}) do
			api.Ui.navigate(pair[1], pair[2])
			task.wait()
			check(api.Ui.body:FindFirstChildOfClass("Frame") ~= nil, "Seção " .. pair[1] .. "/" .. pair[2])
		end
		api.Game.nativeVisibility(true)
		modules.TabManager.ShowHideTabs()
		check(nativeCalls == 0 and not locked.Visible, "Ocultação cancelada na função")
		api.Game.nativeVisibility(true)
		check(#api.Hub.patches == 1, "Patch idempotente")
		api.Game.openMenu(shop)
		check(shop.Visible and not api.Ui.window.Visible and api.Ui.context.Visible, "Loja com ações contextuais")
		api.Game.buyShop(shop)
		check(
			#events == 2 and events[1].upgradeId == "a" and events[2].upgradeId == "b",
			"Compra somente da loja aberta"
		)
		api.Game.buySelected()
		check(events[#events].upgradeId == "a", "Compra da seleção nativa")
		api.Hub.settings.collect = true
		api.Game.collectAll()
		api.Game.collectAll()
		task.wait(0.12)
		check(#cuts == 3, "Coleta de todos os fields sem duplicar pedidos pendentes")
		local byField = {}
		for _, payload in ipairs(cuts) do
			byField[payload.field] = payload
		end
		check(byField.main.quantity == 120 and byField.main.identifier == "top", "Cap e maior tier em World 1")
		check(byField.jungle.quantity == 200 and byField.jungle.identifier == "top", "World 2 coletado sem seleção")
		check(byField.anti.quantity == 5000 and api.Hub.stats.rejected == 1, "Limite de lote e recusa contabilizada")
		check(api.Hub.collectedFields.anti > os.clock() + 1, "Backoff para field recusado")
		local eventCount = #events
		api.Game.claimRewards()
		check(
			#events == eventCount + 2
				and events[eventCount + 1].id == "dailyReward"
				and events[eventCount + 2].id == "hourlyReward",
			"Daily e hourly automáticos"
		)
		stats.dailyTimeRemaining = 90000
		stats.hourlyTimeRemaining = 500
		eventCount = #events
		api.Game.claimRewards()
		check(#events == eventCount, "Resgates aguardam elegibilidade")
		signals.Idled:Fire()
		task.wait(0.1)
		check(idleCalls == 3, "Anti-AFK automático")
		local visible = api.Ui.window.Visible
		signals.InputBegan:Fire({ KeyCode = Enum.KeyCode.K }, false)
		check(api.Ui.window.Visible ~= visible, "K alterna visibilidade")
		signals.InputBegan:Fire({ KeyCode = Enum.KeyCode.K }, true)
		check(api.Ui.window.Visible ~= visible, "K respeita entrada consumida")
		api.Game.finishRun()
		check(
			events[#events].id == "stopPRTimer" and events[#events].timer == 20000,
			"Planet Run usa mínimo do catálogo"
		)
		api.Game.chartBuy(1)
		check(events[#events].id == "buySC" and events[#events].scId == "sol", "Chart filtra world e pré-requisitos")
		api.Game.revealMachines(1)
		check(
			hiddenMachine:GetPivot().Position.Y < 100000
				and secondMachine:GetPivot().Position.Y > 100000
				and otherMachine:GetPivot().Position.Y > 100000,
			"Máquinas separadas por world"
		)
		api.Game.revealMachines(2)
		check(secondMachine:GetPivot().Position.Y < 100000, "Máquinas World 2 expostas")
		check(
			(nativeMachine:GetPivot().Position - Vector3.new(-206.75, -12.251, -0.126)).Magnitude < 0.01,
			"Máquinas mapeadas na posição original"
		)
		api.Game.removeBarriers(1)
		check(door:GetPivot().Position.Y > 100000, "Barreiras locais removidas")
		api.Game.exposeSolarians()
		check(modules.Solarians.Bars.sol.unlockCondition(), "Funções Solarians expostas localmente")
		api.Hub.settings.collect = false
		stats.dailyTimeRemaining = 86400
		stats.hourlyTimeRemaining = 0
		eventCount = #events
		signals.Heartbeat:Fire()
		task.wait(0.08)
		check(#events == eventCount + 2, "Scheduler resgata sem ativação manual")
		api.Hub.remember(humanoid, "WalkSpeed", 90)
		api.Ui.root:Destroy()
		check(
			not api.Hub.alive and humanoid.WalkSpeed == 16 and locked.Visible,
			"Encerrar restaura estado e velocidade"
		)
		check(modules.TabManager.ShowHideTabs == nativeFunction, "Função original restaurada")
		check(
			not modules.Solarians.Bars.sol.unlockCondition() and door:GetPivot().Position.Y == 5,
			"Condições Solarians e barreiras restauradas"
		)
		check(
			(hiddenMachine:GetPivot().Position - originalPivot.Position).Magnitude < 0.01 and not surface.Enabled,
			"Máquinas e displays restaurados"
		)
		for _, connection in ipairs(api.Hub.connections) do
			assert(not connection.Connected, "Conexão global ativa após encerrar")
		end
		for _, connection in ipairs(api.Hub.pageConnections) do
			assert(not connection.Connected, "Conexão de página ativa após encerrar")
		end
		check(true, "Todas as conexões encerradas")
	end)
	if api and api.Hub.alive then
		api.Ui.root:Destroy()
	end
	testRoot:Destroy()
	assert(ok, message)
	return { passed = true, checks = #checks, cases = checks, requests = #cuts }
end
