-- ==========================================================
-- 🌐 Teleport Menu GUI (Noctis GUI Style)
-- ==========================================================

local TeleportMenu = {}
local guiVisible = false

-- Buat window baru di luar tab utama
local TeleportWindow = Noctis:CreateWindow({
    Title = "🌍 Teleport Menu",
    Size = UDim2.new(0, 400, 0, 480),
    Position = UDim2.new(0.5, -200, 0.5, -240),
    ShowMinimizeButton = true,
    ShowCloseButton = false,
})

-- Buat groupbox utama
local IslandBox = TeleportWindow:AddLeftGroupbox("<b>Teleport To Spot</b>", "map")
local autoTeleIslandFeature = FeatureManager:Get("AutoTeleportIsland")
local currentIsland = "Fisherman Island"

-- Semua dropdown dan tombol teleport seperti sebelumnya
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

-- Simpan control agar bisa diinisialisasi
if autoTeleIslandFeature then
    autoTeleIslandFeature.__controls = {
        Dropdown = teleisland_dd,
        button = teleisland_btn
    }

    if autoTeleIslandFeature.Init and not autoTeleIslandFeature.__initialized then
        autoTeleIslandFeature:Init(autoTeleIslandFeature, autoTeleIslandFeature.__controls)
        autoTeleIslandFeature.__initialized = true
    end
end

-- Fungsi show/hide
function TeleportMenu.Show()
    TeleportWindow:Show()
    guiVisible = true
end

function TeleportMenu.Hide()
    TeleportWindow:Hide()
    guiVisible = false
end

return TeleportMenu
