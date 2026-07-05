-- [[ ZINNEE HUB V4.0 - LOADING SCREEN (UPDATED REPO 2) ]] --
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Tạo ScreenGui
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "ZinNeeLoading_NewRepo"
LoadingGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame Nền (Đen mờ)
local LoadFrame = Instance.new("Frame", LoadingGui)
LoadFrame.Size = UDim2.new(0, 300, 0, 150)
LoadFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
LoadFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
LoadFrame.BackgroundTransparency = 0.15
Instance.new("UICorner", LoadFrame).CornerRadius = UDim.new(0, 10)

-- Viền tím Neon
local Stroke = Instance.new("UIStroke", LoadFrame)
Stroke.Color = Color3.fromRGB(140, 0, 255)
Stroke.Thickness = 2

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
