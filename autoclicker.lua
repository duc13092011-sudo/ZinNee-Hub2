-- [[ MODULE: AUTOMATIC MOUSE CLICKER ]] --
local VirtualInputManager = game:GetService("VirtualInputManager")
_G.AutoClickActive = not _G.AutoClickActive

task.spawn(function()
    while _G.AutoClickActive do
        -- Tự động giả lập bấm chuột trái tại tâm màn hình mỗi 0.05 giây
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        task.wait(0.05)
    end
end)
