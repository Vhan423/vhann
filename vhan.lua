-- VHAN CORE SYSTEM v1.0
-- Roblox Studio - StarterPlayerScripts
-- Functional UI + task lifecycle + pause/mode/stop

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local VHAN = {
    Running = false,
    Paused = false,
    Mode = 1,
    Modes = {"SAFE", "BALANCED", "FAST"},
    TaskName = "Idle",
    TaskToken = 0,
}

local function stopTask()
    VHAN.TaskToken += 1
    VHAN.Running = false
    VHAN.Paused = false
    VHAN.TaskName = "Idle"
end

local function startTask(name, callback)
    stopTask()

    VHAN.TaskToken += 1
    local myToken = VHAN.TaskToken

    VHAN.Running = true
    VHAN.Paused = false
    VHAN.TaskName = name

    task.spawn(function()
        while VHAN.TaskToken == myToken and VHAN.Running do
            if not VHAN.Paused then
                local ok, err = pcall(callback)

                if not ok then
                    warn("[VHAN] Task error:", err)
                    stopTask()
                    break
                end
            end

            task.wait(0.1)
        end
    end)
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "VHAN_Core"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.fromOffset(280, 250)
panel.Position = UDim2.new(0.5, -140, 0.5, -125)
panel.BackgroundColor3 = Color3.fromRGB(24, 17, 20)
panel.BorderSizePixel = 0
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(220, 45, 35)
stroke.Thickness = 2
stroke.Parent = panel

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 42)
title.Position = UDim2.fromOffset(10, 4)
title.BackgroundTransparency = 1
title.Text = "VHAN  •  CORE"
title.TextColor3 = Color3.fromRGB(255, 194, 65)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = panel

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 36)
status.Position = UDim2.fromOffset(10, 47)
status.BackgroundColor3 = Color3.fromRGB(42, 30, 33)
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.Parent = panel

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 7)
statusCorner.Parent = status

local function refresh()
    local state = "READY"
    if VHAN.Running and VHAN.Paused then
        state = "PAUSED"
    elseif VHAN.Running then
        state = "RUNNING"
    end

    status.Text = string.format(
        "STATE: %s  |  TASK: %s  |  MODE: %s",
        state, VHAN.TaskName, VHAN.Modes[VHAN.Mode]
    )
end

local function makeButton(text, y, color, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -24, 0, 36)
    button.Position = UDim2.fromOffset(12, y)
    button.BackgroundColor3 = color
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    button.Text = text
    button.AutoButtonColor = true
    button.Parent = panel

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = button

    button.Activated:Connect(callback)
    return button
end

makeButton("START DEMO TASK", 92,
    Color3.fromRGB(145, 37, 30), function()
        startTask("Demo", function()
            -- Contoh tugas nyata yang aman: memperbarui status.
            -- Ganti callback ini dengan logika game milikmu.
            refresh()
        end)
        refresh()
    end)

makeButton("PAUSE / RESUME", 134,
    Color3.fromRGB(125, 82, 25), function()
        if VHAN.Running then
            VHAN.Paused = not VHAN.Paused
        end
        refresh()
    end)

makeButton("CHANGE MODE", 176,
    Color3.fromRGB(70, 55, 100), function()
        VHAN.Mode = (VHAN.Mode % #VHAN.Modes) + 1
        refresh()
    end)

makeButton("STOP TASK", 218,
    Color3.fromRGB(75, 35, 38), function()
        stopTask()
        refresh()
    end)

-- Drag panel using mouse or touch
local dragging = false
local dragInput
local dragStart
local startPosition

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = panel.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

refresh()
print("[VHAN] Core loaded successfully.")
