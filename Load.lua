-- [[ ZINNEE HUB - LOADING SCREEN (LOGO EDITION WITH INTRO ANIMATION) ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- ⚙️ CẤU HÌNH LOGO
-- ==========================================
local LOGO_IMAGE_ID = "rbxassetid://0" -- thay số 0 bằng ID ảnh của bạn[span_3](start_span)[span_3](end_span)
local LOGO_TEXT = "ZN" --[span_4](start_span)[span_4](end_span)

local LoadGui = Instance.new("ScreenGui")
LoadGui.Name = "ZinNeeLoader[span_5](start_span)"[span_5](end_span)
LoadGui.ResetOnSpawn = false[span_6](start_span)[span_6](end_span)
pcall(function() LoadGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui") end)[span_7](start_span)[span_7](end_span)

local BG = Instance.new("Frame", LoadGui)
-- CHỈNH SỬA: Đặt kích thước và vị trí ban đầu bằng 0 ở giữa màn hình để làm hiệu ứng bung ra
BG.Size = UDim2.new(0, 0, 0, 0)
BG.Position = UDim2.new(0.5, 0, 0.5, 0)
BG.BackgroundColor3 = Color3.fromRGB(12, 12, 12)[span_8](start_span)[span_8](end_span)
BG.ClipsDescendants = true -- Ẩn các phần tử con khi khung đang nhỏ để tránh bị lỗi hiển thị
Instance.new("UICorner", BG).CornerRadius = UDim.new(0, 10)[span_9](start_span)[span_9](end_span)

local Stroke = Instance.new("UIStroke", BG)
Stroke.Color = Color3.fromRGB(140, 0, 255)[span_10](start_span)[span_10](end_span)
Stroke.Thickness = 1.5[span_11](start_span)[span_11](end_span)

-- ==========================================
-- 🖼️ LOGO (ảnh hoặc chữ, có viền tròn neon)
-- ==========================================
local LogoHolder = Instance.new("Frame", BG)
LogoHolder.Size = UDim2.new(0, 56, 0, 56)[span_12](start_span)[span_12](end_span)
LogoHolder.Position = UDim2.new(0.5, -28, 0, 14)[span_13](start_span)[span_13](end_span)
LogoHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)[span_14](start_span)[span_14](end_span)
Instance.new("UICorner", LogoHolder).CornerRadius = UDim.new(1, 0)[span_15](start_span)[span_15](end_span)
local LogoStroke = Instance.new("UIStroke", LogoHolder)
LogoStroke.Color = Color3.fromRGB(140, 0, 255)[span_16](start_span)[span_16](end_span)
LogoStroke.Thickness = 2[span_17](start_span)[span_17](end_span)

local LogoImage = Instance.new("ImageLabel", LogoHolder)
LogoImage.Size = UDim2.new(1, -10, 1, -10)[span_18](start_span)[span_18](end_span)
LogoImage.Position = UDim2.new(0, 5, 0, 5)[span_19](start_span)[span_19](end_span)
LogoImage.BackgroundTransparency = 1[span_20](start_span)[span_20](end_span)
LogoImage.Image = LOGO_IMAGE_ID[span_21](start_span)[span_21](end_span)
Instance.new("UICorner", LogoImage).CornerRadius = UDim.new(1, 0)[span_22](start_span)[span_22](end_span)

local LogoFallbackText = Instance.new("TextLabel", LogoHolder)
LogoFallbackText.Size = UDim2.new(1, 0, 1, 0)[span_23](start_span)[span_23](end_span)
LogoFallbackText.BackgroundTransparency = 1[span_24](start_span)[span_24](end_span)
LogoFallbackText.Font = Enum.Font.GothamBold[span_25](start_span)[span_25](end_span)
LogoFallbackText.TextColor3 = Color3.fromRGB(140, 0, 255)[span_26](start_span)[span_26](end_span)
LogoFallbackText.TextSize = 20[span_27](start_span)[span_27](end_span)
LogoFallbackText.Text = LOGO_TEXT[span_28](start_span)[span_28](end_span)
LogoFallbackText.Visible = (LOGO_IMAGE_ID == "rbxassetid://0")[span_29](start_span)[span_29](end_span)

-- vòng xoay quanh logo khi đang tải
local Spinner = Instance.new("Frame", LogoHolder)
Spinner.Size = UDim2.new(1, 8, 1, 8)[span_30](start_span)[span_30](end_span)
Spinner.Position = UDim2.new(0, -4, 0, -4)[span_31](start_span)[span_31](end_span)
Spinner.BackgroundTransparency = 1[span_32](start_span)[span_32](end_span)
local SpinnerStroke = Instance.new("UIStroke", Spinner)
SpinnerStroke.Color = Color3.fromRGB(0, 255, 200)[span_33](start_span)[span_33](end_span)
SpinnerStroke.Thickness = 2[span_34](start_span)[span_34](end_span)
Instance.new("UICorner", Spinner).CornerRadius = UDim.new(1, 0)[span_35](start_span)[span_35](end_span)

task.spawn(function()
    while LoadGui and LoadGui.Parent do
        Spinner.Rotation = (Spinner.Rotation + 4) % 360[span_36](start_span)[span_36](end_span)
        task.wait(0.03)[span_37](start_span)[span_37](end_span)
    end
end)

-- ==========================================
-- 🔤 TIÊU ĐỀ RGB
-- ==========================================
local Title = Instance.new("TextLabel", BG)
Title.Size = UDim2.new(1, 0, 0, 24)[span_38](start_span)[span_38](end_span)
Title.Position = UDim2.new(0, 0, 0, 76)[span_39](start_span)[span_39](end_span)
Title.BackgroundTransparency = 1[span_40](start_span)[span_40](end_span)
Title.Font = Enum.Font.GothamBold[span_41](start_span)[span_41](end_span)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)[span_42](start_span)[span_42](end_span)
Title.TextSize = 16[span_43](start_span)[span_43](end_span)
Title.Text = "ZINNEE HUB[span_44](start_span)"[span_44](end_span)

task.spawn(function()
    while LoadGui and LoadGui.Parent do
        for h = 0, 1, 0.01 do[span_45](start_span)[span_45](end_span)
            if not Title.Parent then break end[span_46](start_span)[span_46](end_span)
            Title.TextColor3 = Color3.fromHSV(h, 0.75, 1)[span_47](start_span)[span_47](end_span)
            task.wait(0.02)[span_48](start_span)[span_48](end_span)
        end
    end
end)

local Status = Instance.new("TextLabel", BG)
Status.Size = UDim2.new(1, 0, 0, 20)[span_49](start_span)[span_49](end_span)
Status.Position = UDim2.new(0, 0, 0, 104)[span_50](start_span)[span_50](end_span)
Status.BackgroundTransparency = 1[span_51](start_span)[span_51](end_span)
Status.Font = Enum.Font.GothamSemibold[span_52](start_span)[span_52](end_span)
Status.TextColor3 = Color3.fromRGB(150, 150, 150)[span_53](start_span)[span_53](end_span)
Status.TextSize = 11[span_54](start_span)[span_54](end_span)
Status.Text = "Đang khởi động...[span_55](start_span)"[span_55](end_span)

local BarBg = Instance.new("Frame", BG)
BarBg.Size = UDim2.new(0.85, 0, 0, 6)[span_56](start_span)[span_56](end_span)
BarBg.Position = UDim2.new(0.075, 0, 0, 140)[span_57](start_span)[span_57](end_span)
BarBg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)[span_58](start_span)[span_58](end_span)
Instance.new("UICorner", BarBg)[span_59](start_span)[span_59](end_span)

