-- [[ ZINNEE HUB - LOADING SCREEN (CLASSIC FADE EDITION WITH MAIN LINK) ]] --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Kiểm tra phân vùng PlayerGui an toàn
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then return end
if PlayerGui:FindFirstChild("ZinNeeLoader") then PlayerGui.ZinNeeLoader:Destroy() end

local LoadGui = Instance.new("ScreenGui")
LoadGui.Name = "ZinNeeLoader[span_0](start_span)"[span_0](end_span)
LoadGui.ResetOnSpawn = false[span_1](start_span)[span_1](end_span)
LoadGui.Parent = PlayerGui

-- ==========================================
-- ⚙️ CẤU HÌNH LOGO & KHUNG NỀN (HIỆN TRỰC TIẾP)
-- ==========================================
local LOGO_IMAGE_ID = "rbxassetid://0" -- thay số 0 bằng ID ảnh của bạn[span_2](start_span)[span_2](end_span)
local LOGO_TEXT = "ZN" --[span_3](start_span)[span_3](end_span)

local BG = Instance.new("Frame", LoadGui)
BG.Size = UDim2.new(0, 320, 0, 200) -- Hiện thẳng kích thước chuẩn[span_4](start_span)[span_4](end_span)
BG.Position = UDim2.new(0.5, -160, 0.5, -100) -- Nằm giữa màn hình[span_5](start_span)[span_5](end_span)
BG.BackgroundColor3 = Color3.fromRGB(12, 12, 12)[span_6](start_span)[span_6](end_span)
Instance.new("UICorner", BG).CornerRadius = UDim.new(0, 10)[span_7](start_span)[span_7](end_span)

local Stroke = Instance.new("UIStroke", BG)
Stroke.Color = Color3.fromRGB(140, 0, 255)[span_8](start_span)[span_8](end_span)
Stroke.Thickness = 1.5[span_9](start_span)[span_9](end_span)

-- ==========================================
-- 🖼️ LOGO TRUNG TÂM
-- ==========================================
local LogoHolder = Instance.new("Frame", BG)
LogoHolder.Size = UDim2.new(0, 56, 0, 56)
LogoHolder.Position = UDim2.new(0.5, -28, 0, 14)
LogoHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", LogoHolder).CornerRadius = UDim.new(1, 0)
local LogoStroke = Instance.new("UIStroke", LogoHolder)
LogoStroke.Color = Color3.fromRGB(140, 0, 255)
LogoStroke.Thickness = 2

local LogoImage = Instance.new("ImageLabel", LogoHolder)
LogoImage.Size = UDim2.new(1, -10, 1, -10)
LogoImage.Position = UDim2.new(0, 5, 0, 5)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = LOGO_IMAGE_ID
Instance.new("UICorner", LogoImage).CornerRadius = UDim.new(1, 0)

local LogoFallbackText = Instance.new("TextLabel", LogoHolder)
LogoFallbackText.Size = UDim2.new(1, 0, 1, 0)
LogoFallbackText.BackgroundTransparency = 1
LogoFallbackText.Font = Enum.Font.GothamBold
LogoFallbackText.TextColor3 = Color3.fromRGB(140, 0, 255)
LogoFallbackText.TextSize = 20
LogoFallbackText.Text = LOGO_TEXT
LogoFallbackText.Visible = (LOGO_IMAGE_ID == "rbxassetid://0")

-- Vòng xoay Neon xanh
local Spinner = Instance.new("Frame", LogoHolder)
Spinner.Size = UDim2.new(1, 8, 1, 8)
Spinner.Position = UDim2.new(0, -4, 0, -4)
Spinner.BackgroundTransparency = 1
local SpinnerStroke = Instance.new("UIStroke", Spinner)
SpinnerStroke.Color = Color3.fromRGB(0, 255, 200)
SpinnerStroke.Thickness = 2
Instance.new("UICorner", Spinner).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    while LoadGui and LoadGui.Parent do
        Spinner.Rotation = (Spinner.Rotation + 4) % 360
        task.wait(0.03)
    end
end)

-- ==========================================
-- 🔤 TIÊU ĐỀ RGB & THANH TIẾN TRÌNH
-- ==========================================
local Title = Instance.new("TextLabel", BG)
Title.Size = UDim2.new(1, 0, 0, 24)
Title.Position = UDim2.new(0, 0, 0, 76)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Text = "ZINNEE HUB"

task.spawn(function()
    while LoadGui and LoadGui.Parent do
        for h = 0, 1, 0.01 do
            if not Title.Parent then break end
            Title.TextColor3 = Color3.fromHSV(h, 0.75, 1)
            task.wait(0.02)
        end
    end
end)

