-- [[ ZINNEE HUB V2 - MODULE: MOVEMENT CONSOLE WITH RGB & SANITIZED INPUT ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- 1. DỌN DẸP BẢNG ĐIỀU KHIỂN CŨ NẾU CHẠY TRÙNG
if CoreGui:FindFirstChild("ZinNeeMovementConsole") then
    CoreGui.ZinNeeMovementConsole:Destroy()
end

-- 2. KHỞI TẠO SCREEN GUI MỚI
local MoveGui = Instance.new("ScreenGui")
MoveGui.Name = "ZinNeeMovementConsole"
MoveGui.ResetOnSpawn = false
pcall(function() MoveGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui") end)

-- 3. KHUNG BẢNG ĐIỀU KHIỂN MINI (MINI PANEL)
local Panel = Instance.new("Frame", MoveGui)
Panel.Size = UDim2.new(0, 240, 0, 180)
Panel.Position = UDim2.new(0.5, -340, 0.5, -90) -- Lệch sang bên trái Menu chính để tránh đè
Panel.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Panel.Active = true
Panel.Draggable = true
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 8)

-- ĐÂY LÀ VIỀN RGB SẼ ĐỔI MÀU CẦU VỒNG
local RGBStroke = Instance.new("UIStroke", Panel)
RGBStroke.Thickness = 2
RGBStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Tiêu đề Bảng điều khiển
local Title = Instance.new("TextLabel", Panel)
Title.Size = UDim2.new(1, 0, 0, 32)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 11
Title.Text = "⚡ ZINNEE MOVEMENT CONTROL"

-- Nút đóng nhanh bảng điều khiển
local CloseBtn = Instance.new("TextButton", Panel)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -25, 0, 6)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.MouseButton1Click:Connect(function() MoveGui:Destroy() end)

-- ========================================================
-- 🛠️ HÀM TẠO Ô NHẬP LIỆU THÔNG MINH (TEXTBOX VALIDATION)
-- ========================================================
local function CreateInputRow(labelName, yOffset, defaultValue, maxValue, callback)
    -- Nhãn chữ hướng dẫn phía trên
    local label = Instance.new("TextLabel", Panel)
    label.Size = UDim2.new(0.5, 0, 0, 30)
    label.Position = UDim2.new(0.05, 0, 0, yOffset)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = labelName
    
    -- Ô TextBox để nhập số
    local textBox = Instance.new("TextBox", Panel)
    textBox.Size = UDim2.new(0.35, 0, 0, 26)
    textBox.Position = UDim2.new(0.55, 0, 0, yOffset + 2)
    textBox.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    textBox.Font = Enum.Font.Code
    textBox.TextSize = 12
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Text = tostring(defaultValue)
    textBox.PlaceholderText = "Số..."
    Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 4)
    local tStroke = Instance.new("UIStroke", textBox)
    tStroke.Color = Color3.fromRGB(40, 40, 45)
    tStroke.Thickness = 1

    -- Lọc dữ liệu thời gian thực khi người dùng đang gõ
    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        local currentText = textBox.Text
        local cleanText = currentText:gsub("%D", "") -- Xóa sạch ký tự không phải số
        
        if cleanText ~= "" then
            local num = tonumber(cleanText)
            if num and num > maxValue then
                cleanText = tostring(maxValue) -- Khống chế kịch trần
            end
        end
        
        if currentText ~= cleanText then
            textBox.Text = cleanText
        end
    end)

    -- Trả kết quả về hàm xử lý khi người dùng ấn Enter xác nhận
    textBox.FocusLost:Connect(function(enterPressed)
        local finalValue = tonumber(textBox.Text)
        if not finalValue or textBox.Text == "" then
            finalValue = defaultValue
            textBox.Text = tostring(defaultValue)
        end
        tStroke.Color = Color3.fromRGB(140, 0, 255)
        task.wait(0.15)
        tStroke.Color = Color3.fromRGB(40, 40, 45)
        
        callback(finalValue)
    end)
end

-- ========================================================
-- ⚙️ KHỞI TẠO CÁC Ô ĐIỀU CHỈNH TRONG MENU
-- ========================================================

-- Hàng 1: Nhập thông số Tốc độ chạy (Mặc định 16, tối đa 20000)
CreateInputRow("Tốc độ nhân vật (Speed):", 45, 16, 20000, function(value)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = value
        print("Đã cập nhật WalkSpeed hợp lệ: ", value)
    end
end)

-- Hàng 2: Nhập thông số Lực nhảy bay cao (Mặc định 50, tối đa 20000)
CreateInputRow("Lực nhảy cao (Jump):", 95, 50, 20000, function(value)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum.UseJumpPower then
            hum.JumpPower = value
        else
            hum.JumpHeight = value
        end
        print("Đã cập nhật JumpPower/Height hợp lệ: ", value)
    end
end)

-- Nút kích hoạt nhanh trạng thái đứng im trên không (Fly hỗ trợ)
local FlyBtn = Instance.new("TextButton", Panel)
FlyBtn.Size = UDim2.new(0.9, 0, 0, 28)
FlyBtn.Position = UDim2.new(0.05, 0, 1, -38)
FlyBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
FlyBtn.Text = "Kích Hoạt Trạng Thái Float"
FlyBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
FlyBtn.Font = Enum.Font.GothamSemibold
FlyBtn.TextSize = 11
Instance.new("UICorner", FlyBtn).CornerRadius = UDim.new(0, 4)
local fStroke = Instance.new("UIStroke", FlyBtn)
fStroke.Color = Color3.fromRGB(35, 35, 40)

local floatActive = false
local floatBody = nil

FlyBtn.MouseButton1Click:Connect(function()
    floatActive = not floatActive
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if floatActive then
        FlyBtn.Text = "Đang Giữ Trên Không [ON]"
        FlyBtn.TextColor3 = Color3.fromRGB(140, 0, 255)
        fStroke.Color = Color3.fromRGB(140, 0, 255)
        
        if hrp then
            floatBody = Instance.new("BodyVelocity")
            floatBody.Name = "ZinNeeFloat"
            floatBody.Velocity = Vector3.new(0, 0, 0)
            floatBody.MaxForce = Vector3.new(0, math.huge, 0) -- Giữ nguyên độ cao trục Y
            floatBody.Parent = hrp
        end
    else
        FlyBtn.Text = "Kích Hoạt Trạng Thái Float"
        FlyBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        fStroke.Color = Color3.fromRGB(35, 35, 40)
        
        if hrp and hrp:FindFirstChild("ZinNeeFloat") then
            hrp.ZinNeeFloat:Destroy()
        end
    end
end)

-- ========================================================
-- 🌈 LUỒNG CHẠY HIỆU ỨNG ĐỔI MÀU CẦU VỒNG (RGB CHROMA LOOP)
-- ========================================================
task.spawn(function()
    local hue = 0
    while Panel and Panel.Parent do
        hue = hue + 0.006 -- Tốc độ chuyển màu (càng nhỏ chuyển càng chậm mượt)
        if hue > 1 then hue = 0 end
        
        local rainbowColor = Color3.fromHSV(hue, 0.9, 1)
        
        -- Áp màu RGB lên viền bảng điều khiển và màu chữ tiêu đề
        RGBStroke.Color = rainbowColor
        Title.TextColor3 = rainbowColor
        
        task.wait(0.02) -- Tối ưu tần suất quét để tránh giảm FPS game
    end
end)

print("🔮 ZinNee Hub V2: Movement System with RGB & Strict Inputs Loaded.")
