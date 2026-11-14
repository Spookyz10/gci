local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
assert(player, "Froggyz Hub deve executar no cliente")
local playerGui = player:WaitForChild("PlayerGui")
local previous = playerGui:FindFirstChild("FroggyzHub")
if previous then
	previous:Destroy()
end

local Hub = {
	alive = true,
	connections = {},
	pageConnections = {},
	threads = {},
	modules = {},
	jobs = {},
	patches = {},
	properties = {},
	machinePivots = {},
	fieldRequests = {},
	collectedFields = {},
	settings = { collect = false, autoWin = false, autoBits = false, luck = 1000, unlock = false },
	stats = { requests = 0, accepted = 0, rejected = 0, fields = 0, rewards = 0 },
	currentWorld = 1,
	nativeMenu = nil,
	purchaseBusy = false,
	page = "Geral",
	section = "Início",
}

local Theme = {
	background = Color3.fromRGB(15, 20, 26),
	panel = Color3.fromRGB(23, 30, 38),
	card = Color3.fromRGB(30, 39, 48),
	border = Color3.fromRGB(48, 60, 70),
	text = Color3.fromRGB(241, 246, 248),
	muted = Color3.fromRGB(173, 190, 202),
	accent = Color3.fromRGB(130, 237, 180),
	accentInk = Color3.fromRGB(13, 49, 34),
	blue = Color3.fromRGB(144, 196, 255),
	danger = Color3.fromRGB(255, 154, 154),
}

