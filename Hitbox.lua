-- 💫 XenC Hitbox GUI | KRNL Compatible
-- GUI: Nền đen, viền trắng, nút bật xanh, nút tắt đỏ, có ô nhập hitbox

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "XenCHitboxGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.5, -125, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Frame.BorderColor3 = Color3.fromRGB(255,255,255)
Frame.Active = true
Frame.Draggable = true

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "XenC Hitbox GUI"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- Hitbox Value Input
local TextBox = Instance.new("TextBox", Frame)
TextBox.Size = UDim2.new(0.6,0,0,30)
TextBox.Position = UDim2.new(0.2,0,0.35,0)
TextBox.PlaceholderText = "Hitbox size"
TextBox.Text = ""
TextBox.ClearTextOnFocus = false
TextBox.TextColor3 = Color3.fromRGB(255,255,255)
TextBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
TextBox.BorderColor3 = Color3.fromRGB(255,255,255)
TextBox.Font = Enum.Font.SourceSans
TextBox.TextSize = 18

-- Buttons
local function createButton(name, color, posY)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(0.4,0,0,30)
    btn.Position = UDim2.new(0.05 + posY*0.5,0,0.65,0)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    return btn
end

local BtnOn = createButton("Bật", Color3.fromRGB(0,255,0), 0)
local BtnOff = createButton("Tắt", Color3.fromRGB(255,0,0), 1)

-- Hitbox logic
local Enabled = false
local HitboxSize = 5 -- default

local function updateHitbox()
    if not Enabled then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
            player.Character.HumanoidRootPart.Transparency = 0.5
        end
    end
end

RunService.RenderStepped:Connect(updateHitbox)

-- Buttons events
BtnOn.MouseButton1Click:Connect(function()
    local size = tonumber(TextBox.Text)
    if size then
        HitboxSize = size
    end
    Enabled = true
end)

BtnOff.MouseButton1Click:Connect(function()
    Enabled = false
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Size = Vector3.new(2,2,1)
            player.Character.HumanoidRootPart.Transparency = 0
        end
    end
end)
