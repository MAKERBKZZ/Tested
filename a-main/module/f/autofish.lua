-- ===========================
-- AUTO FISH FEATURE - SUPER EXTREME (FIXED & RANDOM)
-- File: autofishv4_superextreme.lua
-- ===========================

local AutoFishFeature = {}
AutoFishFeature.__index = AutoFishFeature

local logger = _G.Logger and _G.Logger.new("AutoFish") or {
	debug = function() end,
	info = function() end,
	warn = function() end,
	error = function() end
}

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Network setup
local NetPath = nil
local EquipTool, ChargeFishingRod, RequestFishing, FishingCompleted, FishObtainedNotification

local function initializeRemotes()
	local success = pcall(function()
		NetPath = ReplicatedStorage:WaitForChild("Packages", 5)
			:WaitForChild("_Index", 5)
			:WaitForChild("sleitnick_net@0.2.0", 5)
			:WaitForChild("net", 5)

		EquipTool = NetPath:WaitForChild("RE/EquipToolFromHotbar", 5)
		ChargeFishingRod = NetPath:WaitForChild("RF/ChargeFishingRod", 5)
		RequestFishing = NetPath:WaitForChild("RF/RequestFishingMinigameStarted", 5)
		FishingCompleted = NetPath:WaitForChild("RE/FishingCompleted", 5)
		FishObtainedNotification = NetPath:WaitForChild("RE/ObtainedNewFishNotification", 5)
		return true
	end)
	return success
end

-- Feature state
local isRunning = false
local currentMode = "Fast"
local connection, spamConnection, fishObtainedConnection
local controls = {}
local fishingInProgress = false
local lastFishTime = 0
local remotesInitialized = false
local spamActive = false
local completionCheckActive = false
local lastBackpackCount = 0
local fishCaughtFlag = false

-- Fishing mode configurations
local FISHING_CONFIGS = {
	["Fast"] = {
		chargeTime = 1.0,
		waitBetween = 0,
		rodSlot = 1,
		spamDelay = 0.001,
		maxSpamTime = 30,
		skipMinigame = true
	},
	["Slow"] = {
		chargeTime = 1.0,
		waitBetween = 1,
		rodSlot = 1,
		spamDelay = 0.1,
		maxSpamTime = 20,
		skipMinigame = false,
		minigameDuration = 5
	},
	["Extreme"] = {
		chargeTime = 0.1,
		waitBetween = 0,
		rodSlot = 1,
		spamDelay = 0.01,
		maxSpamTime = 9999,
		skipMinigame = true,
		instantCatch = true,
		bypassLimit = true
	},
	["SuperExtreme"] = {
        chargeTime = 0.0001,                   -- Instant lempar
        waitBetween = 0,
        rodSlot = 1,
        spamDelay = 0.0001,                  -- Spam ultra cepat
        maxSpamTime = math.random(30,11000), -- Random waktu aktif
        skipMinigame = true,
        instantCatch = true,
        bypassLimit = true,
        ignoreCooldown = true,
        superReel = true,
        amazingCast = true                   -- 💥 Auto Amazing Cast
    }
}

-- Initialize
function AutoFishFeature:Init(guiControls)
	controls = guiControls or {}
	remotesInitialized = initializeRemotes()
	if not remotesInitialized then
		logger:warn("Failed to initialize remotes")
		return false
	end
	self:UpdateBackpackCount()
	logger:info("Initialized with SPAM method - All modes ready")
	return true
end

-- Start fishing
function AutoFishFeature:Start(config)
	if isRunning then return end
	if not remotesInitialized then
		logger:warn("Cannot start - remotes not initialized")
		return
	end

	isRunning = true
	currentMode = config.mode or "Fast"
	fishingInProgress, spamActive, fishCaughtFlag = false, false, false
	lastFishTime = 0

	logger:info("Started SPAM method - Mode:", currentMode)
	self:SetupFishObtainedListener()

	connection = RunService.Heartbeat:Connect(function()
		if not isRunning then return end
		self:SpamFishingLoop()
	end)
end

-- Stop fishing
function AutoFishFeature:Stop()
	if not isRunning then return end
	isRunning = false
	fishingInProgress, spamActive, completionCheckActive, fishCaughtFlag = false, false, false, false

	if connection then connection:Disconnect() connection = nil end
	if spamConnection then spamConnection:Disconnect() spamConnection = nil end
	if fishObtainedConnection then fishObtainedConnection:Disconnect() fishObtainedConnection = nil end

	logger:info("Stopped SPAM method")
end

