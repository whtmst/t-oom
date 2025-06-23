--[[
T-OoM Settings Manager
Manages addon settings and SavedVariables integration
Менеджер настроек аддона и интеграция с SavedVariables
--]]

-- Default settings (Настройки по умолчанию)
local DEFAULT_SETTINGS = {
    -- Mana thresholds (Пороги маны)
    lowManaThreshold1 = 0.30,     -- 30% mana threshold
    lowManaThreshold2 = 0.15,     -- 15% mana threshold  
    lowManaThreshold3 = 0.05,     -- 5% mana threshold
    
    -- Messages (Сообщения)
    lowManaMsg = "--- LOW ON MANA ---",
    criticalLowManaMsg = "--- CRITICAL LOW MANA ---",
    outOfManaMessage = "--- OUT OF MANA ---",
    
    -- Chat settings (Настройки чата)
    chatChannel = "SAY",          -- SAY, PARTY, RAID, GUILD, WHISPER
    
    -- Display settings (Настройки отображения)
    messageDuration = 3,          -- Message duration in seconds
    fontSize = 96,                -- Font size
    frameColor = {0, 0, 0, 0},    -- Frame background color {r, g, b, a}
    fontColor = {1, 1, 1, 1},     -- Font color {r, g, b, a}
    fontPath = "Interface\\AddOns\\T-OoM\\fonts\\ARIALN.ttf",
    
    -- Instance types where addon is active (Типы инстансов где аддон активен)
    instanceTypeOptions = {
        none = false,      -- Outside instances (В открытом мире)
        party = true,      -- 5-man dungeons (Подземелья на 5-человек)
        raid = false,      -- Raid instances (Рейды)
        arena = false,     -- Arenas (Арены)
        pvp = false,       -- Battlegrounds (Поля боя)
        scenario = false   -- Scenarios (Сценарии)
    },
    
    -- Localization settings (Настройки локализации)
    language = "enUS",             -- Default language
    
    -- GUI settings (Настройки интерфейса)
    minimapButton = {
        enabled = true,
        angle = 0,                 -- Angle around minimap in radians
        radius = 80               -- Distance from minimap center
    }
}

-- Settings module
local Settings = {}

-- Debug message to confirm settings.lua is executed
DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6EC[T-OoM]|r settings.lua loaded successfully!")

-- Initialize settings from SavedVariables or defaults
function Settings:Initialize()
    -- Create SavedVariables if it doesn't exist
    if not T_OoM_Settings then
        T_OoM_Settings = {}
    end
    
    -- Migrate settings from SavedVariables or use defaults
    for key, value in pairs(DEFAULT_SETTINGS) do
        if T_OoM_Settings[key] == nil then
            T_OoM_Settings[key] = self:DeepCopy(value)
        end
    end
    
    -- Validate settings
    self:ValidateSettings()
    
    DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6ECT-OoM:|r Settings loaded successfully")
end

-- Deep copy function for nested tables
function Settings:DeepCopy(original)
    if type(original) ~= "table" then
        return original
    end
    
    local copy = {}
    for key, value in pairs(original) do
        copy[key] = self:DeepCopy(value)
    end
    return copy
end

-- Validate settings and fix invalid values
function Settings:ValidateSettings()
    local settings = T_OoM_Settings
    
    -- Validate thresholds
    if settings.lowManaThreshold1 <= settings.lowManaThreshold2 then
        settings.lowManaThreshold1 = 0.30
    end
    if settings.lowManaThreshold2 <= settings.lowManaThreshold3 then
        settings.lowManaThreshold2 = 0.15
    end
    if settings.lowManaThreshold3 <= 0 then
        settings.lowManaThreshold3 = 0.05
    end
    
    -- Validate chat channel
    local validChannels = {"SAY", "PARTY", "RAID", "GUILD", "WHISPER"}
    local isValidChannel = false
    for _, channel in ipairs(validChannels) do
        if settings.chatChannel == channel then
            isValidChannel = true
            break
        end
    end
    if not isValidChannel then
        settings.chatChannel = "SAY"
    end
    
    -- Validate display settings
    if settings.messageDuration < 1 or settings.messageDuration > 10 then
        settings.messageDuration = 3
    end
    if settings.fontSize < 20 or settings.fontSize > 120 then
        settings.fontSize = 96
    end
    
    -- Validate language
    if settings.language ~= "enUS" and settings.language ~= "ruRU" then
        settings.language = "enUS"
    end
end

-- Get setting value
function Settings:Get(key)
    return T_OoM_Settings[key]
end

-- Set setting value
function Settings:Set(key, value)
    T_OoM_Settings[key] = value
    self:ValidateSettings()
end

-- Get all settings
function Settings:GetAll()
    return T_OoM_Settings
end

-- Reset to default settings
function Settings:Reset()
    T_OoM_Settings = self:DeepCopy(DEFAULT_SETTINGS)
    DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6ECT-OoM:|r Settings reset to defaults")
end

-- Export settings to string (for sharing)
function Settings:Export()
    -- Simple serialization for basic types
    local function serialize(t, indent)
        indent = indent or 0
        local result = "{\n"
        for k, v in pairs(t) do
            result = result .. string.rep("  ", indent + 1) .. "[\"" .. k .. "\"] = "
            if type(v) == "table" then
                result = result .. serialize(v, indent + 1)
            elseif type(v) == "string" then
                result = result .. "\"" .. v .. "\""
            else
                result = result .. tostring(v)
            end
            result = result .. ",\n"
        end
        result = result .. string.rep("  ", indent) .. "}"
        return result
    end
    
    return serialize(T_OoM_Settings)
end

-- Import settings from string
function Settings:Import(settingsString)
    -- This is a simplified import - in a real implementation you'd want proper parsing
    -- For now, we'll just validate and use the current settings
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00T-OoM:|r Settings import functionality will be implemented in GUI phase")
end

-- Register the settings module
if T_OoM_Modules and T_OoM_Modules.Loader then
    T_OoM_Modules.Loader:RegisterModule("Settings", Settings)
end
