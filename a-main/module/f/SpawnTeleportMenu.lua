-- ===========================
-- 🗺️ SPAWN TELEPORT MENU GUI
-- ===========================
local SpawnTeleportGUI = {}

function SpawnTeleportGUI:Create()
    local autoTeleIslandFeature = FeatureManager:Get("AutoTeleportIsland")
    local currentIsland = "Fisherman Island"

    local IslandBox = SpawnTeleport:AddLeftGroupbox("<b>Teleport To Spot</b>", "map")
    self.IslandBox = IslandBox

    -- Dropdown v1
    local teleisland_dd = IslandBox:AddDropdown("teleislanddd", {
        Text = "Select Spot Paus & Batu",
        Tooltip = "",
        Values = {
            "Bawah Air Terjun",
            "Atas Air Terjun",
            "Dalam Goa",
            "Tebing Laut",
            "Belakang Patung",
        },
        Searchable = true,
        MaxVisibileDropdownItems = 6,
        Multi = false,
        Callback = function(Value)
            currentIsland = Value or {}
            if autoTeleIslandFeature and autoTeleIslandFeature.SetIsland then
                autoTeleIslandFeature:SetIsland(Value)
            end
        end
    })

    -- Dropdown v2
    local teleisland_ddv2 = IslandBox:AddDropdown("teleislandddv2", {
        Text = "Select Spot Teleport Spot Cacing",
        Tooltip = "",
        Values = { "NOOB", "Goa Es", "Es Kecil" },
        Searchable = true,
        MaxVisibileDropdownItems = 6,
        Multi = false,
        Callback = function(Value)
            currentIsland = Value or {}
            if autoTeleIslandFeature and autoTeleIslandFeature.SetIsland then
                autoTeleIslandFeature:SetIsland(Value)
            end
        end
    })

    -- Dropdown v3
    local teleisland_ddv3 = IslandBox:AddDropdown("teleislandddv3", {
        Text = "Select Spot Frosborn Crater",
        Tooltip = "",
        Values = { "Tengah", "Tepi" },
        Searchable = true,
        MaxVisibileDropdownItems = 6,
        Multi = false,
        Callback = function(Value)
            currentIsland = Value or {}
            if autoTeleIslandFeature and autoTeleIslandFeature.SetIsland then
                autoTeleIslandFeature:SetIsland(Value)
            end
        end
    })

    -- Dropdown v4
    local teleisland_ddv4 = IslandBox:AddDropdown("teleislandddv4", {
        Text = "Select Spot Kraken & Orca",
        Tooltip = "",
        Values = {
            "Depan Board",
            "Belakang Patung",
            "Bawah Jembatan",
            "Atas Jembatan",
            "Pulau Kecil",
        },
        Searchable = true,
        MaxVisibileDropdownItems = 6,
        Multi = false,
        Callback = function(Value)
            currentIsland = Value or {}
            if autoTeleIslandFeature and autoTeleIslandFeature.SetIsland then
                autoTeleIslandFeature:SetIsland(Value)
            end
        end
    })

    -- Dropdown v5
    local teleisland_ddv5 = IslandBox:AddDropdown("teleislandddv5", {
        Text = "Select Spot Orca",
        Tooltip = "",
        Values = {
            "Bawah Jembatan",
            "Atas Jembatan",
            "Pulau Kecil",
        },
        Searchable = true,
        MaxVisibileDropdownItems = 6,
        Multi = false,
        Callback = function(Value)
            currentIsland = Value or {}
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

    -- Init FeatureManager
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
end

-- Fungsi untuk menghapus GUI
function SpawnTeleportGUI:Destroy()
    if self.IslandBox then
        self.IslandBox:Destroy()
        self.IslandBox = nil
    end
end

return SpawnTeleportGUI
