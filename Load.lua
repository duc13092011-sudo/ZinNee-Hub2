-- [[ ZINNEE HUB - STANDALONE LOADING SCREEN ]] --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Kiểm tra và dọn dẹp phân vùng PlayerGui an toàn
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then return end
if PlayerGui:FindFirstChild("ZinNeeLoader") then PlayerGui.ZinNeeLoader:Destroy() end

local LoadGui = Instance.new("ScreenGui")
LoadGui.Name = "ZinNeeLoader"
LoadGui.ResetOnSpawn = false
LoadGui.Parent = PlayerGui

-- ==========================================
-- ⚙️ CẤU HÌNH LOGO & KHUNG NỀN (HIỆN TRỰC TIẾP)
-- ==========================================
local LOGO_IMAGE_ID = "rbxassetid://0" -- thay số 0 bằng ID ảnh của bạn (nếu có)
local LOGO_TEXT = "ZN" -- Chữ hiển thị thay thế nếu không dùng ảnh

local BG = Instance.new("Frame", LoadGui)
BG.Size = UDim2.new(0, 320, 0, 200) -- Hiện thẳng kích thước chuẩn
BG.Position = UDim2.new(0.5, -160, 0.5, -100) -- Nằm giữa màn hình
BG.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Instance.new("UICorner", BG).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", BG)
Stroke.Color = Color3.fromRGB(140, 0, 255)
Stroke.Thickness = 1.5

-- ==========================================
-- 🖼️ LOGO TRUNG TÂM & VÒNG XOAY NEON
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

-- Vòng xoay Neon xanh cyan xung quanh Logo
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
Status.Text = "Đang tải giao diện..."

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
-- 📶 TIẾN TRÌNH CHẠY CHUYỂN ĐỔI % TẢI
-- ==========================================
local steps = {
    {status = "Đang kết nối GitHub...", progress = 0.30, delay = 0.6},
    {status = "Đang khởi tạo module...", progress = 0.65, delay = 0.7},
    {status = "Đang đồng bộ dữ liệu...", progress = 0.90, delay = 0.5},
    {status = "Hoàn tất!", progress = 1.00, delay = 0.4},
}

for _, step in ipairs(steps) do
    Status.Text = step.status
    TweenService:Create(BarFill, TweenInfo.new(step.delay, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(step.progress, 0, 1, 0)}):Play()
    local startPct = tonumber(PercentLabel.Text:match("%d+")) or 0
    local endPct = math.floor(step.progress * 100)
    for i = startPct, endPct do
        PercentLabel.Text = i .. "%"
        task.wait(step.delay / math.max(endPct - startPct, 1))
    end
end

task.wait(0.4)

-- ==========================================
-- 🍃 ĐOẠN CUỐI: FADE OUT MỜ DẦN & XÓA UI
-- ==========================================
local fadeTime = 0.4
TweenService:Create(BG, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()
TweenService:Create(Stroke, TweenInfo.new(fadeTime), {Transparency = 1}):Play()
for _, obj in ipairs(BG:GetDescendants()) do
    if obj:IsA("TextLabel") then
        TweenService:Create(obj, TweenInfo.new(fadeTime), {TextTransparency = 1}):Play()
    elseif obj:IsA("Frame") then
        TweenService:Create(obj, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()
    elseif obj:IsA("UIStroke") then
        TweenService:Create(obj, TweenInfo.new(fadeTime), {Transparency = 1}):Play()
    elseif obj:IsA("ImageLabel") then
        TweenService:Create(obj, TweenInfo.new(fadeTime), {ImageTransparency = 1}):Play()
    end
end
task.wait(fadeTime)
LoadGui:Destroy()

-- ==========================================
-- 🚀 TỰ ĐỘNG KÍCH HOẠT LINK RAW MENU CHÍNH CỦA ÔNG
-- ==========================================
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/duc13092011-sudo/ZinNee-Hub2/main/main.lua"))()
end)