local BarFill = Instance.new("Frame", BarBg)
BarFill.Size = UDim2.new(0, 0, 1, 0)[span_60](start_span)[span_60](end_span)
BarFill.BackgroundColor3 = Color3.fromRGB(140, 0, 255)[span_61](start_span)[span_61](end_span)
Instance.new("UICorner", BarFill)[span_62](start_span)[span_62](end_span)

local PercentLabel = Instance.new("TextLabel", BG)
PercentLabel.Size = UDim2.new(1, 0, 0, 16)[span_63](start_span)[span_63](end_span)
PercentLabel.Position = UDim2.new(0, 0, 0, 152)[span_64](start_span)[span_64](end_span)
PercentLabel.BackgroundTransparency = 1[span_65](start_span)[span_65](end_span)
PercentLabel.Font = Enum.Font.Code[span_66](start_span)[span_66](end_span)
PercentLabel.TextColor3 = Color3.fromRGB(0, 255, 200)[span_67](start_span)[span_67](end_span)
PercentLabel.TextSize = 10[span_68](start_span)[span_68](end_span)
PercentLabel.Text = "0%[span_69](start_span)"[span_69](end_span)

-- ==========================================
-- ✨ THỰC THI: HIỆU ỨNG MỞ MÀN (INTRO TWEEN)
-- ==========================================
-- Cấu hình Tween phóng to kèm độ nảy (Back Out) giúp UI xuất hiện cực mượt
local introInfo = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local introTween = TweenService:Create(BG, introInfo, {
    Size = UDim2.new(0, 320, 0, 200),
    Position = UDim2.new(0.5, -160, 0.5, -100)
})
introTween:Play()
introTween.Completed:Wait() -- Đợi hiệu ứng bung ra xong hoàn toàn mới chạy tiếp chữ và phần trăm

