-- [[ ZINNEE HUB - LOADING SCREEN ]] --
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Tạo ScreenGui
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "ZinNeeLoading"
LoadingGui.Parent = CoreGui
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame Nền
local LoadFrame = Instance.new("Frame", LoadingGui)
LoadFrame.Size = UDim2.new(0, 300, 0, 150)
LoadFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
LoadFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
LoadFrame.BackgroundTransparency = 0.1
Instance.new("UICorner", LoadFrame).CornerRadius = UDim.new(0, 10)

-- Viền tím Neon
local Stroke = Instance.new("UIStroke", LoadFrame)
Stroke.Color = Color3.fromRGB(140, 0, 255)
Stroke.Thickness = 2

-- Title
local Title = Instance.new("TextLabel", LoadFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "ZinNee Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1

-- Thanh Loading
local BarBg = Instance.new("Frame", LoadFrame)
BarBg.Size = UDim2.new(0.8, 0, 0, 10)
BarBg.Position = UDim2.new(0.1, 0, 0.6, 0)
BarBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame", BarBg)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(140, 0, 255)
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

-- Hiệu ứng chạy thanh Loading
task.spawn(function()
    TweenService:Create(BarFill, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(2.6)
    
    -- Sau khi xong, xóa Loading và load Main
    LoadingGui:Destroy()
    
    -- GỌI FILE MAIN TỪ GITHUB
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/duc13092011-sudo/ZinNee-Hub/main/Main.lua", true))()
    end)
end)