local Ui = { pages = {}, navigation = {}, sectionButtons = {}, order = 0, renderers = {} }
local Game = {}
Game.machinePositions = {
	[1] = {
		["FlowerShop"] = CFrame.new(-38.363, 41.75, -149.734) * CFrame.Angles(0, -1.9198621771937625, 0),
		["AutomationShop"] = CFrame.new(-206.75, -12.251, -0.126) * CFrame.Angles(0, -0.08726646259971647, 0),
		["AntiAntiAutomationShop"] = CFrame.new(-16797.01, -13.5, -0.053) * CFrame.Angles(0, -3.0543261909900767, 0),
		["PrestigeShop"] = CFrame.new(-223.375, -15.25, 166.499) * CFrame.Angles(0, 0, 0),
		["Crystallize"] = CFrame.new(-210.125, -15.25, 242.248) * CFrame.Angles(0, 0.5235987755982988, 0),
		["CrystalShop"] = CFrame.new(-141.5, -15.25, 273.874) * CFrame.Angles(0, 1.4835298641951802, 0),
		["Accomplishments"] = CFrame.new(-26.5, -7.25, 281.874) * CFrame.Angles(0, 1.5707963267948966, 0),
		["Grasshop"] = CFrame.new(178.12, -15.25, 116.469) * CFrame.Angles(0, 3.141592653589793, 0),
		["GrasshopMilestones"] = CFrame.new(178.063, -9.75, 165.061) * CFrame.Angles(0, 3.141592653589793, 0),
		["Steelie"] = CFrame.new(177.969, -15.25, 212.404) * CFrame.Angles(0, -3.141592653589793, 0),
		["Funify"] = CFrame.new(-17181.486, -15.251, 117.22) * CFrame.Angles(0, 0, 0),
		["TheFactory"] = CFrame.new(164, 16.207, 408.375) * CFrame.Angles(0, 1.5707963267948966, 0),
		["TheFunnyMachine"] = CFrame.new(-17167.5, 16.207, 408.375) * CFrame.Angles(0, 1.5707963267948966, 0),
		["Foundry"] = CFrame.new(237.375, 18.457, 393.5) * CFrame.Angles(0, 2.181661564992912, 0),
		["Generator"] = CFrame.new(259.875, 18.457, 353.5) * CFrame.Angles(0, 3.141592653589793, 0),
		["Charger"] = CFrame.new(280.375, -13, 241.999) * CFrame.Angles(0, 2.705260340591211, 0),
		["Assembler"] = CFrame.new(289.875, -15.25, 163.999) * CFrame.Angles(0, -3.141592653589793, 0),
		["Decelerator"] = CFrame.new(298.697, -13, 87.671) * CFrame.Angles(0, 2.792526803190927, 0),
		["Refinery"] = CFrame.new(343.21, -13.002, -16.834) * CFrame.Angles(0, 2.6179938779914944, 0),
		["LaunchPad"] = CFrame.new(379.91, -13.002, -127.594) * CFrame.Angles(0, -2.8797932657906435, 0),
		["OilRig"] = CFrame.new(375.647, -12.891, -76.435) * CFrame.Angles(0, 2.792526803190927, 0),
		["StarAccumulator"] = CFrame.new(428.875, -14, -189.001) * CFrame.Angles(0, 3.141592653589793, 0),
		["Recelerator"] = CFrame.new(-17303.563, -12, 89.106) * CFrame.Angles(0, 0.3490658503988659, 0),
		["Fundry"] = CFrame.new(-17241.611, 18.457, 395.628) * CFrame.Angles(0, 0.9599310885968813, 0),
		["SFRGTGenerator"] = CFrame.new(-17263.875, 18.457, 355) * CFrame.Angles(0, 0, 0),
		["Platform2"] = CFrame.new(-17203, -3.194, 380) * CFrame.Angles(0, -1.5707963267948966, 0),
		["Section2"] = CFrame.new(-188, -56.25, 16.999) * CFrame.Angles(0, 0, 0),
		["Section3"] = CFrame.new(-177, -56.25, 283.499) * CFrame.Angles(0, 0, 0),
		["Section3a"] = CFrame.new(-47, 57.75, 326.999) * CFrame.Angles(0, 0, 0),
		["Section4"] = CFrame.new(227.5, -56.25, 28.499) * CFrame.Angles(0, 0, 0),
		["Platform"] = CFrame.new(199, -3.194, 380) * CFrame.Angles(0, 1.5707963267948966, 0),
		["Section5"] = CFrame.new(348.5, -56.25, 122.499) * CFrame.Angles(0, 0, 0),
		["IslandHubGateway"] = CFrame.new(184.25, 60.5, -145.251) * CFrame.Angles(0, 3.141592653589793, 0),
		["AnonymityShop"] = CFrame.new(-16780.375, -15.25, 167.499) * CFrame.Angles(0, 3.141592653589793, 0),
		["Liquefy"] = CFrame.new(-16795.262, -15.5, 243.617) * CFrame.Angles(0, 2.530727415391778, 0),
		["OilShop"] = CFrame.new(-16866, -15.25, 273.874) * CFrame.Angles(0, 1.6580627893946132, 0),
		["Grassskip"] = CFrame.new(-17181.49, -15.25, 213.22) * CFrame.Angles(0, 0, 0),
		["GrassskipMilestones"] = CFrame.new(-17181.486, -9.751, 164.716) * CFrame.Angles(0, 0, 0),
		["Rocket"] = CFrame.new(327.344, -10.254, -202.045) * CFrame.Angles(0, -1.7453292519943295, 0),
		["UnnaturalUpgradesShop"] = CFrame.new(-27409.391, 367.238, -48.501) * CFrame.Angles(0, -1.5707963267948966, 0),
		["Normality"] = CFrame.new(-27514.301, 380.863, -26.911) * CFrame.Angles(0, -0.7853981633974483, 0),
		["NormalityShop"] = CFrame.new(-27528.494, 380.863, 48.259) * CFrame.Angles(0, 0.08726646259971647, 0),
		["Vaporize"] = CFrame.new(-27507.328, 381.363, 126.638) * CFrame.Angles(0, 0.6981317007977318, 0),
		["CloudShop"] = CFrame.new(-27434.141, 381.363, 154.628) * CFrame.Angles(0, 1.5707963267948966, 0),
		["StarChart"] = CFrame.new(743.701, 4106.579, 418.012) * CFrame.Angles(0, 3.141592653589793, 0),
		["DarkMatterManipulator"] = CFrame.new(447.264, 4101.011, 134.311) * CFrame.Angles(0, -2.356194490192345, 0),
		["DarkMatterPlant"] = CFrame.new(488.914, 4100.987, 176.34) * CFrame.Angles(0, -2.356194490192345, 0),
		["StellarObelisk"] = CFrame.new(-148.718, 4102.144, -13.174) * CFrame.Angles(0, 0.08726646259971647, 0),
		["LunarObelisk"] = CFrame.new(-125.101, 4102.385, -54.819) * CFrame.Angles(0, -0.7853981633974483, 0),
		["VoidObelisk"] = CFrame.new(-82.539, 4102.144, -76.12) * CFrame.Angles(0, -1.7453292519943295, 0),
		["DarkCharger"] = CFrame.new(-718.524, 5067.25, 3481.791) * CFrame.Angles(0, 1.3089969389957472, 0),
		["EclipseUpgrades"] = CFrame.new(-1008.25, 4419.267, -1735.546) * CFrame.Angles(0, 1.4835298641951802, 0),
		["ConstellationSol"] = CFrame.new(-1007.952, 4430.354, -1669.91)
			* CFrame.Angles(0, -2.8797932657906435, 1.0471975511965976),
	},
	[2] = {
		["Frog"] = CFrame.new(32785.316, 16.75, -31.602) * CFrame.Angles(0, -2.792526803190927, 0),
		["AwakenMilestones"] = CFrame.new(32909.152, -10.5, 129.571) * CFrame.Angles(0, 1.0471975511965976, 0),
		["Construct"] = CFrame.new(33075.426, -16.497, 123) * CFrame.Angles(0, -3.141592653589793, 0),
		["AncientBridge"] = CFrame.new(33200.176, -39.247, 59.75) * CFrame.Angles(0, 0, 0),
		["Stability"] = CFrame.new(33309.613, -10.247, -27.579) * CFrame.Angles(0, -1.8325957145940461, 0),
		["InstabilityMods"] = CFrame.new(33445.426, -13.497, -6) * CFrame.Angles(0, 0, 0),
		["CavernKey"] = CFrame.new(33446.926, -19.512, 396.75) * CFrame.Angles(0, 0, -0.7853981633974483),
		["ToJungleRift"] = CFrame.new(34452.574, -319.582, 26239.801) * CFrame.Angles(0, 0, 0),
		["Rift"] = CFrame.new(33465.926, -19.997, 252.25) * CFrame.Angles(0, 1.5707963267948966, 0),
		["ToCaveRift"] = CFrame.new(34152.934, -276, 26406.25) * CFrame.Angles(0, 0, 0),
		["CaveRift"] = CFrame.new(34016.176, 117.003, 801.25) * CFrame.Angles(0, 3.141592653589793, 0),
		["ToUTRift"] = CFrame.new(35259.934, -104, 26167.748) * CFrame.Angles(0, 1.5707963267948966, 0),
		["ToFDRift"] = CFrame.new(33802.875, 3642.599, 6530.395) * CFrame.Angles(0, -1.5707963267948966, 0),
		["Linker"] = CFrame.new(34691.934, -334.75, 26458.25) * CFrame.Angles(0, -1.5707963267948966, 0),
		["TempleTele"] = CFrame.new(32999.426, 33.753, 393.75) * CFrame.Angles(0, 0, 0),
		["CollapseReminder"] = CFrame.new(34369.184, -339.5, 26567.625)
			* CFrame.Angles(0, 1.5707963267948966, -1.5707963267948966),
		["Discovery"] = CFrame.new(38178.82, -102.5, 15803.949) * CFrame.Angles(0, 0, 0),
		["Epiphany"] = CFrame.new(38298.945, -97.5, 15896.699) * CFrame.Angles(0, 3.141592653589793, 0),
		["Regeneration"] = CFrame.new(30622.307, 19.75, 373.25) * CFrame.Angles(0, 0, 0),
		["GauntletDesert"] = CFrame.new(34954.434, -7, -917.75) * CFrame.Angles(0, 3.141592653589793, 0),
		["DestabilizePath"] = CFrame.new(34369.184, -115, 27053.75) * CFrame.Angles(0, 0, 0),
		["Destabilize"] = CFrame.new(35117.934, -101, 26175.75) * CFrame.Angles(0, 0, 0),
		["Twilight"] = CFrame.new(33754.375, 3620.1, 7006.395) * CFrame.Angles(0, 0, 0),
		["TwilightShop"] = CFrame.new(33711.59, 3622.588, 7049.596) * CFrame.Angles(0, -1.5707963267948966, 0),
		["Midnight"] = CFrame.new(33951.375, 3644.1, 6720.395) * CFrame.Angles(0, 0, 0),
		["MidnightMile"] = CFrame.new(33951.375, 3651.6, 6672.395) * CFrame.Angles(0, 0, 0),
		["MidnightShop"] = CFrame.new(33951.375, 3651.6, 6602.395) * CFrame.Angles(0, 0, 0),
		["UpgradesSFS"] = CFrame.new(33908.16, 3634.524, 6487.834) * CFrame.Angles(0, -1.5707963267948966, 0),
		["UpgradesCactusS"] = CFrame.new(34008.656, 3634.524, 6487.834) * CFrame.Angles(0, -1.5707963267948966, 0),
		["TrialStuff"] = CFrame.new(34563.184, -505.25, -1490.5) * CFrame.Angles(0, 3.141592653589793, 0),
		["TrialChargeShop"] = CFrame.new(35107.461, -539.15, -1351.484) * CFrame.Angles(0, -2.0943951023931953, 0),
		["CGPortal"] = CFrame.new(34717.934, -509.5, -1437.75) * CFrame.Angles(0, 3.141592653589793, 0),
		["CactusT1"] = CFrame.new(35049.84, -539, -1529.107) * CFrame.Angles(0, 0.17453292519943295, 0),
		["CactusT2"] = CFrame.new(35008.637, -539, -1039.997) * CFrame.Angles(0, 2.9670597283903604, 0),
		["CactusT3"] = CFrame.new(35248.258, -539, -1449.279) * CFrame.Angles(0, -1.6580627893946132, 0),
		["RiftMile"] = CFrame.new(34545.934, 1044, 26200.75) * CFrame.Angles(0, 0, 0),
		["SpecUpgrades"] = CFrame.new(34545.934, 1041.003, 26076.758) * CFrame.Angles(0, -1.5707963267948966, 0),
		["UpgradesRift"] = CFrame.new(34489.184, 1041.25, 26018.875) * CFrame.Angles(0, -1.5707963267948966, 0),
		["RiftRune"] = CFrame.new(34545.934, 1041, 26276.75) * CFrame.Angles(0, -1.5707963267948966, 0),
		["RiftEssenceShop"] = CFrame.new(34353.57, 1045.25, 26090.789) * CFrame.Angles(0, -0.2617993877991494, 0),
		["GauntletRift"] = CFrame.new(34359.184, 1048.5, 26349.25) * CFrame.Angles(0, 1.5707963267948966, 0),
		["RiftGenerator"] = CFrame.new(34399.512, 1045.25, 26041.428) * CFrame.Angles(0, -1.0471975511965976, 0),
		["EndgameText"] = CFrame.new(34014.684, -675, 751.125) * CFrame.Angles(0, 0, 0),
		["ToPOD"] = CFrame.new(33992.805, -661, 425.935) * CFrame.Angles(0, 3.141592653589793, 0),
		["Scam2Shop"] = CFrame.new(48508.938, 67.8, -1035.502) * CFrame.Angles(0, -1.5707963267948966, 0),
		["ScamUndo"] = CFrame.new(48501.938, 64.3, -1099.002) * CFrame.Angles(0, 3.141592653589793, 0),
	},
}

function Hub.connect(signal, callback, pageScoped)
	local connection = signal:Connect(callback)
	table.insert(pageScoped and Hub.pageConnections or Hub.connections, connection)
	return connection
end

function Hub.spawn(callback)
	local thread
	thread = task.defer(function()
		local ok, message = pcall(callback)
		if thread then
			Hub.threads[thread] = nil
		end
		if not ok and Hub.alive then
			Ui.notify(message, true)
		end
	end)
	Hub.threads[thread] = true
	return thread
end

function Hub.module(name)
	if Hub.modules[name] then
		return Hub.modules[name]
	end
	local object = ReplicatedStorage:FindFirstChild(name)
	assert(object and object:IsA("ModuleScript"), "Módulo indisponível: " .. name)
	local result = require(object)
	assert(type(result) == "table", "Módulo inválido: " .. name)
	Hub.modules[name] = result
	return result
end

function Hub.remember(object, property, value)
	local properties = Hub.properties[object]
	if not properties then
		properties = {}
		Hub.properties[object] = properties
	end
	if properties[property] == nil then
		properties[property] = { value = object[property] }
	end
	object[property] = value
