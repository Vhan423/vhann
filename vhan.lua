
--// VHAN | VN Executor UI
--// UI test for supported Roblox Lua environments
--// Auto-steal/game actions are not implemented.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
if not player then
    warn("[VHAN] LocalPlayer unavailable.")
    return
end

-- Remove previous copy
pcall(function()
    local old = CoreGui:FindFirstChild("VHAN_UI")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "VHAN_UI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ok = pcall(function()
    gui.Parent = CoreGui
end)

if not ok or not gui.Parent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

local GOLD = Color3.fromRGB(255, 199, 55)
local DARK = Color3.fromRGB(14, 19, 32)
local CARD = Color3.fromRGB(26, 35, 55)
local WHITE = Color3.fromRGB(245, 245, 245)
local MUTED = Color3.fromRGB(160, 175, 200)

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function stroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Parent = obj
end

-- Floating VN logo
local logo = Instance.new("TextButton")
logo.Name = "VN"
logo.Size = UDim2.fromOffset(58, 58)
logo.Position = UDim2.new(0, 20, 0.42, 0)
logo.BackgroundColor3 = DARK
logo.Text = "VN"
logo.TextColor3 = GOLD
logo.TextSize = 23
logo.Font = Enum.Font.GothamBlack
logo.AutoButtonColor = true
logo.Parent = gui
corner(logo, 100)
stroke(logo, GOLD, 2)

-- Main panel
local panel = Instance.new("Frame")
panel.Name = "VHAN_Panel"
panel.Size = UDim2.fromOffset(290, 330)
panel.Position = UDim2.new(0, 88, 0.35, 0)
panel.BackgroundColor3 = DARK
panel.Visible = false
panel.Parent = gui
corner(panel, 14)
stroke(panel, GOLD, 1.5)

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -20, 0, 34)
header.Position = UDim2.fromOffset(10, 8)
header.BackgroundTransparency = 1
header.Text = "VHAN  |  ONE PIECE"
header.TextColor3 = GOLD
header.Font = Enum.Font.GothamBlack
header.TextSize = 17
header.Parent = panel

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, -20, 0, 22)
sub.Position = UDim2.fromOffset(10, 40)
sub.BackgroundTransparency = 1
sub.Text = "VN SYSTEM  •  UI TEST"
sub.TextColor3 = MUTED
sub.Font = Enum.Font.Gotham
sub.TextSize = 11
sub.Parent = panel

local function newButton(label, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -24, 0, 43)
    b.Position = UDim2.fromOffset(12, y)
    b.BackgroundColor3 = CARD
    b.TextColor3 = WHITE
    b.Text = label .. "  [OFF]"
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Parent = panel
    corner(b, 9)
    return b
end

local target = newButton("AUTO TARGET EGG", 76)
local take = newButton("AUTO TAKE", 128)
local base = newButton("RETURN TO BASE", 180)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 48)
status.Position = UDim2.fromOffset(10, 237)
status.BackgroundColor3 = CARD
status.TextColor3 = GOLD
status.Text = "Status: UI ready\nGame actions not connected"
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.TextWrapped = true
status.Parent = panel
corner(status, 8)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(28, 28)
close.Position = UDim2.new(1, -35, 0, 8)
close.BackgroundColor3 = CARD
close.Text = "×"
close.TextColor3 = WHITE
close.TextSize = 22
close.Font = Enum.Font.GothamBold
close.Parent = panel
corner(close, 8)

logo.Activated:Connect(function()
    panel.Visible = not panel.Visible
end)

close.Activated:Connect(function()
    panel.Visible = false
end)

local flags = {}

local function bindToggle(button, key, label)
    flags[key] = false
    button.Activated:Connect(function()
        flags[key] = not flags[key]
        button.Text = label .. (flags[key] and "  [ON]" or "  [OFF]")
        button.BackgroundColor3 =
            flags[key] and Color3.fromRGB(70, 55, 20) or CARD

        status.Text = label .. (flags[key] and " enabled" or " disabled")
            .. "\nUI test only; no game action"
    end)
end

bindToggle(target, "target", "AUTO TARGET EGG")
bindToggle(take, "take", "AUTO TAKE")
bindToggle(base, "base", "RETURN TO BASE")

-- Drag the VN logo with touch or mouse
local dragging = false
local dragInput
local dragStart
local startPos

logo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = logo.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end

    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        logo.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

print("[VHAN] UI loaded.")
