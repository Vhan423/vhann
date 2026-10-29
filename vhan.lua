-- Vhan Hub - One Piece Edition with Optimized Auto Steal & 3D VN Logo
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Hapus GUI lama jika ada agar tidak menumpuk
if playerGui:FindFirstChild("VhanAnimeHub") then
    playerGui.VhanAnimeHub:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VhanAnimeHub"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- 1. TOMBOL LOGO VN 3D UNGU (Floating Button)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "VNLogo"
toggleBtn.Parent = screenGui
toggleBtn.BackgroundColor3 = Color3.fromRGB(110, 30, 200) -- Warna ungu khas
toggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
toggleBtn.Size = UDim2.new(0, 55, 0, 55)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Text = "VN"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 20

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0) -- Membuat tombol bulat sempurna (gaya 3D)
btnCorner.Parent = toggleBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(200, 150, 255)
btnStroke.Thickness = 3
btnStroke.Parent = toggleBtn

-- 2. FRAME UTAMA (MENU DENGAN BACKGROUND ANIME ONE PIECE)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.Position = UDim2.new(0.5, -140, 0.3, 0)
mainFrame.Size = UDim2.new(0, 280, 0, 340)
mainFrame.Visible = false -- Disembunyikan dulu, akan muncul saat logo VN diketuk
mainFrame.Active = true
mainFrame.Draggable = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Background Gambar Anime One Piece
local bgImage = Instance.new("ImageLabel")
bgImage.Parent = mainFrame
bgImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bgImage.BackgroundTransparency = 1
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Image = "rbxassetid://6071575919" -- Asset gambar latar belakang bertema anime
bgImage.ImageTransparency = 0.45 -- Transparansi agar tombol tetap terlihat jelas
bgImage.ScaleType = Enum.ScaleType.Slice

-- Judul Menu
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
title.BackgroundTransparency = 0.3
title.Size = UDim2.new(1, 0, 0, 40)
title.Font = Enum.Font.GothamBold
title.Text = "  🏴‍☠️ Vhan Hub | One Piece Edition"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left

-- Aksi Ketuk Logo VN 3D untuk Membuka/Menutup Menu
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Tombol Tutup (X) di dalam Menu
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = title
closeBtn.BackgroundTransparency = 1
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
closeBtn.TextSize = 14

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Container Tempat Tombol Fitur (Bisa di-scroll)
local scroll = Instance.new("ScrollingFrame")
scroll.Parent = mainFrame
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.Position = UDim2.new(0, 0, 0, 45)
scroll.Size = UDim2.new(1, 0, 1, -45)
scroll.CanvasSize = UDim2.new(0, 0, 0, 380)
scroll.ScrollBarThickness = 3

local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)

-- Fungsi Pembuat Tombol Fitur yang Rapi
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = scroll
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    btn.BackgroundTransparency = 0.4
    btn.Size = UDim2.new(0, 250, 0, 36)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(140, 80, 255)
    stroke.Transparency = 0.5
    stroke.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- 1. FITUR AUTO STEAL (Mengambil dan Membawa Pulang Telur)
local autoStealOn = false
createButton("🥚 Auto Steal Egg: OFF", function(btn)
    autoStealOn = not autoStealOn
    btn.Text = autoStealOn and "🥚 Auto Steal Egg: ON" or "🥚 Auto Steal Egg: OFF"
end)

-- Sistem Loop untuk Menjalankan Auto Steal di Game
task.spawn(function()
    while true do
        task.wait(1)
        if autoStealOn then
            pcall(function()
                local char = localPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    -- Mencari objek telur di dalam map game
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if autoStealOn and obj:IsA("Model") and (string.lower(obj.Name):find("egg") or obj:FindFirstChild("TouchInterest")) then
                            local handle = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                            if handle then
                                local oldPos = char.HumanoidRootPart.CFrame
                                -- Teleport otomatis ke posisi telur untuk mengambilnya
                                char.HumanoidRootPart.CFrame = handle.CFrame
                                task.wait(0.3)
                                -- Mengembalikan posisi karakter kembali ke area semula/markas
                                char.HumanoidRootPart.CFrame = oldPos
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 2. Tombol Speed Boost
local speedOn = false
createButton("⚡ Toggle Speed Boost (50)", function(btn)
    speedOn = not speedOn
    local char = localPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speedOn and 50 or 16
        btn.Text = speedOn and "⚡ Speed Boost: ON (50)" or "⚡ Toggle Speed Boost (50)"
    end
end)

-- 3. Tombol Super Jump
local jumpOn = false
createButton("🦘 Toggle Super Jump (120)", function(btn)
    jumpOn = not jumpOn
    local char = localPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = jumpOn and 120 or 50
        btn.Text = jumpOn and "🦘 Super Jump: ON (120)" or "🦘 Toggle Super Jump (120)"
    end
end)

-- 4. Tombol Teleport ke Markas/Sarang
createButton("📍 Teleport ke Sarang", function()
    local char = localPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 35, 0)
    end
end)

-- 5. Tombol Infinite Jump
local infJumpOn = false
createButton("🚀 Toggle Infinite Jump: OFF", function(btn)
    infJumpOn = not infJumpOn
    btn.Text = infJumpOn and "🚀 Infinite Jump: ON" or "🚀 Toggle Infinite Jump: OFF"
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpOn then
        local char = localPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 6. Tombol Noclip (Tembus Dinding)
local noclipOn = false
createButton("👻 Toggle Noclip: OFF", function(btn)
    noclipOn = not noclipOn
    btn.Text = noclipOn and "👻 Noclip: ON" or "👻 Toggle Noclip: OFF"
end)

RunService.Stepped:Connect(function()
    if noclipOn then
        local char = localPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)
