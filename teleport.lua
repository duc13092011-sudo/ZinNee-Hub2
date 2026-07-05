-- [[ ZINNEE HUB V2 - ADVANCED TELEPORT & WAYPOINT MENU ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- 1. DỌN DẸP GIAO DIỆN CŨ TRÁNH TRÙNG LẶP
if CoreGui:FindFirstChild("ZinNeeTeleportConsole") then
    CoreGui.ZinNeeTeleportConsole:Destroy()
end

-- Bảng lưu trữ tọa độ tạm thời trong bộ nhớ game
local SavedWaypoints = {}
local ClickToTeleportActive = false

-- 2. KHỞI TẠO SCREEN GUI MỚI
local TeleGui = Instance.new("ScreenGui")
TeleGui.Name = "ZinNeeTeleportConsole"
TeleGui.ResetOnSpawn = false
pcall(function() TeleGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui") end)

-- 3. KHUNG BẢNG ĐIỀU KHIỂN MINI (MINI PANEL)
local Panel = Instance.new("Frame", TeleGui)
Panel.Size = UDim2.new(0, 240, 0, 280)
Panel.Position = UDim2.new(0.5, -340, 0.5, -140) -- Căn góc trái để không đè lên Menu chính
Panel.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
Panel.Active = true
Panel.Draggable = true
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 8)

local RGBStroke = Instance.new("UIStroke", Panel)
RGBStroke.Thickness = 1.8
RGBStroke.Color = Color3.fromRGB(140, 0, 255)

local Title = Instance.new("TextLabel", Panel)
Title.Size = UDim2.new(1, 0, 0, 32)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Title.Text = "📍 ZINNEE TELEPORT SYSTEM"
Title.TextColor3 = Color3.fromRGB(140, 0, 255)

local CloseBtn = Instance.new("TextButton", Panel)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -25, 0, 6)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.MouseButton1Click:Connect(function() TeleGui:Destroy() end)

-- 4. Ô NHẬP TÊN ĐIỂM CẦN LƯU (WAYPOINT NAME INPUT)
local NameInput = Instance.new("TextBox", Panel)
NameInput.Size = UDim2.new(0.9, 0, 0, 26)
NameInput.Position = UDim2.new(0.05, 0, 0, 35)
NameInput.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
NameInput.Font = Enum.Font.Gotham
NameInput.Text = ""
NameInput.PlaceholderText = "Nhập tên vị trí cần lưu..."
NameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
NameInput.TextSize = 11
Instance.new("UICorner", NameInput).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", NameInput).Color = Color3.fromRGB(35, 35, 40)

-- 5. DANH SÁCH CUỘN CHỨA CÁC ĐIỂM ĐÃ LƯU
local ListFrame = Instance.new("ScrollingFrame", Panel)
ListFrame.Size = UDim2.new(0.9, 0, 0, 130)
ListFrame.Position = UDim2.new(0.05, 0, 0, 70)
ListFrame.BackgroundTransparency = 1
ListFrame.ScrollBarThickness = 2
ListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ListLayout = Instance.new("UIListLayout", ListFrame)
ListLayout.Padding = UDim.new(0, 4)

-- Hàm vẽ lại danh sách điểm tọa độ lên giao diện
local function RefreshWaypointList()
    for _, child in ipairs(ListFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    for name, cframe in pairs(SavedWaypoints) do
        local row = Instance.new("Frame", ListFrame)
        row.Size = UDim2.new(1, -4, 0, 28)
        row.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)
        
        -- Chữ hiển thị tên vị trí
        local txt = Instance.new("TextLabel", row)
        txt.Size = UDim2.new(0.65, 0, 1, 0)
        txt.Position = UDim2.new(0, 8, 0, 0)
        txt.BackgroundTransparency = 1
        txt.Font = Enum.Font.Gotham
        txt.TextColor3 = Color3.fromRGB(200, 200, 200)
        txt.TextSize = 11
        txt.TextXAlignment = Enum.TextXAlignment.Left
        txt.Text = name

        -- Nút bấm để bay tới vị trí đó
        local tpBtn = Instance.new("TextButton", row)
        tpBtn.Size = UDim2.new(0.25, 0, 0, 20)
        tpBtn.Position = UDim2.new(0.7, 0, 0.5, -10)
        tpBtn.BackgroundColor3 = Color3.fromRGB(35, 15, 60)
        tpBtn.Text = "TELE"
        tpBtn.TextColor3 = Color3.fromRGB(140, 0, 255)
        tpBtn.Font = Enum.Font.GothamBold
        tpBtn.TextSize = 10
        Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 3)

        tpBtn.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Dịch chuyển và cộng thêm chiều cao trục Y để chống lún đất
                hrp.CFrame = cframe + Vector3.new(0, 2, 0)
            end
        end)
    end
