-- [[ ZINNEE HUB V2 - MAIN INTERFACE (FULL REWRITE) ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Xóa UI cũ nếu đang chạy trùng
if CoreGui:FindFirstChild("ZinNeeMainGui") then
    CoreGui.ZinNeeMainGui:Destroy()
end

-- 1. TẠO SCREEN GUI
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "ZinNeeMainGui"
MainGui.ResetOnSpawn = false
pcall(function() MainGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui") end)

-- 2. KHUNG CHÍNH (MAIN FRAME)
local MainFrame = Instance.new("Frame", MainGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 350)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 9)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(140, 0, 255)
Stroke.Thickness = 1.8

-- 3. THANH TIÊU ĐỀ (TOPBAR)
local Topbar = Instance.new("Frame", MainFrame)
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 35)
Topbar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Topbar)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Text = "ZINNEE HUB V2 | Premium Edition"

local CloseBtn = Instance.new("TextButton", Topbar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 2.5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22

CloseBtn.MouseButton1Click:Connect(function()
    MainGui:Destroy()
end)

-- 4. THANH MENU BÊN CẠNH (SIDEBAR)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 130, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Sidebar.BorderSizePixel = 0

local SidebarLine = Instance.new("Frame", Sidebar)
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(1, -1, 0, 0)
SidebarLine.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
SidebarLine.BorderSizePixel = 0

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, -5, 1, -10)
TabContainer.Position = UDim2.new(0, 0, 0, 5)
TabContainer.BackgroundTransparency = 1
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabContainer.ScrollBarThickness = 0

local TabListLayout = Instance.new("UIListLayout", TabContainer)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)

-- 5. KHUNG CHỨA NỘI DUNG (CONTAINER)
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -145, 1, -45)
ContentContainer.Position = UDim2.new(0, 140, 0, 40)
ContentContainer.BackgroundTransparency = 1

-- HỆ THỐNG QUẢN LÝ TAB & MODULE
local tabs = {}
local activeTab = nil

local function CreateTab(tabName)
    local page = Instance.new("ScrollingFrame", ContentContainer)
    page.Name = tabName .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 2
    page.Visible = false
    
    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 6)
    
    local tabBtn = Instance.new("TextButton", TabContainer)
    tabBtn.Size = UDim2.new(0.9, 0, 0, 32)
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    tabBtn.Text = "  " .. tabName
    tabBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.TextSize = 12
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", tabBtn).Color = Color3.fromRGB(30, 30, 35)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.page.Visible = false
            t.btn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
            t.btn.TextColor3 = Color3.fromRGB(160, 160, 160)
        end
        page.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 60)
        tabBtn.TextColor3 = Color3.fromRGB(140, 0, 255)
    end)

    tabs[tabName] = {page = page, btn = tabBtn}
    return page
end

-- HÀM TẠO NÚT TÍNH NĂNG (ĐÃ FIX LINK USER ĐÚNG CỦA ÔNG)
local function AddFunctionButton(parentPage, btnText, githubFileName)
    local btn = Instance.new("TextButton", parentPage)
    btn.Size = UDim2.new(0.96, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    btn.Text = btnText
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(35, 35, 40)

    btn.MouseButton1Click:Connect(function()
        btnStroke.Color = Color3.fromRGB(140, 0, 255)
        task.wait(0.15)
        btnStroke.Color = Color3.fromRGB(35, 35, 40)
        
        -- Đường dẫn chuẩn hóa đến tài khoản duc13092011-sudo
        local targetURL = "https://raw.githubusercontent.com/duc13092011-sudo/ZinNee-Hub2/main/" .. githubFileName
        
        local success, err = pcall(function()
            loadstring(game:HttpGet(targetURL))()
        end)
        
        if not success then 
            warn("ZinNee Hub Error: Không thể tải module " .. githubFileName .. " -> " .. tostring(err)) 
        end
    end)
end

-- 6. KHỞI TẠO CÁC TÀB GIAO DIỆN
local HomeTab = CreateTab("Trang Chủ")
local CombatTab = CreateTab("Combat & ESP")
local MotionTab = CreateTab("Di Chuyển")

-- Thêm nội dung cho Tab Trang Chủ
local WelcomeText = Instance.new("TextLabel", HomeTab)
WelcomeText.Size = UDim2.new(0.96, 0, 0, 40)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Font = Enum.Font.Gotham
WelcomeText.TextColor3 = Color3.fromRGB(180, 180, 180)
WelcomeText.TextSize = 12
WelcomeText.Text = "Chào mừng ông đã quay trở lại với ZinNee Hub V2!\nChọn các tab bên cạnh để kích hoạt chức năng."

-- TÍCH HỢP MODULE VÀO CÁC NÚT BẤM
AddFunctionButton(CombatTab, "Kích hoạt AimBot & ESP", "aim_esp.lua")
AddFunctionButton(MotionTab, "Kích hoạt Speed & Fly", "movement.lua")

-- Mặc định mở Tab đầu tiên
tabs["Trang Chủ"].page.Visible = true
tabs["Trang Chủ"].btn.BackgroundColor3 = Color3.fromRGB(35, 20, 60)
tabs["Trang Chủ"].btn.TextColor3 = Color3.fromRGB(140, 0, 255)

-- 7. CƠ CHẾ KÉO THẢ GIAO DIỆN (SMOOTH DRAGGING)
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
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Topbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
