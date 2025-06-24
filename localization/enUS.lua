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
L["HELP_HELP"] = "/toom help - Show this help message"
L["HELP_LANG"] = "/toom lang <en/ru> - Change language"

-- Test messages (Тестовые сообщения)
L["TEST_START"] = "Running T-OoM Quick Test..."
L["TEST_MODULE_SYSTEM"] = "Module System"
L["TEST_SETTINGS"] = "Settings System"
L["TEST_SAVEDVARS"] = "SavedVariables"
L["TEST_LOCALIZATION"] = "Localization System"
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

-- Export locale table
T_OoM_Locale_enUS = L
DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6EC[T-OoM]|r T_OoM_Locale_enUS exported successfully!")
