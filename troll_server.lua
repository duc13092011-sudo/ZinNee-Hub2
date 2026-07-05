-- [[ MODULE: SERVER INTERVENTION TROLL ]] --
-- Quét các kênh truyền tải dữ liệu (RemoteEvents) lỏng lẻo của Server để gửi gói tin ngắt kết nối giả lập
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local foundEvent = false

for _, child in ipairs(ReplicatedStorage:GetDescendants()) do
    if child:IsA("RemoteEvent") and (string.find(string.lower(child.Name), "kick") or string.find(string.lower(child.Name), "ban")) then
        -- Khai thác Remote lỏng lẻo để gửi tín hiệu thử nghiệm
        child:FireServer("TrollAttack", true)
        foundEvent = true
    end
end

if not foundEvent then
    -- Nếu server bảo mật tốt (FE chặt chẽ), thực hiện Kick cục bộ ngay trên máy khách để giả lập lệnh Ban
    game:GetService("Players").LocalPlayer:Kick("⚠️ [ZinNee Server Error]: Connection terminated by Remote Intervention.")
end
