-- [[ ZINNEE HUB - LOADING SCREEN (SIGNATURE OUTRO EDITION) ]] --
print("⚙️ ZinNeeLoader: Khởi động phiên bản hoạt ảnh đóng mở đối xứng...")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Kiểm tra và dọn dẹp bộ nhớ chống trùng lặp UI
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then return end
if PlayerGui:FindFirstChild("ZinNeeLoader") then PlayerGui.ZinNeeLoader:Destroy() end

local LoadGui = Instance.new("ScreenGui")
LoadGui.Name = "ZinNeeLoader"
LoadGui.ResetOnSpawn = false
LoadGui.Parent = PlayerGui

-- ==========================================
-- 🎨 THIẾT KẾ KHUNG UI CHÍNH
-- ==========================================
local BG = Instance.new("Frame", LoadGui)
BG.Size = UDim2.new(0, 0, 0, 0) -- Khởi tạo từ 0 để bung ra
BG.Position = UDim2.new(0.5, 0, 0.5, 0)
BG.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
BG.ClipsDescendants = true -- Khóa các phần tử con không cho tràn viền khi co giãn
Instance.new("UICorner", BG).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", BG)
Stroke.Color = Color3.fromRGB(140, 0, 255)
Stroke.Thickness = 1.5

-- [Các thành phần nội dung: Logo, Vòng xoay, Chữ nghĩa]
local LogoHolder = Instance.new("Frame", BG)
LogoHolder.Size = UDim2.new(0, 56, 0, 56)
LogoHolder.Position = UDim2.new(0.5, -28, 0, 14)
LogoHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", LogoHolder).CornerRadius = UDim.new(1, 0)

local LogoStroke = Instance.new("UIStroke", LogoHolder)
LogoStroke.Color = Color3.fromRGB(140, 0, 255)
LogoStroke.Thickness = 2

local LogoFallbackText = Instance.new("TextLabel", LogoHolder)
LogoFallbackText.Size = UDim2.new(1, 0, 1, 0)
LogoFallbackText.BackgroundTransparency = 1
LogoFallbackText.Font = Enum.Font.GothamBold
LogoFallbackText.TextColor3 = Color3.fromRGB(140, 0, 255)
LogoFallbackText.TextSize = 20
LogoFallbackText.Text = "ZN"

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
-- 🎬 BIỂU DIỄN: INTRO BUNG NẢY (POP-UP)
-- ==========================================
local introInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local introTween = TweenService:Create(BG, introInfo, {
    Size = UDim2.new(0, 320, 0, 200),
    Position = UDim2.new(0.5, -160, 0.5, -100)
})
introTween:Play()
introTween.Completed:Wait()
BG.ClipsDescendants = false

-- ==========================================
-- 📶 CHẠY TIẾN TRÌNH %
-- ==========================================
local steps = {
    {status = "Đang kiểm tra phân vùng...", progress = 0.40, delay = 0.5},
    {status = "Đang tối ưu hóa UI mượt mà...", progress = 0.80, delay = 0.5},
    {status = "Kích hoạt thành công!", progress = 1.00, delay = 0.3}
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

task.wait(0.3)

-- ==========================================
-- 🛠️ ĐOẠN CUỐI ĐƯỢC SỬA ĐỔI: THU NHỎ NÉN TÂM (OUTRO TWEEN)
-- ==========================================
BG.ClipsDescendants = true -- Khóa lại để chữ nghĩa co cụm theo khung hình khi thu nhỏ
local outroTime = 0.4

-- Luồng 1: Ép khung hình thu nhỏ biến mất ngược về tâm (Dùng EasingStyle.Back để tạo độ nén)
local outroTween = TweenService:Create(BG, TweenInfo.new(outroTime, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
    Size = UDim2.new(0, 0, 0, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundTransparency = 1
})
outroTween:Play()

-- Luồng 2: Làm mờ dải viền Stroke cùng lúc
TweenService:Create(Stroke, TweenInfo.new(outroTime), {Transparency = 1}):Play()

-- Luồng 3: Quét qua làm mờ toàn bộ các chi tiết chữ, ảnh bên trong
for _, obj in ipairs(BG:GetDescendants()) do
    if obj:IsA("TextLabel") then
        TweenService:Create(obj, TweenInfo.new(outroTime - 0.1), {TextTransparency = 1}):Play()
    elseif obj:IsA("Frame") then
        TweenService:Create(obj, TweenInfo.new(outroTime - 0.1), {BackgroundTransparency = 1}):Play()
    elseif obj:IsA("UIStroke") then
        TweenService:Create(obj, TweenInfo.new(outroTime - 0.1), {Transparency = 1}):Play()
    end
end

-- Đợi hoạt ảnh kết thúc chạy xong hoàn toàn rồi mới xóa UI khỏi bộ nhớ game
outroTween.Completed:Wait()
LoadGui:Destroy()

-- ==========================================
-- 🚀 NƠI GỌI MENU CHÍNH CỦA ÔNG
-- ==========================================
print("🎉 ZinNeeLoader: Đóng màn hình chờ thành công! Sẵn sàng khởi động Menu tổng.")
