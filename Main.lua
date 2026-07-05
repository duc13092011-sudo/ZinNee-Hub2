-- [[ ZINNEE HUB V2 - FULL UNIVERSAL MENU (REWRITTEN 2026) ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Xóa UI cũ nếu đang chạy trùng tránh đè màn hình
if CoreGui:FindFirstChild("ZinNeeMainGui") then
    CoreGui.ZinNeeMainGui:Destroy()
end

-- 1. KHỞI TẠO SCREEN GUI GỐC
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "ZinNeeMainGui"
MainGui.ResetOnSpawn = false
pcall(function() MainGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui") end)

-- 2. KHUNG GIAO DIỆN CHÍNH (MAIN FRAME)
local MainFrame = Instance.new("Frame", MainGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, 360)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 9)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(140, 0, 255) -- Màu Tím Neon chủ đạo
Stroke.Thickness = 1.8

-- 3. THANH TIÊU ĐỀ (TOPBAR)
local Topbar = Instance.new("Frame", MainFrame)
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 38)
Topbar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Topbar)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Text = "🔮 ZINNEE HUB V2 | Modular Edition"

local CloseBtn = Instance.new("TextButton", Topbar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 4)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.MouseButton1Click:Connect(function() MainGui:Destroy() end)

-- 4. THANH SIDEBAR CHỨA CÁC TAB (BÊN TRÁI)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 140, 1, -38)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Sidebar.BorderSizePixel = 0

local SidebarLine = Instance.new("Frame", Sidebar)
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(1, -1, 0, 0)
SidebarLine.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
SidebarLine.BorderSizePixel = 0

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, -6, 1, -10)
TabContainer.Position = UDim2.new(0, 3, 0, 5)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 1
TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y -- Tự mở rộng khi thêm nhiều Tab

local TabListLayout = Instance.new("UIListLayout", TabContainer)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 5. VÙNG KHÔNG GIAN HIỂN THỊ NỘI DUNG CHỨC NĂNG (BÊN PHẢI)
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -155, 1, -48)
ContentContainer.Position = UDim2.new(0, 150, 0, 43)
ContentContainer.BackgroundTransparency = 1

local tabs = {}

-- HÀM KHỞI TẠO MỘT TAB MỚI
local function CreateTab(tabName)
    local page = Instance.new("ScrollingFrame", ContentContainer)
    page.Name = tabName .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.Visible = false
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 6)
    pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local tabBtn = Instance.new("TextButton", TabContainer)
    tabBtn.Size = UDim2.new(0.95, 0, 0, 32)
    tabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    tabBtn.Text = "  " .. tabName
    tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.TextSize = 11
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 4)
    local btnStroke = Instance.new("UIStroke", tabBtn)
    btnStroke.Color = Color3.fromRGB(25, 25, 30)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.page.Visible = false
            t.btn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
            t.btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            t.stroke.Color = Color3.fromRGB(25, 25, 30)
        end
        page.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(30, 15, 55)
        tabBtn.TextColor3 = Color3.fromRGB(140, 0, 255)
        btnStroke.Color = Color3.fromRGB(140, 0, 255)
    end)

    tabs[tabName] = {page = page, btn = tabBtn, stroke = btnStroke}
    return page
end

-- HÀM THÊM NÚT KÍCH HOẠT MODULE TỪ XA
local function AddFunctionButton(parentPage, btnText, githubFileName)
    local btn = Instance.new("TextButton", parentPage)
    btn.Size = UDim2.new(0.96, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    btn.Text = btnText
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11.5
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(32, 32, 38)

    btn.MouseButton1Click:Connect(function()
        btnStroke.Color = Color3.fromRGB(140, 0, 255)
        task.wait(0.12)
        btnStroke.Color = Color3.fromRGB(32, 32, 38)
        
        -- Đường dẫn thô chính xác tuyệt đối tới repository của ông
        local targetURL = "https://raw.githubusercontent.com/duc13092011-sudo/ZinNee-Hub2/main/" .. githubFileName
        
        local success, err = pcall(function()
            loadstring(game:HttpGet(targetURL))()
        end)
        
        if not success then 
            warn("ZinNee Hub Error: Không tìm thấy file con " .. githubFileName .. " trên GitHub!") 
        end
    end)
end

-- ========================================================
-- 🛠️ KHỞI TẠO TOÀN BỘ 7 TAB CHỨC NĂNG THEO YÊU CẦU
-- ========================================================

-- Tab 1: Trang chủ chào mừng
local HomeTab = CreateTab("Trang Chủ")
local Welcome = Instance.new("TextLabel", HomeTab)
Welcome.Size = UDim2.new(0.95, 0, 0, 50)
Welcome.BackgroundTransparency = 1
Welcome.Font = Enum.Font.Gotham
Welcome.TextColor3 = Color3.fromRGB(160, 160, 160)
Welcome.TextSize = 11
Welcome.Text = "Chào mừng ông bạn đã quay trở lại với ZinNee Hub V2!\nHệ thống modular đã đồng bộ hóa thành công."

-- Tab 2: Aim & ESP
local CombatTab = CreateTab("Aim & ESP")
AddFunctionButton(CombatTab, "🎯 Bật Hệ Thống AimBot & ESP", "aim_esp.lua")

-- Tab 3: Speed, Fly & Noclip
local MovementTab = CreateTab("Movement Mod")
AddFunctionButton(MovementTab, "⚡ Kích hoạt Speed / Fly / Noclip", "movement.lua")

-- Tab 4: Boombox ID
local BoomboxTab = CreateTab("Boombox ID")
AddFunctionButton(BoomboxTab, "🎵 Mở Bảng Quản Lý Nhạc Boombox", "boombox.lua")

-- Tab 5: Auto Clicker
local ClickerTab = CreateTab("Auto Clicker")
AddFunctionButton(ClickerTab, "🖱️ Kích hoạt Auto Click Siêu Tốc", "autoclicker.lua")

-- Tab 6: Teleport Waypoints
local TeleportTab = CreateTab("Teleport List")
AddFunctionButton(TeleportTab, "📍 Khởi tạo Điểm Mốc Dịch Chuyển", "teleport.lua")

-- Tab 7: Optimization (Fix lag / Boost FPS)
local OptizTab = CreateTab("Optimization")
AddFunctionButton(OptizTab, "⚙️ Dọn Dẹp Ram & Boost FPS Tối Đa", "optimization.lua")

-- Tab 8: Server Intervention (Troll Kick/Ban)
local TrollTab = CreateTab("Server Troll")
AddFunctionButton(TrollTab, "⚠️ Thực thi Lệnh Can Thiệp Máy Chủ", "troll_server.lua")

-- MẶC ĐỊNH MỞ TAB TRANG CHỦ KHI LOAD XONG
tabs["Trang Chủ"].page.Visible = true
tabs["Trang Chủ"].btn.BackgroundColor3 = Color3.fromRGB(30, 15, 55)
tabs["Trang Chủ"].btn.TextColor3 = Color3.fromRGB(140, 0, 255)
tabs["Trang Chủ"].stroke.Color = Color3.fromRGB(140, 0, 255)

-- ========================================================
-- 🖱️ CƠ CHẾ KÉO THẢ DI CHUYỂN MENU (SMOOTH DRAGGING)
-- ========================================================
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

Topbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)
