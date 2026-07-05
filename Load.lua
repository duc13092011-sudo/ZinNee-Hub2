-- [[ ZINNEE HUB - BOOTLOADER LUA ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- Khởi tạo UI Loading
local LoadGui = Instance.new("ScreenGui")
LoadGui.Name = "ZinNeeLoader"
LoadGui.ResetOnSpawn = false
pcall(function() LoadGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui") end)

local BG = Instance.new("Frame", LoadGui)
BG.Size = UDim2.new(0, 320, 0, 140)
BG.Position = UDim2.new(0.5, -160, 0.5, -70)
BG.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Instance.new("UICorner", BG).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", BG)
Stroke.Color = Color3.fromRGB(140, 0, 255)
Stroke.Thickness = 1.5

local Title = Instance.new("TextLabel", BG)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Text = "ZINNEE HUB V2"

local Status = Instance.new("TextLabel", BG)
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Position = UDim2.new(0, 0, 0, 40)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.GothamSemibold
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.TextSize = 11
Status.Text = "Checking whitelist..."

local BarBg = Instance.new("Frame", BG)
BarBg.Size = UDim2.new(0.85, 0, 0, 6)
BarBg.Position = UDim2.new(0.075, 0, 0, 80)
BarBg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", BarBg)

local BarFill = Instance.new("Frame", BarBg)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
Instance.new("UICorner", BarFill)

-- Tiến trình chạy Loading mô phỏng thực tế
local steps = {
    {status = "Connecting to database...", progress = 0.15, delay = 0.8},
    {status = "Loading UI elements...", progress = 0.45, delay = 1.2},
    {status = "Injecting core modules...", progress = 0.75, delay = 0.6},
    {status = "Bypassing internal check...", progress = 0.90, delay = 1.5},
    {status = "Done! Ready to execute.", progress = 1.00, delay = 0.5}
}

for _, step in ipairs(steps) do
    Status.Text = step.status
    TweenService:Create(BarFill, TweenInfo.new(step.delay, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(step.progress, 0, 1, 0)}):Play()
    task.wait(step.delay)
end

-- Đứng hình 3 giây khi hoàn thành (Tạo độ Real)
Status.Text = "Execution stabilization (3s)..."
task.wait(3)

-- Hủy UI Loading và gọi Main Menu
LoadGui:Destroy()

-- Thay URL bằng link GitHub của ông
loadstring(game:HttpGet("https://raw.githubusercontent.com/Cari1501/ZinNee-Hub2/main/Main.lua"))()

-- Tiêu đề
local Title = Instance.new("TextLabel", LoadFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "🔮 ZinNee Hub v4.0"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1

-- Thanh Loading bên dưới
local BarBg = Instance.new("Frame", LoadFrame)
BarBg.Size = UDim2.new(0.8, 0, 0, 10)
BarBg.Position = UDim2.new(0.1, 0, 0.6, 0)
BarBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame", BarBg)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

-- Hiệu ứng chạy thanh phần trăm và tải Main Menu
task.spawn(function()
    TweenService:Create(BarFill, TweenInfo.new(2.2, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(2.3)
    
    -- Tự xóa giao diện loading sau khi hoàn thành
    LoadingGui:Destroy()
    
    -- GỌI FILE MAIN TỪ REPOSITORY MỚI (ZinNee-Hub2)
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/duc13092011-sudo/ZinNee-Hub2/main/Main.lua", true))()
    end)
end)
