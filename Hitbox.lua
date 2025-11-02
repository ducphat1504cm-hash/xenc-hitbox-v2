--// Glass Shield V1 by mod script vn🇻🇳
--// Mượt, không bay, chặn NPC & vật bỏ neo, UI kéo được, auto off khi chết

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local shieldEnabled = false
local char, root, hum
local heartConn

--== UI SETUP ==--
local gui = Instance.new("ScreenGui")
gui.Name = "GlassShieldUI"
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 180, 0, 45)
button.Position = UDim2.new(0.5, -90, 0.85, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 20
button.Text = "🧊 Bật kính bảo vệ"
button.ZIndex = 9999
button.Parent = gui

--== KÉO THẢ NÚT ==--
local dragging = false
local dragStart, startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	button.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

button.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = button.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateDrag(input)
	end
end)

--== KÍNH BẢO VỆ ==--
local function repelObjects()
	if not root then return end
	local region = Region3.new(root.Position - Vector3.new(6, 6, 6), root.Position + Vector3.new(6, 6, 6))
	local parts = workspace:FindPartsInRegion3(region, char, 50)
	for _, p in ipairs(parts) do
		if p and p:IsA("BasePart") and not p.Anchored then
			-- chỉ đẩy nếu là vật bỏ neo hoặc NPC
			local owner = Players:GetPlayerFromCharacter(p.Parent)
			if not owner then
				local dist = (p.Position - root.Position).Magnitude
				if dist < 6 then
					local dir = (p.Position - root.Position).Unit
					p.AssemblyLinearVelocity = dir * 40
				end
			end
		end
	end
end

--== BẬT / TẮT ==--
local function toggleShield()
	shieldEnabled = not shieldEnabled
	if shieldEnabled then
		button.Text = "❌ Tắt kính bảo vệ"
		heartConn = RunService.Heartbeat:Connect(repelObjects)
	else
		button.Text = "🧊 Bật kính bảo vệ"
		if heartConn then
			heartConn:Disconnect()
			heartConn = nil
		end
	end
end
button.MouseButton1Click:Connect(toggleShield)

--== AUTO OFF KHI CHẾT ==--
local function onCharacterAdded(c)
	char = c
	root = c:WaitForChild("HumanoidRootPart")
	hum = c:WaitForChild("Humanoid")
	hum.Died:Connect(function()
		if shieldEnabled then toggleShield() end
	end)
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end
--// Glass Shield V1 by mod script vn🇻🇳
--// Hộp kính 8x8x8, visual thật, UI kéo được, mượt, không lag, không bay

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local shieldEnabled = false
local shieldPart = nil
local repelConn
local char, root, hum

--== UI SETUP ==--
local gui = Instance.new("ScreenGui")
gui.Name = "GlassShieldUI"
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.85, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 20
button.Text = "🧊 Bật kính bảo vệ"
button.ZIndex = 9999
button.Parent = gui

--== Kéo thả UI ==--
local dragging = false
local dragStart, startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	button.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

button.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = button.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateDrag(input)
	end
end)

--== Tạo kính ==--
local function createShield()
	local part = Instance.new("Part")
	part.Name = "GlassShield"
	part.Size = Vector3.new(8,8,8)
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Transparency = 0.45
	part.Color = Color3.fromRGB(0,255,255)
	part.Material = Enum.Material.Glass
	part.Parent = workspace

	-- Viền ánh sáng mờ
	local selection = Instance.new("SelectionBox")
	selection.Adornee = part
	selection.LineThickness = 0.05
	selection.Color3 = Color3.fromRGB(0,255,255)
	selection.SurfaceColor3 = Color3.fromRGB(0,180,255)
	selection.SurfaceTransparency = 0.8
	selection.Parent = part

	return part
end

--== Repel vật bỏ neo / NPC ==--
local function repelObjects()
	if not shieldPart or not root then return end
	shieldPart.Position = root.Position

	local region = Region3.new(root.Position - Vector3.new(4,4,4), root.Position + Vector3.new(4,4,4))
	local parts = workspace:FindPartsInRegion3(region, char, 100)
	for _, p in ipairs(parts) do
		if p and p:IsA("BasePart") and not p.Anchored then
			local owner = Players:GetPlayerFromCharacter(p.Parent)
			if not owner then
				local dist = (p.Position - root.Position).Magnitude
				if dist < 4 then
					local dir = (p.Position - root.Position).Unit
					p.AssemblyLinearVelocity = dir * 70
				end
			end
		end
	end
end

--== Bật / Tắt ==--
local function toggleShield()
	shieldEnabled = not shieldEnabled
	if shieldEnabled then
		shieldPart = createShield()
		repelConn = RunService.Heartbeat:Connect(repelObjects)
		button.Text = "❌ Tắt kính bảo vệ"
	else
		if repelConn then repelConn:Disconnect() repelConn = nil end
		if shieldPart then shieldPart:Destroy() shieldPart = nil end
		button.Text = "🧊 Bật kính bảo vệ"
	end
end

button.MouseButton1Click:Connect(toggleShield)

--== Auto tắt khi chết ==--
local function onCharacterAdded(c)
	char = c
	root = c:WaitForChild("HumanoidRootPart")
	hum = c:WaitForChild("Humanoid")
	hum.Died:Connect(function()
		if shieldEnabled then toggleShield() end
	end)
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end
