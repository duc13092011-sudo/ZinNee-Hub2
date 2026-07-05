-- Hệ thống lưu vị trí (Waypoint System) dành cho môi trường phát triển game
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Bảng lưu trữ danh sách các tọa độ đã lưu (Waypoints)
local SavedPositions = {}

-- 1. Hàm lưu vị trí hiện tại của nhân vật
local function SaveCurrentPosition(slotName)
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if rootPart then
        -- Lưu lại toàn bộ CFrame (bao gồm cả vị trí và góc quay hướng mặt)
        SavedPositions[slotName] = rootPart.CFrame
        print("💾 Đã lưu vị trí thành công vào ô: " .. tostring(slotName))
    else
        warn("⚠️ Không tìm thấy nhân vật để lưu vị trí.")
    end
end

-- 2. Hàm di chuyển nhân vật đến vị trí đã lưu
local function TeleportToSavedPosition(slotName)
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if rootPart then
        local targetCFrame = SavedPositions[slotName]
        if targetCFrame then
            -- Thay đổi CFrame để đưa nhân vật đến điểm chỉ định
            rootPart.CFrame = targetCFrame
            print("✨ Đã di chuyển nhân vật đến ô: " .. tostring(slotName))
        else
            warn("⚠️ Ô vị trí '" .. tostring(slotName) .. "' chưa được lưu dữ liệu.")
        end
    else
        warn("⚠️ Không tìm thấy nhân vật để di chuyển.")
    end
end

-- 3. Hàm di chuyển dựa trên vị trí chuột chỉ định (Click-to-Move cơ bản trong phát triển)
local function MoveToVector(targetVector3)
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if rootPart and targetVector3 then
        -- Cộng thêm một khoảng nhỏ theo trục Y để nhân vật không bị kẹt dưới đất
        rootPart.CFrame = CFrame.new(targetVector3 + Vector3.new(0, 3, 0))
    end
end

-- ví dụ minh họa cách vận hành hệ thống:
-- Hàng lệnh 1: Lưu vị trí đứng hiện tại vào ô mang tên "CheckPoint1"
SaveCurrentPosition("CheckPoint1")

-- Hàng lệnh 2: Sau khi nhân vật di chuyển đi chỗ khác, gọi hàm này để quay về điểm cũ
-- TeleportToSavedPosition("CheckPoint1")
