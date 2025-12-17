-- ======================================
-- 🏪 AutoBuyMerchant (Fixed Version)
-- ======================================

local AutoBuyMerchant = {}
AutoBuyMerchant.__index = AutoBuyMerchant

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketItemData = require(ReplicatedStorage.Shared.MarketItemData)
local PurchaseEvent = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseMarketItem"]
local Replion = require(ReplicatedStorage.Packages.Replion)

function AutoBuyMerchant.new()
    local self = setmetatable({}, AutoBuyMerchant)

    self._running = false
    self._targetItems = {}
    self._controls = nil
    self._merchant = nil
    self._invWatcher = nil
    self._updateThread = nil
    self._processing = false

    return self
end

function AutoBuyMerchant:Init(controls)
    self._controls = controls

    local invWatcherCode = game:HttpGet("https://raw.githubusercontent.com/MAKERBKZZ/a/refs/heads/main/utils/fishit/inventdetect.lua")
    local InventoryWatcher = loadstring(invWatcherCode)()
    self._invWatcher = InventoryWatcher.new()

    self._invWatcher:onReady(function()
        print("[AutoBuyMerchant] ✅ InventoryWatcher ready")
    end)

    -- Tunggu merchant siap dulu
    Replion.Client:AwaitReplion("Merchant", function(merchant)
        self._merchant = merchant
        print("[AutoBuyMerchant] ✅ Merchant replion loaded")

        -- Jika sedang menunggu merchant saat toggle ON, langsung mulai loop
        if self._running and not self._updateThread then
            self._updateThread = task.spawn(function()
                self:_updateLoop()
            end)
        end
    end)
end

function AutoBuyMerchant:SetTargetItems(items)
    self._targetItems = items or {}
    print("[AutoBuyMerchant] 🎯 Target items set:", table.concat(self._targetItems, ", "))
end

function AutoBuyMerchant:_getItemByIdentifier(identifier)
    for _, item in ipairs(MarketItemData) do
        if item.Identifier == identifier then
            return item
        end
    end
    return nil
end

function AutoBuyMerchant:_isInStock(itemId)
    if not self._merchant then return false end
    local items = self._merchant:Get("Items")
    if not items then return false end

    for _, id in ipairs(items) do
        if id == itemId then
            return true
        end
    end
    return false
end

function AutoBuyMerchant:_ownsItem(itemData)
    if not itemData.SingleCopy then return false end
    if not self._invWatcher then return false end

    local snapshot = self._invWatcher:getSnapshotTyped(itemData.Type)
    if not snapshot then return false end

    for _, entry in ipairs(snapshot) do
        local entryId = entry.Id or entry.id
        if entryId == itemData.Identifier then
            return true
        end
    end
    return false
end

function AutoBuyMerchant:_tryPurchase(itemData)
    if self._processing then return end
    if not self:_isInStock(itemData.Id) then return end
    if itemData.SingleCopy and self:_ownsItem(itemData) then return end

    self._processing = true

    local success, err = pcall(function()
        PurchaseEvent:InvokeServer(itemData.Id)
    end)

    if success then
        print("[AutoBuyMerchant] 🛒 Purchased:", itemData.Identifier)
    else
        warn("[AutoBuyMerchant] ❌ Purchase failed:", err)
    end

    task.wait(0.5)
    self._processing = false
end

function AutoBuyMerchant:_updateLoop()
    print("[AutoBuyMerchant] 🔁 Update loop started")

    while self._running do
        if not self._merchant then
            print("[AutoBuyMerchant] Waiting for merchant...")
            task.wait(5)
            continue
        end

        for _, identifier in ipairs(self._targetItems) do
            if not self._running then break end
            local itemData = self:_getItemByIdentifier(identifier)
            if itemData then
                self:_tryPurchase(itemData)
            else
                warn("[AutoBuyMerchant] Unknown item:", identifier)
            end
        end

        task.wait(60)
    end

    print("[AutoBuyMerchant] ⛔ Update loop ended")
end

function AutoBuyMerchant:Start(config)
    if self._running then return end

    if config and config.targetItems then
        self._targetItems = config.targetItems
    end

    if #self._targetItems == 0 then
        warn("[AutoBuyMerchant] ⚠️ No items selected")
        if self._controls and self._controls.Toggle then
            self._controls.Toggle:SetValue(false)
        end
        return
    end

    self._running = true
    print("[AutoBuyMerchant] ▶️ Started with items:", table.concat(self._targetItems, ", "))

    if self._merchant then
        self._updateThread = task.spawn(function()
            self:_updateLoop()
        end)
    else
        print("[AutoBuyMerchant] Waiting for merchant to load...")
    end
end

function AutoBuyMerchant:Stop()
    if not self._running then return end

    self._running = false
    self._processing = false

    print("[AutoBuyMerchant] ⏹️ Stopped")
end

function AutoBuyMerchant:Cleanup()
    self:Stop()

    if self._invWatcher and self._invWatcher.destroy then
        self._invWatcher:destroy()
        self._invWatcher = nil
    end

    self._merchant = nil
    self._controls = nil
    self._targetItems = {}

    print("[AutoBuyMerchant] 🧹 Cleaned up")
end

return AutoBuyMerchant
