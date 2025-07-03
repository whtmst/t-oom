--[[
T-OoM - is a simple Out of Mana announcer addon for Turtle WoW.
T-OoM - это простой аддон для объявления об окончании маны для сервера Turtle WoW.

Addon GitHub link: https://github.com/whtmst/t-oom

Author: Mikhail Palagin (Wht Mst)
Website: https://band.link/whtmst

Compatibility:
- Designed for World of Warcraft 1.12.0 (Vanilla)
- Optimized for Turtle WoW server (supports IsInInstance() function)
- Fallback logic for other 1.12.0 servers
--]]

-- T-OoM Main Coordinator File
-- This file now serves as a coordinator for all modules
-- All core functionality has been moved to specialized modules:
-- - modules/mana_monitor.lua (mana tracking logic)
-- - modules/ui_display.lua (UI display logic)
-- - modules/settings.lua (settings management)
-- - modules/localization.lua (localization system)

local T_OoM = CreateFrame("Frame")
local isMinimapButtonInitialized = false -- ADDED: Flag to ensure minimap button is created only once

-- Module initialization and coordination
local function InitializeModules()
    -- This function now only handles non-visual modules that can be set up early.
    -- Localization and Settings are now initialized later, in ADDON_LOADED.
end

local function PostInitializeModules()
    -- This function now handles modules that can be initialized after settings are loaded.
    if T_OoM_Modules then
        -- Initialize modules that depend on settings and localization
        if T_OoM_Modules.ManaMonitor then
            T_OoM_Modules.ManaMonitor:Initialize()
        end
        if T_OoM_Modules.UIDisplay then
            T_OoM_Modules.UIDisplay:Initialize()
        end
        if T_OoM_Modules.ConfigGUI then
            T_OoM_Modules.ConfigGUI:Initialize()
        end
    end
end

-- Event handler for the main frame
T_OoM:SetScript("OnEvent", function(event, arg1)
    if event == "ADDON_LOADED" and arg1 == "T-OoM" then
        -- This is the correct place to initialize systems that depend on all files being loaded.
        
        -- 1. Initialize Localization first (it needs the locale files like enUS.lua to be loaded)
        if T_OoM_Modules and T_OoM_Modules.Localization then
            T_OoM_Modules.Localization:Initialize()
        end

        -- 2. Initialize Settings (it may depend on localization for defaults)
        if T_OoM_Modules and T_OoM_Modules.Settings then
            T_OoM_Modules.Settings:Initialize()
        end

        -- 3. Initialize other core modules
        PostInitializeModules()

        -- 4. Setup slash commands
        SlashCmdList["TOOM"] = T_OoM_Modules.Settings.SlashCmdHandler
        SLASH_TOOM1 = "/toom"

        DEFAULT_CHAT_FRAME:AddMessage("|cFF1AF5A5[WM T]|r T-OoM v1.0.0 (Beta) - " .. ((T_OoM_Modules.Localization and T_OoM_Modules.Localization.GetString("LOADED_SUCCESSFULLY")) or "T-OoM loaded successfully!"))
        
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- This event fires after the player is in the world and all addons are loaded.
        -- This is the safest place to create UI elements like minimap buttons.
        if not isMinimapButtonInitialized then
            if T_OoM_Modules and T_OoM_Modules.MinimapButton and T_OoM_Settings and T_OoM_Settings.minimapButton.enabled then
                T_OoM_Modules.MinimapButton:Initialize()
            end
            isMinimapButtonInitialized = true
            
            -- Unregister the event to prevent this block from running again
            T_OoM:UnregisterEvent("PLAYER_ENTERING_WORLD")
        end
    end
end)

-- Register events
T_OoM:RegisterEvent("ADDON_LOADED")
T_OoM:RegisterEvent("PLAYER_ENTERING_WORLD") -- CHANGED: We now listen for this event

-- Initial call (if needed for any pre-loading logic)
InitializeModules()

-- Test command handler
function T_OoM_TestCommandHandler(msg)
    local L = T_OoM_Modules.Localization.GetString
    local args = {}
    for w in string.gfind(msg, "[^%s]+") do table.insert(args, w) end
    local command = args[1]

    if command == "test" then
        DEFAULT_CHAT_FRAME:AddMessage("T-OoM: Quick test executed.")
    elseif command == "status" then
        T_OoM_Modules.Tests:PrintStatus()
    elseif command == "testorder" then
        T_OoM_Modules.Tests:TestSettingsOrder()
    elseif command == "testmana" then
        T_OoM_Modules.Tests:TestManaMonitor()
    elseif command == "testui" then
        T_OoM_Modules.Tests:TestUIDisplay()
    elseif command == "testui_mana" then
        T_OoM_Modules.Tests:TestUIDisplayWithMana()
    elseif command == "testgui" then
        T_OoM_Modules.Tests:TestGUIFramework()
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00T-OoM:|r " .. ((L and L("HELP_HEADER")) or "Available test commands:"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_TEST")) or "/toom test - Run quick functionality test"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_STATUS")) or "/toom status - Check global test functions status"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_TESTORDER")) or "/toom testorder - Test settings keys order"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_TESTMANA")) or "/toom testmana - Test mana monitor module (Stage 3.1)"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_TESTUI")) or "/toom testui - Test UI display module (Stage 3.2)"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_TESTUI_MANA")) or "/toom testui_mana - Test UI display with mana events (Stage 3.2)"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_TESTGUI")) or "/toom testgui - Test GUI framework module (Stage 4.1)"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_CONFIG")) or "/toom config - Open configuration window"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_EXPORT")) or "/toom export - Export current settings to chat"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_LANG")) or "/toom lang <en/ru> - Change language"))
        DEFAULT_CHAT_FRAME:AddMessage("...")
    end
end