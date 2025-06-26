--[[
T-OoM English (US) Localization
Default language pack for English users
--]]

local L = {}

-- Debug message to confirm enUS.lua is executed
DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6EC[T-OoM]|r enUS.lua loaded successfully!")

-- Mana messages (Сообщения о мане)
L["LOW_MANA"] = "--- LOW ON MANA ---"
L["CRITICAL_LOW_MANA"] = "--- CRITICAL LOW MANA ---"
L["OUT_OF_MANA"] = "--- OUT OF MANA ---"

-- Chat commands (Команды чата)
L["HELP_TITLE"] = "T-OoM Addon Commands:"
L["HELP_TEST"] = "/toom test - Run quick functionality test"
L["HELP_CONFIG"] = "/toom config - Open configuration window"
L["HELP_EXPORT"] = "/toom export - Export current settings to chat"
L["HELP_HELP"] = "/toom help - Show this help message"
L["HELP_LANG"] = "/toom lang <en/ru> - Change language"

-- Test messages (Тестовые сообщения)
L["TEST_START"] = "Running T-OoM Quick Test..."
L["TEST_MODULE_SYSTEM"] = "Module System"
L["TEST_SETTINGS"] = "Settings System"
L["TEST_SAVEDVARS"] = "SavedVariables"
L["TEST_LOCALIZATION"] = "Localization System"
L["TEST_LOADER"] = "Module Loader"
L["TEST_MANA_MONITOR"] = "Mana Monitor Module"
L["TEST_UI_DISPLAY"] = "UI Display Module"
L["TEST_COMPLETE"] = "T-OoM Quick Test Complete!"
L["TEST_OK"] = "OK"
L["TEST_ERROR"] = "ERROR"

-- Status messages (Статусные сообщения)
L["ADDON_LOADED"] = "T-OoM loaded successfully!"
L["LANGUAGE_CHANGED"] = "Language changed to:"
L["LANGUAGE_NOT_FOUND"] = "Language pack not found:"
L["CONFIG_NOT_AVAILABLE"] = "Configuration interface not yet available."

-- Mana threshold names (Названия порогов маны)
L["THRESHOLD_LOW"] = "Low Mana"
L["THRESHOLD_CRITICAL"] = "Critical Low Mana"
L["THRESHOLD_OUT"] = "Out of Mana"

-- Chat channel names (Названия каналов чата)
L["CHANNEL_SAY"] = "Say"
L["CHANNEL_PARTY"] = "Party"
L["CHANNEL_RAID"] = "Raid"
L["CHANNEL_GUILD"] = "Guild"
L["CHANNEL_WHISPER"] = "Whisper"

-- Instance type names (Названия типов инстансов)
L["INSTANCE_NONE"] = "Open World"
L["INSTANCE_PARTY"] = "Dungeons"
L["INSTANCE_RAID"] = "Raids"
L["INSTANCE_ARENA"] = "Arenas"
L["INSTANCE_PVP"] = "Battlegrounds"
L["INSTANCE_SCENARIO"] = "Scenarios"

-- Export messages (Сообщения экспорта)
L["EXPORT_SUCCESS"] = "Settings exported. Copy from chat:"

-- Error messages (Сообщения об ошибках)
L["TEST_ERROR"] = "Test module not available"
L["SETTINGS_ORDER_TEST_ERROR"] = "Settings order test not available"
L["UI_DISPLAY_TEST_ERROR"] = "UI Display test not available"
L["UI_DISPLAY_MANA_TEST_ERROR"] = "UI Display mana events test not available"
L["MANA_MONITOR_TEST_ERROR"] = "Mana monitor test not available"
L["SETTINGS_MODULE_ERROR"] = "Settings module not available"
L["LOCALIZATION_MODULE_ERROR"] = "Localization module not available"
L["GUI_FRAMEWORK_TEST_ERROR"] = "GUI Framework test not available"
L["CONFIG_GUI_ERROR"] = "Configuration GUI not available"

-- Debug messages (Отладочные сообщения)
L["MAIN_FILE_LOADED"] = "Main file loaded. Modules status:"
L["MODULES_STATUS"] = "T_OoM_Modules:"
L["LOADER_STATUS"] = "Loader:"
L["SETTINGS_STATUS"] = "Settings:"
L["MODULE_OK"] = "OK"
L["MODULE_MISSING"] = "MISSING"
L["ADDON_LOADED_EVENT"] = "ADDON_LOADED: SavedVariables ready"
L["FALLBACK_SUCCESS"] = "Successfully loaded!"
L["UNKNOWN_COMMAND"] = "Unknown command. Use"

-- Status command messages (Сообщения команды статуса)
L["STATUS_TITLE"] = "T-OoM Global Functions Status:"
L["STATUS_AVAILABLE"] = "Available"
L["STATUS_MISSING"] = "Missing"
L["HELP_STATUS"] = "/toom status - Check global test functions status"

-- Help command messages (Сообщения команд справки)
L["HELP_TESTORDER"] = "/toom testorder - Test settings keys order"
L["HELP_TESTMANA"] = "/toom testmana - Test mana monitor module (Stage 3.1)"
L["HELP_TESTUI"] = "/toom testui - Test UI display module (Stage 3.2)"
L["HELP_TESTUI_MANA"] = "/toom testui_mana - Test UI display with mana events (Stage 3.2)"
L["HELP_TESTGUI"] = "/toom testgui - Test GUI framework module (Stage 4.1)"

-- Minimap button tooltips
L["MINIMAP_TOOLTIP_DESC"] = "Out of Mana announcer addon"
L["MINIMAP_TOOLTIP_CLICK"] = "Click: Open configuration"
L["MINIMAP_TOOLTIP_DRAG"] = "Shift+Drag: Move button"

-- Export locale table
T_OoM_Locale_enUS = L
DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6EC[T-OoM]|r T_OoM_Locale_enUS exported successfully!")
