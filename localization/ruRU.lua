--[[
T-OoM Russian Localization
Локализация для русскоговорящих пользователей
--]]

local L = {}

-- Debug message to confirm ruRU.lua is executed
DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6EC[T-OoM]|r ruRU.lua loaded successfully!")

-- Mana messages (Сообщения о мане)
L["LOW_MANA"] = "--- МАЛО МАНЫ ---"
L["CRITICAL_LOW_MANA"] = "--- КРИТИЧЕСКИ МАЛО МАНЫ ---"
L["OUT_OF_MANA"] = "--- ЗАКОНЧИЛАСЬ МАНА ---"

-- Chat commands (Команды чата)
L["HELP_TITLE"] = "Команды аддона T-OoM:"
L["HELP_TEST"] = "/toom test - Запустить быстрый тест функций"
L["HELP_CONFIG"] = "/toom config - Открыть окно настроек"
L["HELP_HELP"] = "/toom help - Показать это сообщение помощи"
L["HELP_LANG"] = "/toom lang <en/ru> - Изменить язык"

-- Test messages (Тестовые сообщения)
L["TEST_START"] = "Запуск быстрого теста T-OoM..."
L["TEST_MODULE_SYSTEM"] = "Система модулей"
L["TEST_SETTINGS"] = "Система настроек"
L["TEST_SAVEDVARS"] = "SavedVariables"
L["TEST_LOCALIZATION"] = "Система локализации"
L["TEST_COMPLETE"] = "Быстрый тест T-OoM завершён!"
L["TEST_OK"] = "ОК"
L["TEST_ERROR"] = "ОШИБКА"

-- Status messages (Статусные сообщения)
L["ADDON_LOADED"] = "T-OoM успешно загружен!"
L["LANGUAGE_CHANGED"] = "Язык изменён на:"
L["LANGUAGE_NOT_FOUND"] = "Языковой пакет не найден:"
L["CONFIG_NOT_AVAILABLE"] = "Интерфейс настроек пока не доступен."

-- Mana threshold names (Названия порогов маны)
L["THRESHOLD_LOW"] = "Мало маны"
L["THRESHOLD_CRITICAL"] = "Критически мало маны"
L["THRESHOLD_OUT"] = "Нет маны"

-- Chat channel names (Названия каналов чата)
L["CHANNEL_SAY"] = "Сказать"
L["CHANNEL_PARTY"] = "Группа"
L["CHANNEL_RAID"] = "Рейд"
L["CHANNEL_GUILD"] = "Гильдия"
L["CHANNEL_WHISPER"] = "Шепот"

-- Instance type names (Названия типов инстансов)
L["INSTANCE_NONE"] = "Открытый мир"
L["INSTANCE_PARTY"] = "Подземелья"
L["INSTANCE_RAID"] = "Рейды"
L["INSTANCE_ARENA"] = "Арены"
L["INSTANCE_PVP"] = "Поля боя"
L["INSTANCE_SCENARIO"] = "Сценарии"

-- Export locale table
T_OoM_Locale_ruRU = L
DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6EC[T-OoM]|r T_OoM_Locale_ruRU exported successfully!")
