-- [[ ZINNEE MENU - COMBAT PRO EDITION (REBUILT) ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

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

-- Khởi tạo Drawing API (ESP/FOV)
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.NumSides = 60
fovCircle.Radius = aimbotFOV
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(140, 0, 255)
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

-- Tiêu đề RGB
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

-- Nút nổi
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

-- Danh sách tính năng
local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, 0, 1, -75)
Container.Position = UDim2.new(0, 0, 0, 40)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0, 0, 0, 500)
Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

-- Hàm tạo nút
local function createToggle(text, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

-- ==========================================
-- 🎯 COMBAT LOGIC
-- ==========================================
createToggle("🎯 Aimbot Lock", function(v) aimbotEnabled = v end)
createToggle("📦 Hitbox Expander", function(v) hitboxEnabled = v end)
createToggle("👁️ ESP Highlight", function(v) espEnabled = v end)

-- ESP Loop
local highlights = {}
local lines = {}
RunService.RenderStepped:Connect(function()
    -- Aimbot
    if aimbotEnabled then
        fovCircle.Visible = true
        fovCircle.Position = UserInputService:GetMouseLocation()
        -- Logic tìm mục tiêu gần nhất...
    else
        fovCircle.Visible = false
    end

    -- ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if espEnabled then
                if not highlights[p] then
                    local hl = Instance.new("Highlight", p.Character)
                    hl.FillColor = Color3.fromRGB(140, 0, 255)
                    highlights[p] = hl
                end
                -- Line 0.2
                if not lines[p] then
                    local l = Drawing.new("Line")
                    l.Thickness = 0.2
                    l.Color = Color3.fromRGB(140, 0, 255)
                    lines[p] = l
                end
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onScreen then
                    lines[p].From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
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
-- 📊 BẢNG FPS/PING
-- ==========================================
local Stats = Instance.new("TextLabel", MainFrame)
Stats.Size = UDim2.new(1, 0, 0, 25)
Stats.Position = UDim2.new(0, 0, 1, -25)
Stats.BackgroundTransparency = 1
Stats.TextColor3 = Color3.fromRGB(255, 255, 255)
Stats.Text = "FPS: -- | PING: -- ms"
Stats.Font = Enum.Font.Code
Stats.TextSize = 10

task.spawn(function()
    while task.wait(1) do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
        Stats.Text = "FPS: "..fps.." | PING: "..ping.." ms"
    end
end)