end

function Hub.patch(object, key, replacement)
	for _, patch in ipairs(Hub.patches) do
		if patch.object == object and patch.key == key then
			return
		end
	end
	local original = object[key]
	object[key] = replacement
	table.insert(Hub.patches, { object = object, key = key, original = original, replacement = replacement })
end

function Hub.restorePatches()
	for index = #Hub.patches, 1, -1 do
		local patch = Hub.patches[index]
		if patch.object[patch.key] == patch.replacement then
			patch.object[patch.key] = patch.original
		end
	end
	table.clear(Hub.patches)
end

function Hub.job(name, interval, callback)
	Hub.jobs[name] = { interval = interval, nextAt = 0, busy = false, callback = callback }
end

function Game.stats()
	return Hub.module("Data").ImportantData.Stats
end

function Game.event(payload)
	if not Hub.alive then
		return false
	end
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	local remote = remotes and remotes:FindFirstChild("GenericEvent")
	assert(remote and remote:IsA("RemoteEvent"), "GenericEvent indisponível")
	remote:FireServer(payload)
	return true
end

function Game.nativeVisibility(enabled)
	if enabled then
		local manager = Hub.module("TabManager")
		assert(type(manager.ShowHideTabs) == "function", "Gerenciador de visibilidade não encontrado")
		Hub.patch(manager, "ShowHideTabs", function() end)
		for _, worldName in ipairs({ "W1", "W2", "Solarians" }) do
			local world = playerGui:FindFirstChild(worldName)
			if world then
				for _, object in ipairs(world:GetDescendants()) do
					if
						object:IsA("GuiObject")
						and (object.Name == "Locked" or object.Name == "AutoLock" or object.Name == "FillerLock")
					then
						Hub.remember(object, "Visible", false)
					end
				end
			end
		end
		Hub.settings.unlock = true
	else
		Hub.settings.unlock = false
		Hub.restorePatches()
		for object, properties in pairs(Hub.properties) do
			if object.Parent then
				for property, state in pairs(properties) do
					if property ~= "WalkSpeed" then
						pcall(function()
							object[property] = state.value
						end)
						properties[property] = nil
					end
				end
			end
		end
		Game.restoreMachines()
		local manager = Hub.modules.TabManager
		if manager then
			pcall(manager.ShowHideTabs)
		end
	end
end

function Game.openMenu(menu)
	assert(menu and menu.Parent and menu:IsA("GuiObject"), "Menu ainda não carregado")
	Game.nativeVisibility(true)
	if Hub.nativeMenu and Hub.nativeMenu ~= menu and Hub.nativeMenu.Parent then
		Hub.nativeMenu.Visible = false
	end
	local current = menu
	while current and current ~= playerGui do
		if current:IsA("GuiObject") then
			Hub.remember(current, "Visible", true)
		end
		if current:IsA("ScreenGui") then
			Hub.remember(current, "Enabled", true)
		end
		current = current.Parent
	end
	Hub.nativeMenu = menu
	Ui.window.Visible = false
	Ui.context.Visible = true
	Ui.contextTitle.Text = Game.menuTitle(menu)
	Ui.notify("Menu aberto. Volte pelo botão Froggyz ou pressione K.")
end

function Game.menuTitle(menu)
	local name = menu.Name
	if name == "ShopContainer" or name == "PrestigeMenu" or name == "Upgrades" then
		name = menu.Parent.Name
	end
	return name:gsub("(%l)(%u)", "%1 %2")
end

function Game.menus(worldId)
	local world = playerGui:FindFirstChild("W" .. worldId)
	local result = {}
	if world then
		for _, feature in ipairs(world:GetChildren()) do
			local candidates = {}
			for _, child in ipairs(feature:GetChildren()) do
				if
					child:IsA("GuiObject")
					and (
						child.Name == "ShopContainer"
						or child.Name == "PrestigeMenu"
						or child.Name == "Upgrades"
						or child.Name == "Board"
						or child.Name == "Perks"
					)
				then
					table.insert(candidates, child)
				end
			end
			if #candidates == 0 and feature:IsA("GuiObject") and not feature:FindFirstChild("Locked") then
				if feature.Name == "TheStar" or feature.Name == "PlanetaryTrials" then
					table.insert(candidates, feature)
				end
			end
			for _, menu in ipairs(candidates) do
				table.insert(result, menu)
			end
		end
	end
	table.sort(result, function(a, b)
		return Game.menuTitle(a) < Game.menuTitle(b)
	end)
	return result
end

function Game.openFeature(worldName, featureName)
	local world = playerGui:FindFirstChild(worldName)
	local feature = world and world:FindFirstChild(featureName)
	assert(feature, "Interface ainda não carregada: " .. featureName)
	local menu = feature:FindFirstChild("ShopContainer")
		or feature:FindFirstChild("PrestigeMenu")
		or feature:FindFirstChild("Upgrades")
		or feature
	Game.openMenu(menu)
end

function Game.catalog()
	local upgrades = Hub.module("Upgrades").Basic
	assert(type(upgrades) == "table" and next(upgrades), "Aguarde o catálogo de upgrades carregar")
	return upgrades
end

function Game.buySelected()
	local id = Game.stats().upgradeSelected
	assert(id and id ~= "none", "Toque em um upgrade na loja do jogo primeiro")
	Game.event({ id = "buyUpgrade", mode = "max", upgradeId = id })
	Ui.notify("Compra máxima enviada para o upgrade selecionado.")
end

