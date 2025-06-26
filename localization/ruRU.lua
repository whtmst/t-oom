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
L["HELP_EXPORT"] = "/toom export - Экспортировать текущие настройки в чат"
L["HELP_HELP"] = "/toom help - Показать это сообщение помощи"
L["HELP_LANG"] = "/toom lang <en/ru> - Изменить язык"

-- Test messages (Тестовые сообщения)
L["TEST_START"] = "Запуск быстрого теста T-OoM..."
L["TEST_MODULE_SYSTEM"] = "Система модулей"
L["TEST_SETTINGS"] = "Система настроек"
L["TEST_SAVEDVARS"] = "SavedVariables"
L["TEST_LOCALIZATION"] = "Система локализации"
L["TEST_LOADER"] = "Загрузчик модулей"
L["TEST_MANA_MONITOR"] = "Модуль мониторинга маны"
L["TEST_UI_DISPLAY"] = "Модуль отображения UI"
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

-- Export messages (Сообщения экспорта)
L["EXPORT_SUCCESS"] = "Настройки экспортированы. Скопируйте из чата:"

-- Error messages (Сообщения об ошибках)
L["TEST_ERROR"] = "Модуль тестирования недоступен"
L["SETTINGS_ORDER_TEST_ERROR"] = "Тест порядка настроек недоступен"
L["UI_DISPLAY_TEST_ERROR"] = "Тест UI Display недоступен"
L["UI_DISPLAY_MANA_TEST_ERROR"] = "Тест UI с событиями маны недоступен"
L["MANA_MONITOR_TEST_ERROR"] = "Тест мониторинга маны недоступен"
L["SETTINGS_MODULE_ERROR"] = "Модуль настроек недоступен"
L["LOCALIZATION_MODULE_ERROR"] = "Модуль локализации недоступен"
L["GUI_FRAMEWORK_TEST_ERROR"] = "Тест GUI фреймворка недоступен"

-- Debug messages (Отладочные сообщения)
L["MAIN_FILE_LOADED"] = "Основной файл загружен. Статус модулей:"
L["MODULES_STATUS"] = "T_OoM_Modules:"
L["LOADER_STATUS"] = "Загрузчик:"
L["SETTINGS_STATUS"] = "Настройки:"
L["MODULE_OK"] = "ОК"
L["MODULE_MISSING"] = "ОТСУТСТВУЕТ"
L["ADDON_LOADED_EVENT"] = "ADDON_LOADED: SavedVariables готовы"
L["FALLBACK_SUCCESS"] = "Успешно загружено!"
L["UNKNOWN_COMMAND"] = "Неизвестная команда. Используйте"

-- Status command messages (Сообщения команды статуса)
L["STATUS_TITLE"] = "Статус глобальных функций T-OoM:"
L["STATUS_AVAILABLE"] = "Доступно"
L["STATUS_MISSING"] = "Отсутствует"
L["HELP_STATUS"] = "/toom status - Проверить статус глобальных функций тестов"

-- Help command messages (Сообщения команд справки)
L["HELP_TESTORDER"] = "/toom testorder - Тест порядка настроек"
L["HELP_TESTMANA"] = "/toom testmana - Тест модуля мониторинга маны (Этап 3.1)"
L["HELP_TESTUI"] = "/toom testui - Тест модуля отображения UI (Этап 3.2)"
L["HELP_TESTUI_MANA"] = "/toom testui_mana - Тест UI с событиями маны (Этап 3.2)"
L["HELP_TESTGUI"] = "/toom testgui - Тест модуля GUI фреймворка (Этап 4.1)"

-- Export locale table
T_OoM_Locale_ruRU = L
DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6EC[T-OoM]|r T_OoM_Locale_ruRU exported successfully!")