-- Setup fish obtained listener
function AutoFishFeature:SetupFishObtainedListener()
	if not FishObtainedNotification then
		logger:warn("FishObtainedNotification not available")
		return
	end
	if fishObtainedConnection then fishObtainedConnection:Disconnect() end

	fishObtainedConnection = FishObtainedNotification.OnClientEvent:Connect(function()
		if isRunning then
			logger:info("🎣 Fish obtained detected!")
			fishCaughtFlag = true
			if spamActive then spamActive, completionCheckActive = false, false end
			task.spawn(function()
				task.wait(0.1)
				fishingInProgress, fishCaughtFlag = false, false
			end)
		end
	end)
end

-- Main spam loop
function AutoFishFeature:SpamFishingLoop()
	if fishingInProgress or spamActive then return end
	local currentTime = tick()
	local config = FISHING_CONFIGS[currentMode]

	if currentTime - lastFishTime < config.waitBetween then return end
	fishingInProgress = true
	lastFishTime = currentTime

	task.spawn(function()
		local success = self:ExecuteSpamFishingSequence()
		fishingInProgress = false
		if success then logger:info("SPAM cycle completed!") end
	end)
end

-- Execute sequence
function AutoFishFeature:ExecuteSpamFishingSequence()
	local config = FISHING_CONFIGS[currentMode]
	if not self:EquipRod(config.rodSlot) then return false end
	task.wait(0.1)
	if not self:ChargeRod(config.chargeTime) then return false end
	if not self:CastRod() then return false end

	-- 🎲 Random maxSpamTime setiap kali siklus dimulai
	local randomMaxTime = math.random(30, 11000)
	logger:info("SuperExtreme spam duration:", randomMaxTime, "seconds")

	self:StartCompletionSpam(config.spamDelay, randomMaxTime)
	return true
end

-- Equip rod
function AutoFishFeature:EquipRod(slot)
	if not EquipTool then return false end
	return pcall(function() EquipTool:FireServer(slot) end)
end

-- Charge rod
function AutoFishFeature:ChargeRod(chargeTime)
	if not ChargeFishingRod then return false end
	return pcall(function()
		local chargeValue = tick() + (chargeTime * 1000)
		return ChargeFishingRod:InvokeServer(chargeValue)
	end)
end

-- Cast rod
function AutoFishFeature:CastRod()
	if not RequestFishing then return false end
	return pcall(function()
		local x, z = -1.233184814453125, 0.9999120558411321
		return RequestFishing:InvokeServer(x, z)
	end)
end

-- Spam FishingCompleted
function AutoFishFeature:StartCompletionSpam(delay, maxTime)
	if spamActive then return end
	spamActive, completionCheckActive, fishCaughtFlag = true, true, false
	local spamStartTime = tick()

	task.spawn(function()
		while spamActive and isRunning and (tick() - spamStartTime) < maxTime do
			self:FireCompletion()
			if fishCaughtFlag or self:CheckFishingCompleted() then break end
			task.wait(delay > 0 and delay or 0.0001)
		end
		spamActive, completionCheckActive = false, false
	end)
end

-- Fire FishingCompleted
function AutoFishFeature:FireCompletion()
	if not FishingCompleted then return false end
	return pcall(function() FishingCompleted:FireServer() end)
end

-- Check completion
function AutoFishFeature:CheckFishingCompleted()
	if fishCaughtFlag then return true end
	local currentCount = self:GetBackpackItemCount()
	if currentCount > lastBackpackCount then
		lastBackpackCount = currentCount
		return true
	end
	return false
end

-- Backpack utilities
function AutoFishFeature:UpdateBackpackCount()
	lastBackpackCount = self:GetBackpackItemCount()
end

function AutoFishFeature:GetBackpackItemCount()
	local count = 0
	if LocalPlayer.Backpack then count += #LocalPlayer.Backpack:GetChildren() end
	if LocalPlayer.Character then
		for _, child in pairs(LocalPlayer.Character:GetChildren()) do
			if child:IsA("Tool") then count += 1 end
		end
	end
	return count
end

-- Status
function AutoFishFeature:GetStatus()
	return {
		running = isRunning,
		mode = currentMode,
		spamming = spamActive,
		lastCatch = lastFishTime,
		fishCaughtFlag = fishCaughtFlag
	}
end

-- Set mode
function AutoFishFeature:SetMode(mode)
	if FISHING_CONFIGS[mode] then
		currentMode = mode
		logger:info("Mode changed to:", mode)
		return true
	end
	return false
end

function AutoFishFeature:Cleanup()
	logger:info("Cleaning up AutoFishFeature...")
	self:Stop()
end

return AutoFishFeature

