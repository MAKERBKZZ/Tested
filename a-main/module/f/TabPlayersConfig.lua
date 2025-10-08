-- ===================================================
-- ⚙️ TabPlayersConfig.lua
-- ===================================================
-- Berisi implementasi fitur: Speed Hack, Infinity Jump,
-- Noclip, Fly Little, dan ESP.
-- ===================================================

local PlayersConfig = {}
PlayersConfig.__index = PlayersConfig

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Variabel status fitur
local isSpeedHackEnabled = false
local isInfinityJumpEnabled = false
local isNoclipEnabled = false
local isFlyEnabled = false
local isESPEnabled = false
local flyVelocity

-- 🏃 SPEED HACK
function PlayersConfig.SpeedHack(speed)
	if Humanoid and speed then
		Humanoid.WalkSpeed = speed
	end
end

function PlayersConfig.ResetSpeed()
	if Humanoid then
		Humanoid.WalkSpeed = 16
	end
end

-- 🦘 INFINITY JUMP
UserInputService.JumpRequest:Connect(function()
	if isInfinityJumpEnabled and Humanoid then
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

function PlayersConfig.ToggleInfinityJump(state)
	isInfinityJumpEnabled = state
end

-- 🧱 NOCLIP
RunService.Stepped:Connect(function()
	if isNoclipEnabled and Character then
		for _, part in pairs(Character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide then
				part.CanCollide = false
			end
		end
	end
end)

function PlayersConfig.ToggleNoclip(state)
	isNoclipEnabled = state
end

-- 🕊️ FLY LITTLE
function PlayersConfig.ToggleFly(state)
	isFlyEnabled = state
	if not Character or not Humanoid then return end

	if state then
		local root = Character:FindFirstChild("HumanoidRootPart")
		if root then
			flyVelocity = Instance.new("BodyVelocity")
			flyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
			flyVelocity.Velocity = Vector3.new(0, 25, 0)
			flyVelocity.Parent = root
		end
	else
		if flyVelocity then
			flyVelocity:Destroy()
			flyVelocity = nil
		end
	end
end

-- 👁️ ESP (Simple Box)
function PlayersConfig.ToggleESP(state)
	isESPEnabled = state
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player ~= Player and player.Character and player.Character:FindFirstChild("Head") then
			local highlight = player.Character:FindFirstChildOfClass("Highlight")
			if state then
				if not highlight then
					local newHighlight = Instance.new("Highlight")
					newHighlight.FillTransparency = 1
					newHighlight.OutlineColor = Color3.new(1, 0, 0)
					newHighlight.Parent = player.Character
				end
			else
				if highlight then
					highlight:Destroy()
				end
			end
		end
	end
end

return PlayersConfig