function Game.buyShop(menu)
	assert(not Hub.purchaseBusy, "Uma compra em grupo já está em andamento")
	assert(menu and menu.Parent, "Abra uma loja pelo hub primeiro")
	local ids = {}
	for id, upgrade in pairs(Game.catalog()) do
		local object = upgrade.object
		if typeof(object) == "Instance" and object:IsDescendantOf(menu) then
			table.insert(ids, id)
		end
	end
	if #ids == 0 then
		for _, object in ipairs(menu:GetDescendants()) do
			local identifier = object:FindFirstChild("Identifier")
			if identifier and identifier:IsA("StringValue") and Game.catalog()[identifier.Value] then
				ids[identifier.Value] = true
			end
		end
		local found = {}
		for id in pairs(ids) do
			if type(id) == "string" then
				table.insert(found, id)
			end
		end
		ids = found
	end
	assert(#ids > 0, "Esta interface não é uma loja de upgrades básicos. Use os botões nativos dela.")
	table.sort(ids)
	Hub.purchaseBusy = true
	local ok, message = pcall(function()
		for _, id in ipairs(ids) do
			if not Hub.alive then
				break
			end
			Game.event({ id = "buyUpgrade", mode = "max", upgradeId = id })
			task.wait(0.1)
		end
	end)
	Hub.purchaseBusy = false
	assert(ok, message)
	Ui.notify("Compra enviada para " .. #ids .. " upgrades da loja. Custos validados pelo jogo.")
end

function Game.bestTier(field)
	local identifier = field.defaultId
	if identifier == "tier" or identifier == "tier2" then
		identifier = Game.stats().currentTier
		local types = Hub.module("GrassTypes").Types
		local visited = {}
		while identifier and types[identifier] and not visited[identifier] do
			visited[identifier] = true
			local nextTier = types[identifier].nextTier
			if not nextTier or not types[nextTier] or types[nextTier].special then
				break
			end
			identifier = nextTier
		end
	end
	return identifier
end

function Game.collectAll()
	if not Hub.settings.collect or not Game.stats().slotLoaded then
		return
	end
	local fields = Hub.module("Fields").Fields
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	local remote = remotes and remotes:FindFirstChild("GenericFunction")
	assert(remote and remote:IsA("RemoteFunction"), "Coleta indisponível")
	local count = 0
	for id, field in pairs(fields) do
		local world = field.world or 1
		local cap = math.floor(math.min(5000, math.max(0, tonumber(field.max) or 0)))
		if (world == 1 or world == 2 or world == 0 or world == -1) and cap > 0 then
			count += 1
			if not Hub.fieldRequests[id] and (Hub.collectedFields[id] or 0) <= os.clock() then
				local identifier = Game.bestTier(field)
				if type(identifier) == "string" then
					Hub.fieldRequests[id] = true
					local requestedAt = os.clock()
					Hub.spawn(function()
						Hub.stats.requests += 1
						local ok, response = pcall(function()
							return remote:InvokeServer({
								id = "cut",
								field = id,
								identifier = identifier,
								quantity = cap,
							})
						end)
						Hub.fieldRequests[id] = nil
						Hub.collectedFields[id] = ok and response and (requestedAt + 0.2) or (os.clock() + 2)
						if ok and response then
							Hub.stats.accepted += 1
						else
							Hub.stats.rejected += 1
						end
					end)
				end
			end
		end
	end
	Hub.stats.fields = count
end

function Game.claimRewards()
	local stats = Game.stats()
	if not stats.slotLoaded then
		return
	end
	local daily = tonumber(stats.dailyTimeRemaining)
	local hourly = tonumber(stats.hourlyTimeRemaining)
	if not daily or daily <= 86400 then
		Game.event({ id = "dailyReward" })
		Hub.stats.rewards += 1
	end
	if not hourly or hourly <= 0 then
		Game.event({ id = "hourlyReward" })
		Hub.stats.rewards += 1
	end
end

function Game.restoreMachines()
	for model, pivot in pairs(Hub.machinePivots) do
		if model.Parent then
			pcall(function()
				model:PivotTo(pivot)
			end)
		end
	end
	table.clear(Hub.machinePivots)
	if Hub.gallery then
		Hub.gallery:Destroy()
		Hub.gallery = nil
	end
end

function Game.revealMachines(worldId)
	Game.nativeVisibility(true)
	local features = workspace:FindFirstChild("Features")
	assert(features, "Pasta Features indisponível")
	local field = Hub.module("Fields").Fields[worldId == 1 and "main" or "jungle"]
	assert(field and field.spawnArea, "Área do world indisponível")
	local area = field.spawnArea
	local center = Vector3.new((area.x.X + area.x.Y) / 2, area.y, (area.z.X + area.z.Y) / 2)
	if not Hub.gallery then
		Hub.gallery = Instance.new("Folder")
		Hub.gallery.Name = "FroggyzMachines"
		Hub.gallery.Parent = features.Parent
	end
	local candidates = {}
	local function isBarrier(name)
		name = name:lower()
		for _, token in ipairs({ "door", "gate", "closed", "blocker", "wall", "lock" }) do
			if name:find(token, 1, true) then
				return true
			end
		end
		return false
	end
	local function visit(folder)
		for _, child in ipairs(folder:GetChildren()) do
			if child:IsA("Model") then
				for _, object in ipairs(child:GetDescendants()) do
					if object:IsA("SurfaceGui") or object:IsA("BillboardGui") then
						Hub.remember(object, "Enabled", true)
					end
				end
				if child:GetPivot().Position.Y > 100000 and not isBarrier(child.Name) then
					table.insert(candidates, child)
				end
			elseif
				child:IsA("Folder")
				and (worldId == 2 or (child.Name ~= "W2" and child.Name ~= "Real" and child.Name ~= "Quantity"))
			then
				visit(child)
			end
		end
	end
	if worldId == 2 then
		local world = features:FindFirstChild("W2")
		assert(world, "Máquinas de World 2 indisponíveis")
		visit(world)
	else
		visit(features)
	end
	table.sort(candidates, function(a, b)
		return a.Name < b.Name
	end)
	local moved = 0
	local nativeCount = 0
	for _, model in ipairs(candidates) do
		local box, size = model:GetBoundingBox()
		local nativePivot = Game.machinePositions[worldId][model.Name]
		if nativePivot or size.Magnitude < 650 then
			local pivot = model:GetPivot()
			Hub.machinePivots[model] = Hub.machinePivots[model] or pivot
			local index = moved - nativeCount
			local base = center + Vector3.new((index % 6 - 2.5) * 150, 1, 180 + math.floor(index / 6) * 150)
			local offsetY = pivot.Position.Y - (box.Position.Y - size.Y / 2)
			if nativePivot then
				model:PivotTo(nativePivot)
				nativeCount += 1
			else
				model:PivotTo(CFrame.new(base + Vector3.new(0, offsetY, 0)))
				local floor = Instance.new("Part")
				floor.Name = model.Name
				floor.Anchored = true
				floor.Size = Vector3.new(math.max(48, size.X + 8), 2, math.max(48, size.Z + 8))
				floor.Color = Theme.panel
				floor.CFrame = CFrame.new(base - Vector3.new(0, 1, 0))
				floor.Parent = Hub.gallery
			end
			for _, object in ipairs(model:GetDescendants()) do
				if object:IsA("SurfaceGui") or object:IsA("BillboardGui") then
					Hub.remember(object, "Enabled", true)
				end
			end
			moved += 1
			if moved % 8 == 0 then
				task.wait()
			end
		end
	end
	Ui.notify(
		nativeCount .. " máquinas nas posições originais; " .. (moved - nativeCount) .. " na área ao lado do field."
	)
end

function Game.removeBarriers(worldId)
	Game.nativeVisibility(true)
	local features = workspace:FindFirstChild("Features")
	assert(features, "Pasta Features indisponível")
	local target = features
	if worldId == 2 then
		target = features:FindFirstChild("W2")
	end
	assert(target, "World indisponível")
	local secondWorld = features:FindFirstChild("W2")
	local realWorld = features:FindFirstChild("Real")
	local quantityWorld = features:FindFirstChild("Quantity")
	local count = 0
	for _, object in ipairs(target:GetDescendants()) do
		local excluded = worldId == 1
			and (
				(secondWorld and object:IsDescendantOf(secondWorld))
				or (realWorld and object:IsDescendantOf(realWorld))
				or (quantityWorld and object:IsDescendantOf(quantityWorld))
			)
		if object:IsA("Model") and not excluded then
			local name = object.Name:lower()
			if
				name:find("door", 1, true)
				or name:find("gate", 1, true)
				or name:find("closed", 1, true)
				or name:find("blocker", 1, true)
			then
				local pivot = object:GetPivot()
				if pivot.Position.Y < 100000 then
					Hub.machinePivots[object] = Hub.machinePivots[object] or pivot
					object:PivotTo(CFrame.new(0, 200000, 0))
					count += 1
				end
			end
		end
	end
	Ui.notify(count .. " barreiras locais removidas. O servidor ainda pode restringir acesso.")
end

function Game.winBattle()
	local galaxy = Hub.module("GalaxyGen")
	local combat = galaxy.CombatState
	if not combat.fighting or not combat.enemyObj then
		return false
	end
	combat.playerStats.tempLuck = Hub.settings.luck
	galaxy.EnemyDead()
	return true
end

function Game.collectBits()
	local stats = Game.stats()
	assert(stats.planetRun and stats.planetRun ~= "none", "Entre em um Planet Run primeiro")
	local run = Hub.module("PlanetRun")
	local count = 0
	Hub.bitClaims = Hub.bitClaims or setmetatable({}, { __mode = "k" })
	for object in pairs(run.BitsCreated or {}) do
		if typeof(object) == "Instance" and object.Parent and not Hub.bitClaims[object] then
			local hurtbox = object:FindFirstChild("Hurtbox")
			local position = hurtbox and hurtbox:GetAttribute("SpawnPos")
			if position then
				Game.event({ id = "collectBit", pos = position })
				Hub.bitClaims[object] = true
				count += 1
				task.wait(0.05)
			end
		end
	end
	return count
end

function Game.finishRun()
	local stats = Game.stats()
	assert(stats.planetRun and stats.planetRun ~= "none", "Entre em um Planet Run primeiro")
	local area = Hub.module("PlanetRun").Levels[stats.planetRun]
	local level = area and area.levels[tostring(stats.planetRunLevel)]
	assert(level, "Dados da fase indisponíveis")
	local timer = math.max(tonumber(stats.prTimerClient or stats.prTimer) or 0, tonumber(level.minTime) or 0)
	Game.event({ id = "stopPRTimer", timer = timer })
	Ui.notify("Conclusão solicitada com o tempo mínimo da fase; confira o resultado no jogo.")
end

function Game.capSolarians()
	local bars = Hub.module("Solarians").Bars
	local count = 0
	for id in pairs(bars) do
		if not Hub.alive then
			break
		end
		Game.event({ id = "capSol", barId = id })
		count += 1
		task.wait(0.1)
	end
	Ui.notify("Alocação máxima solicitada para " .. count .. " funções.")
end

function Game.exposeSolarians()
	Game.nativeVisibility(true)
	local solarians = Hub.module("Solarians")
	local count = 0
	for _, catalogName in ipairs({ "Bars", "CompressionBars", "SoulItems", "CompressionItems" }) do
		for _, entry in pairs(solarians[catalogName] or {}) do
			for _, key in ipairs({ "unlockCondition", "visibleCondition" }) do
				if type(entry[key]) == "function" then
					Hub.patch(entry, key, function()
						return true
					end)
					count += 1
				end
			end
		end
	end
	Ui.notify(count .. " condições locais suspensas. Abra Solarians para ver as funções.")
end

function Game.chartBuy(worldId)
	local chart = Hub.module("SingularityChart").Upgrades
	local queue = {}
	for id, upgrade in pairs(chart) do
		if (upgrade.world or 1) == worldId and (upgrade.level or 0) < (upgrade.levelCap or 1) then
			local available = true
			for _, prerequisite in ipairs(upgrade.prereqs or {}) do
				if not chart[prerequisite] or (chart[prerequisite].level or 0) < 1 then
					available = false
					break
				end
			end
			if available then
				table.insert(queue, id)
			end
		end
	end
	table.sort(queue)
	for _, id in ipairs(queue) do
		if not Hub.alive then
			break
		end
		Game.event({ id = "buySC", scId = id })
		task.wait(0.12)
	end
	Ui.notify("Compra solicitada para " .. #queue .. " nós com pré-requisitos locais atendidos.")
end

function Ui.create(className, properties, parent)
	local object = Instance.new(className)
	for key, value in pairs(properties or {}) do
		object[key] = value
	end
	object.Parent = parent
	return object
end

function Ui.round(object, radius)
	Ui.create("UICorner", { CornerRadius = UDim.new(0, radius or 12) }, object)
	return object
end

function Ui.stroke(object, color)
	return Ui.create("UIStroke", { Color = color or Theme.border, Transparency = 0.3, Thickness = 1 }, object)
end

function Ui.text(parent, text, size, color, bold)
	return Ui.create("TextLabel", {
		BackgroundTransparency = 1,
		Text = text,
		TextSize = size or 14,
		TextColor3 = color or Theme.text,
		Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextWrapped = true,
		Size = UDim2.new(1, 0, 0, 22),
	}, parent)
end

function Ui.notify(message, isError)
	if not Hub.alive or not Ui.status then
		return
	end
	Ui.status.Text = tostring(message):gsub("^.-:%d+: ", ""):sub(1, 220)
	Ui.status.TextColor3 = isError and Theme.danger or Theme.muted
end

function Ui.button(parent, text, callback, primary)
	local button = Ui.round(
		Ui.create("TextButton", {
			Name = text,
			Text = text,
			TextSize = 14,
			TextWrapped = true,
			Font = Enum.Font.GothamMedium,
			TextColor3 = primary and Theme.accentInk or Theme.text,
			BackgroundColor3 = primary and Theme.accent or Theme.border,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 44),
			AutoButtonColor = true,
		}, parent),
		9
	)
	local busy = false
	Hub.connect(button.Activated, function()
		if busy or not Hub.alive then
			return
		end
		busy = true
		Hub.spawn(function()
			local original = button.Text
			local ok, message = pcall(callback, button)
			busy = false
			if not ok then
				Ui.notify(message, true)
			end
			if button.Parent and button.Text == "Aguarde…" then
				button.Text = original
			end
		end)
	end, Ui.body and button:IsDescendantOf(Ui.body))
	return button
end

function Ui.column(parent, gap)
	Ui.create("UIListLayout", { Padding = UDim.new(0, gap or 10), SortOrder = Enum.SortOrder.LayoutOrder }, parent)
end

function Ui.card(parent, title, description, tag)
	Ui.order += 1
	local card = Ui.round(
		Ui.create("Frame", {
			Name = title,
			BackgroundColor3 = Theme.card,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -2, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = Ui.order,
		}, parent),
		13
	)
	Ui.stroke(card)
	Ui.create("UIPadding", {
		PaddingLeft = UDim.new(0, 16),
		PaddingRight = UDim.new(0, 16),
		PaddingTop = UDim.new(0, 14),
		PaddingBottom = UDim.new(0, 14),
	}, card)
	Ui.column(card, 10)
	if tag then
		Ui.text(card, tag, 11, Theme.accent, true).LayoutOrder = 1
	end
	local heading = Ui.text(card, title, 17, Theme.text, true)
	heading.LayoutOrder = 2
	heading.AutomaticSize = Enum.AutomaticSize.Y
	if description and #description > 0 then
		local subtitle = Ui.text(card, description, 13, Theme.muted)
		subtitle.Size = UDim2.new(1, 0, 0, 0)
		subtitle.AutomaticSize = Enum.AutomaticSize.Y
		subtitle.LayoutOrder = 3
	end
	local actions = Ui.create("Frame", {
		Name = "Actions",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 4,
	}, card)
	Ui.column(actions, 8)
	return actions, card
end

function Ui.toggle(parent, key, title)
	local function caption()
		return title .. "   ·   " .. (Hub.settings[key] and "Ligado" or "Desligado")
	end
	local button
	button = Ui.button(parent, caption(), function()
		Hub.settings[key] = not Hub.settings[key]
		button.Text = caption()
		button.BackgroundColor3 = Hub.settings[key] and Theme.accent or Theme.border
		button.TextColor3 = Hub.settings[key] and Theme.accentInk or Theme.text
	end, Hub.settings[key])
	return button
end

function Ui.input(parent, placeholder, initial)
	return Ui.round(
		Ui.create("TextBox", {
			BackgroundColor3 = Theme.background,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 44),
			Text = initial or "",
			PlaceholderText = placeholder,
			PlaceholderColor3 = Theme.muted,
			TextColor3 = Theme.text,
			TextSize = 14,
			Font = Enum.Font.Gotham,
			ClearTextOnFocus = false,
		}, parent),
		9
	)
end

function Ui.section(parent, text)
	Ui.order += 1
	local title = Ui.text(parent, text, 18, Theme.text, true)
	title.Size = UDim2.new(1, 0, 0, 34)
	title.AutomaticSize = Enum.AutomaticSize.Y
	title.LayoutOrder = Ui.order
end

function Ui.buildShell()
	Ui.root = Ui.create("ScreenGui", {
		Name = "FroggyzHub",
		ResetOnSpawn = false,
		DisplayOrder = 100,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = false,
	}, playerGui)
	Ui.canvas =
		Ui.create("Frame", { Name = "Canvas", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, Ui.root)
	Ui.window = Ui.round(
		Ui.create("Frame", {
			Name = "Window",
			BackgroundColor3 = Theme.background,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(720, 640),
			ClipsDescendants = true,
		}, Ui.canvas),
		17
	)
	Ui.stroke(Ui.window)
	Ui.header = Ui.create("Frame", {
		Name = "DragHeader",
		BackgroundColor3 = Theme.panel,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 72),
		Active = true,
	}, Ui.window)
	local mark = Ui.round(
		Ui.create(
			"Frame",
			{ BackgroundColor3 = Theme.accent, Position = UDim2.fromOffset(16, 16), Size = UDim2.fromOffset(38, 38) },
			Ui.header
		),
		12
	)
	local glyph = Ui.text(mark, "F", 24, Theme.accentInk, true)
	glyph.Size = UDim2.fromScale(1, 1)
	glyph.TextXAlignment = Enum.TextXAlignment.Center
	local title = Ui.text(Ui.header, "Froggyz Hub", 20, Theme.text, true)
	title.Position = UDim2.fromOffset(66, 13)
	title.Size = UDim2.new(1, -178, 0, 25)
	local subtitle = Ui.text(Ui.header, "World 1 + 2  ·  arraste aqui", 11, Theme.muted)
	subtitle.Position = UDim2.fromOffset(66, 39)
	subtitle.Size = UDim2.new(1, -170, 0, 18)
	local minimize = Ui.button(Ui.header, "−", function()
		Ui.window.Visible = false
	end)
	minimize.Size = UDim2.fromOffset(38, 38)
	minimize.Position = UDim2.new(1, -94, 0, 16)
	local close = Ui.button(Ui.header, "×", function()
		Ui.root:Destroy()
	end)
	close.Size = UDim2.fromOffset(38, 38)
	close.Position = UDim2.new(1, -50, 0, 16)
	Ui.nav = Ui.create("Frame", {
		Name = "Navigation",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(14, 82),
		Size = UDim2.new(1, -28, 0, 44),
	}, Ui.window)
	Ui.create("UIGridLayout", {
		CellSize = UDim2.new(1 / 3, -6, 1, 0),
		CellPadding = UDim2.fromOffset(8, 0),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, Ui.nav)
	for index, name in ipairs({ "Geral", "World 1", "World 2" }) do
		local button = Ui.button(Ui.nav, name, function()
			Ui.navigate(name)
		end)
		button.LayoutOrder = index
		Ui.navigation[name] = button
	end
	Ui.subnav = Ui.create("ScrollingFrame", {
		Name = "Sections",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(14, 138),
		Size = UDim2.new(1, -28, 0, 40),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ScrollBarThickness = 2,
	}, Ui.window)
	Ui.create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, Ui.subnav)
	Ui.body = Ui.create("ScrollingFrame", {
		Name = "Content",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(14, 190),
		Size = UDim2.new(1, -28, 1, -248),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Theme.accent,
		ScrollingDirection = Enum.ScrollingDirection.Y,
	}, Ui.window)
	Ui.column(Ui.body, 12)
	Ui.create("UIPadding", { PaddingRight = UDim.new(0, 7), PaddingBottom = UDim.new(0, 16) }, Ui.body)
	local footer = Ui.create("Frame", {
		BackgroundColor3 = Theme.panel,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, -48),
		Size = UDim2.new(1, 0, 0, 48),
	}, Ui.window)
	Ui.status = Ui.text(footer, "Pronto. Daily, hourly e anti-AFK já estão ativos.", 12, Theme.muted)
	Ui.status.Position = UDim2.fromOffset(14, 4)
	Ui.status.Size = UDim2.new(1, -28, 1, -8)
	Ui.status.TextTruncate = Enum.TextTruncate.AtEnd
	Ui.floating = Ui.button(Ui.canvas, "Froggyz  ·  K", function()
		Ui.window.Visible = not Ui.window.Visible
	end, true)
	Ui.floating.Size = UDim2.fromOffset(134, 44)
	Ui.floating.Position = UDim2.new(0, 12, 1, -56)
	Ui.context = Ui.round(
		Ui.create("Frame", {
			Name = "ShopActions",
			BackgroundColor3 = Theme.panel,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(240, 148),
			Position = UDim2.new(1, -252, 1, -220),
			Visible = false,
		}, Ui.canvas),
		14
	)
	Ui.stroke(Ui.context)
	Ui.create("UIPadding", {
		PaddingLeft = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 12),
		PaddingTop = UDim.new(0, 10),
		PaddingBottom = UDim.new(0, 10),
	}, Ui.context)
	Ui.column(Ui.context, 8)
	Ui.contextTitle = Ui.text(Ui.context, "Loja do jogo", 13, Theme.accent, true)
	Ui.button(Ui.context, "Máximo do selecionado", Game.buySelected)
	Ui.button(Ui.context, "Máximo desta loja", function()
		Game.buyShop(Hub.nativeMenu)
	end, true)
	Ui.resize()
	Hub.connect(Ui.canvas:GetPropertyChangedSignal("AbsoluteSize"), Ui.resize)
	Hub.connect(Ui.window:GetPropertyChangedSignal("Visible"), function()
		if Ui.window.Visible then
			Ui.context.Visible = false
		end
	end)
	Ui.enableDragging()
