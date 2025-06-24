--[[
T-OoM Mana Monitor Module
Handles mana level monitoring and threshold detection
Модуль мониторинга маны - отслеживает уровень маны и определяет пороговые значения
--]]

-- Create the ManaMonitor module
local ManaMonitor = {}

-- Module state
local isInitialized = false
local lastManaPercentage = 0
local callbacks = {
    onManaThresholdReached = {},
    onPowerTypeChanged = {}
}

-- Private variables
local currentPowerType = nil
local isMonitoringActive = false

-- Initialize the module
function ManaMonitor:Initialize()
    if isInitialized then
        return
    end
    
    isInitialized = true
      -- Register for power-related events
    local frame = CreateFrame("Frame", "T_OoM_ManaMonitorFrame")
    ---@diagnostic disable-next-line: param-type-mismatch
    frame:RegisterEvent("UNIT_MANA")
    ---@diagnostic disable-next-line: param-type-mismatch
    frame:RegisterEvent("UNIT_MAXMANA")
    ---@diagnostic disable-next-line: param-type-mismatch
    frame:RegisterEvent("UNIT_DISPLAYPOWER")
    
    -- Set up event handler
    frame:SetScript("OnEvent", function()
        if arg1 == "player" then
            self:OnPlayerPowerUpdate()
        end
    end)
    
    -- Store frame reference for cleanup
    self.frame = frame
    
    -- Initialize current state
    self:UpdatePowerType()
    self:UpdateManaPercentage()
    
    -- Start monitoring
    isMonitoringActive = true
    
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00T-OoM:|r Mana Monitor initialized")
end

-- Update current power type and notify if changed
function ManaMonitor:UpdatePowerType()
    local unit = "player"
    local powerType = UnitPowerType(unit)
    local powerToken = (powerType == 0) and "MANA" or "UNKNOWN"
    
    if currentPowerType ~= powerToken then
        local oldPowerType = currentPowerType
        currentPowerType = powerToken
        
        -- Notify callbacks about power type change
        self:TriggerCallbacks("onPowerTypeChanged", {
            oldType = oldPowerType,
            newType = currentPowerType,
            isManaUser = (currentPowerType == "MANA")
        })
    end
end

-- Update mana percentage and check thresholds
function ManaMonitor:UpdateManaPercentage()
    if currentPowerType ~= "MANA" then
        return
    end
    
    local unit = "player"
    local currentMana = UnitMana(unit)
    local maxMana = UnitManaMax(unit)
    
    if maxMana == 0 then
        return
    end
    
    local manaPercentage = currentMana / maxMana
    
    -- Check if we crossed any thresholds
    self:CheckManaThresholds(manaPercentage, lastManaPercentage)
    
    lastManaPercentage = manaPercentage
end

-- Check mana thresholds and trigger callbacks
function ManaMonitor:CheckManaThresholds(current, previous)
    if not T_OoM_Modules or not T_OoM_Modules.Settings then
        return
    end
    
    local settings = T_OoM_Modules.Settings:GetAll()
    if not settings then
        return
    end
    
    local threshold1 = settings.lowManaThreshold1 or 0.30  -- Low mana
    local threshold2 = settings.lowManaThreshold2 or 0.15  -- Critical low mana  
    local threshold3 = settings.lowManaThreshold3 or 0.05  -- Out of mana
    
    -- Check threshold3 (most critical)
    if current <= threshold3 and previous > threshold3 then
        self:TriggerCallbacks("onManaThresholdReached", {
            threshold = 3,
            level = "outOfMana",
            percentage = current,
            message = settings.outOfManaMessage or "OUT OF MANA"
        })
    -- Check threshold2 (critical)
    elseif current <= threshold2 and current > threshold3 and previous > threshold2 then
        self:TriggerCallbacks("onManaThresholdReached", {
            threshold = 2,
            level = "critical",
            percentage = current,
            message = settings.criticalLowManaMsg or "CRITICAL LOW MANA"
        })
    -- Check threshold1 (low)
    elseif current <= threshold1 and current > threshold2 and previous > threshold1 then
        self:TriggerCallbacks("onManaThresholdReached", {
            threshold = 1,
            level = "low",
            percentage = current,
            message = settings.lowManaMsg or "LOW MANA"
        })
    end
end

-- Event handler for player power updates
function ManaMonitor:OnPlayerPowerUpdate()
    if not isMonitoringActive then
        return
    end
    
    self:UpdatePowerType()
    self:UpdateManaPercentage()
end

-- Register callback for mana events
function ManaMonitor:RegisterCallback(eventType, callback)
    if not callbacks[eventType] then
        callbacks[eventType] = {}
    end
    
    table.insert(callbacks[eventType], callback)
end

-- Unregister callback
function ManaMonitor:UnregisterCallback(eventType, callback)
    if not callbacks[eventType] then
        return
    end
    
    for i, cb in ipairs(callbacks[eventType]) do
        if cb == callback then
            table.remove(callbacks[eventType], i)
            break
        end
    end
end

-- Trigger callbacks for specific event type
function ManaMonitor:TriggerCallbacks(eventType, data)
    if not callbacks[eventType] then
        return
    end
    
    for _, callback in ipairs(callbacks[eventType]) do
        if type(callback) == "function" then
            local success, err = pcall(callback, data)
            if not success then
                DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r Callback error: " .. tostring(err))
            end
        end
    end
end

-- Get current mana state
function ManaMonitor:GetCurrentState()
    if currentPowerType ~= "MANA" then
        return {
            powerType = currentPowerType,
            isManaUser = false,
            manaPercentage = 0,
            currentMana = 0,
            maxMana = 0
        }
    end
    
    local unit = "player"
    local currentMana = UnitMana(unit)
    local maxMana = UnitManaMax(unit)
    local manaPercentage = maxMana > 0 and (currentMana / maxMana) or 0
    
    return {
        powerType = currentPowerType,
        isManaUser = true,
        manaPercentage = manaPercentage,
        currentMana = currentMana,
        maxMana = maxMana
    }
end

-- Enable/disable monitoring
function ManaMonitor:SetMonitoringActive(active)
    isMonitoringActive = active
end

-- Check if monitoring is active
function ManaMonitor:IsMonitoringActive()
    return isMonitoringActive
end

-- Cleanup function
function ManaMonitor:Cleanup()
    if self.frame then
        self.frame:UnregisterAllEvents()
        self.frame:SetScript("OnEvent", nil)
    end
    
    isMonitoringActive = false
    callbacks = {
        onManaThresholdReached = {},
        onPowerTypeChanged = {}
    }
end

-- Register the module
if T_OoM_Modules and T_OoM_Modules.Loader then
    T_OoM_Modules.Loader:RegisterModule("ManaMonitor", ManaMonitor)
else
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r Module loader not available for ManaMonitor")
end
