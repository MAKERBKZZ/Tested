-- ===========================
-- 📦 CFrameGrabber.lua
-- ===========================
local CFrameGrabber = {}

function CFrameGrabber.GetCurrentCFrame()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local cframe = player.Character.HumanoidRootPart.CFrame
        return string.format(
            "CFrame.new(%.6f, %.6f, %.6f, %.6f, %.8f, %.6f, %.8f, %.6f, %.8f, %.6f, %.8f, %.6f)",
            cframe:GetComponents()
        )
    else
        return "Tidak dapat mengambil CFrame (karakter tidak ditemukan)"
    end
end

return CFrameGrabber
