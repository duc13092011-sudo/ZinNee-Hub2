-- [[ ZINNEE HUB V2 - MODULE: FAKE KICK/BAN SIMULATOR (CLIENT-SIDE) ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- 1. DỌN DẸP GIAO DIỆN GIẢ LẬP CŨ NẾU CÓ
if CoreGui:FindFirstChild("ZinNeeFakeBanGui") then
    CoreGui.ZinNeeFakeBanGui:Destroy()
end

-- 2. TẠO SCREEN GUI PHỦ TOÀN MÀN HÌNH
local FakeGui = Instance.new("ScreenGui")
FakeGui.Name = "ZinNeeFakeBanGui"
FakeGui.DisplayOrder = 999999 -- Đảm bảo hiển thị trên cùng tất cả các UI khác
FakeGui.ResetOnSpawn = false
pcall(function() FakeGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui") end)

-- 3. LỚP NỀN TỐI (BACKGROUND PHỦ KÍN MÀN HÌNH)
local Background = Instance.new("Frame", FakeGui)
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Màu nền xám tối chuẩn Roblox
Background.BackgroundTransparency = 0.15

-- 4. KHUNG THÔNG BÁO TRUNG TÂM (ERROR MODAL)
local Modal = Instance.new("Frame", Background)
Modal.Size = UDim2.new(0, 400, 0, 240)
Modal.Position = UDim2.new(0.5, -200, 0.5, -120)
Modal.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Modal.BorderSizePixel = 0
Instance.new("UICorner", Modal).CornerRadius = UDim.new(0, 8)

-- Tiêu đề thông báo lỗi
local ErrorTitle = Instance.new("TextLabel", Modal)
ErrorTitle.Size = UDim2.new(1, 0, 0, 50)
ErrorTitle.Position = UDim2.new(0, 0, 0, 10)
ErrorTitle.BackgroundTransparency = 1
ErrorTitle.Font = Enum.Font.GothamBold
ErrorTitle.TextSize = 22
ErrorTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ErrorTitle.Text = "Disconnected"

-- Nội dung lý do Ban/Kick giả (Ông có thể tự sửa text tùy thích)
local ErrorMessage = Instance.new("TextLabel", Modal)
ErrorMessage.Size = UDim2.new(0.9, 0, 0, 80)
ErrorMessage.Position = UDim2.new(0.05, 0, 0, 65)
ErrorMessage.BackgroundTransparency = 1
ErrorMessage.Font = Enum.Font.Gotham
ErrorMessage.TextSize = 14
ErrorMessage.TextColor3 = Color3.fromRGB(200, 200, 200)
ErrorMessage.TextWrapped = true
ErrorMessage.Text = "You have been permanently banned from this server by ZinNeeHub V2 Anticheat.\nReason: Exploiting detected (Speed/Fly).\n(Error Code: 267)"

-- 5. NÚT "LEAVE" GIẢ LẬP (BẤM VÀO SẼ TỰ ĐÓNG UI TROLL CHỨ KHÔNG THOÁT GAME)
local LeaveBtn = Instance.new("TextButton", Modal)
LeaveBtn.Size = UDim2.new(0.8, 0, 0, 40)
LeaveBtn.Position = UDim2.new(0.1, 0, 1, -60)
LeaveBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LeaveBtn.Font = Enum.Font.GothamMedium
LeaveBtn.TextSize = 16
LeaveBtn.TextColor3 = Color3.fromRGB(35, 35, 35)
LeaveBtn.Text = "Leave"
Instance.new("UICorner", LeaveBtn).CornerRadius = UDim.new(0, 6)

-- Xử lý sự kiện nhấn nút Leave giả -> Tự hủy UI và hồi phục màn hình bình thường
LeaveBtn.MouseButton1Click:Connect(function()
    -- Tạo hiệu ứng mờ dần rồi biến mất cho mượt mà
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local fadeOut = TweenService:Create(Background, tweenInfo, {BackgroundTransparency = 1})
    
    for _, child in ipairs(Modal:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            TweenService:Create(child, tweenInfo, {TextTransparency = 1}):Play()
        end
    end
    TweenService:Create(Modal, tweenInfo, {BackgroundTransparency = 1}):Play()
    
    fadeOut:Play()
    fadeOut.Completed:Connect(function()
        FakeGui:Destroy()
        print("🎉 Đã tắt chế độ Fake Ban. Trở lại game bình thường!")
    end)
end)

print("🎭 ZinNee Hub V2: Client-side Fake Ban Simulator Loaded.")

