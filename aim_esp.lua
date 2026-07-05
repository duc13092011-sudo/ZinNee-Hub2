-- [[ MODULE: AIM & ESP INTERNALS ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Bản vẽ ESP đơn giản sử dụng Highlight của Roblox (Hiệu quả cao, không lag)
for _, v in ipairs(Players:GetPlayers()) do
    if v ~= LocalPlayer and v.Character then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ZinNeeESP"
        highlight.FillColor = Color3.fromRGB(140, 0, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Parent = v.Character
    end
end
print("System: ESP Modules injected successfully.")
