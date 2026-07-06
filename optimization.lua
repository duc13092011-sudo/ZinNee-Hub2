-- [[ ROBLOX PREMIUM FPS BOOSTER GUI ]] --
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- 1. TẠO GIAO DIỆN (UI DESIGN)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FPS_Booster_Premium"
-- Hỗ trợ chạy an toàn trên mọi Executor
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Khung nền chính (Nền đen, viền tím)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 280)
MainFrame.Position = UDim2.new(0.5, -175, 0.4, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Nền đen đậm
MainFrame.BorderColor3 = Color3.fromRGB(138, 43, 226) -- Viền tím (Purple/Violet)
MainFrame.BorderSizePixel = 3
MainFrame.Active = true
MainFrame.Draggable = true -- Có thể kéo giữ để di chuyển trên màn hình
MainFrame.Parent = ScreenGui

-- Tiêu đề (Chữ chạy hiệu ứng RGB)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "★ KENISME - FPS BOOSTER ★"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.Parent = MainFrame

-- Hiệu ứng Chữ RGB chuyển màu liên tục
task.spawn(function()
    local hue = 0
    while task.wait(0.02) do
        hue = (hue + 1) % 360
        TitleLabel.TextColor3 = Color3.fromHSV(hue / 360, 1, 1)
    end
end)

-- Hàm tạo Button mẫu để code ngắn gọn
local function createButton(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 310, 0, 45)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.BorderColor3 = Color3.fromRGB(100, 0, 200) -- Viền nút tím tối
    btn.BorderSizePixel = 1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = MainFrame
    
    -- Hiệu ứng di chuột vào nút (Hover)
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(40, 20, 60) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25) end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 2. ĐỊNH NGHĨA CÁC CHỨC NĂNG BOOST

-- [Boost 1]: Xóa các hạt hiệu ứng (Khói, lửa, hiệu ứng skill...)
local function activateBoost1()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj.Enabled = false
        end
    end
    -- Quét cả các hạt sinh ra sau này
    workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj.Enabled = false
        end
    end)
    TitleLabel.Text = "[✓] BOOST 1 ACTIVATED!"
    task.wait(1.5)
    TitleLabel.Text = "★ KENISME - FPS BOOSTER ★"
end

-- [Boost 2]: Xóa hoàn toàn hiệu ứng và đồ họa (Potato Mode siêu mượt)
local function activateBoost2()
    -- Tắt hiệu ứng ánh sáng, bóng đổ
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("DepthOfFieldEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("Atmosphere") then
            effect.Enabled = false
        end
    end
    
    -- Biến mọi thứ thành nhựa phẳng & Xóa vân bề mặt (Textures)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsA("MeshPart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj.Enabled = false
        end
    end
    
    -- Hạ cấu hình render ẩn xuống mức 1
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    
    TitleLabel.Text = "[✓] POTATO MODE ACTIVATED!"
    task.wait(1.5)
    TitleLabel.Text = "★ KENISME - FPS BOOSTER ★"
end

-- [Boost 3]: Smart Render Radius (Ý tưởng AI: Tự ẩn vật thể/người ở quá xa)
local function activateBoost3()
    local maxDistance = 150 -- Bán kính tối đa được hiển thị (tính bằng Studs)
    
    task.spawn(function()
        while true do
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local myPos = character.HumanoidRootPart.Position
                
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and not obj:IsDescendantOf(character) then
                        -- Không can thiệp vào sàn nhà (tránh rơi xuống void)
                        if obj.Name ~= "Baseplate" and obj.Name ~= "Terrain" then
                            local dist = (obj.Position - myPos).Magnitude
                            if dist > maxDistance then
                                obj.LocalTransparencyModifier = 1 -- Ẩn đi đối với máy bạn
                            else
                                obj.LocalTransparencyModifier = 0 -- Hiện lại khi lại gần
                            end
                        end
                    end
                end
            end
            task.wait(1) -- Quét lại mỗi giây để tránh mệt máy
        end
    end)
    
    TitleLabel.Text = "[✓] SMART RADIUS ACTIVATED!"
    task.wait(1.5)
    TitleLabel.Text = "★ KENISME - FPS BOOSTER ★"
end

-- 3. KHỞI TẠO CÁC NÚT BẤM TRÊN GUI
createButton("Boost 1: Xóa Hạt Hiệu Ứng", UDim2.new(0, 20, 0, 60), activateBoost1)
createButton("Boost 2: Xóa Toàn Bộ Đồ Họa (Potato)", UDim2.new(0, 20, 0, 115), activateBoost2)
createButton("Boost 3: Tầm Nhìn Thông Minh (PvP)", UDim2.new(0, 20, 0, 170), activateBoost3)

-- Nút đóng Menu ẩn danh
local CloseBtn = createButton("Đóng Menu", UDim2.new(0, 20, 0, 225), function()
    ScreenGui:Destroy()
end)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
CloseBtn.BorderColor3 = Color3.fromRGB(150, 0, 0)
