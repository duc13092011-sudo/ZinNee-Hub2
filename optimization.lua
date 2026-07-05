-- [[ ZINNEE HUB V2 - UNIVERSAL FPS BOOST MODULE ]] --
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- 1. TỐI ƯU HÓA ĐỊA HÌNH VÀ NƯỚC (TERRAIN & WATER)
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0
    -- Chuyển đổi chế độ render vật liệu về mức thấp nhất nếu game cho phép
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
end

-- 2. TỐI ƯU HÓA ÁNH SÁNG VÀ HIỆU ỨNG (LIGHTING & EFFECTS)
Lighting.GlobalShadows = false -- Tắt đổ bóng toàn cục (Tăng FPS nhiều nhất)
Lighting.FogEnd = 9e9          -- Đẩy sương mù ra vô hạn để giảm xử lý chiều sâu
Lighting.ShadowMapBlur = 0

-- Loại bỏ các hiệu ứng hậu kỳ làm mờ/lóa màn hình
for _, effect in ipairs(Lighting:GetChildren()) do
    if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") or effect:IsA("DepthOfFieldEffect") then
        effect.Enabled = false
    end
end

-- 3. HÀM TỐI ƯU HÓA CHI TIẾT VẬT THỂ (PART & TEXTURE CLEANER)
local function OptimizeObject(obj)
    -- Tối ưu vân bề mặt (Textures & Decals)
    if obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1 -- Làm vô hình các Decal để giảm tải VRAM
    
    -- Tối ưu hóa các hạt hiệu ứng động gây lag tụt FPS
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
        obj.Enabled = false
        
    -- Tối ưu hóa chất liệu của các khối hộp (Parts)
    elseif obj:IsA("MeshPart") or obj:IsA("Part") or obj:IsA("CornerWedgePart") or obj:IsA("WedgePart") then
        obj.Material = Enum.Material.SmoothPlastic -- Ép về nhựa phẳng siêu nhẹ
        obj.Reflectance = 0
        obj.CastShadow = false
    end
end

-- Quét toàn bộ các vật thể hiện đang có trong thế giới game
for _, desc in ipairs(Workspace:GetDescendants()) do
    OptimizeObject(desc)
end

-- Lắng nghe các vật thể mới được sinh ra trong quá trình chơi để tối ưu luôn
Workspace.DescendantAdded:Connect(function(desc)
    task.wait(0.1) -- Đợi một chút để vật thể tải xong rồi xử lý
    OptimizeObject(desc)
end)

-- 4. ĐỒNG BỘ CÀI ĐẶT NETWORK & PHYSICS (GIẢM GIẬT LAG)
settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.DefaultAuto
settings().Physics.ThrottleAdjustTime = 1

print("🚀 ZinNee Hub V2: FPS Booster Module Executed Successfully! Enjoy High Performance.")