end

function Ui.resize(viewportOverride)
	if not Ui.window then
		return
	end
	local viewport = typeof(viewportOverride) == "Vector2" and viewportOverride or Ui.canvas.AbsoluteSize
	if viewport.X < 1 or viewport.Y < 1 then
		viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 650)
	end
	local width = math.min(760, math.max(260, viewport.X - 20))
	local height = math.min(700, math.max(240, viewport.Y - 28))
	Ui.window.Size = UDim2.fromOffset(width, height)
	if Hub.dragged then
		local position = Ui.window.Position
		Ui.window.Position = UDim2.fromOffset(
			math.clamp(position.X.Offset, width / 2, math.max(width / 2, viewport.X - width / 2)),
			math.clamp(position.Y.Offset, height / 2, math.max(height / 2, viewport.Y - height / 2))
		)
	end
end

function Ui.enableDragging()
	local drag
	Hub.connect(Ui.header.InputBegan, function(input)
		if
			input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end
		drag = {
			input = input,
			start = input.Position,
			origin = Ui.window.AbsolutePosition - Ui.canvas.AbsolutePosition + Ui.window.AbsoluteSize / 2,
		}
	end)
	Hub.connect(UserInputService.InputChanged, function(input)
		if not drag then
			return
		end
		if drag.input.UserInputType == Enum.UserInputType.Touch and input ~= drag.input then
			return
		end
		if
			input.UserInputType ~= Enum.UserInputType.MouseMovement
			and input.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end
		local delta = input.Position - drag.start
		local desired = drag.origin + Vector2.new(delta.X, delta.Y)
		local viewport, size = Ui.canvas.AbsoluteSize, Ui.window.AbsoluteSize
		Ui.window.Position = UDim2.fromOffset(
			math.clamp(desired.X, size.X / 2, math.max(size.X / 2, viewport.X - size.X / 2)),
			math.clamp(desired.Y, size.Y / 2, math.max(size.Y / 2, viewport.Y - size.Y / 2))
		)
		Hub.dragged = true
	end)
	Hub.connect(UserInputService.InputEnded, function(input)
		if drag and (input == drag.input or input.UserInputType == Enum.UserInputType.MouseButton1) then
			drag = nil
		end
	end)
	Hub.connect(UserInputService.InputBegan, function(input, processed)
		if input.KeyCode == Enum.KeyCode.K and not processed and not UserInputService:GetFocusedTextBox() then
			Ui.window.Visible = not Ui.window.Visible
		end
	end)
