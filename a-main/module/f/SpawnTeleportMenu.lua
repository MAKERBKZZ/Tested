-- ==========================================================
-- 🌐 Teleport Menu GUI (DellstoreV2 Compatible)
-- ==========================================================

local TeleportMenu = {}
local guiVisible = false

-- Deteksi framework GUI utama
local mainLib = Library or Noctis or getgenv().Library or getgenv().Noctis
if not mainLib then
    warn("⚠️ Library GUI tidak ditemukan. Pastikan Library global sudah di-load sebelum menu ini.")
    return {}
end

-- Membuat window baru (mengambang)
local TeleportWindow = mainLib:CreateWindow({
    Title = "🌍 Teleport Menu",
    Center = true,
    AutoShow = true,
    Size = UDim2.new(0, 420, 0, 500),
})

-- Pastikan window tidak langsung tampil
TeleportWindow:Hide()

-- Tambahkan groupbox utama
local IslandBox = TeleportWindow:AddLeftGroupbox("<b>Teleport To Spot</b>", "map")
local autoTeleIslandFeature = FeatureManager:Get("AutoTeleportIsland")
local currentIsland = "Fisherman Island"

-- Fungsi bantu buat dropdown cepat
local function addDropdown(id, text, list)
    return IslandBox:AddDropdown(id, {
        Text = text,
        Values = list,
        Searchable = true,
        MaxVisibileDropdownItems = 6,
        Multi = false,
        Callback = function(Value)
            currentIsland = Value
            if autoTeleIslandFeature and autoTeleIslandFeature.SetIsland then
                autoTeleIslandFeature:SetIsland(Value)
            end
        end
    })
end

-- Semua dropdown
addDropdown("teleislanddd", "Select Spot Paus & Batu", {
    "Bawah Air Terjun", "Atas Air Terjun", "Dalam Goa", "Tebing Laut", "Belakang Patung"
})

addDropdown("teleislandddv2", "Select Spot Teleport Spot Cacing", {
    "NOOB", "Goa Es", "Es Kecil"
})

addDropdown("teleislandddv3", "Select Spot Frosborn Crater", {
    "Tengah", "Tepi"
})

addDropdown("teleislandddv4", "Select Spot Kraken & Orca", {
    "Depan Board", "Belakang Patung", "Bawah Jembatan", "Atas Jembatan", "Pulau Kecil"
})

addDropdown("teleislandddv5", "Select Spot Ancient Jungle", {
    "Ancient.J Spot1", "Ancient.J Spot2"
})

-- Tombol teleport
IslandBox:AddButton({
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

-- Sinkronisasi fitur
if autoTeleIslandFeature then
    autoTeleIslandFeature.__controls = { button = "teleisland_btn" }
    if autoTeleIslandFeature.Init and not autoTeleIslandFeature.__initialized then
        autoTeleIslandFeature:Init(autoTeleIslandFeature, autoTeleIslandFeature.__controls)
        autoTeleIslandFeature.__initialized = true
    end
end

-- Fungsi tampil/sembunyi
function TeleportMenu.Show()
    TeleportWindow:Show()
    guiVisible = true
end

function TeleportMenu.Hide()
    TeleportWindow:Hide()
    guiVisible = false
end

return TeleportMenu
