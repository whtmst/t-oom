--[[
T-OoM - is a simple Out of Mana announcer addon for Turtle WoW.
T-OoM - это простой аддон для объявления об окончании маны для сервера Turtle WoW.

Addon GitHub link: https://github.com/whtmst/t-oom

Author: Mikhail Palagin (Wht Mst)
Website: https://band.link/whtmst

Compatibility:
- Designed for World of Warcraft 1.12.1 (Vanilla)
- Optimized for Turtle WoW server (supports IsInInstance() function)
- Fallback logic for other 1.12.1 servers
--]]

-- T-OoM Main Coordinator File
-- This file now serves as a coordinator for all modules
-- All core functionality has been moved to specialized modules:
-- - modules/mana_monitor.lua (mana tracking logic)
-- - modules/ui_display.lua (UI display logic)
-- - modules/settings.lua (settings management)
-- - modules/localization.lua (localization system)

local T_OoM = CreateFrame("Frame")

-- Module initialization and coordination
local function InitializeModules()
    -- Initialize modules in correct order
    if T_OoM_Modules then
        -- 1. Initialize localization first (required by other modules)
        if T_OoM_Modules.Localization then
            T_OoM_Modules.Localization:Initialize()
        end
        
        -- 2. Initialize settings (depends on localization)
        if T_OoM_Modules.Settings then
            T_OoM_Modules.Settings:Initialize()
        end
        
        -- 3. Initialize mana monitor (business logic)
        if T_OoM_Modules.ManaMonitor then
            T_OoM_Modules.ManaMonitor:Initialize()
        end
        
        -- 4. Initialize UI display last (depends on mana monitor and settings)
        if T_OoM_Modules.UIDisplay then
            T_OoM_Modules.UIDisplay:Initialize()
        end
        
        -- 5. Initialize test module if available
        if T_OoM_Modules.Test then
            T_OoM_Modules.Test:Initialize()
        end
    end
end

-- On player login event handler
local function OnPlayerLogin()
    InitializeModules()
    
    -- Show success message using localization
    local title = GetAddOnMetadata("T-OoM", "Title")
    local loaded = title .. " - |cFF00FF00" .. ((L and L("ADDON_LOADED")) or (L and L("FALLBACK_SUCCESS")) or "Successfully loaded!") .. "|r"
    
    DEFAULT_CHAT_FRAME:AddMessage(loaded)
end

-- Register events
---@diagnostic disable-next-line: param-type-mismatch
T_OoM:RegisterEvent("ADDON_LOADED")
---@diagnostic disable-next-line: param-type-mismatch
T_OoM:RegisterEvent("PLAYER_LOGIN")

-- Event handler
T_OoM:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" and arg1 == "T-OoM" then
        -- SavedVariables are available
        DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6EC[T-OoM]|r " .. ((L and L("ADDON_LOADED_EVENT")) or "ADDON_LOADED: SavedVariables ready"))
    elseif event == "PLAYER_LOGIN" then
        OnPlayerLogin()
    end
end)

-- Slash commands (simplified - removed duplicate aliases)
SLASH_TOOM1 = "/toom"

