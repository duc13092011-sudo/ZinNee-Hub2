-- [[ ZINNEE HUB - LOADING SCREEN (ULTRA SAFE & DIAGNOSTIC VERSION) ]] --
warn("✨ [DIAGNOSTIC] 1. Script bắt đầu chạy...")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Chống kẹt: Đợi cho đến khi hệ thống nhận diện được Người chơi
local LocalPlayer = Players.LocalPlayer
local attempts = 0
while not LocalPlayer and attempts < 100 do
    task.wait(0.1)
    LocalPlayer = Players.LocalPlayer
    attempts = attempts + 1
end

if not LocalPlayer then
    warn("❌ [DIAGNOSTIC] LỖI: Không tìm thấy LocalPlayer!")
    return
end
warn("✨ [DIAGNOSTIC] 2. Đã nhận diện Player: " .. tostring(LocalPlayer.Name))

-- Chống nghẽn vô hạn: Đợi PlayerGui tối đa 10 giây
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then
    warn("❌ [DIAGNOSTIC] LỖI: Game không chịu tải phân vùng PlayerGui!")
    return
end
warn("✨ [DIAGNOSTIC] 3. Đã tìm thấy PlayerGui thành công!")

-- Dọn dẹp bản cũ nếu có để tránh xung đột dữ liệu
if PlayerGui:FindFirstChild("ZinNeeLoader") then 
    PlayerGui.ZinNeeLoader:Destroy() 
    warn("🧹 [DIAGNOSTIC] Đã dọn dẹp bộ Loader cũ kẹt trong máy.")
end

-- Khởi tạo ScreenGui trực tiếp vào PlayerGui (Bỏ qua CoreGui để chống chết luồng)
local LoadGui = Instance.new("ScreenGui")
LoadGui.Name = "ZinNeeLoader"
LoadGui.ResetOnSpawn = false
LoadGui.Parent = PlayerGui
warn("✨ [DIAGNOSTIC] 4. Đã khởi tạo ScreenGui thành công!")

-- Cấu hình hiển thị chữ thay thế
local LOGO_TEXT = "ZN"

-- Khung nền chính
local BG = Instance.new("Frame", LoadGui)
BG.Size = UDim2.new(0, 0, 0, 0) -- Bắt đầu từ 0 để bung ra
BG.Position = UDim2.new(0.5, 0, 0.5, 0)
BG.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
BG.ClipsDescendants = true
Instance.new("UICorner", BG).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", BG)
Stroke.Color = Color3.fromRGB(140, 0, 255)
Stroke.Thickness = 1.5

-- Vòng giữ Logo
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
LogoFallbackText.Text = LOGO_TEXT

-- Vòng xoay neon xanh
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

-- Tiêu đề RGB
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

-- Các thông số tiến trình thanh loading
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

warn("✨ [DIAGNOSTIC] 5. Toàn bộ UI đã dựng xong lắp ráp vào luồng vẽ. Chuẩn bị chạy Intro...")

-- ==========================================
-- ✨ THỰC THI HIỆU ỨNG POP-UP INTRO
-- ==========================================
local introInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local introTween = TweenService:Create(BG, introInfo, {
    Size = UDim2.new(0, 320, 0, 200),
    Position = UDim2.new(0.5, -160, 0.5, -100)
})
introTween:Play()
introTween.Completed:Wait()

BG.ClipsDescendants = false
warn("✨ [DIAGNOSTIC] 6. Hiệu ứng Bung Pop-up hoàn tất! Bắt đầu trượt % tải...")

-- ==========================================
-- 📶 TIẾN TRÌNH CHẠY BIẾN ĐỔI %
-- ==========================================
local steps = {
    {status = "Đang kết nối cơ sở dữ liệu...", progress = 0.35, delay = 0.5},
    {status = "Đang cấu hình giao diện...", progress = 0.75, delay = 0.5},
    {status = "Hệ thống đã sẵn sàng!", progress = 1.00, delay = 0.4}
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

task.wait(0.2)
warn("✨ [DIAGNOSTIC] 7. Đạt 100%! Bắt đầu chạy hiệu ứng Fade-out ẩn menu chờ...")

-- ==========================================
-- 🍃 FADE OUT HOÀN TẤT
-- ==========================================
local fadeTime = 0.3
TweenService:Create(BG, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()
TweenService:Create(Stroke, TweenInfo.new(fadeTime), {Transparency = 1}):Play()
for _, obj in ipairs(BG:GetDescendants()) do
    if obj:IsA("TextLabel") then
        TweenService:Create(obj, TweenInfo.new(fadeTime), {TextTransparency = 1}):Play()
    elseif obj:IsA("Frame") then
        TweenService:Create(obj, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()
    elseif obj:IsA("UIStroke") then
        TweenService:Create(obj, TweenInfo.new(fadeTime), {Transparency = 1}):Play()
    end
end
task.wait(fadeTime)
LoadGui:Destroy()

print("🎉 [DIAGNOSTIC] ĐÃ HOÀN THÀNH TOÀN BỘ TIẾN TRÌNH LOADER CHẠY AN TOÀN!")
