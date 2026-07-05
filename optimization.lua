-- [[ MODULE: FPS BOOST & LAG FIX ]] --
-- Duyệt qua toàn bộ map, hạ cấp các hiệu ứng phức tạp không cần thiết để giải phóng tài nguyên CPU/GPU
for _, object in ipairs(workspace:GetDescendants()) do
    if object:IsA("Decal") or object:IsA("Texture") then
        object:Destroy() -- Xóa chất liệu bề mặt để tăng tốc độ dựng hình
    elseif object:IsA("PostEffect") then
        object.Enabled = false -- Tắt hiệu ứng làm mờ, đổ bóng chuyên sâu
    end
end
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
print("System: Graphics memory clean up achieved.")