SlashCmdList["TOOM"] = function(msg)
    local args = {}
    for word in string.gmatch(msg, "%S+") do
        table.insert(args, word)
    end
    
    local command = string.lower(args[1] or "")
    
    if command == "test" then
        -- Main functionality test
        if T_OoM_Modules and T_OoM_Modules.Test and T_OoM_Modules.Test.RunQuickTest then
            T_OoM_Modules.Test:RunQuickTest()
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r " .. ((L and L("TEST_ERROR")) or "Test module not available"))
        end
    elseif command == "status" then
        -- Debug command to check global functions availability
        DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6EC" .. ((L and L("STATUS_TITLE")) or "T-OoM Global Functions Status:") .. "|r")
        DEFAULT_CHAT_FRAME:AddMessage("  T_OoM_SettingsOrderTest: " .. (T_OoM_SettingsOrderTest and ("|cFF00FF00" .. ((L and L("STATUS_AVAILABLE")) or "Available") .. "|r") or ("|cFFFF0000" .. ((L and L("STATUS_MISSING")) or "Missing") .. "|r")))
        DEFAULT_CHAT_FRAME:AddMessage("  T_OoM_ManaMonitorTest: " .. (T_OoM_ManaMonitorTest and ("|cFF00FF00" .. ((L and L("STATUS_AVAILABLE")) or "Available") .. "|r") or ("|cFFFF0000" .. ((L and L("STATUS_MISSING")) or "Missing") .. "|r")))
        DEFAULT_CHAT_FRAME:AddMessage("  T_OoM_UIDisplayTest: " .. (T_OoM_UIDisplayTest and ("|cFF00FF00" .. ((L and L("STATUS_AVAILABLE")) or "Available") .. "|r") or ("|cFFFF0000" .. ((L and L("STATUS_MISSING")) or "Missing") .. "|r")))
        DEFAULT_CHAT_FRAME:AddMessage("  T_OoM_UIDisplayManaEventsTest: " .. (T_OoM_UIDisplayManaEventsTest and ("|cFF00FF00" .. ((L and L("STATUS_AVAILABLE")) or "Available") .. "|r") or ("|cFFFF0000" .. ((L and L("STATUS_MISSING")) or "Missing") .. "|r")))
    elseif command == "testorder" then
        -- Settings order test
        if T_OoM_SettingsOrderTest then 
            T_OoM_SettingsOrderTest()
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r " .. ((L and L("SETTINGS_ORDER_TEST_ERROR")) or "Settings order test not available"))
        end
    elseif command == "testmana" then
        -- Mana monitor test
        if T_OoM_ManaMonitorTest then 
            T_OoM_ManaMonitorTest()
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r " .. ((L and L("MANA_MONITOR_TEST_ERROR")) or "Mana monitor test not available"))
        end
    elseif command == "testui" then
        -- UI display test
        if T_OoM_UIDisplayTest then 
            T_OoM_UIDisplayTest()
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r " .. ((L and L("UI_DISPLAY_TEST_ERROR")) or "UI Display test not available"))
        end
    elseif command == "testui_mana" then
        -- UI display mana events test
        if T_OoM_UIDisplayManaEventsTest then 
            T_OoM_UIDisplayManaEventsTest()
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r " .. ((L and L("UI_DISPLAY_MANA_TEST_ERROR")) or "UI Display mana events test not available"))
        end
    elseif command == "config" then
        DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6ECT-OoM:|r " .. ((L and L("CONFIG_NOT_AVAILABLE")) or "Configuration interface not yet available."))
    elseif command == "export" then
        -- Export settings
        if T_OoM_Modules and T_OoM_Modules.Settings and T_OoM_Modules.Settings.Export then
            local exportData = T_OoM_Modules.Settings:Export()
            DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6ECT-OoM:|r " .. ((L and L("EXPORT_SUCCESS")) or "Settings exported. Copy from chat:"))
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00" .. exportData .. "|r")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r " .. ((L and L("SETTINGS_MODULE_ERROR")) or "Settings module not available"))
        end
    elseif command == "lang" then
        -- Language change
        local newLang = args[2]
        if newLang and T_OoM_Modules and T_OoM_Modules.Localization then
            if T_OoM_Modules.Localization:SetLanguage(newLang) then
                local currentLang = T_OoM_Modules.Localization:GetLanguage()
                DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6ECT-OoM:|r " .. ((L and L("LANGUAGE_CHANGED")) or "Language changed to:") .. " " .. currentLang)
            else
                DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM:|r " .. ((L and L("LANGUAGE_NOT_FOUND")) or "Language pack not found:") .. " " .. newLang)
            end
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM:|r " .. ((L and L("LOCALIZATION_MODULE_ERROR")) or "Localization module not available"))
        end
    elseif command == "help" or command == "" then
        -- Help information
        DEFAULT_CHAT_FRAME:AddMessage((L and L("HELP_TITLE")) or "T-OoM Addon Commands:")
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_TEST")) or "/toom test - Run quick functionality test"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_STATUS")) or "/toom status - Check global test functions status"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_TESTORDER")) or "/toom testorder - Test settings keys order"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_TESTMANA")) or "/toom testmana - Test mana monitor module (Stage 3.1)"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_TESTUI")) or "/toom testui - Test UI display module (Stage 3.2)"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_TESTUI_MANA")) or "/toom testui_mana - Test UI display with mana events (Stage 3.2)"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_CONFIG")) or "/toom config - Open configuration window"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_EXPORT")) or "/toom export - Export current settings to chat"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_LANG")) or "/toom lang <en/ru> - Change language"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_HELP")) or "/toom help - Show this help message"))
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM:|r " .. ((L and L("UNKNOWN_COMMAND")) or "Unknown command. Use") .. " |cFFFFFF00/toom help|r")
    end
end