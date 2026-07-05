-- [[ MODULE: MOVEMENT CONTROLS ]] --
local LocalPlayer = game:GetService("Players").LocalPlayer
local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")

-- Tăng tốc độ chạy và nhảy mặc định lên mức an toàn cao
Hum.WalkSpeed = 80
Hum.JumpPower = 120

-- Cơ chế Noclip (Xuyên tường) qua vòng lặp RunService
game:GetService("RunService").Stepped:Connect(function()
    if Char then
        for _, part in ipairs(Char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)
print("System: Movement overrides completed.")
