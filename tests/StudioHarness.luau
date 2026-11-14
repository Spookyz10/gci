return function(runHub)
	local root = Instance.new("Folder")
	root.Name = "FroggyzTests"
	local function make(className, name, parent)
		local object = Instance.new(className)
		object.Name = name
		object.Parent = parent
		return object
	end
	local playerGui = make("Folder", "PlayerGui", root)
	local w1 = make("SurfaceGui", "W1", playerGui)
	local w2 = make("SurfaceGui", "W2", playerGui)
	w1.Enabled = false
	local features = make("Folder", "Features", root)
	local automation = make("Model", "AutomationShop", features)
	local part = make("Part", "Interface", automation)
	part.Anchored = true
	part.Size = Vector3.new(12, 8, 1)
	part.CFrame = CFrame.new(0, 200000, 0)
	local door = make("Model", "LockedDoor", automation)
	local doorPart = make("Part", "Door", door)
	doorPart.Anchored = true
	doorPart.CFrame = CFrame.new(5, 200008, 0)
	local partOriginal, doorOriginal = part.CFrame, doorPart.CFrame
	local unknown = make("Model", "UnknownMachine", features)
	local unknownPart = make("Part", "Base", unknown)
	unknownPart.Anchored = true
	unknownPart.CFrame = CFrame.new(20, 200000, 0)
	local w2Features = make("Folder", "W2", features)
	local w2Machine = make("Model", "Stability", w2Features)
	local w2Part = make("Part", "Base", w2Machine)
	w2Part.Anchored = true
	w2Part.CFrame = CFrame.new(0, 200000, 0)
	local surface = make("SurfaceGui", "Upgrades", w1)
	surface.Adornee = part
	surface.Enabled = false
	local alternate = make("SurfaceGui", "AutomationUpgrades", w1)
	alternate.Adornee = part
	local shop = make("Frame", "ShopContainer", surface)
	local otherShop = make("Frame", "ShopContainer", alternate)
	local lock = make("Frame", "Locked", surface)
	local upgradeA = make("Frame", "UpgradeA", shop)
	local upgradeB = make("Frame", "UpgradeB", shop)
	local upgradeC = make("Frame", "UpgradeC", otherShop)
	local chartNode = make("Frame", "ChartNode", shop)
	local chartLock = make("Frame", "Lock", chartNode)
	local chartUnlocked = make("Frame", "Unlocked", chartNode)
	chartUnlocked.Visible = false
	local chartPrereqs = { "previous" }
	local chartCondition = function()
		return false
	end
	local chartEntry =
		{ world = 1, obj = chartNode, prereqs = chartPrereqs, unlocked = false, unlockCondition = chartCondition }
	local signals = {}
	for _, name in ipairs({ "Heartbeat", "Idled", "InputBegan", "InputChanged", "InputEnded" }) do
		signals[name] = make("BindableEvent", name, root)
	end
	local character = make("Model", "Character", root)
	local humanoid = make("Humanoid", "Humanoid", character)
	humanoid.WalkSpeed = 16
	local player = {
		Character = character,
		Idled = signals.Idled.Event,
		WaitForChild = function(_, name)
			assert(name == "PlayerGui")
			return playerGui
		end,
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
		prTimerClient = 0,
	}
	local upgrades = { decelerator = { level = 0 }, recelerator = { level = 0 }, bridge2 = { level = 0 } }
	local fields = {
		main = { world = 1, max = 120, counter = 50, defaultId = "tier", growSpeed = 1 },
		anti = { world = 1, max = 9000, counter = 100, defaultId = "tier", growSpeed = 10 },
		planet = { world = 1, max = 900, counter = 100, defaultId = "basic" },
		un = { world = 1, max = 500, counter = 100, defaultId = "basic" },
		jungle = { world = 2, max = 200, counter = 100, defaultId = "tier2" },
		cavern = { world = 2, max = 600, counter = 100, defaultId = "basic" },
		locked = { world = 1, max = 800, counter = 100, unlocked = false },
	}
	local nativeCalls = 0
	local native = function()
		nativeCalls += 1
	end
	local modules = {
		Data = { ImportantData = { Stats = stats, UpgradeLevels = { generic = upgrades, upgrades = {} } } },
		Fields = { Fields = fields },
		InfoStore = { Resets = {} },
		MapTeles = { Teles = { field2 = {
			visibleConditionC = function()
				return false
			end,
		} } },
		TabManager = { ShowHideTabs = native },
		Upgrades = { Basic = { a = { object = upgradeA }, b = { object = upgradeB }, c = { object = upgradeC } } },
		Solarians = { Bars = { sol = {} } },
		PlanetRun = { BitsCreated = {}, Levels = { normal = { levels = { ["1"] = { minTime = 20000 } } } } },
		SingularityChart = { Upgrades = { node = chartEntry } },
		GalaxyGen = { CombatState = { fighting = false, playerStats = { tempLuck = 0 } } },
	}
	local cuts, events, active, maxActive, idleCalls = {}, {}, 0, 0, 0
	local remoteFunction = {
		IsA = function(_, className)
			return className == "RemoteFunction"
		end,
		InvokeServer = function(_, payload)
			active += 1
			maxActive = math.max(maxActive, active)
			table.insert(cuts, payload)
			task.wait(0.04)
			active -= 1
			return payload.identifier ~= "pw8"
		end,
	}
	local remoteEvent = {
		IsA = function(_, className)
			return className == "RemoteEvent"
		end,
		FireServer = function(_, payload)
			table.insert(events, payload)
		end,
	}
	local remotes = {
		FindFirstChild = function(_, name)
			return name == "GenericFunction" and remoteFunction or name == "GenericEvent" and remoteEvent
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
	local camera = {
		ViewportSize = Vector2.new(360, 760),
		CFrame = CFrame.new(20, 30, 40),
		Focus = CFrame.new(),
		CameraType = Enum.CameraType.Custom,
		CameraSubject = humanoid,
	}
	local originalCamera = camera.CFrame
	local services = {
		Players = { LocalPlayer = player },
		ReplicatedStorage = replicatedStorage,
		RunService = { Heartbeat = signals.Heartbeat.Event },
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
			CurrentCamera = camera,
			FindFirstChild = function(_, name)
				return root:FindFirstChild(name)
			end,
		},
		require = function(object)
			return modules[object.Name]
		end,
	}
	local api
	local layoutPart
	local cases = {}
	local function check(condition, name)
		assert(condition, name)
		table.insert(cases, name)
	end
	local function runCollect()
		api.Hub.nextCollectionAt = 0
		api.Game.collectAll()
	end
	local ok, message = pcall(function()
		api = runHub(environment)
		check(api.Ui.subnav == nil, "Apenas três abas; sem navegação aninhada")
		for _, page in ipairs({ "Geral", "World 1", "World 2" }) do
			api.Ui.navigate(page)
			check(api.Ui.body:FindFirstChildOfClass("Frame") ~= nil, "Conteúdo de " .. page)
		end
		api.Ui.navigate("Geral")
		api.Ui.resize(Vector2.new(360, 760))
		check(api.Ui.window.Size.X.Offset == 340 and api.Ui.window.Size.Y.Offset == 720, "Janela de telefone")
		check(api.Ui.body.Position.Y.Offset == 132, "Mais área útil para conteúdo")
		layoutPart = Instance.new("Part")
		layoutPart.Name = "FroggyzLayoutTest"
		layoutPart.Anchored = true
		layoutPart.CanCollide = false
		layoutPart.CFrame = CFrame.new(0, 100000, 0)
		local layoutSurface = Instance.new("SurfaceGui")
		layoutSurface.CanvasSize = Vector2.new(360, 760)
		layoutSurface.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
		layoutSurface.Adornee = layoutPart
		layoutSurface.Parent = layoutPart
		local canvas = api.Ui.canvas:Clone()
		canvas.Window.Visible = true
		canvas.Parent = layoutSurface
		layoutPart.Parent = workspace
		task.wait(0.1)
		local modePositions = {}
		for _, object in ipairs(canvas:GetDescendants()) do
			if
				object:IsA("TextButton")
				and (object.Text == "PW8" or object.Text == "Platinum" or object.Text == "Moonstone")
			then
				modePositions[object.Text] = object.AbsolutePosition
			end
		end
		check(
			modePositions.PW8.Y == modePositions.Platinum.Y
				and modePositions.PW8.Y == modePositions.Moonstone.Y
				and modePositions.Moonstone.X > modePositions.Platinum.X,
			"Três modos na mesma linha em telefone real"
		)
		layoutPart:Destroy()
		layoutPart = nil
		api.Ui.beginDrag({ UserInputType = Enum.UserInputType.MouseButton1, Position = Vector3.zero })
		api.Ui.moveDrag({ UserInputType = Enum.UserInputType.MouseMovement, Position = Vector3.new(15, 20, 0) })
		check(api.Hub.dragged == true, "Arrastar com mouse")
		api.Hub.drag = nil
		local touch = { UserInputType = Enum.UserInputType.Touch, Position = Vector3.zero }
		api.Ui.beginDrag(touch)
		touch.Position = Vector3.new(25, 40, 0)
		api.Ui.moveDrag(touch)
		check(api.Hub.dragged and api.Hub.drag.input == touch, "Arrastar com toque")
		local before = api.Ui.window.Visible
		signals.InputBegan:Fire({ KeyCode = Enum.KeyCode.K }, false)
		check(api.Ui.window.Visible ~= before, "Atalho K")
		local unlocked = api.Game.unlockedFields()
		check(#unlocked == 1 and unlocked[1].id == "main", "Cap positivo não libera fields bloqueados")
		stats.world = "1"
		stats.slotLoaded = false
		fields.main.max = 0
		check(api.Game.fieldUnlocked("main", fields.main), "Main independe de cap e flag de save")
		check(api.Game.unlockedFields()[1].id == "main", "World numérico em texto reconhecido")
		stats.world = 1
		stats.slotLoaded = true
		fields.main.max = 120
		api.Hub.settings.collect = true
		api.Game.setFarmMode("pw8")
		runCollect()
		check(#cuts == 1 and cuts[1].identifier == "pw8" and cuts[1].quantity == 120, "PW8 fixo com lote maior")
		check(cuts[1].field == "main", "Sem envio a anti bloqueado ou outro world")
		api.Game.setFarmMode("platinum")
		runCollect()
		check(
			cuts[#cuts].field == "main" and cuts[#cuts].identifier == "platinum" and cuts[#cuts].quantity == 1,
			"Platinum em main quando anti bloqueado"
		)
		upgrades.decelerator.level = 1
		runCollect()
		check(cuts[#cuts].field == "anti" and cuts[#cuts].quantity == 1, "Platinum prefere anti liberado com grama")
		api.Game.setFarmMode("moonstone")
		runCollect()
		check(
			cuts[#cuts].field == "anti" and cuts[#cuts].identifier == "moonstone" and cuts[#cuts].quantity == 1,
			"Moonstone em anti com quantidade um"
		)
		fields.anti.counter = 0
		runCollect()
		check(cuts[#cuts].field == "main", "Fallback para main quando anti está vazio")
		fields.anti.counter = 100
		api.Game.setFarmMode("pw8")
		api.Hub.nextCollectionAt = 0
		local count = #cuts
		task.defer(api.Game.collectAll)
		task.wait(0.01)
		check(api.Hub.pendingRequest ~= nil, "Pedido pendente registrado")
		api.Game.setFarmMode("moonstone")
		api.Game.collectAll()
		check(#cuts == count + 1, "Trocar modo não intercala pedidos")
		task.wait(0.06)
		runCollect()
		check(maxActive == 1 and cuts[#cuts].identifier == "moonstone", "Somente um farm e um pedido ativos")
		stats.world = 2
		count = #cuts
		runCollect()
		check(#cuts == count, "Especiais não rodam em World 2")
		api.Game.setFarmMode("pw8")
		runCollect()
		check(cuts[#cuts].field == "jungle" and cuts[#cuts].identifier == "pw8", "PW8 usa fields liberados de World 2")
		upgrades.bridge2.level = 1
		check(api.Game.fieldUnlocked("cavern", fields.cavern), "Cavern liberada por progresso real")
		stats.world = 1
		api.Hub.settings.collect = false
		local probeOk, probeResult = api.Game.testCollect100()
		check(
			probeOk
				and probeResult == false
				and cuts[#cuts].field == "main"
				and cuts[#cuts].identifier == "pw8"
				and cuts[#cuts].quantity == 100,
			"Teste de 100 mostra retorno falso sem fingir sucesso"
		)
		api.Game.buySelected()
		api.Game.buyShop()
		check(
			events[#events].upgradeId == "b" and events[#events - 1].upgradeId == "a",
			"Compra pela SurfaceGui da seleção"
		)
		upgradeA.Visible = false
		api.Game.revealMachines(1)
		check(upgradeA.Visible, "Upgrade oculto revelado")
		check(
			#chartEntry.prereqs == 0 and chartEntry.unlocked and chartEntry.unlockCondition(),
			"Chart expõe nós sem pré-requisito local"
		)
		check(not chartLock.Visible and chartUnlocked.Visible, "Chart usa botão nativo desbloqueado")
		upgradeA.Visible = false
		task.wait()
		check(upgradeA.Visible, "Atualização de visibilidade corrigida por evento")
		check(
			(automation:GetPivot().Position - api.Game.machinePositions[1].AutomationShop.Position).Magnitude < 0.1,
			"Máquina na posição original conhecida"
		)
		check(unknownPart.Position.Y == 200000, "Máquina sem posição não é realocada")
		api.Game.openFeature("W1", "Upgrades")
		check(
			camera.CameraType == Enum.CameraType.Scriptable and surface.Enabled and not alternate.Enabled,
			"Foco em SurfaceGui sem sobrepor a outra face"
		)
		check(
			shop.Visible and otherShop.Visible and shop.Parent == surface and otherShop.Parent == alternate,
			"Lojas não são janelas abertas ou reparentadas"
		)
		api.Game.restoreCamera()
		check(
			camera.CameraType == Enum.CameraType.Custom and camera.CFrame == originalCamera and alternate.Enabled,
			"Câmera e superfície anterior restauradas"
		)
		api.Game.removeBarriers(1)
		check(door:GetPivot().Position.Y > 100000, "Barreira aninhada ocultada")
		api.Game.nativeVisibility(false)
		check(
			chartEntry.prereqs == chartPrereqs
				and not chartEntry.unlocked
				and chartEntry.unlockCondition == chartCondition,
			"Condições originais do chart restauradas"
		)
		check(chartLock.Visible and not chartUnlocked.Visible, "Widgets do chart restaurados")
		check(not upgradeA.Visible, "Visibilidade original do upgrade restaurada")
		upgradeA.Visible = true
		upgradeA.Visible = false
		task.wait()
		check(not upgradeA.Visible, "Controlador de visibilidade desconectado ao restaurar")
		check(
			part.CFrame == partOriginal and doorPart.CFrame == doorOriginal,
			"Peças de modelos aninhados restauradas exatamente"
		)
		check(
			not surface.Enabled and not w1.Enabled and lock.Visible and modules.TabManager.ShowHideTabs == native,
			"SurfaceGuis, locks e função restaurados"
		)
		local broken = setmetatable({ Parent = root }, {
			__newindex = function()
				error("falha simulada")
			end,
		})
		api.Hub.mapParts[broken] = CFrame.new()
		local restored, failures = api.Game.restoreMachines()
		check(
			restored == 0 and #failures == 1 and api.Hub.mapParts[broken] ~= nil,
			"Falha de restauração é preservada para nova tentativa"
		)
		api.Hub.mapParts[broken] = nil
		local eventCount = #events
		signals.Heartbeat:Fire()
		task.wait(0.05)
		check(#events == eventCount + 2, "Daily e hourly automáticos")
		signals.Idled:Fire()
		task.wait(0.08)
		check(idleCalls == 3, "Anti-AFK automático")
		api.Hub.remember(humanoid, "WalkSpeed", 80)
		api.Game.revealMachines(1)
		api.Ui.root:Destroy()
		check(
			not api.Hub.alive
				and part.CFrame == partOriginal
				and doorPart.CFrame == doorOriginal
				and humanoid.WalkSpeed == 16,
			"Fechar desfaz alterações"
		)
		for _, connection in ipairs(api.Hub.connections) do
			assert(not connection.Connected)
		end
		for _, connection in ipairs(api.Hub.pageConnections) do
			assert(not connection.Connected)
		end
		check(true, "Conexões encerradas")
	end)
	if api and api.Hub.alive then
		api.Ui.root:Destroy()
	end
	if layoutPart then
		layoutPart:Destroy()
	end
	root:Destroy()
	assert(ok, message)
	return { passed = true, checks = #cases, cases = cases, maxConcurrentRequests = maxActive }
end
