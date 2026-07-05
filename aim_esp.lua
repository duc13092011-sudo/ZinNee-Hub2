-- [[ ZINNEE HUB V2 - MODULE: AIMBOT & ESP UNIVERSAL ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CẤU HÌNH HỆ THỐNG (CÓ THỂ TỰ ĐIỀU CHỈNH)
local Settings = {
    AimBot = {
        Enabled = true,
        Key = Enum.UserInputType.MouseButton2, -- Giữ chuột phải để Aim
        TargetPart = "HumanoidRootPart",      -- Bộ phận ngắm (Head / HumanoidRootPart)
        Smoothness = 0.15,                    -- Độ mượt khi ghì tâm (càng nhỏ càng mượt, từ 0.05 - 1)
        TeamCheck = false                     -- Bật true nếu không muốn ngắm đồng đội
    },
    FOV = {
        Visible = true,
        Radius = 120,                         -- Độ rộng vòng quét Aim
        Color = Color3.fromRGB(140, 0, 255),  -- Màu tím nhạt neon
        Thickness = 1
    },
    ESP = {
        Enabled = true,
        Boxes = true,                         -- Khung viền phát sáng xuyên tường
        Tracers = true,                       -- Kẻ đường định vị
        BoxColor = Color3.fromRGB(140, 0, 255),
        TracerColor = Color3.fromRGB(255, 255, 255)
    }
}

-- DỌN DẸP HỆ THỐNG CŨ NẾU CHẠY TRÙNG
if _G.ZinNeeAimESPConnection then
    _G.ZinNeeAimESPConnection:Disconnect()
end
if _G.ZinNeeFOVObj then
    _G.ZinNeeFOVObj:Destroy()
end
if _G.ZinNeeESPFolder then
    _G.ZinNeeESPFolder:Destroy()
end

-- 1. TẠO VÒNG FOV CHO AIMBOT
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = Settings.FOV.Radius
FOVCircle.Color = Settings.FOV.Color
FOVCircle.Thickness = Settings.FOV.Thickness
FOVCircle.Filled = false
FOVCircle.Visible = Settings.FOV.Visible
_G.ZinNeeFOVObj = FOVCircle

-- Khởi tạo Folder chứa đồ họa ESP
local ESPFolder = Instance.new("Folder", game:GetService("CoreGui"))
ESPFolder.Name = "ZinNee_ESP_Storage"
_G.ZinNeeESPFolder = ESPFolder

-- 2. HÀM TÌM MỤC TIÊU GẦN TÂM CHUỘT NHẤT
local function GetClosestPlayer()
    local ClosestPlayer = nil
    local ShortestDistance = math.huge
    local MousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Settings.AimBot.TargetPart) and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            
            -- Kiểm tra đội nếu bật TeamCheck
            if Settings.AimBot.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end

            local TargetPart = player.Character[Settings.AimBot.TargetPart]
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(TargetPart.Position)

            if OnScreen then
                local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                if Distance < ShortestDistance and Distance <= Settings.FOV.Radius then
                    ShortestDistance = Distance
                    ClosestPlayer = player
                end
            end
        end
    end
    return ClosestPlayer
end

-- 3. HÀM QUẢN LÝ VẼ ĐỒ HỌA ESP CHO TỪNG NGƯỜI CHƠI
local TracersCache = {}

local function ApplyESP(player)
    local function UpdateCharacterESP()
        local char = player.Character
        if not char then return end

        -- Tạo Highlight Box (Khung viền phát sáng xuyên tường)
        if Settings.ESP.Boxes and not char:FindFirstChild("ZinNeeHighlight") then
            local hl = Instance.new("Highlight")
            hl.Name = "ZinNeeHighlight"
            hl.Parent = char
            hl.FillColor = Settings.ESP.BoxColor
            hl.FillTransparency = 0.6
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.OutlineTransparency = 0.1
            hl.Adornee = char
        end

        -- Tạo Tracer Line (Đường kẻ định vị)
        if Settings.ESP.Tracers and not TracersCache[player] then
            local line = Drawing.new("Line")
            line.Color = Settings.ESP.TracerColor
            line.Thickness = 1
            line.Transparency = 0.8
            TracersCache[player] = line
        end
    end

    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        UpdateCharacterESP()
    end)
    if player.Character then UpdateCharacterESP() end
end

-- Bật ESP cho toàn bộ người chơi đang có trong phòng
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then ApplyESP(p) end
end
Players.PlayerAdded:Connect(ApplyESP)

-- Xóa dữ liệu vẽ khi người chơi thoát
Players.PlayerRemoving:Connect(function(player)
    if TracersCache[player] then
        TracersCache[player]:Destroy()
        TracersCache[player] = nil
    end
end)

-- 4. VÒNG LẶP HỆ THỐNG (LOOP UPDATE BẰNG RENDERSTEPPED)
local IsAiming = false

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Settings.AimBot.Key then
        IsAiming = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Settings.AimBot.Key then
        IsAiming = false
    end
end)

_G.ZinNeeAimESPConnection = RunService.RenderStepped:Connect(function()
    -- Cập nhật lại vị trí vòng tròn FOV theo kích thước màn hình thực tế
    local MousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = MousePos
    
    -- XỬ LÝ AIMBOT
    if Settings.AimBot.Enabled and IsAiming then
        local TargetPlayer = GetClosestPlayer()
        if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild(Settings.AimBot.TargetPart) then
            local TargetPart = TargetPlayer.Character[Settings.AimBot.TargetPart]
            local TargetPos = Camera:WorldToViewportPoint(TargetPart.Position)
            
            -- Di chuyển Camera mượt mà (Interpolation) hướng về mục tiêu
            local CurrentCamCFrame = Camera.CFrame
            local TargetCFrame = CFrame.new(CurrentCamCFrame.Position, TargetPart.Position)
            Camera.CFrame = CurrentCamCFrame:Lerp(TargetCFrame, Settings.AimBot.Smoothness)
        end
    end

    -- XỬ LÝ CẬP NHẬT TRACERS CỦA ESP
    for player, line in pairs(TracersCache) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local hrp = player.Character.HumanoidRootPart
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(hrp.Position)

            if OnScreen and Settings.ESP.Tracers then
                line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y) -- Gốc từ đáy giữa màn hình
                line.To = Vector2.new(ScreenPos.X, ScreenPos.Y)
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end)

print("🔮 ZinNee Hub V2: Module AimBot & ESP Loaded Successfully!")