end

function Ui.clearContent()
	for _, connection in ipairs(Hub.pageConnections) do
		connection:Disconnect()
	end
	table.clear(Hub.pageConnections)
	for _, child in ipairs(Ui.body:GetChildren()) do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end
	Ui.body.CanvasPosition = Vector2.zero
	Ui.order = 0
	Ui.summary = nil
end

function Ui.navigate(page, section)
	Hub.page = page
	local sections = page == "Geral" and { "Início", "Compras", "Ajustes" }
		or page == "World 1" and { "Acesso", "Grasslands", "Solarians", "Planet Run", "Chart" }
		or { "Acesso", "Templo", "Gauntlet" }
	Hub.section = section or sections[1]
	for name, button in pairs(Ui.navigation) do
		button.BackgroundColor3 = name == page and Theme.accent or Theme.panel
		button.TextColor3 = name == page and Theme.accentInk or Theme.muted
	end
	for _, child in ipairs(Ui.subnav:GetChildren()) do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end
	for index, name in ipairs(sections) do
		local button = Ui.button(Ui.subnav, name, function()
			Ui.navigate(page, name)
		end)
		button.Size = UDim2.fromOffset((name == "Grasslands" or name == "Planet Run") and 116 or 104, 34)
		button.LayoutOrder = index
		button.BackgroundColor3 = name == Hub.section and Theme.card or Theme.background
		button.TextColor3 = name == Hub.section and Theme.accent or Theme.muted
	end
	Ui.clearContent()
	local key = page .. "/" .. Hub.section
	local renderer = Ui.renderers[key]
	if renderer then
		Hub.spawn(function()
			if Hub.alive and Hub.page .. "/" .. Hub.section == key then
				renderer(Ui.body)
			end
		end)
	end
end

