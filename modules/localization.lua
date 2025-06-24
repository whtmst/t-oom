--[[
T-OoM Localization Manager
Manages language switching and localized strings
Менеджер локализации и переключения языков
--]]

-- Debug message to confirm localization.lua is executed
DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6EC[T-OoM]|r localization.lua loaded successfully!")

local T_OoM_Localization = {}

-- Current language (Текущий язык)
local currentLanguage = "enUS"
local currentLocale = nil

-- Available languages (Доступные языки)
local availableLanguages = {
    ["enUS"] = "T_OoM_Locale_enUS",
    ["ruRU"] = "T_OoM_Locale_ruRU"
}

-- Get client locale with fallback to system detection
-- Получить локаль клиента с fallback на автоопределение
local function GetClientLocale()
    if GetLocale then
        local locale = GetLocale()
        if locale and availableLanguages[locale] then
            return locale
        end
    end
    
    -- Default fallback to enUS
    return "enUS"
end

-- Internal function to set language with fallback (for initialization)
-- Внутренняя функция для установки языка с fallback (для инициализации)
local function SetLanguageWithFallback(langCode)
    if not langCode or not availableLanguages[langCode] then
        langCode = "enUS" -- Fallback to English
    end
    
    local globalName = availableLanguages[langCode]
    local localeTable = nil
    
    -- Direct access to global variables (WoW 1.12.1 compatible)
    if globalName == "T_OoM_Locale_enUS" then
        localeTable = T_OoM_Locale_enUS
    elseif globalName == "T_OoM_Locale_ruRU" then
        localeTable = T_OoM_Locale_ruRU
    end
    
    if localeTable then
        currentLanguage = langCode
        currentLocale = localeTable
        
        -- Save language preference
        if T_OoM_Settings then
            T_OoM_Settings.language = langCode
        end
        
        return true
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6ECT-OoM|r: Warning - Locale table not found: " .. globalName)
        return false
    end
end

-- Initialize localization system
-- Инициализация системы локализации
function T_OoM_Localization:Initialize()
    -- Get saved language preference or auto-detect
    local savedLang = nil
    if T_OoM_Settings and T_OoM_Settings.language then
        savedLang = T_OoM_Settings.language
    end
    
    local targetLang = savedLang or GetClientLocale()
    
    -- Set language with fallback for initialization
    SetLanguageWithFallback(targetLang)
    
    DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6ECT-OoM|r: Localization system initialized (Language: " .. currentLanguage .. ")")
end

-- Set current language
-- Установить текущий язык
function T_OoM_Localization:SetLanguage(langCode)
    -- Convert short codes to full codes for user convenience
    local langMap = {
        ["en"] = "enUS",
        ["ru"] = "ruRU",
        ["enUS"] = "enUS", -- Support full codes too
        ["ruRU"] = "ruRU"
    }
    
    local fullLangCode = langMap[langCode]
    
    -- Validate input language code
    if not langCode or not fullLangCode or not availableLanguages[fullLangCode] then
        DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6ECT-OoM|r: Invalid language code: " .. (langCode or "nil") .. ". Available: en, ru")
        return false
    end
    
    local globalName = availableLanguages[fullLangCode]
    local localeTable = nil
    
    -- Direct access to global variables (WoW 1.12.1 compatible)
    if globalName == "T_OoM_Locale_enUS" then
        localeTable = T_OoM_Locale_enUS
    elseif globalName == "T_OoM_Locale_ruRU" then
        localeTable = T_OoM_Locale_ruRU
    end
    
    if localeTable then
        currentLanguage = fullLangCode
        currentLocale = localeTable
        
        -- Save language preference
        if T_OoM_Settings then
            T_OoM_Settings.language = fullLangCode
        end
        
        return true
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6ECT-OoM|r: Warning - Locale table not found: " .. globalName)
        return false
    end
end

-- Get current language
-- Получить текущий язык
function T_OoM_Localization:GetLanguage()
    return currentLanguage
end

-- Get localized string (simplified version without varargs)
-- Получить локализованную строку (упрощённая версия без varargs)
function T_OoM_Localization:GetString(key)
    if not currentLocale then
        return key -- Return key if no locale loaded
    end
      local text = currentLocale[key]
    if not text then
        -- Fallback to English if key not found
        if currentLanguage ~= "enUS" and T_OoM_Locale_enUS then
            text = T_OoM_Locale_enUS[key]
        end
        
        if not text then
            return key -- Return key if still not found
        end
    end
    
    return text
end

-- Get available languages list
-- Получить список доступных языков
function T_OoM_Localization:GetAvailableLanguages()
    local langs = {}
    for langCode in pairs(availableLanguages) do
        table.insert(langs, langCode)
    end
    return langs
end

-- Global function for easy access to localized strings
-- Глобальная функция для удобного доступа к локализованным строкам
function L(key)
    if T_OoM_Localization then
        return T_OoM_Localization:GetString(key)
    end
    return key
end

-- Module registration
T_OoM_Modules = T_OoM_Modules or {}

T_OoM_Modules.Localization = {
    name = "Localization",
    version = "1.0.0",
    dependencies = {"Settings"},
    
    Initialize = function(self)
        T_OoM_Localization:Initialize()
    end,
    
    PostInitialize = function(self)
        -- Post-initialization logic if needed
    end,
    
    -- Public interface
    SetLanguage = function(self, langCode)
        return T_OoM_Localization:SetLanguage(langCode)
    end,
    
    GetLanguage = function(self)
        return T_OoM_Localization:GetLanguage()
    end,
    
    GetString = function(self, key)
        return T_OoM_Localization:GetString(key)
    end,
    
    GetAvailableLanguages = function(self)
        return T_OoM_Localization:GetAvailableLanguages()
    end
}

-- Register the localization module
if T_OoM_Modules and T_OoM_Modules.Loader then
    T_OoM_Modules.Loader:RegisterModule("Localization", T_OoM_Modules.Localization)
end
