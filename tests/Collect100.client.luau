local replicatedStorage = game:GetService("ReplicatedStorage")
local remote = replicatedStorage:WaitForChild("Remotes"):WaitForChild("GenericFunction")
local ok, result = pcall(function()
	return remote:InvokeServer({
		id = "cut",
		field = "main",
		identifier = "pw8",
		quantity = 100,
	})
end)
print("Froggyz Teste 100:", ok, result)
