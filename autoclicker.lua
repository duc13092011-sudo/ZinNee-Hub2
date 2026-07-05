-- [[ ZINNEE HUB V2 - ADVANCED AUTO CLICKER MODULE ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- 1. DỌN DẸP HỆ THỐNG CŨ NẾU ĐANG CHẠY TRÙNG
if _G.ZinNeeClickerUI then _G.ZinNeeClickerUI:Destroy() end
if _G.ZinNeeClickerLoop then _G.ZinNeeClickerLoop:Disconnect() end
if _G.ZinNeeClickerDot then _G.ZinNeeClickerDot:Destroy() end

-- CẤU HÌNH TRẠNG THÁI MẶC ĐỊNH
local ClickerState = {
    Running = false,
    Interval = 0.1, -- Mặc định là Cấp độ 1 (Safe)
    Modes = {
        {Name = "Safe (10 CPS)", Value = 0.1},
        {Name = "Fast (20 CPS)", Value = 0.05},
        {Name = "Ultra (50 CPS)", Value = 0.02},
        {Name = "Insane (Max Speed)", Value = 0.001}
    }
}

-- 2. TẠO VÒNG TRÒN CHỈ ĐỊNH SIÊU NHỎ (DRAWING API)
local TargetDot = Drawing.new("Circle")
TargetDot.Radius = 4 -- Siêu nhỏ tinh tế
TargetDot.Color = Color3.fromRGB(140, 0, 255) -- Tím Neon
TargetDot.Thickness = 1.5
TargetDot.Filled = true
TargetDot.Visible = true
_G.ZinNeeClickerDot = TargetDot

-- 3. TẠO GIAO DIỆN BẢNG ĐIỀU KHIỂN MINI
local ClickerGui = Instance.new("ScreenGui")
ClickerGui.Name = "ZinNeeClickerPanel"
ClickerGui.ResetOnSpawn = false
pcall(function() ClickerGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui") end)
_G.ZinNeeClickerUI = ClickerGui

local Panel = Instance.new("Frame", ClickerGui)
Panel.Size = UDim2.new(0, 220, 0, 240)
Panel.Position = UDim2.new(0.5, 100, 0.5, -120) -- Lệch sang phải Menu chính một chút
Panel.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Panel.Active = true
Panel.Draggable = true
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", Panel)
Stroke.Color = Color3.fromRGB(140, 0, 255)
Stroke.Thickness = 1.5

-- Tiêu đề Panel
local Title = Instance.new("TextLabel", Panel)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
Title.Text = "🖱️ ZINNEE AUTO CLICKER"

-- Khung chứa các nút chọn tốc độ
local SpeedContainer = Instance.new("Frame", Panel)
SpeedContainer.Size = UDim2.new(0.9, 0, 0, 130)
SpeedContainer.Position = UDim2.new(0.05, 0, 0, 35)
SpeedContainer.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", SpeedContainer)
Layout.Padding = UDim.new(0, 4)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local modeButtons = {}

-- Hàm tạo và quản lý nút chọn Tốc độ
for i, mode in ipairs(ClickerState.Modes) do
    local btn = Instance.new("TextButton", SpeedContainer)
    btn.Size = UDim2.new(1, 0, 0, 26)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(40, 15, 70) or Color3.fromRGB(22, 22, 26)
    btn.Text = mode.Name
    btn.TextColor3 = (i == 1) and Color3.fromRGB(140, 0, 255) or Color3.fromRGB(160, 160, 160)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    local bStroke = Instance.new("UIStroke", btn)
    bStroke.Color = (i == 1) and Color3.fromRGB(140, 0, 255) or Color3.fromRGB(30, 30, 35)
    
    modeButtons[i] = {btn = btn, stroke = bStroke}
    
    btn.MouseButton1Click:Connect(function()
        ClickerState.Interval = mode.Value
        -- Đổi màu highlight nút được chọn
        for idx, item in ipairs(modeButtons) do
            if idx == i then
                item.btn.BackgroundColor3 = Color3.fromRGB(40, 15, 70)
                item.btn.TextColor3 = Color3.fromRGB(140, 0, 255)
                item.stroke.Color = Color3.fromRGB(140, 0, 255)
            else
                item.btn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
                item.btn.TextColor3 = Color3.fromRGB(160, 160, 160)
                item.stroke.Color = Color3.fromRGB(30, 30, 35)
            end
        end
    end)
end

-- 4. NÚT KHỞI CHẠY (START / STOP BUTTON)
local StartBtn = Instance.new("TextButton", Panel)
StartBtn.Size = UDim2.new(0.9, 0, 0, 38)
StartBtn.Position = UDim2.new(0.05, 0, 1, -48)
StartBtn.BackgroundColor3 = Color3.fromRGB(20, 35, 20)
StartBtn.Text = "START ACTIVE"
StartBtn.TextColor3 = Color3.fromRGB(0, 230, 100)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 13
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0, 5)
local StartStroke = Instance.new("UIStroke", StartBtn)
StartStroke.Color = Color3.fromRGB(0, 200, 80)

-- Nút tắt nhanh bảng điều khiển
local CloseBtn = Instance.new("TextButton", Panel)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -25, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.MouseButton1Click:Connect(function()
    ClickerState.Running = false
    TargetDot.Visible = false
    ClickerGui:Destroy()
end)

-- 5. LÔ-GÍC XỬ LÝ CLICK VÀ CẬP NHẬT VÒNG TRÒN CHỈ ĐỊNH
StartBtn.MouseButton1Click:Connect(function()
    ClickerState.Running = not ClickerState.Running
    
    if ClickerState.Running then
        StartBtn.Text = "STOP CLICKER"
        StartBtn.BackgroundColor3 = Color3.fromRGB(45, 15, 20)
        StartBtn.TextColor3 = Color3.fromRGB(255, 50, 70)
        StartStroke.Color = Color3.fromRGB(220, 30, 50)
    else
        StartBtn.Text = "START ACTIVE"
        StartBtn.BackgroundColor3 = Color3.fromRGB(20, 35, 20)
        StartBtn.TextColor3 = Color3.fromRGB(0, 230, 100)
        StartStroke.Color = Color3.fromRGB(0, 200, 80)
        TargetDot.Color = Color3.fromRGB(140, 0, 255) -- Trả lại màu tím khi dừng
    end
end)

-- Chạy vòng lặp RenderStepped quản lý vị trí chuột và clicker
local clickTimer = 0
_G.ZinNeeClickerLoop = RunService.RenderStepped:Connect(function(deltaTime)
    local mousePos = UserInputService:GetMouseLocation()
    TargetDot.Position = mousePos
    
    if ClickerState.Running then
        -- Hiệu ứng nhấp nháy vòng tròn khi đang click (Đổi màu liên tục để nhận biết)
        TargetDot.Color = (tick() % 0.2 > 0.1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 0, 255)
        
        clickTimer = clickTimer + deltaTime
        if clickTimer >= ClickerState.Interval then
            clickTimer = 0
            -- Thực thi gửi gói tin bấm chuột ảo tại tọa độ chỉ định
            VirtualInputManager:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, true, game, 1)
            VirtualInputManager:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, false, game, 1)
        end
    else
        TargetDot.Visible = true
    end
end)

print("⚙️ ZinNee Hub V2: Robust Auto Clicker Panel loaded.")