function Ui.renderAccess(parent, worldId)
	Ui.section(parent, "Todos os sistemas, em um só lugar")
	local actions = Ui.card(
		parent,
		"Acesso às máquinas",
		"Mantém as máquinas visíveis. Usa posições originais mapeadas; as demais ficam ao lado do field. A mudança é local.",
		"WORLD " .. worldId
	)
	Ui.button(actions, "Exibir máquinas ocultas", function()
		Game.revealMachines(worldId)
	end, true)
	Ui.button(actions, "Remover portas e barreiras locais", function()
		Game.removeBarriers(worldId)
	end)
	Ui.button(actions, "Restaurar máquinas e regras do jogo", function()
		Game.nativeVisibility(false)
		Ui.notify("Máquinas e regras de visibilidade restauradas.")
	end)
	local searchActions = Ui.card(
		parent,
		"Abrir interfaces",
		"Pesquise pelo nome da máquina. Apenas um menu abre por vez e o hub sai da frente."
	)
	local search = Ui.input(searchActions, "Buscar máquina…")
	local results = Ui.create("Frame", {
		Name = "MenuResults",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
	}, searchActions)
	Ui.column(results, 8)
	local menus = Game.menus(worldId)
	local function populate()
		for _, child in ipairs(results:GetChildren()) do
			if child:IsA("GuiObject") then
				child:Destroy()
			end
		end
		local query = string.lower(search.Text)
		local count = 0
		for _, menu in ipairs(menus) do
			local title = Game.menuTitle(menu)
			if query == "" or string.find(string.lower(title), query, 1, true) then
				count += 1
				Ui.button(results, title .. "  →", function()
					Game.openMenu(menu)
				end)
			end
		end
		if count == 0 then
			Ui.text(results, "Nenhuma interface encontrada. Aguarde o save carregar.", 13, Theme.muted)
		end
	end
	Hub.connect(search:GetPropertyChangedSignal("Text"), populate, true)
	populate()
end

Ui.renderers["Geral/Início"] = function(parent)
	Ui.section(parent, "Seu painel de automação")
	local summary = Ui.card(
		parent,
		"Já cuidamos do básico",
		"Daily + hourly automáticos e anti-AFK ativo desde a abertura. Você só precisa ligar as automações que quiser usar.",
		"SEMPRE ATIVO"
	)
	Ui.summary = Ui.text(summary, "Carregando status…", 13, Theme.accent)
	Ui.summary.Size = UDim2.new(1, 0, 0, 38)
	local actions = Ui.card(
		parent,
		"Coletar em todos os fields",
		"Detecta os fields de World 1 e 2 com cap positivo, sem seleção manual. Usa o maior tier do catálogo e até 5.000 por pedido; rejeições recebem intervalo maior.",
		"COLETA MULTIFIELD"
	)
	Ui.toggle(actions, "collect", "Auto collect")
	Ui.text(actions, "Tier e quantidade são pedidos ao servidor. O retorno aparece no contador.", 12, Theme.muted).Size =
		UDim2.new(1, 0, 0, 36)
	local access = Ui.card(
		parent,
		"Menus que ficam abertos",
		"O bloqueio é feito na função que esconde as interfaces, sem um loop de visibilidade. Abra as lojas em World 1 ou World 2."
	)
	Ui.button(access, "Suspender fechamento por progresso", function()
		Game.nativeVisibility(true)
		Ui.notify("ShowHideTabs suspensa. Abra as lojas pelas abas de world.")
	end, true)
end

Ui.renderers["Geral/Compras"] = function(parent)
	Ui.section(parent, "Compras sem digitar IDs")
	local selected = Ui.card(
		parent,
		"O upgrade que você está vendo",
		"Abra uma loja e toque em um upgrade no jogo. O hub usa a seleção do próprio jogo para comprar o máximo.",
		"CONTEXTO DO JOGO"
	)
	Ui.button(selected, "Comprar máximo do selecionado", Game.buySelected, true)
	local shop = Ui.card(
		parent,
		"A loja inteira",
		"Abra uma loja pela aba do world. O painel flutuante permite comprar os upgrades dessa loja sem copiar nomes ou percorrer IDs."
	)
	Ui.button(shop, "Comprar máximo da última loja aberta", function()
		Game.buyShop(Hub.nativeMenu)
	end, true)
	Ui.button(shop, "Abrir lojas de World 1", function()
		Ui.navigate("World 1")
	end)
	Ui.button(shop, "Abrir lojas de World 2", function()
		Ui.navigate("World 2")
	end)
end

Ui.renderers["Geral/Ajustes"] = function(parent)
	Ui.section(parent, "Movimento e interface")
	local movement = Ui.card(
		parent,
		"Velocidade do personagem",
		"Aplica ao Humanoid local e restaura o valor anterior ao fechar o hub."
	)
	local speed = Ui.input(movement, "Velocidade entre 16 e 300", "48")
	Ui.button(movement, "Aplicar velocidade", function()
		local value = tonumber(speed.Text)
		assert(value and value == value and value >= 16 and value <= 300, "Velocidade: use 16 a 300")
		local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		assert(humanoid, "Personagem indisponível")
		Hub.remember(humanoid, "WalkSpeed", value)
		Ui.notify("Velocidade local: " .. value)
	end, true)
	local layout = Ui.card(
		parent,
		"Do seu jeito",
		"Arraste pelo cabeçalho com mouse ou toque. K mostra/oculta; no celular, use o botão Froggyz. A digitação nos campos não aciona atalhos."
	)
	Ui.button(layout, "Centralizar janela", function()
		Hub.dragged = false
		Ui.window.Position = UDim2.fromScale(0.5, 0.5)
	end)
	Ui.button(layout, "Restaurar visibilidade e máquinas", function()
		Game.nativeVisibility(false)
		Ui.notify("Regras nativas restauradas.")
	end)
end

Ui.renderers["World 1/Acesso"] = function(parent)
	Ui.renderAccess(parent, 1)
end
Ui.renderers["World 2/Acesso"] = function(parent)
	Ui.renderAccess(parent, 2)
end

Ui.renderers["World 1/Grasslands"] = function(parent)
	Ui.section(parent, "Grasslands")
	local battles = Ui.card(
		parent,
		"Batalhas rápidas",
		"Auto win chama a conclusão local EnemyDead quando existe uma batalha ativa. A recompensa ainda é solicitada ao servidor.",
		"COMBATE"
	)
	Ui.toggle(battles, "autoWin", "Auto win")
	Ui.button(battles, "Vencer batalha atual", function()
		assert(Game.winBattle(), "Nenhuma batalha ativa")
		Ui.notify("Conclusão local enviada.")
	end)
	Ui.button(battles, "Iniciar combate", function()
		Game.event({ id = "startFight" })
		Ui.notify("Início de combate solicitado.")
	end)
	Ui.button(battles, "Parar combate", function()
		Game.event({ id = "stopFight" })
		Ui.notify("Parada solicitada.")
	end)
	local luck = Ui.card(
		parent,
		"Sorte na recompensa",
		"tempLuck é aplicada antes de concluir a batalha. O servidor pode limitar ou recalcular esse valor."
	)
	local input = Ui.input(luck, "Luck de 0 a 1.000.000.000", tostring(Hub.settings.luck))
	Ui.button(luck, "Aplicar luck", function()
		local value = tonumber(input.Text)
		assert(value and value == value and value >= 0 and value <= 1000000000, "Luck: use 0 a 1.000.000.000")
		Hub.settings.luck = value
		Ui.notify("Luck para próximas conclusões: " .. value)
	end, true)
	Ui.button(luck, "Abrir inventário", function()
		Game.openFeature("W1", "Inventory")
	end)
end

Ui.renderers["World 1/Solarians"] = function(parent)
	Ui.section(parent, "Solarians")
	local actions = Ui.card(
		parent,
		"Alocação sem percorrer funções",
		"Solicita capSol para cada função do catálogo. O servidor calcula quanto pode ser alocado; nenhum saldo é inventado.",
		"ALOCAÇÃO"
	)
	Ui.button(actions, "Alocar máximo em todas as funções", Game.capSolarians, true)
	Ui.button(actions, "Mostrar funções bloqueadas localmente", Game.exposeSolarians)
	Ui.button(actions, "Recolher todas as unidades", function()
		Game.event({ id = "recallSol" })
		Ui.notify("Recall solicitado.")
	end)
	Ui.button(actions, "Abrir painel Solarians", function()
		Game.openFeature("Solarians", "Solarian")
	end)
	local access = Ui.card(
		parent,
		"Restoration, souls e singularity",
		"Acesso direto às interfaces do jogo, com as regras locais de ocultação suspensas."
	)
	Ui.button(access, "Abrir Restoration", function()
		Game.openFeature("Solarians", "Restoration")
	end)
	Ui.button(access, "Abrir Souls", function()
		Game.openFeature("Solarians", "Souls")
	end)
	Ui.button(access, "Abrir Singularity Chart", function()
		Game.openFeature("W1", "SingularityChart")
	end)
