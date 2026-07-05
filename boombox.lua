-- [[ MODULE: BOOMBOX ID PLAYER ]] --
-- [[ ZINNEE HUB V2 - ADVANCED BOOMBOX & MEDIA PLAYER MODULE ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- 1. DỌN DẸP TRÌNH PHÁT CŨ TRÁNH ĐÈ ÂM THANH
if CoreGui:FindFirstChild("ZinNeeBoomboxConsole") then
    CoreGui.ZinNeeBoomboxConsole:Destroy()
end
if _G.ZinNeeCurrentSound then
    _G.ZinNeeCurrentSound:Stop()
    _G.ZinNeeCurrentSound:Destroy()
end

-- 2. KHỞI TẠO ĐỐI TƯỢNG ÂM THANH GỐC (LOCAL SOUND)
local CurrentSound = Instance.new("Sound")
CurrentSound.Name = "ZinNeeTrackPlayer"
CurrentSound.Volume = 2 -- Độ to âm thanh
CurrentSound.Parent = SoundService
_G.ZinNeeCurrentSound = CurrentSound

-- KHO DỮ LIỆU NHẠC PHONK (Ông có thể tự thêm ID nhạc của ông vào đây)
local MusicDatabase = {
    {Name = "🔊 INTERWORLD - Metamorphosis", Id = "9043224765"},
    {Name = "🔊 KORDHELL - Murder In My Mind", Id = "10831627885"},
    {Name = "🔊 Hensonn - Sahara", Id = "8756973340"},
    {Name = "🔊 RAIZHELL - Disaster", Id = "9212390885"},
    {Name = "🔊 PLAYAMANIA - Phonky Town", Id = "6857413645"},
    {Name = "🔊 DVRST - Close Eyes", Id = "7442650325"},
    {Name = "🔊 KXNVRA - Featan", Id = "1123495810"}
}

-- 3. KHỞI TẠO GIAO DIỆN HỘP NHẠC
local MediaGui = Instance.new("ScreenGui")
MediaGui.Name = "ZinNeeBoomboxConsole"
MediaGui.ResetOnSpawn = false
pcall(function() MediaGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui") end)

local Panel = Instance.new("Frame", MediaGui)
Panel.Size = UDim2.new(0, 260, 0, 320)
Panel.Position = UDim2.new(0.5, 100, 0.5, -160) -- Lệch phải để cân đối giao diện
Panel.BackgroundColor3 = Color3.fromRGB(11, 11, 13)
Panel.Active = true
Panel.Draggable = true
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", Panel)
Stroke.Color = Color3.fromRGB(140, 0, 255)
Stroke.Thickness = 1.6

local Title = Instance.new("TextLabel", Panel)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(140, 0, 255)
Title.TextSize = 12
Title.Text = "🎵 ZINNEE ADVANCED MEDIA PLAYER"

local CloseBtn = Instance.new("TextButton", Panel)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -25, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.MouseButton1Click:Connect(function() 
    CurrentSound:Stop()
    MediaGui:Destroy() 
end)

-- 4. Ô TÌM KIẾM BÀI HÁT (SEARCH BOX)
local SearchBar = Instance.new("TextBox", Panel)
SearchBar.Size = UDim2.new(0.9, 0, 0, 28)
SearchBar.Position = UDim2.new(0.05, 0, 0, 35)
SearchBar.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
SearchBar.Font = Enum.Font.Gotham
SearchBar.Text = ""
SearchBar.PlaceholderText = "🔍 Nhập tên bài hát hoặc ID..."
SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBar.TextSize = 11
Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0, 4)
local sStroke = Instance.new("UIStroke", SearchBar)
sStroke.Color = Color3.fromRGB(35, 35, 40)

-- 5. DANH SÁCH BÀI HÁT CUỘN (PLAYLIST SCROLL)
local PlaylistFrame = Instance.new("ScrollingFrame", Panel)
PlaylistFrame.Size = UDim2.new(0.9, 0, 0, 130)
PlaylistFrame.Position = UDim2.new(0.05, 0, 0, 70)
PlaylistFrame.BackgroundTransparency = 1
PlaylistFrame.ScrollBarThickness = 2
PlaylistFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ListLayout = Instance.new("UIListLayout", PlaylistFrame)
ListLayout.Padding = UDim.new(0, 4)

-- Hàm phát nhạc khi chọn một bài
local function PlayAudio(audioId, trackName)
    CurrentSound:Stop()
    CurrentSound.SoundId = "rbxassetid://" .. audioId
    CurrentSound:Play()
    Title.Text = "🎵 Playing: " .. string.sub(trackName, 4)
end

-- Hàm cập nhật và lọc danh sách nhạc hiển thị
local function RenderPlaylist(filterText)
    -- Xóa danh sách cũ hiển thị
    for _, child in ipairs(PlaylistFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    -- Lọc bài hát phù hợp
    for _, track in ipairs(MusicDatabase) do
        if filterText == "" or string.find(string.lower(track.Name), string.lower(filterText)) or string.find(track.Id, filterText) then
            local tBtn = Instance.new("TextButton", PlaylistFrame)
            tBtn.Size = UDim2.new(1, -5, 0, 26)
            tBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
            tBtn.Text = "  " .. track.Name
            tBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
            tBtn.Font = Enum.Font.Gotham
            tBtn.TextSize = 10.5
            tBtn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 4)
            
            tBtn.MouseButton1Click:Connect(function()
                PlayAudio(track.Id, track.Name)
            end)
        end
    end
end

-- Lắng nghe sự kiện gõ chữ trên ô tìm kiếm để lọc nhạc thời gian thực
SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    RenderPlaylist(SearchBar.Text)
end)

-- Nhấn Enter ở ô tìm kiếm để tự nạp ID lạ ở ngoài
SearchBar.FocusLost:Connect(function(enterPressed)
    if enterPressed and SearchBar.Text ~= "" then
        local targetId = SearchBar.Text:gsub("%D", "") -- Lọc lấy nguyên cụm số ID
        if targetId ~= "" then
            PlayAudio(targetId, "🔊 Custom Track ID")
        end
    end
end)

-- Khởi chạy kết xuất danh sách nhạc mặc định ban đầu
RenderPlaylist("")

-- 6. THANH ĐIỀU KHIỂN CHUNG (PLAY / PAUSE / STOP)
local ControlBar = Instance.new("Frame", Panel)
ControlBar.Size = UDim2.new(0.9, 0, 0, 32)
ControlBar.Position = UDim2.new(0.05, 0, 0, 210)
ControlBar.BackgroundTransparency = 1
local CtrlLayout = Instance.new("UIListLayout", ControlBar)
CtrlLayout.FillDirection = Enum.FillDirection.Horizontal
CtrlLayout.Padding = UDim.new(0, 5)

local function CreateCtrlBtn(text, color, callback)
    local btn = Instance.new("TextButton", ControlBar)
    btn.Size = UDim2.new(0.31, 0, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    btn.Text = text
    btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    local bStk = Instance.new("UIStroke", btn)
    bStk.Color = Color3.fromRGB(35, 35, 40)
    btn.MouseButton1Click:Connect(callback)
end

CreateCtrlBtn("▶ RESUME", Color3.fromRGB(0, 220, 100), function() CurrentSound:Play() end)
CreateCtrlBtn("⏸ PAUSE", Color3.fromRGB(240, 180, 0), function() CurrentSound:Pause() end)
CreateCtrlBtn("⏹ STOP", Color3.fromRGB(255, 60, 80), function() CurrentSound:Stop() end)

-- 7. KHU VỰC ĐIỀU CHỈNH TỐC ĐỘ (SPEED CONTROLLER)
local SpeedBar = Instance.new("Frame", Panel)
SpeedBar.Size = UDim2.new(0.9, 0, 0, 28)
SpeedBar.Position = UDim2.new(0.05, 0, 1, -65)
SpeedBar.BackgroundTransparency = 1
local SpdLayout = Instance.new("UIListLayout", SpeedBar)
SpdLayout.FillDirection = Enum.FillDirection.Horizontal
SpdLayout.Padding = UDim.new(0, 4)

local speedModes = {
    {Text = "x0.5", Value = 0.5},
    {Text = "x1.0", Value = 1.0},
    {Text = "x1.5", Value = 1.5},
    {Text = "x2.0", Value = 2.0}
}

local speedButtons = {}

for i, mode in ipairs(speedModes) do
    local sBtn = Instance.new("TextButton", SpeedBar)
    sBtn.Size = UDim2.new(0.235, 0, 1, 0)
    sBtn.BackgroundColor3 = (i == 2) and Color3.fromRGB(35, 15, 60) or Color3.fromRGB(20, 20, 24)
    sBtn.Text = mode.Text
    sBtn.TextColor3 = (i == 2) and Color3.fromRGB(140, 0, 255) or Color3.fromRGB(150, 150, 150)
    sBtn.Font = Enum.Font.Code
    sBtn.TextSize = 10
    Instance.new("UICorner", sBtn).CornerRadius = UDim.new(0, 4)
    local sBtnStk = Instance.new("UIStroke", sBtn)
    sBtnStk.Color = (i == 2) and Color3.fromRGB(140, 0, 255) or Color3.fromRGB(30, 30, 35)
    
    speedButtons[i] = {btn = sBtn, stroke = sBtnStk}
    
    sBtn.MouseButton1Click:Connect(function()
        CurrentSound.PlaybackSpeed = mode.Value -- Cài đặt tốc độ bài hát
        
        -- Đổi màu Highlight nút tốc độ hiện tại
        for idx, item in ipairs(speedButtons) do
            if idx == i then
                item.btn.BackgroundColor3 = Color3.fromRGB(35, 15, 60)
                item.btn.TextColor3 = Color3.fromRGB(140, 0, 255)
                item.stroke.Color = Color3.fromRGB(140, 0, 255)
            else
                item.btn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
                item.btn.TextColor3 = Color3.fromRGB(150, 150, 150)
                item.stroke.Color = Color3.fromRGB(30, 30, 35)
            end
        end
    end)
end

-- 8. THÔNG TIN BẢN QUYỀN NHỎ DƯỚI ĐÁY UI
local Footer = Instance.new("TextLabel", Panel)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 1, -22)
Footer.BackgroundTransparency = 1
Footer.Font = Enum.Font.SourceSansItalic
Footer.TextColor3 = Color3.fromRGB(100, 100, 100)
Footer.TextSize = 10
Footer.Text = "Tip: Paste Audio ID into search bar and press Enter to play"