end

-- 6. NÚT LƯU VỊ TRÍ HIỆN TẠI (SAVE POSITION BUTTON)
local SaveBtn = Instance.new("TextButton", Panel)
SaveBtn.Size = UDim2.new(0.9, 0, 0, 28)
SaveBtn.Position = UDim2.new(0.05, 0, 1, -72)
SaveBtn.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
SaveBtn.Text = "💾 LƯU VỊ TRÍ HIỆN TẠI"
SaveBtn.TextColor3 = Color3.fromRGB(0, 210, 90)
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = 11
Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 4)

SaveBtn.MouseButton1Click:Connect(function()
    local wpName = NameInput.Text ~= "" and NameInput.Text or "Điểm " .. tostring(tick() % 1000):sub(1,3)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        SavedWaypoints[wpName] = hrp.CFrame
        NameInput.Text = "" -- Xóa ô chữ sau khi lưu xong
        RefreshWaypointList()
    end
end)

-- 7. NÚT NHẤN ĐÂU BAY ĐÓ (CLICK TO TELEPORT MODULE)
local ClickTpBtn = Instance.new("TextButton", Panel)
ClickTpBtn.Size = UDim2.new(0.9, 0, 0, 32)
ClickTpBtn.Position = UDim2.new(0.05, 0, 1, -38)
ClickTpBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
ClickTpBtn.Text = "🖱️ CLICK TO TELEPORT [OFF]"
ClickTpBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
ClickTpBtn.Font = Enum.Font.GothamBold
ClickTpBtn.TextSize = 11
Instance.new("UICorner", ClickTpBtn).CornerRadius = UDim.new(0, 5)
local cStroke = Instance.new("UIStroke", ClickTpBtn)
cStroke.Color = Color3.fromRGB(35, 35, 40)

ClickTpBtn.MouseButton1Click:Connect(function()
    ClickToTeleportActive = not ClickToTeleportActive
    if ClickToTeleportActive then
        ClickTpBtn.Text = "🖱️ CLICK TO TELEPORT [ON]"
        ClickTpBtn.TextColor3 = Color3.fromRGB(140, 0, 255)
        cStroke.Color = Color3.fromRGB(140, 0, 255)
        ClickTpBtn.BackgroundColor3 = Color3.fromRGB(30, 15, 55)
    else
        ClickTpBtn.Text = "🖱️ CLICK TO TELEPORT [OFF]"
        ClickTpBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
        cStroke.Color = Color3.fromRGB(35, 35, 40)
        ClickTpBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    end
end)

-- Lắng nghe sự kiện bấm chuột ngoài bản đồ khi chế độ Click-To-Teleport bật
Mouse.Button1Down:Connect(function()
    if ClickToTeleportActive then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and Mouse.Hit then
            -- Di chuyển thẳng tới điểm chuột vừa nhấp
            hrp.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

-- 8. VÒNG LẶP ĐỔI MÀU RGB CHO ĐỒNG BỘ GIAO DIỆN CHỦ ĐẠO
task.spawn(function()
    local hue = 0
    while Panel and Panel.Parent do
        hue = hue + 0.005
        if hue > 1 then hue = 0 end
        local rainbow = Color3.fromHSV(hue, 0.9, 1)
        RGBStroke.Color = rainbow
        Title.TextColor3 = rainbow
        task.wait(0.02)
    end
end)

print("🔮 ZinNee Hub V2: Advanced Waypoint Menu Loaded!")
