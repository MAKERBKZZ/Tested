-- ===================================================
-- ⚙️ TabPlayersConfig.lua
-- ===================================================

local TabPlayersConfig = {}

-- ========== SPEED HACK ==========
function TabPlayersConfig.SetSpeed(value)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = value
    end
    WindUI:Notify({
        Title = "Speed Hack",
        Content = "WalkSpeed set to " .. value,
        Duration = 2
    })
end

function TabPlayersConfig.ResetSpeed()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 18
    end
    WindUI:Notify({
        Title = "SpeedHack Reset",
        Content = "WalkSpeed dikembalikan ke normal (18)",
        Duration = 2
    })
end

-- ========== INFINITY JUMP ==========
function TabPlayersConfig.ToggleInfinityJump(state)
    _G.InfinityJumpEnabled = state
    local UserInputService = game:GetService("UserInputService")
    local player = game.Players.LocalPlayer

    if _G.InfinityJumpConnection then
        _G.InfinityJumpConnection:Disconnect()
        _G.InfinityJumpConnection = nil
    end

    if state then
        local function tryJump()
            local char = player.Character or player.CharacterAdded:Wait()
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
        _G.InfinityJumpConnection = UserInputService.JumpRequest:Connect(function()
            if _G.InfinityJumpEnabled then
                tryJump()
            end
        end)
        WindUI:Notify({Title="Infinity Jump", Content="Enabled", Duration=2})
    else
        WindUI:Notify({Title="Infinity Jump", Content="Disabled", Duration=2})
    end
end

-- ========== NOCLIP ==========
function TabPlayersConfig.ToggleNoclip(state)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()

    if state then
        _G.NoclipConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        WindUI:Notify({Title="Noclip", Content="Enabled", Duration=2})
    else
        if _G.NoclipConnection then
            _G.NoclipConnection:Disconnect()
            _G.NoclipConnection = nil
        end
        if char then
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        WindUI:Notify({Title="Noclip", Content="Disabled", Duration=2})
    end
end

-- ========== FLY LITTLE ==========
local runService = game:GetService("RunService")
local bp, floatConnection
local floatHeight = 3
local walkOnWaterEnabled = false

local function setupFloat()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(0, math.huge, 0)
    bp.D = 15
    bp.P = 2000
    bp.Position = hrp.Position
    bp.Parent = hrp

    floatConnection = runService.RenderStepped:Connect(function()
        if walkOnWaterEnabled and hrp and hrp.Parent then
            local ray = Ray.new(hrp.Position, Vector3.new(0, -50, 0))
            local part, pos = workspace:FindPartOnRay(ray, char)
            if part and (part.Material == Enum.Material.Water or part.Name:lower():find("lava")) then
                bp.Position = Vector3.new(hrp.Position.X, pos.Y + floatHeight, hrp.Position.Z)
            else
                bp.Position = hrp.Position
            end
        end
    end)
end

function TabPlayersConfig.ToggleFlyLittle(state)
    walkOnWaterEnabled = state
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    if state then
        setupFloat()
        WindUI:Notify({Title="Fly Little", Content="Enabled", Duration=2})
    else
        if floatConnection then
            floatConnection:Disconnect()
            floatConnection = nil
        end
        if bp then
            bp:Destroy()
            bp = nil
        end
        WindUI:Notify({Title="Fly Little", Content="Disabled", Duration=2})
    end
end

-- ========== PLAYER ESP ==========
function TabPlayersConfig.ToggleESP(state)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local CoreGui = game:GetService("CoreGui")

    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = player.Name
                highlight.FillColor = Color3.fromRGB(0, 170, 255)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = player.Character
            end
        end
        WindUI:Notify({Title="Player ESP", Content="Enabled", Duration=2})
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChildOfClass("Highlight")
                if highlight then highlight:Destroy() end
            end
        end
        WindUI:Notify({Title="Player ESP", Content="Disabled", Duration=2})
    end
end

return TabPlayersConfig
