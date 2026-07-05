-- [[ MODULE: WAYPOINT SYSTEM ]] --
local Char = game:GetService("Players").LocalPlayer.Character
if not _G.Waypoints then _G.Waypoints = {} end

-- Lưu vị trí đứng hiện tại vào danh sách bộ nhớ tạm toàn cục
if Char and Char:FindFirstChild("HumanoidRootPart") then
    local currentPos = Char.HumanoidRootPart.CFrame
    table.insert(_G.Waypoints, currentPos)
    print("Đã lưu điểm mốc tọa độ số: " .. #_G.Waypoints)
end
