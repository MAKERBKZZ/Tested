-- ===================================================
-- ⚙️ TabPlayersConfig.lua
-- ===================================================
-- Berisi: Speed Hack, Infinity Jump, Noclip, Fly, ESP
-- Notifikasi: Noctis:Notify
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
	Noctis:Notify({Title = "Speed Reset", Description = "Kecepatan dikembalikan ke 16"})
end

-- 🦘 INFINITY JUMP
UserInputService.JumpRequest:Connect(function()
	if isInfinityJumpEnabled and Humanoid then
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

function PlayersConfig.ToggleInfinityJump(state)
	isInfinityJumpEnabled = state
	Noctis:Notify({
		Title = "Infinity Jump",
		Description = state and "Infinity Jump diaktifkan" or "Infinity Jump dimatikan"
	})
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
	Noctis:Notify({
		Title = "Noclip",
		Description = state and "Mode tembus aktif" or "Mode tembus dimatikan"
	})
end

-- 🕊️ FLY LITTLE
function PlayersConfig.ToggleFly(state)
	isFlyEnabled = state
	if not Character or not Humanoid then return end

	local root = Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if state then
		flyVelocity = Instance.new("BodyVelocity")
		flyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
		flyVelocity.Velocity = Vector3.new(0, 25, 0)
		flyVelocity.Parent = root
		Noctis:Notify({Title = "Fly Mode", Description = "Fly diaktifkan"})
	else
		if flyVelocity then
			flyVelocity:Destroy()
			flyVelocity = nil
		end
		Noctis:Notify({Title = "Fly Mode", Description = "Fly dimatikan"})
	end
end

-- 👁️ ESP
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
	Noctis:Notify({
		Title = "ESP",
		Description = state and "ESP Aktif" or "ESP Dimatikan"
	})
end

return PlayersConfig