local Status = Instance.new("TextLabel", BG)
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Position = UDim2.new(0, 0, 0, 104)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.GothamSemibold
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.TextSize = 11
Status.Text = "Đang khởi động..."

local BarBg = Instance.new("Frame", BG)
BarBg.Size = UDim2.new(0.85, 0, 0, 6)
BarBg.Position = UDim2.new(0.075, 0, 0, 140)
BarBg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", BarBg)

local BarFill = Instance.new("Frame", BarBg)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
Instance.new("UICorner", BarFill)

local PercentLabel = Instance.new("TextLabel", BG)
PercentLabel.Size = UDim2.new(1, 0, 0, 16)
PercentLabel.Position = UDim2.new(0, 0, 0, 152)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Font = Enum.Font.Code
PercentLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
PercentLabel.TextSize = 10
PercentLabel.Text = "0%"

-- ==========================================
-- 📶 TIẾN TRÌNH CHẠY % TẢI
-- ==========================================
local steps = {
    {status = "Đang tải giao diện...", progress = 0.30, delay = 0.6},[span_10](start_span)[span_10](end_span)
    {status = "Đang khởi tạo module...", progress = 0.65, delay = 0.7},[span_11](start_span)[span_11](end_span)
    {status = "Đang đồng bộ dữ liệu...", progress = 0.90, delay = 0.5},[span_12](start_span)[span_12](end_span)
    {status = "Hoàn tất!", progress = 1.00, delay = 0.4},[span_13](start_span)[span_13](end_span)
}

for _, step in ipairs(steps) do
    Status.Text = step.status[span_14](start_span)[span_14](end_span)
    TweenService:Create(BarFill, TweenInfo.new(step.delay, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(step.progress, 0, 1, 0)}):Play()[span_15](start_span)[span_15](end_span)
    local startPct = tonumber(PercentLabel.Text:match("%d+")) or 0[span_16](start_span)[span_16](end_span)
    local endPct = math.floor(step.progress * 100)[span_17](start_span)[span_17](end_span)
    for i = startPct, endPct do
        PercentLabel.Text = i .. "%[span_18](start_span)"[span_18](end_span)
        task.wait(step.delay / math.max(endPct - startPct, 1))[span_19](start_span)[span_19](end_span)
    end
end

task.wait(0.4)[span_20](start_span)[span_20](end_span)

-- ==========================================
-- 🍃 ĐOẠN CUỐI: FADE OUT MỜ DẦN TRUYỀN THỐNG
-- ==========================================
local fadeTime = 0.4[span_21](start_span)[span_21](end_span)
TweenService:Create(BG, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()[span_22](start_span)[span_22](end_span)
TweenService:Create(Stroke, TweenInfo.new(fadeTime), {Transparency = 1}):Play()[span_23](start_span)[span_23](end_span)
for _, obj in ipairs(BG:GetDescendants()) do[span_24](start_span)[span_24](end_span)
    if obj:IsA("TextLabel") then[span_25](start_span)[span_25](end_span)
        TweenService:Create(obj, TweenInfo.new(fadeTime), {TextTransparency = 1}):Play()[span_26](start_span)[span_26](end_span)
    elseif obj:IsA("Frame") then[span_27](start_span)[span_27](end_span)
        TweenService:Create(obj, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()[span_28](start_span)[span_28](end_span)
    elseif obj:IsA("UIStroke") then[span_29](start_span)[span_29](end_span)
        TweenService:Create(obj, TweenInfo.new(fadeTime), {Transparency = 1}):Play()[span_30](start_span)[span_30](end_span)
    elseif obj:IsA("ImageLabel") then[span_31](start_span)[span_31](end_span)
        TweenService:Create(obj, TweenInfo.new(fadeTime), {ImageTransparency = 1}):Play()[span_32](start_span)[span_32](end_span)
    end
end
task.wait(fadeTime)[span_33](start_span)[span_33](end_span)
LoadGui:Destroy()[span_34](start_span)[span_34](end_span)

-- ==========================================
-- 🚀 KÍCH HOẠT ĐƯỜNG LINK MENU CHÍNH
-- ==========================================
print("ZinNee Hub: Loading screen hoàn tất, sẵn sàng mở menu chính.")[span_35](start_span)[span_35](end_span)

pcall(function()
    -- LƯU Ý: Thay cái link ví dụ bên dưới thành link raw (GitHub/Pastebin) chứa code menu chính của ông nhé!
    loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/YourRepo/main/main.lua"))()
end)
