-- [[ ZINNEE MENU - COMBAT PRO EDITION (REBUILT 2026) ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Biến lưu trạng thái chức năng
local currentWalkSpeed = 16
local flying = false
local noclipActive = false
local aimbotEnabled = false
local aimbotFOV = 120
local hitboxEnabled = false
local hitboxSize = 10
local espEnabled = false

-- Khởi tạo Drawing API cho Vòng FOV cố định
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.NumSides = 60
fovCircle.Radius = aimbotFOV
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(140, 0, 255) -- Màu tím Neon chủ đạo
fovCircle.Visible = false

-- ScreenGui Chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZinNeeMainCore"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui") end)

-- ==========================================
-- 🎨 GIAO DIỆN (NỀN ĐEN MỜ, VIỀN TÍM NEON)
-- ==========================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 430)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -215)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Viền Tím Neon
local FrameStroke = Instance.new("UIStroke", MainFrame)
FrameStroke.Color = Color3.fromRGB(140, 0, 255)
FrameStroke.Thickness = 2

-- Tiêu đề RGB Cầu Vồng
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "ZinNeeMenu"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Position = UDim2.new(0, 0, 0, 0)

task.spawn(function()
    while MainFrame and MainFrame.Parent do
        for h = 0, 1, 0.005 do
            if not Title or not Title.Parent then break end
            Title.TextColor3 = Color3.fromHSV(h, 0.8, 1)
            task.wait(0.01)
        end
    end
end)

-- Nút nổi thu phóng
local FloatBtn = Instance.new("TextButton", ScreenGui)
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(0, 20, 0, 120)
FloatBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
FloatBtn.Text = "Z"
FloatBtn.TextColor3 = Color3.fromRGB(140, 0, 255)
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.Draggable = true
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", FloatBtn).Color = Color3.fromRGB(140, 0, 255)
FloatBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- Danh sách tính năng (ScrollingFrame)
local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, 0, 1, -75)
Container.Position = UDim2.new(0, 0, 0, 40)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0, 0, 0, 500)
local ListLayout = Instance.new("UIListLayout", Container)
ListLayout.Padding = UDim.new(0, 5)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Hàm tạo Nút Bật/Tắt mẫu
local function createToggle(text, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        btn.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
end

-- ==========================================
-- 🎯 CƠ CHẾ AIMBOT CỐ ĐỊNH TÂM - LOCK HEAD
-- ==========================================
local function getClosestPlayerToCenter()
    local closestTarget = nil
    local shortestDistance = math.huge
    
    -- Lấy vị trí trung tâm chính xác của màn hình
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            
            -- Kiểm tra đối thủ còn sống và có bộ phận Đầu
            if head and hum and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    -- Tính khoảng cách từ ĐẦU mục tiêu đến TÂM màn hình
                    local distanceToCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    
                    -- Nếu nằm trong phạm vi FOV cài đặt và gần tâm nhất
                    if distanceToCenter < shortestDistance and distanceToCenter <= aimbotFOV then
                        shortestDistance = distanceToCenter
                        closestTarget = head
                    end
                end
            end
        end
    end
    return closestTarget
end

-- Ô nhập thông số FOV
local FovInput = Instance.new("TextBox", Container)
FovInput.Size = UDim2.new(0.9, 0, 0, 30)
FovInput.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
FovInput.Text = "Phạm vi FOV: 120"
FovInput.TextColor3 = Color3.fromRGB(180, 180, 180)
FovInput.Font = Enum.Font.GothamSemibold
FovInput.TextSize = 11
Instance.new("UICorner", FovInput).CornerRadius = UDim.new(0, 6)
FovInput.FocusLost:Connect(function()
    local num = tonumber(FovInput.Text:match("%d+"))
    if num then aimbotFOV = math.clamp(num, 10, 600) else aimbotFOV = 120 end
    FovInput.Text = "Phạm vi FOV: " .. aimbotFOV
end)

createToggle("🎯 Aimbot Lock Đầu", function(v) aimbotEnabled = v end)
createToggle("📦 Mở Rộng Hitbox", function(v) hitboxEnabled = v end)
createToggle("👁️ ESP Highlight & Line", function(v) espEnabled = v end)

-- Vòng lặp RenderStepped (Xử lý Aim, FOV và ESP)
local highlights = {}
local lines = {}

RunService.RenderStepped:Connect(function()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    -- Xử lý Aimbot Cố định tâm
    if aimbotEnabled then
        fovCircle.Position = screenCenter
        fovCircle.Radius = aimbotFOV
        fovCircle.Visible = true

        local targetHead = getClosestPlayerToCenter()
        if targetHead then
            -- Ghim chặt Camera trực tiếp vào Đầu đối thủ, triệt tiêu độ lệch
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        end
    else
        fovCircle.Visible = false
    end

    -- Xử lý ESP Line 0.2 và Highlight
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if espEnabled and hrp then
                if not highlights[p] then
                    local hl = Instance.new("Highlight", p.Character)
                    hl.FillColor = Color3.fromRGB(140, 0, 255)
                    highlights[p] = hl
                end
                if not lines[p] then
                    local l = Drawing.new("Line")
                    l.Thickness = 0.2
                    l.Color = Color3.fromRGB(140, 0, 255)
                    lines[p] = l
                end
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    lines[p].From = Vector2.new(screenCenter.X, Camera.ViewportSize.Y)
                    lines[p].To = Vector2.new(pos.X, pos.Y)
                    lines[p].Visible = true
                else
                    lines[p].Visible = false
                end
            else
                if highlights[p] then highlights[p]:Destroy() highlights[p] = nil end
                if lines[p] then lines[p]:Destroy() lines[p] = nil end
            end
        end
    end
end)

-- ==========================================
-- 📦 HITBOX EXPANDER LOOP
-- ==========================================
task.spawn(function()
    while task.wait(0.5) do
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if hitboxEnabled then
                        hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        hrp.Transparency = 0.7
                        hrp.CanCollide = false
                    else
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                        hrp.CanCollide = true
                    end
                end
            end
        end
    end
end)

-- ==========================================
-- 📊 BẢNG THEO DÕI HIỆU NĂNG (FPS / PING)
-- ==========================================
local Stats = Instance.new("TextLabel", MainFrame)
Stats.Size = UDim2.new(1, 0, 0, 25)
Stats.Position = UDim2.new(0, 0, 1, -25)
Stats.BackgroundTransparency = 1
Stats.TextColor3 = Color3.fromRGB(0, 255, 200)
Stats.Text = "FPS: -- | PING: -- ms"
Stats.Font = Enum.Font.Code
Stats.TextSize = 10

task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
        Stats.Text = "🟢 FPS: " .. fps .. " | ⚡ PING: " .. ping .. " ms"
    end
end)