end

Ui.renderers["World 1/Planet Run"] = function(parent)
	Ui.section(parent, "Planet Run")
	local bits = Ui.card(
		parent,
		"Bits da fase atual",
		"Usa as posições SpawnPos já criadas pelo jogo. Cada objeto é enviado uma vez por execução do hub.",
		"COLETA"
	)
	Ui.toggle(bits, "autoBits", "Auto bits")
	Ui.button(bits, "Coletar bits agora", function()
		Ui.notify(Game.collectBits() .. " bits solicitados.")
	end)
	local finish = Ui.card(
		parent,
		"Conclusão da fase",
		"Envia stopPRTimer usando o mínimo definido no catálogo da fase. Aceitação, pré-requisitos e prêmio dependem do servidor."
	)
	Ui.button(finish, "Solicitar conclusão da fase atual", Game.finishRun, true)
	Ui.button(finish, "Sair de Planet Run", function()
		Game.event({ id = "quitPR" })
		Ui.notify("Saída solicitada.")
	end)
	local starts = Ui.card(
		parent,
		"Escolher fase",
		"Use o seletor do próprio jogo para entrar em uma fase; o hub cuida da coleta depois."
	)
	Ui.button(starts, "Abrir Planet Run", function()
		local world = playerGui:FindFirstChild("W1")
		local feature = world and (world:FindFirstChild("PlanetRun") or world:FindFirstChild("PR"))
		if feature then
			Game.openMenu(feature)
		else
			Game.openFeature("W1", "TheStar")
		end
	end)
	Ui.button(starts, "Abrir Planetary", function()
		Game.openFeature("W1", "Planetary")
	end)
	Ui.button(starts, "Abrir Planetoids", function()
		Game.openFeature("W1", "Planetoids")
	end)
end

Ui.renderers["World 1/Chart"] = function(parent)
	Ui.section(parent, "Singularity e progressão")
	local chart = Ui.card(
		parent,
		"Comprar nós disponíveis",
		"Descobre os IDs internamente e solicita uma compra por nó abaixo do cap com pré-requisitos locais atendidos. Custos e desbloqueios são validados pelo jogo."
	)
	Ui.button(chart, "Comprar nós disponíveis de World 1", function()
		Game.chartBuy(1)
	end, true)
	Ui.button(chart, "Abrir Singularity Chart", function()
		Game.openFeature("W1", "SingularityChart")
	end)
	local progression = Ui.card(
		parent,
		"Acesso à progressão",
		"Resets ficam manuais no menu do jogo, para você conferir custos e perdas antes de confirmar."
	)
	for _, name in ipairs({ "Planetary", "Supernova", "Constellation", "DarkMatter", "StarChart" }) do
		Ui.button(progression, "Abrir " .. name, function()
			Game.openFeature("W1", name)
		end)
	end
end

Ui.renderers["World 2/Templo"] = function(parent)
	Ui.section(parent, "Templo e progressão")
	local chart = Ui.card(
		parent,
		"Temple Chart",
		"Compra os nós de World 2 sem exigir IDs. Os pedidos respeitam os pré-requisitos conhecidos pelo cliente."
	)
	Ui.button(chart, "Comprar nós disponíveis do templo", function()
		Game.chartBuy(2)
	end, true)
	Ui.button(chart, "Abrir Temple Upgrades", function()
		Game.openFeature("W2", "TempleUpgrades")
	end)
	local progression = Ui.card(
		parent,
		"Máquinas de World 2",
		"Abra cada sistema diretamente, com a função de ocultação suspensa."
	)
	for _, name in ipairs({
		"OpalUpgrades",
		"BulbUpgrades",
		"TreeReset",
		"TempleReset",
		"Creation",
		"Regeneration",
		"RemnantUpgrades",
		"RiftGenerator",
	}) do
		Ui.button(progression, "Abrir " .. name, function()
			Game.openFeature("W2", name)
		end)
	end
end

Ui.renderers["World 2/Gauntlet"] = function(parent)
	Ui.section(parent, "Gauntlet")
	local room = Ui.card(
		parent,
		"Sala máxima disponível",
		"Usa os comandos encontrados na interface nativa. Não pressupõe que o servidor aceite salas ou áreas bloqueadas."
	)
	Ui.button(room, "Ir para a maior sala disponível", function()
		Game.event({ id = "gauntletRoomMax", increase = true })
		Ui.notify("Sala máxima solicitada.")
	end, true)
	Ui.button(room, "Voltar à menor sala", function()
		Game.event({ id = "gauntletRoomMax", increase = false })
		Ui.notify("Sala mínima solicitada.")
	end)
	Ui.button(room, "Abrir Gauntlet", function()
		Game.openFeature("W2", "Gauntlet")
	end)
	local areas = Ui.card(parent, "Áreas e artefatos", "Use o seletor nativo para trocar de área, sem copiar IDs.")
	Ui.button(areas, "Escolher área", function()
		Game.openFeature("W2", "GauntletAreas")
	end)
	Ui.button(areas, "Abrir artefatos", function()
		Game.openFeature("W2", "Artifacts")
	end)
end

function Hub.shutdown()
	if not Hub.alive then
		return
	end
	Hub.alive = false
	if Hub.idleHeld then
		pcall(function()
			VirtualUser:Button2Up(
				Vector2.zero,
				workspace.CurrentCamera and workspace.CurrentCamera.CFrame or CFrame.new()
			)
		end)
		Hub.idleHeld = false
	end
	for _, connection in ipairs(Hub.connections) do
		connection:Disconnect()
	end
	for _, connection in ipairs(Hub.pageConnections) do
		connection:Disconnect()
	end
	for thread in pairs(Hub.threads) do
		if thread ~= coroutine.running() then
			pcall(task.cancel, thread)
		end
	end
	Hub.restorePatches()
	Game.restoreMachines()
	for object, properties in pairs(Hub.properties) do
		if object.Parent then
			for property, state in pairs(properties) do
				pcall(function()
					object[property] = state.value
				end)
			end
		end
	end
	local manager = Hub.modules.TabManager
	if manager then
		task.defer(function()
			pcall(manager.ShowHideTabs)
		end)
	end
end

Ui.buildShell()
Hub.connect(Ui.root.Destroying, Hub.shutdown)
Hub.connect(player.Idled, function()
	Hub.spawn(function()
		local ok = pcall(function()
			VirtualUser:CaptureController()
			VirtualUser:Button2Down(
				Vector2.zero,
				workspace.CurrentCamera and workspace.CurrentCamera.CFrame or CFrame.new()
			)
			Hub.idleHeld = true
			task.wait(0.05)
			VirtualUser:Button2Up(
				Vector2.zero,
				workspace.CurrentCamera and workspace.CurrentCamera.CFrame or CFrame.new()
			)
			Hub.idleHeld = false
		end)
		if not ok then
			Ui.notify("Este ambiente bloqueou VirtualUser; anti-AFK não pôde enviar entrada.", true)
		end
	end)
end)

Hub.job("collection", 0.2, Game.collectAll)
Hub.job("rewards", 30, Game.claimRewards)
Hub.job("battles", 0.2, function()
	if Hub.settings.autoWin then
		Game.winBattle()
	end
end)
Hub.job("bits", 2, function()
	if Hub.settings.autoBits then
		Game.collectBits()
	end
end)
Hub.job("summary", 1, function()
	if Ui.summary and Ui.summary.Parent then
		Ui.summary.Text = Hub.stats.fields
			.. " fields  ·  "
			.. Hub.stats.accepted
			.. " retornos positivos  ·  "
			.. Hub.stats.rejected
			.. " recusas/erros"
	end
end)

Hub.connect(RunService.Heartbeat, function()
	if not Hub.alive then
		return
	end
	local now = os.clock()
	for _, job in pairs(Hub.jobs) do
		if not job.busy and now >= job.nextAt then
			job.busy = true
			job.nextAt = now + job.interval
			Hub.spawn(function()
				local ok, message = pcall(job.callback)
				job.busy = false
				if not ok then
					job.nextAt = os.clock() + math.max(5, job.interval)
					if job.lastError ~= tostring(message) then
						job.lastError = tostring(message)
						Ui.notify(message, true)
					end
				end
			end)
		end
	end
end)
Ui.navigate("Geral")
return { Hub = Hub, Game = Game, Ui = Ui }
