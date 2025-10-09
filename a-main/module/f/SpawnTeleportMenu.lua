-- ==========================================================
-- 🌐 Teleport Menu GUI (Noctis GUI Style)
-- ==========================================================

local TeleportMenu = {}
local guiVisible = false

-- Cek apakah Noctis tersedia
local guiSystem = nil
if Noctis then
    guiSystem = Noctis
elseif _G.Noctis then
    guiSystem = _G.Noctis
elseif Window and Window.CreateWindow then
    guiSystem = Window
else
    warn("⚠️ Noctis GUI instance not found, fallback using Window")
    guiSystem = Window
end

-- Buat window baru
local TeleportWindow = guiSystem:CreateWindow({
    Title = "🌍 Teleport Menu",
    Size = UDim2.new(0, 420, 0, 500),
    Position = UDim2.new(0.5, -210, 0.5, -250),
    ShowMinimizeButton = true,
    ShowCloseButton = true,
})

-- Pastikan window tersembunyi dulu
TeleportWindow:Hide()

-- Buat groupbox utama
local IslandBox = TeleportWindow:AddLeftGroupbox("<b>Teleport To Spot</b>", "map")
local autoTeleIslandFeature = FeatureManager:Get("AutoTeleportIsland")
local currentIsland = "Fisherman Island"

-- Dropdown 1
local teleisland_dd = IslandBox:AddDropdown("teleislanddd", {
    Text = "Select Spot Paus & Batu",
    Values = { "Bawah Air Terjun", "Atas Air Terjun", "Dalam Goa", "Tebing Laut", "Belakang Patung" },
    Searchable = true,
    Callback = function(Value)
        currentIsland = Value
        if autoTeleIslandFeature and autoTeleIslandFeature.SetIsland then
            autoTeleIslandFeature:SetIsland(Value)
        end
    end
})

-- Dropdown 2
local teleisland_ddv2 = IslandBox:AddDropdown("teleislandddv2", {
    Text = "Select Spot Teleport Spot Cacing",
    Values = { "NOOB", "Goa Es", "Es Kecil" },
    Searchable = true,
    Callback = function(Value)
        currentIsland = Value
        if autoTeleIslandFeature and autoTeleIslandFeature.SetIsland then
            autoTeleIslandFeature:SetIsland(Value)
        end
    end
})

-- Dropdown 3
local teleisland_ddv3 = IslandBox:AddDropdown("teleislandddv3", {
    Text = "Select Spot Frosborn Crater",
    Values = { "Tengah", "Tepi" },
    Searchable = true,
    Callback = function(Value)
        currentIsland = Value
        if autoTeleIslandFeature and autoTeleIslandFeature.SetIsland then
            autoTeleIslandFeature:SetIsland(Value)
        end
    end
})

-- Dropdown 4
local teleisland_ddv4 = IslandBox:AddDropdown("teleislandddv4", {
    Text = "Select Spot Kraken & Orca",
    Values = { "Depan Board", "Belakang Patung", "Bawah Jembatan", "Atas Jembatan", "Pulau Kecil" },
    Searchable = true,
    Callback = function(Value)
        currentIsland = Value
        if autoTeleIslandFeature and autoTeleIslandFeature.SetIsland then
            autoTeleIslandFeature:SetIsland(Value)
        end
    end
})

-- Dropdown 5
local teleisland_ddv5 = IslandBox:AddDropdown("teleislandddv5", {
    Text = "Select Spot Ancient Jungle",
    Values = { "Ancient.J Spot1", "Ancient.J Spot2" },
    Searchable = true,
    Callback = function(Value)
        currentIsland = Value
        if autoTeleIslandFeature and autoTeleIslandFeature.SetIsland then
            autoTeleIslandFeature:SetIsland(Value)
        end
    end
})

-- Tombol Teleport
local teleisland_btn = IslandBox:AddButton({
    Text = "Teleport Spot",
    Func = function()
        if autoTeleIslandFeature then
            if autoTeleIslandFeature.SetIsland then
                autoTeleIslandFeature:SetIsland(currentIsland)
            end
            if autoTeleIslandFeature.Teleport then
                autoTeleIslandFeature:Teleport(currentIsland)
            end
        end
    end
})

-- Sinkronisasi
if autoTeleIslandFeature then
    autoTeleIslandFeature.__controls = { Dropdown = teleisland_dd, button = teleisland_btn }
    if autoTeleIslandFeature.Init and not autoTeleIslandFeature.__initialized then
        autoTeleIslandFeature:Init(autoTeleIslandFeature, autoTeleIslandFeature.__controls)
        autoTeleIslandFeature.__initialized = true
    end
end

-- Fungsi show/hide window
function TeleportMenu.Show()
    TeleportWindow:Show()
    guiVisible = true
end

function TeleportMenu.Hide()
    TeleportWindow:Hide()
    guiVisible = false
end

return TeleportMenu
