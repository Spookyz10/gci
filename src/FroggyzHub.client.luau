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
	mapParts = {},
	mapModels = {},
	mapProperties = {},
	focusProperties = {},
	settings = { collect = false, mode = "pw8", autoWin = false, autoBits = false, luck = 1000, unlock = false },
	stats = { requests = 0, accepted = 0, rejected = 0, fields = 0, rewards = 0 },
	purchaseBusy = false,
	page = "Geral",
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

local Ui = { navigation = {}, order = 0, renderers = {} }
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

function Game.restoreScope(scope)
	local restored, failures = 0, {}
	for object, properties in pairs(scope) do
		if object.Parent then
			for property, state in pairs(properties) do
				local ok, message = pcall(function()
					object[property] = state.value
				end)
				if ok then
					properties[property] = nil
					restored += 1
				else
					table.insert(failures, tostring(message))
				end
			end
		else
			table.clear(properties)
		end
		if not next(properties) then
			scope[object] = nil
		end
	end
	return restored, failures
end

function Game.scopedProperty(scope, object, property, value)
	scope[object] = scope[object] or {}
	if scope[object][property] == nil then
		scope[object][property] = { value = object[property] }
	end
	object[property] = value
end

function Game.nativeVisibility(enabled)
	local manager = Hub.module("TabManager")
	if enabled then
		if not Hub.visibilityState then
			assert(type(manager.ShowHideTabs) == "function", "Controlador de mapa indisponível")
			local replacement = function() end
			Hub.visibilityState = { manager = manager, original = manager.ShowHideTabs, replacement = replacement }
			manager.ShowHideTabs = replacement
		end
		Hub.settings.unlock = true
		return
	end
	Game.restoreCamera()
	local restored, failures = Game.restoreMachines()
	local properties, propertyFailures = Game.restoreScope(Hub.mapProperties)
	for _, message in ipairs(propertyFailures) do
		table.insert(failures, message)
	end
	local state = Hub.visibilityState
	if state then
		if state.manager.ShowHideTabs == state.replacement then
			state.manager.ShowHideTabs = state.original
		end
		Hub.visibilityState = nil
	end
	Hub.settings.unlock = false
	local ok, message = pcall(manager.ShowHideTabs)
	if not ok then
		table.insert(failures, "Atualização nativa: " .. tostring(message))
	end
	if #failures > 0 then
		error("Restauração parcial: " .. #failures .. " falha(s). " .. failures[1])
	end
	Ui.notify("Mapa restaurado: " .. restored .. " peças e " .. properties .. " propriedades.")
	return restored + properties
end

function Game.restoreCamera()
	local state = Hub.cameraState
	if state then
		local camera = state.camera
		camera.CameraType = state.cameraType
		if state.subject and state.subject.Parent then
			camera.CameraSubject = state.subject
		end
		camera.CFrame = state.cframe
		camera.Focus = state.focus
		Hub.cameraState = nil
	end
	local _, failures = Game.restoreScope(Hub.focusProperties)
	assert(#failures == 0, "Não foi possível restaurar uma superfície")
	Hub.nativeSurface = nil
	if Ui.context then
		Ui.context.Visible = false
	end
end

function Game.focusSurface(surface)
	assert(surface and surface:IsA("SurfaceGui"), "Este sistema não possui SurfaceGui")
	local adornee = surface.Adornee
	assert(adornee and adornee:IsA("BasePart"), "A superfície ainda não está ligada à máquina")
	assert(adornee.Position.Y < 100000, "Máquina oculta. Use Mostrar máquinas neste world.")
	Game.restoreCamera()
	Game.nativeVisibility(true)
	local camera = workspace.CurrentCamera
	assert(camera, "Câmera indisponível")
	Hub.cameraState = {
		camera = camera,
		cameraType = camera.CameraType,
		subject = camera.CameraSubject,
		cframe = camera.CFrame,
		focus = camera.Focus,
	}
	for _, worldName in ipairs({ "W1", "W2", "Solarians" }) do
		local root = playerGui:FindFirstChild(worldName)
		if root then
			for _, other in ipairs(root:GetDescendants()) do
				if
					other:IsA("SurfaceGui")
					and other ~= surface
					and other.Adornee == adornee
					and other.Face == surface.Face
				then
					Game.scopedProperty(Hub.focusProperties, other, "Enabled", false)
				end
			end
		end
	end
	local ancestor = surface
	while ancestor and ancestor ~= playerGui do
		if ancestor:IsA("LayerCollector") then
			Game.scopedProperty(Hub.focusProperties, ancestor, "Enabled", true)
		end
		ancestor = ancestor.Parent
	end
	Game.scopedProperty(Hub.focusProperties, surface, "Active", true)
	local normal = adornee.CFrame:VectorToWorldSpace(Vector3.FromNormalId(surface.Face))
	local up = adornee.CFrame.UpVector
	if math.abs(normal:Dot(up)) > 0.95 then
		up = adornee.CFrame.LookVector
	end
	local distance = math.max(8, adornee.Size.Magnitude * 0.9)
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = CFrame.lookAt(adornee.Position + normal * distance, adornee.Position, up)
	Hub.nativeSurface = surface
	Ui.window.Visible = false
	Ui.context.Visible = true
	Ui.contextTitle.Text = surface.Name:gsub("(%l)(%u)", "%1 %2")
	Ui.notify("Câmera na máquina. Toque no upgrade normalmente.")
end

function Game.openFeature(worldName, featureName)
	local root = playerGui:FindFirstChild(worldName)
	local surface = root and root:FindFirstChild(featureName)
	assert(surface, "Superfície não carregada: " .. featureName)
	Game.focusSurface(surface)
end

function Game.selectedSurface()
	local id = Game.stats().upgradeSelected
	local entry = id and Game.catalog()[id]
	local object = entry and entry.object
	if typeof(object) == "Instance" then
		return object:FindFirstAncestorWhichIsA("SurfaceGui")
	end
	return nil
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

function Game.buyShop(surface)
	surface = Game.selectedSurface() or surface or Hub.nativeSurface
	assert(not Hub.purchaseBusy, "Uma compra já está em andamento")
	assert(surface and surface:IsA("SurfaceGui"), "Toque em um upgrade no mapa primeiro")
	local ids = {}
	for id, entry in pairs(Game.catalog()) do
		local object = entry.object
		if typeof(object) == "Instance" and object:FindFirstAncestorWhichIsA("SurfaceGui") == surface then
			table.insert(ids, id)
		end
	end
	assert(#ids > 0, "Nenhum upgrade básico nesta superfície")
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
	Ui.notify("Máximo solicitado para " .. #ids .. " upgrades de " .. surface.Name .. ".")
end

function Game.upgradeLevel(id)
	local levels = Hub.module("Data").ImportantData.UpgradeLevels
	local entry = levels and ((levels.generic and levels.generic[id]) or (levels.upgrades and levels.upgrades[id]))
	return entry and tonumber(entry.level) or 0
end

function Game.resetCount(id)
	local entry = Hub.module("InfoStore").Resets[id]
	return entry and math.max(tonumber(entry.a) or 0, tonumber(entry.b) or 0) or 0
end

function Game.fieldUnlocked(id, field)
	local stats = Game.stats()
	if not stats.slotLoaded then
		return false, "Carregando save"
	end
	if field.world ~= stats.world and field.world ~= -1 then
		return false, "Outro world"
	end
	if field.unlocked == false or field.locked == true or field.disabled == true then
		return false, "Bloqueado"
	end
	if (tonumber(field.max) or 0) <= 0 then
		return false, "Cap indisponível"
	end
	if field.unlocked == true or stats.inField == id then
		return true
	end
	if id == "main" or id == "jungle" then
		return true
	end
	if id == "anti" then
		return Game.upgradeLevel("decelerator") > 0, "Precisa de Decelerator"
	end
	if id == "un" then
		return Game.upgradeLevel("recelerator") > 0, "Precisa de Recelerator"
	end
	if id == "cavern" then
		return Game.upgradeLevel("bridge2") > 0 or Game.resetCount("trueAwaken") > 0, "Cavern bloqueada"
	end
	if id == "intersection" then
		return Game.upgradeLevel("bridge3") > 0 or Game.resetCount("rift") > 0, "Intersection bloqueada"
	end
	if id == "temple" then
		return Game.upgradeLevel("b5") > 0 or Game.resetCount("trueAwaken") > 0, "Temple bloqueado"
	end
	if id == "desert" then
		return (tonumber(stats.prog2) or 0) >= 1, "Desert bloqueado"
	end
	if id == "cactus" then
		return (tonumber(stats.prog2) or 0) >= 3
			or ((tonumber(stats.prog2a) or 0) >= 1 and Game.resetCount("midnight2") >= 6),
			"Cactus bloqueado"
	end
	if id == "rift" then
		return Game.resetCount("rift") > 0, "Rift bloqueado"
	end
	local teleIds = { planet = "field2", blue = "blue", understand = "un", temp = "temp" }
	local teleId = teleIds[id]
	if teleId then
		local entry = Hub.module("MapTeles").Teles[teleId]
		if entry and type(entry.visibleConditionC) == "function" then
			local ok, visible = pcall(entry.visibleConditionC)
			return ok and visible == true, "Área ainda não liberada"
		end
	end
	return false, "Liberação não confirmada"
end

function Game.unlockedFields()
	local result, blocked = {}, {}
	for id, field in pairs(Hub.module("Fields").Fields) do
		if field.world == Game.stats().world or field.world == -1 then
			local ok, unlocked, reason = pcall(Game.fieldUnlocked, id, field)
			if ok and unlocked then
				table.insert(result, { id = id, field = field })
			else
				table.insert(blocked, { id = id, reason = ok and reason or "Dados indisponíveis" })
			end
		end
	end
	table.sort(result, function(a, b)
		return a.id < b.id
	end)
	Hub.stats.fields = #result
	Hub.unlocked = result
	Hub.blocked = blocked
	return result
end

function Game.hasGrass(field)
	if (tonumber(field.counter) or 0) > 0 then
		return true
	end
	for object in pairs(field.objects or {}) do
		if typeof(object) == "Instance" and object.Parent and object:IsA("BasePart") and object.Transparency < 1 then
			return true
		end
	end
	return false
end

function Game.setFarmMode(mode)
	assert(mode == "pw8" or mode == "platinum" or mode == "moonstone", "Modo inválido")
	Hub.settings.mode = mode
	Hub.nextCollectionAt = 0
	if Hub.pendingRequest then
		Ui.notify("Modo alterado. Aguardando o pedido anterior terminar.")
	end
	if Ui.refresh then
		Ui.refresh()
	end
end

function Game.requestCut(fieldId, identifier, quantity)
	assert(not Hub.pendingRequest, "Aguarde o pedido anterior terminar")
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	local remote = remotes and remotes:FindFirstChild("GenericFunction")
	assert(remote and remote:IsA("RemoteFunction"), "GenericFunction indisponível")
	local request = { field = fieldId, identifier = identifier, quantity = quantity, sentAt = os.clock() }
	Hub.pendingRequest = request
	Hub.stats.requests += 1
	local ok, result = pcall(function()
		return remote:InvokeServer({ id = "cut", field = fieldId, identifier = identifier, quantity = quantity })
	end)
	Hub.pendingRequest = nil
	request.ok = ok
	request.result = result
	Hub.lastRequest = request
	if ok and result then
		Hub.stats.accepted += 1
	else
		Hub.stats.rejected += 1
	end
	Hub.nextCollectionAt = ok and (request.sentAt + (identifier == "pw8" and 0.2 or 0.08)) or (os.clock() + 1)
	return ok, result
end

function Game.collectAll()
	if not Hub.settings.collect or Hub.pendingRequest or os.clock() < (Hub.nextCollectionAt or 0) then
		return
	end
	local unlocked = Game.unlockedFields()
	if #unlocked == 0 then
		Hub.farmMessage = "Nenhum field liberado neste world"
		return
	end
	local mode = Hub.settings.mode
	local target
	if mode == "pw8" then
		Hub.fieldCursor = ((Hub.fieldCursor or 0) % #unlocked) + 1
		target = unlocked[Hub.fieldCursor]
	else
		if Game.stats().world ~= 1 then
			Hub.farmMessage = "Platinum e Moonstone usam World 1"
			return
		end
		for _, entry in ipairs(unlocked) do
			if entry.id == "anti" and Game.hasGrass(entry.field) then
				target = entry
				break
			end
		end
		if not target then
			for _, entry in ipairs(unlocked) do
				if entry.id == "main" then
					target = entry
					break
				end
			end
		end
	end
	if not target then
		Hub.farmMessage = "Nenhum field válido para este modo"
		return
	end
	local quantity = mode == "pw8" and math.floor(math.min(5000, target.field.max)) or 1
	if quantity < 1 then
		return
	end
	Hub.farmMessage = target.id .. " · " .. mode .. " × " .. quantity
	Game.requestCut(target.id, mode, quantity)
end

function Game.testCollect100()
	Hub.settings.collect = false
	assert(not Hub.pendingRequest, "Farm pausado. Aguarde o pedido em andamento e teste novamente.")
	Game.setFarmMode("pw8")
	local field = Hub.module("Fields").Fields.main
	assert(field and Game.fieldUnlocked("main", field), "Campo inicial indisponível neste world")
	local ok, result = Game.requestCut("main", "pw8", 100)
	Ui.notify("PW8 × 100 · main · retorno: " .. tostring(result), not ok or not result)
	print("Froggyz Teste 100:", ok, result)
	return ok, result
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

function Game.captureModel(model)
	local function capturePivot(object)
		if Hub.mapModels[object] == nil then
			Hub.mapModels[object] = object:GetPivot()
		end
	end
	capturePivot(model)
	for _, object in ipairs(model:GetDescendants()) do
		if object:IsA("Model") then
			capturePivot(object)
		end
		if object:IsA("BasePart") and Hub.mapParts[object] == nil then
			Hub.mapParts[object] = object.CFrame
		end
	end
end

function Game.restoreMachines()
	local restored, failures = 0, {}
	local models = {}
	for model in pairs(Hub.mapModels) do
		table.insert(models, model)
	end
	local function depth(object)
		local count = 0
		while object.Parent do
			object = object.Parent
			count += 1
		end
		return count
	end
	table.sort(models, function(a, b)
		return depth(a) < depth(b)
	end)
	for _, model in ipairs(models) do
		if model.Parent then
			local ok, message = pcall(function()
				model:PivotTo(Hub.mapModels[model])
			end)
			if not ok then
				table.insert(failures, tostring(message))
			end
		end
	end
	for part, cframe in pairs(Hub.mapParts) do
		if part.Parent then
			local ok, message = pcall(function()
				part.CFrame = cframe
			end)
			if ok then
				Hub.mapParts[part] = nil
				restored += 1
			else
				table.insert(failures, tostring(message))
			end
		else
			Hub.mapParts[part] = nil
		end
	end
	if #failures == 0 then
		table.clear(Hub.mapModels)
	end
	return restored, failures
end

function Game.worldModels(worldId)
	local features = workspace:FindFirstChild("Features")
	assert(features, "Features indisponível")
	local root = features
	if worldId == 2 then
		root = features:FindFirstChild("W2")
	end
	assert(root, "World indisponível")
	local result = {}
	local function visit(folder)
		for _, child in ipairs(folder:GetChildren()) do
			if child:IsA("Model") then
				table.insert(result, child)
			elseif
				child:IsA("Folder")
				and (worldId == 2 or (child.Name ~= "W2" and child.Name ~= "Real" and child.Name ~= "Quantity"))
			then
				visit(child)
			end
		end
	end
	visit(root)
	return result
end

function Game.revealMachines(worldId)
	Game.nativeVisibility(true)
	local moved, skipped = 0, 0
	for _, model in ipairs(Game.worldModels(worldId)) do
		if model:GetPivot().Position.Y > 100000 then
			local nativePivot = Game.machinePositions[worldId][model.Name]
			if nativePivot then
				Game.captureModel(model)
				model:PivotTo(nativePivot)
				moved += 1
			else
				skipped += 1
			end
		end
	end
	local root = playerGui:FindFirstChild("W" .. worldId)
	if root then
		if root:IsA("LayerCollector") then
			Game.scopedProperty(Hub.mapProperties, root, "Enabled", true)
		end
		for _, surface in ipairs(root:GetChildren()) do
			local adornee = surface:IsA("SurfaceGui") and surface.Adornee
			if adornee and adornee.Position.Y < 100000 then
				Game.scopedProperty(Hub.mapProperties, surface, "Enabled", true)
				for _, object in ipairs(surface:GetDescendants()) do
					if object:IsA("GuiObject") and object.Name == "Locked" then
						Game.scopedProperty(Hub.mapProperties, object, "Visible", false)
					end
				end
			end
		end
	end
	Ui.notify(moved .. " máquinas reveladas no mapa; " .. skipped .. " sem posição confirmada, mantidas intactas.")
	return moved, skipped
end

function Game.removeBarriers(worldId)
	Game.nativeVisibility(true)
	local count = 0
	for _, root in ipairs(Game.worldModels(worldId)) do
		local candidates = { root }
		for _, object in ipairs(root:GetDescendants()) do
			if object:IsA("Model") then
				table.insert(candidates, object)
			end
		end
		for _, model in ipairs(candidates) do
			local name = model.Name:lower()
			if
				name:find("door", 1, true)
				or name:find("gate", 1, true)
				or name:find("closed", 1, true)
				or name:find("blocker", 1, true)
			then
				if model:GetPivot().Position.Y < 100000 then
					Game.captureModel(model)
					model:PivotTo(CFrame.new(0, 200000, 0))
					count += 1
				end
			end
		end
	end
	Ui.notify(count .. " barreiras locais ocultadas.")
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
			TextSize = 15,
			Font = Enum.Font.Gotham,
			ClearTextOnFocus = false,
		}, parent),
		9
	)
end

function Ui.toggle(parent, key, label)
	local button
	local function update()
		local enabled = Hub.settings[key]
		button.Text = label .. (enabled and "   ·   Ligado" or "   ·   Desligado")
		button.BackgroundColor3 = enabled and Theme.accent or Theme.border
		button.TextColor3 = enabled and Theme.accentInk or Theme.text
	end
	button = Ui.button(parent, label, function()
		Hub.settings[key] = not Hub.settings[key]
		update()
	end)
	update()
	return button
end

function Ui.grid(parent, columns, height)
	local grid = Ui.create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, height or 44) }, parent)
	Ui.create("UIGridLayout", {
		CellSize = UDim2.new(1 / columns, -8, 0, 44),
		CellPadding = UDim2.fromOffset(8, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, grid)
	return grid
end

function Ui.buildShell()
	Ui.root = Ui.create(
		"ScreenGui",
		{ Name = "FroggyzHub", ResetOnSpawn = false, DisplayOrder = 100, ZIndexBehavior = Enum.ZIndexBehavior.Sibling },
		playerGui
	)
	Ui.canvas =
		Ui.create("Frame", { Name = "Canvas", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, Ui.root)
	Ui.window = Ui.round(
		Ui.create("Frame", {
			Name = "Window",
			BackgroundColor3 = Theme.background,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(620, 680),
			ClipsDescendants = true,
		}, Ui.canvas),
		16
	)
	Ui.stroke(Ui.window)
	Ui.header = Ui.create("Frame", {
		Name = "DragHeader",
		BackgroundColor3 = Theme.panel,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 64),
		Active = true,
	}, Ui.window)
	local mark = Ui.round(
		Ui.create(
			"Frame",
			{ BackgroundColor3 = Theme.accent, Size = UDim2.fromOffset(34, 34), Position = UDim2.fromOffset(16, 15) },
			Ui.header
		),
		10
	)
	local glyph = Ui.text(mark, "F", 22, Theme.accentInk, true)
	glyph.Size = UDim2.fromScale(1, 1)
	glyph.TextXAlignment = Enum.TextXAlignment.Center
	local title = Ui.text(Ui.header, "Froggyz Hub", 20, Theme.text, true)
	title.Position = UDim2.fromOffset(60, 10)
	title.Size = UDim2.new(1, -164, 0, 25)
	local caption = Ui.text(Ui.header, "v3  ·  arraste para mover", 12, Theme.muted)
	caption.Position = UDim2.fromOffset(60, 35)
	caption.Size = UDim2.new(1, -164, 0, 18)
	local minimize = Ui.button(Ui.header, "−", function()
		Ui.window.Visible = false
	end)
	minimize.Size = UDim2.fromOffset(34, 34)
	minimize.Position = UDim2.new(1, -88, 0, 15)
	local close = Ui.button(Ui.header, "×", function()
		Ui.root:Destroy()
	end)
	close.Size = UDim2.fromOffset(34, 34)
	close.Position = UDim2.new(1, -46, 0, 15)
	Ui.nav = Ui.grid(Ui.window, 3, 44)
	Ui.nav.Position = UDim2.fromOffset(14, 76)
	Ui.nav.Size = UDim2.new(1, -28, 0, 44)
	for index, name in ipairs({ "Geral", "World 1", "World 2" }) do
		local button = Ui.button(Ui.nav, name, function()
			Ui.navigate(name)
		end)
		button.LayoutOrder = index
		Ui.navigation[name] = button
	end
	Ui.body = Ui.create("ScrollingFrame", {
		Name = "Content",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(14, 132),
		Size = UDim2.new(1, -28, 1, -186),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Theme.accent,
		ScrollingDirection = Enum.ScrollingDirection.Y,
	}, Ui.window)
	Ui.column(Ui.body, 12)
	Ui.create("UIPadding", { PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 14) }, Ui.body)
	local footer = Ui.create("Frame", {
		BackgroundColor3 = Theme.panel,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, -42),
		Size = UDim2.new(1, 0, 0, 42),
	}, Ui.window)
	Ui.status = Ui.text(footer, "Pronto. Daily, hourly e anti-AFK automáticos.", 12, Theme.muted)
	Ui.status.Position = UDim2.fromOffset(14, 3)
	Ui.status.Size = UDim2.new(1, -28, 1, -6)
	Ui.status.TextTruncate = Enum.TextTruncate.AtEnd
	Ui.floating = Ui.button(Ui.canvas, "Froggyz  ·  K", function()
		Ui.window.Visible = not Ui.window.Visible
	end, true)
	Ui.floating.Size = UDim2.fromOffset(132, 44)
	Ui.floating.Position = UDim2.new(0, 12, 1, -56)
	Ui.context = Ui.round(
		Ui.create("Frame", {
			Name = "SurfaceActions",
			BackgroundColor3 = Theme.panel,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(232, 208),
			Position = UDim2.new(1, -244, 1, -280),
			Visible = false,
		}, Ui.canvas),
		12
	)
	Ui.stroke(Ui.context)
	Ui.create("UIPadding", {
		PaddingLeft = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 12),
		PaddingTop = UDim.new(0, 12),
		PaddingBottom = UDim.new(0, 12),
	}, Ui.context)
	Ui.column(Ui.context, 8)
	Ui.contextTitle = Ui.text(Ui.context, "Superfície no mapa", 14, Theme.accent, true)
	Ui.button(Ui.context, "Máximo do selecionado", Game.buySelected)
	Ui.button(Ui.context, "Máximo desta superfície", function()
		Game.buyShop(Hub.nativeSurface)
	end)
	Ui.button(Ui.context, "Voltar à câmera anterior", Game.restoreCamera, true)
	Ui.resize()
	Hub.connect(Ui.canvas:GetPropertyChangedSignal("AbsoluteSize"), Ui.resize)
	Ui.enableDragging()
