-- [[ MODULE: BOOMBOX ID PLAYER ]] --
-- Tìm kiếm các vật phẩm dạng Boombox trong hòm đồ hoặc trên nhân vật để nạp ID nhạc công cộng
local LocalPlayer = game:GetService("Players").LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local Tool = Backpack:FindFirstChildOfClass("Tool") or LocalPlayer.Character:FindFirstChildOfClass("Tool")

if Tool and Tool:FindFirstChild("Remote") then
    -- Thử nghiệm kích hoạt bản nhạc huyền thoại qua RemoteEvent của Tool
    Tool.Remote:PlaySong(1843358057) -- Ví dụ ID âm thanh công cộng
else
    print("Thông báo: Bạn cần trang bị Boombox trên tay trước khi nạp ID.")
end