BG.ClipsDescendants = false -- Mở lại để vòng xoay Spinner không bị cắt biên khi quay vượt khung

-- ==========================================
-- 📶 CÁC BƯỚC LOADING
-- ==========================================
local steps = {
    {status = "Đang tải giao diện...", progress = 0.30, delay = 0.6},[span_70](start_span)[span_70](end_span)
    {status = "Đang khởi tạo module...", progress = 0.65, delay = 0.7},[span_71](start_span)[span_71](end_span)
    {status = "Đang đồng bộ dữ liệu...", progress = 0.90, delay = 0.5},[span_72](start_span)[span_72](end_span)
    {status = "Hoàn tất!", progress = 1.00, delay = 0.4},[span_73](start_span)[span_73](end_span)
}

for _, step in ipairs(steps) do
    Status.Text = step.status[span_74](start_span)[span_74](end_span)
    TweenService:Create(BarFill, TweenInfo.new(step.delay, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(step.progress, 0, 1, 0)}):Play()[span_75](start_span)[span_75](end_span)
    local startPct = tonumber(PercentLabel.Text:match("%d+")) or 0[span_76](start_span)[span_76](end_span)
    local endPct = math.floor(step.progress * 100)[span_77](start_span)[span_77](end_span)
    for i = startPct, endPct do
        PercentLabel.Text = i .. "%[span_78](start_span)"[span_78](end_span)
        task.wait(step.delay / math.max(endPct - startPct, 1))[span_79](start_span)[span_79](end_span)
    end
end

task.wait(0.4)[span_80](start_span)[span_80](end_span)

-- Fade out kết thúc[span_81](start_span)[span_81](end_span)
local fadeTime = 0.4[span_82](start_span)[span_82](end_span)
TweenService:Create(BG, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()[span_83](start_span)[span_83](end_span)
TweenService:Create(Stroke, TweenInfo.new(fadeTime), {Transparency = 1}):Play()[span_84](start_span)[span_84](end_span)
for _, obj in ipairs(BG:GetDescendants()) do[span_85](start_span)[span_85](end_span)
    if obj:IsA("TextLabel") then[span_86](start_span)[span_86](end_span)
        TweenService:Create(obj, TweenInfo.new(fadeTime), {TextTransparency = 1}):Play()[span_87](start_span)[span_87](end_span)
    elseif obj:IsA("Frame") then[span_88](start_span)[span_88](end_span)
        TweenService:Create(obj, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()[span_89](start_span)[span_89](end_span)
    elseif obj:IsA("UIStroke") then[span_90](start_span)[span_90](end_span)
        TweenService:Create(obj, TweenInfo.new(fadeTime), {Transparency = 1}):Play()[span_91](start_span)[span_91](end_span)
    elseif obj:IsA("ImageLabel") then[span_92](start_span)[span_92](end_span)
        TweenService:Create(obj, TweenInfo.new(fadeTime), {ImageTransparency = 1}):Play()[span_93](start_span)[span_93](end_span)
    end
end
task.wait(fadeTime)[span_94](start_span)[span_94](end_span)
LoadGui:Destroy()[span_95](start_span)[span_95](end_span)

print("ZinNee Hub: Loading screen hoàn tất, sẵn sàng mở menu chính.")[span_96](start_span)[span_96](end_span)