end

function Ui.resize(viewportOverride)
	if not Ui.window then
		return
	end
	local viewport = typeof(viewportOverride) == "Vector2" and viewportOverride or Ui.canvas.AbsoluteSize
	if viewport.X < 1 or viewport.Y < 1 then
		viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 700)
	end
	local width = math.min(640, math.max(260, viewport.X - 20))
	local height = math.min(720, math.max(250, viewport.Y - 24))
	Ui.window.Size = UDim2.fromOffset(width, height)
	if Hub.dragged then
		local position = Ui.window.Position
		Ui.window.Position = UDim2.fromOffset(
			math.clamp(position.X.Offset, width / 2, math.max(width / 2, viewport.X - width / 2)),
			math.clamp(position.Y.Offset, height / 2, math.max(height / 2, viewport.Y - height / 2))
		)
	end
end

function Ui.beginDrag(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end
	Hub.drag = {
		input = input,
		start = input.Position,
		origin = Ui.window.AbsolutePosition - Ui.canvas.AbsolutePosition + Ui.window.AbsoluteSize / 2,
	}
end

function Ui.moveDrag(input)
	local drag = Hub.drag
	if not drag then
		return
	end
	if drag.input.UserInputType == Enum.UserInputType.Touch and input ~= drag.input then
		return
	end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
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
end

function Ui.enableDragging()
	Hub.connect(Ui.header.InputBegan, Ui.beginDrag)
	Hub.connect(UserInputService.InputChanged, Ui.moveDrag)
	Hub.connect(UserInputService.InputEnded, function(input)
		if Hub.drag and (input == Hub.drag.input or input.UserInputType == Enum.UserInputType.MouseButton1) then
			Hub.drag = nil
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
	Ui.farmStatus = nil
	Ui.farmButton = nil
	Ui.modeButtons = {}
	Ui.requestStats = nil
end

function Ui.navigate(page)
	Hub.page = page
	for name, button in pairs(Ui.navigation) do
		button.BackgroundColor3 = name == page and Theme.accent or Theme.panel
		button.TextColor3 = name == page and Theme.accentInk or Theme.muted
	end
	Ui.clearContent()
	local renderer = Ui.renderers[page]
	if renderer then
		renderer(Ui.body)
	end
	Ui.refresh()
end

function Ui.refresh()
	if Ui.modeButtons then
		for mode, button in pairs(Ui.modeButtons) do
			if button.Parent then
				local selected = mode == Hub.settings.mode
				button.BackgroundColor3 = selected and Theme.accent or Theme.border
				button.TextColor3 = selected and Theme.accentInk or Theme.text
			end
		end
	end
	if Ui.farmButton and Ui.farmButton.Parent then
		Ui.farmButton.Text = Hub.settings.collect and "Parar farm" or "Iniciar farm"
		Ui.farmButton.BackgroundColor3 = Hub.settings.collect and Theme.border or Theme.accent
		Ui.farmButton.TextColor3 = Hub.settings.collect and Theme.text or Theme.accentInk
	end
	if Ui.farmStatus and Ui.farmStatus.Parent then
		local mode = Hub.settings.mode == "pw8" and "PW8"
			or Hub.settings.mode == "platinum" and "Platinum"
			or "Moonstone"
		local pending = Hub.pendingRequest
		local state = not Hub.settings.collect and "Parado" or pending and "Aguardando retorno" or "Ativo"
		Ui.farmStatus.Text = state
			.. " · "
			.. mode
			.. "\n"
			.. (Hub.farmMessage or "Somente fields liberados no world atual")
	end
	if Ui.requestStats and Ui.requestStats.Parent then
		Ui.requestStats.Text = Hub.stats.requests
			.. " enviados  ·  "
			.. Hub.stats.accepted
			.. " positivos  ·  "
			.. Hub.stats.rejected
			.. " recusas/erros"
	end
end

function Ui.surfaceShortcuts(parent, worldName, entries)
	local grid = Ui.grid(parent, 2, math.ceil(#entries / 2) * 52 - 8)
	for index, entry in ipairs(entries) do
		local button = Ui.button(grid, entry[1], function()
			Game.openFeature(worldName, entry[2])
		end)
		button.LayoutOrder = index
	end
end

function Ui.mapActions(parent, worldId)
	local actions =
		Ui.card(parent, "Máquinas no mapa", "Mostrar usa apenas posições confirmadas. Nenhuma loja vira uma janela.")
	Ui.button(actions, "Mostrar máquinas de World " .. worldId, function()
		Game.revealMachines(worldId)
	end)
	Ui.button(actions, "Restaurar mapa", function()
		Game.nativeVisibility(false)
	end, true)
end

Ui.renderers.Geral = function(parent)
	local farm = Ui.card(parent, "Farm", "Escolha um modo. Platinum e Moonstone enviam sempre 1.")
	local modes = Ui.grid(farm, 3, 44)
	Ui.modeButtons = {}
	for index, entry in ipairs({ { "pw8", "PW8" }, { "platinum", "Platinum" }, { "moonstone", "Moonstone" } }) do
		local button = Ui.button(modes, entry[2], function()
			Game.setFarmMode(entry[1])
		end)
		button.LayoutOrder = index
		Ui.modeButtons[entry[1]] = button
	end
	Ui.farmButton = Ui.button(farm, "Iniciar farm", function()
		Hub.settings.collect = not Hub.settings.collect
		Hub.nextCollectionAt = 0
		Ui.refresh()
	end, true)
	Ui.farmStatus = Ui.text(farm, "", 14, Theme.muted)
	Ui.farmStatus.Size = UDim2.new(1, 0, 0, 44)
	Ui.requestStats = Ui.text(farm, "", 12, Theme.accent)
	Ui.requestStats.Size = UDim2.new(1, 0, 0, 32)
	Ui.button(farm, "Teste único: PW8 × 100 em main", Game.testCollect100)
	local purchases = Ui.card(
		parent,
		"Upgrade selecionado",
		"Toque em um upgrade na SurfaceGui do jogo. Os botões usam essa seleção."
	)
	Ui.button(purchases, "Comprar máximo do selecionado", Game.buySelected)
	Ui.button(purchases, "Comprar máximo dessa superfície", function()
		Game.buyShop()
	end)
	local map = Ui.card(parent, "Restaurar", "Desfaz peças, superfícies e regras locais alteradas pelo hub.")
	Ui.button(map, "Restaurar mapa e câmera", function()
		Game.nativeVisibility(false)
	end)
	local movement = Ui.card(parent, "Velocidade")
	local speed = Ui.input(movement, "Velocidade", "48")
	Ui.button(movement, "Aplicar", function()
		local value = tonumber(speed.Text)
		assert(value and value == value and value >= 16 and value <= 300, "Use uma velocidade de 16 a 300")
		local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		assert(humanoid, "Personagem indisponível")
		Hub.remember(humanoid, "WalkSpeed", value)
		Ui.notify("Velocidade: " .. value)
	end)
	Ui.text(movement, "Daily + hourly + anti-AFK automáticos.", 12, Theme.accent).Size = UDim2.new(1, 0, 0, 32)
end

Ui.renderers["World 1"] = function(parent)
	Ui.mapActions(parent, 1)
	local surfaces =
		Ui.card(parent, "Ver uma máquina", "Move a câmera até a superfície. Você continua usando a loja do mapa.")
	Ui.surfaceShortcuts(surfaces, "W1", {
		{ "Upgrades", "Upgrades" },
		{ "Prestige", "PrestigeUpgrades" },
		{ "Factory", "FactoryUpgrades" },
		{ "Planetary", "Planetary" },
		{ "Planetoids", "Planetoids" },
		{ "Singularity", "SingularityChart" },
	})
	local combat = Ui.card(parent, "Grasslands")
	Ui.toggle(combat, "autoWin", "Auto win")
	local luck = Ui.input(combat, "tempLuck", tostring(Hub.settings.luck))
	Ui.button(combat, "Aplicar luck", function()
		local value = tonumber(luck.Text)
		assert(value and value == value and value >= 0 and value <= 1000000000, "Luck inválida")
		Hub.settings.luck = value
		Ui.notify("tempLuck: " .. value)
	end)
	Ui.button(combat, "Vencer batalha atual", function()
		assert(Game.winBattle(), "Nenhuma batalha ativa")
		Ui.notify("Conclusão solicitada.")
	end)
	local solarians = Ui.card(parent, "Solarians")
	Ui.button(solarians, "Alocar até o cap nas funções", Game.capSolarians)
	Ui.button(solarians, "Recolher unidades", function()
		Game.event({ id = "recallSol" })
		Ui.notify("Recall solicitado.")
	end)
	Ui.surfaceShortcuts(solarians, "Solarians", { { "Solarian", "Solarian" }, { "Restoration", "Restoration" } })
	local run = Ui.card(parent, "Planet Run")
	Ui.toggle(run, "autoBits", "Auto bits")
	Ui.button(run, "Coletar bits da fase", function()
		Ui.notify(Game.collectBits() .. " bits solicitados.")
	end)
	Ui.button(run, "Solicitar conclusão da fase", Game.finishRun)
	local chart = Ui.card(parent, "Chart")
	Ui.button(chart, "Comprar nós disponíveis de World 1", function()
		Game.chartBuy(1)
	end)
end

Ui.renderers["World 2"] = function(parent)
	Ui.mapActions(parent, 2)
	local surfaces = Ui.card(parent, "Ver uma máquina", "Foca a SurfaceGui no mapa; não abre todas as interfaces.")
	Ui.surfaceShortcuts(surfaces, "W2", {
		{ "Upgrades", "Upgrades" },
		{ "Opal", "OpalUpgrades" },
		{ "Bulb", "BulbUpgrades" },
		{ "Temple", "TempleUpgrades" },
		{ "Gauntlet", "Gauntlet" },
		{ "Artefatos", "Artifacts" },
	})
	local chart = Ui.card(parent, "Temple Chart")
	Ui.button(chart, "Comprar nós disponíveis", function()
		Game.chartBuy(2)
	end)
	local gauntlet = Ui.card(parent, "Gauntlet")
	Ui.button(gauntlet, "Maior sala disponível", function()
		Game.event({ id = "gauntletRoomMax", increase = true })
		Ui.notify("Sala máxima solicitada.")
	end)
	Ui.button(gauntlet, "Menor sala disponível", function()
		Game.event({ id = "gauntletRoomMax", increase = false })
		Ui.notify("Sala mínima solicitada.")
	end)
end

function Hub.shutdown()
	if not Hub.alive then
		return
	end
	Hub.alive = false
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
	if Hub.idleHeld then
		pcall(function()
			VirtualUser:Button2Up(
				Vector2.zero,
				workspace.CurrentCamera and workspace.CurrentCamera.CFrame or CFrame.new()
			)
		end)
		Hub.idleHeld = false
	end
	local failures = {}
	local cameraOk, cameraError = pcall(Game.restoreCamera)
	if not cameraOk then
		table.insert(failures, tostring(cameraError))
	end
	local _, mapErrors = Game.restoreMachines()
	for _, message in ipairs(mapErrors) do
		table.insert(failures, message)
	end
	local _, propertyErrors = Game.restoreScope(Hub.mapProperties)
	for _, message in ipairs(propertyErrors) do
		table.insert(failures, message)
	end
	Hub.restorePatches()
	local _, generalErrors = Game.restoreScope(Hub.properties)
	for _, message in ipairs(generalErrors) do
		table.insert(failures, message)
	end
	local state = Hub.visibilityState
	if state then
		if state.manager.ShowHideTabs == state.replacement then
			state.manager.ShowHideTabs = state.original
		end
		Hub.visibilityState = nil
		local ok, message = pcall(state.manager.ShowHideTabs)
		if not ok then
			table.insert(failures, tostring(message))
		end
	end
	if #failures > 0 then
		warn("Froggyz: restauração incompleta: " .. table.concat(failures, " | "))
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

Hub.job("collection", 0.05, Game.collectAll)
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
Hub.job("summary", 0.25, Ui.refresh)

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
