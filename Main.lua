-- [[ ZINNEE HUB - CORE INTERFACE MAIN LUA ]] --
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local MainGui = Instance.new("ScreenGui")
MainGui.Name = "ZinNeeCoreContainer"
MainGui.ResetOnSpawn = false
pcall(function() MainGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui") end)

-- Khung hiển thị chính
local MainFrame = Instance.new("Frame", MainGui)
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(140, 0, 255)

-- Cột Menu bên trái (Sidebar)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -20)
TabContainer.Position = UDim2.new(0, 0, 0, 10)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
local TabLayout = Instance.new("UIListLayout", TabContainer)
TabLayout.Padding = UDim.new(0, 4)
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Vùng hiển thị nội dung bên phải (Pages Container)
local PageViewer = Instance.new("Frame", MainFrame)
PageViewer.Size = UDim2.new(0, 360, 1, -20)
PageViewer.Position = UDim2.new(0, 150, 0, 10)
PageViewer.BackgroundTransparency = 1

local pages = {}
local currentTab = nil

-- Hàm tạo cấu trúc một Tab mới
local function CreateTab(name)
    local TabButton = Instance.new("TextButton", TabContainer)
    TabButton.Size = UDim2.new(0.9, 0, 0, 32)
    TabButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(160, 160, 160)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.TextSize = 11
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 4)
    
    local Page = Instance.new("ScrollingFrame", PageViewer)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    local PageLayout = Instance.new("UIListLayout", Page)
    PageLayout.Padding = UDim.new(0, 6)
    
    pages[name] = Page
    
    TabButton.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        Page.Visible = true
        TabButton.TextColor3 = Color3.fromRGB(140, 0, 255)
    end)
    
    return Page
end

-- Hàm tạo nút tính năng thực thi lệnh bên trong các Tab
local function CreateFunctionButton(parentPage, text, githubFileName)
    local btn = Instance.new("TextButton", parentPage)
    btn.Size = UDim2.new(0.95, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        btn.TextColor3 = Color3.fromRGB(140, 0, 255)
        task.wait(0.1)
        btn.TextColor3 = Color3.fromRGB(230, 230, 230)
        -- Gọi module từ xa
        local targetURL = "https://raw.githubusercontent.com/Cari1501/ZinNee-Hub2/main/" .. githubFileName
        local success, err = pcall(function()
            loadstring(game:HttpGet(targetURL))()
        end)
        if not success then warn("Lỗi nạp Module: " .. tostring(err)) end
    end)
end

-- ========================================================
-- 📑 KHỞI TẠO CÁC PHÂN MỤC MENU (TABS BẮT BUỘC)
-- ========================================================

local PageCombat = CreateTab("Aim & ESP")
CreateFunctionButton(PageCombat, "🚀 Kích hoạt AimBot & ESP System", "aim_esp.lua")

local PageMovement = CreateTab("Movement")
CreateFunctionButton(PageMovement, "⚡ Kích hoạt Fly / Speed / Noclip Mod", "movement.lua")

local PageBoombox = CreateTab("Boombox ID")
CreateFunctionButton(PageBoombox, "🎵 Mở bảng quản lý âm thanh Boombox", "boombox.lua")

local PageClicker = CreateTab("Auto Clicker")
CreateFunctionButton(PageClicker, "🖱️ Bật/Tắt Auto Click siêu tốc", "autoclicker.lua")

local PageTeleport = CreateTab("Teleport")
CreateFunctionButton(PageTeleport, "📍 Khởi tạo hệ thống lưu Waypoints", "teleport.lua")

local PageOptimization = CreateTab("Optimization")
CreateFunctionButton(PageOptimization, "⚙️ Tối ưu hóa Ram / Khử Lag & Boost FPS", "optimization.lua")

local PageTroll = CreateTab("Server Intervention")
CreateFunctionButton(PageTroll, "⚠️ Thực thi công cụ Troll Server (Admin/Kick/Ban)", "troll_server.lua")

-- Mặc định hiển thị Tab đầu tiên khi load xong
if pages["Aim & ESP"] then pages["Aim & ESP"].Visible = true end
