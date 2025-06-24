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

-- LEGACY SETTINGS (BACKWARD COMPATIBILITY) - will be migrated to SavedVariables
-- These settings are now loaded from the Settings module but kept here for reference
-- Эти настройки теперь загружаются из модуля Settings, но оставлены здесь для справки

-- MAIN CODE (ОСНОВНОЙ КОД)

-- Debug: Check module loading status
DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6EC[T-OoM]|r Main file loaded. Modules status:")
DEFAULT_CHAT_FRAME:AddMessage("  T_OoM_Modules: " .. (T_OoM_Modules and "OK" or "MISSING"))
if T_OoM_Modules then
    DEFAULT_CHAT_FRAME:AddMessage("  Loader: " .. (T_OoM_Modules.Loader and "OK" or "MISSING"))
    DEFAULT_CHAT_FRAME:AddMessage("  Settings: " .. (T_OoM_Modules.Settings and "OK" or "MISSING"))
end

local T_OoM = CreateFrame("Frame")

-- Initialize variables (Инициализация переменных)
local customFrame
local currentMessage = ""
local lastUpdateTime = 0
local lastManaPercentage = 0
local inInstance = false
local instanceType = ""

-- Settings reference (will be populated after Settings module loads)
local settings = {}

-- Create a custom frame (Создание собственного фрейма)
local function CreateCustomFrame()
    customFrame = CreateFrame("Frame", "CustomMessageFrame", UIParent)
    customFrame:SetWidth(400)
    customFrame:SetHeight(100)
    ---@diagnostic disable-next-line: param-type-mismatch
    customFrame:SetPoint("CENTER", 0, 200)

    -- Create a background with transparency (Создание фона с прозрачностью)
    local background = customFrame:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints(customFrame)
    background:SetTexture(unpack(settings.frameColor or {0, 0, 0, 0}))

    -- Create a font string for text (Создание текстовой области для текста)
    local text = customFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    text:SetFont(settings.fontPath or "Interface\\AddOns\\T-OoM\\fonts\\ARIALN.ttf", 
                 settings.fontSize or 96, "OUTLINE")
    text:SetTextColor(unpack(settings.fontColor or {1, 1, 1, 1}))
    text:SetAllPoints(customFrame)
    ---@diagnostic disable-next-line: inject-field
    customFrame.text = text

    customFrame:Hide()
end

-- Show a custom message (Показать собственное сообщение)
local function ShowCustomMessage(message)
    if not customFrame then
        CreateCustomFrame()
    end

    if customFrame.text then
        customFrame.text:SetText(message)
        currentMessage = message
        customFrame:Show()
        lastUpdateTime = GetTime()
    end
end

-- Hide the custom message frame (Скрыть фрейм с сообщением)
local function HideCustomMessage()
    if customFrame and currentMessage ~= "" then
        customFrame:Hide()
        currentMessage = ""
    end
end

-- Load settings and localization from modules
local function LoadSettings()
    if T_OoM_Modules and T_OoM_Modules.Settings then
        -- Initialize settings first
        T_OoM_Modules.Settings:Initialize()
        
        settings = T_OoM_Modules.Settings:GetAll()
    else
        -- Fallback settings if module not loaded
        settings = {
            lowManaThreshold1 = 0.30,
            lowManaThreshold2 = 0.15,
            lowManaThreshold3 = 0.05,
            lowManaMsg = L and L("LOW_MANA") or "--- LOW ON MANA ---",
            criticalLowManaMsg = L and L("CRITICAL_LOW_MANA") or "--- CRITICAL LOW MANA ---",
            outOfManaMessage = L and L("OUT_OF_MANA") or "--- OUT OF MANA ---",
            chatChannel = "SAY",
            messageDuration = 3,
            fontSize = 96,
            frameColor = {0, 0, 0, 0},
            fontColor = {1, 1, 1, 1},
            fontPath = "Interface\\AddOns\\T-OoM\\fonts\\ARIALN.ttf",
            instanceTypeOptions = {
                none = false,
                party = true,
                raid = false,
                arena = false,
                pvp = false,
                scenario = false
            }
        }
    end
end

-- On player login (При входе игрока)
local function OnPlayerLogin()
    -- Initialize localization system first
    if T_OoM_Modules and T_OoM_Modules.Localization then
        T_OoM_Modules.Localization:Initialize()
    end
    
    -- Then load settings (which depends on localization)
    LoadSettings()
      local title = GetAddOnMetadata("T-OoM", "Title")
    local loaded = title .. " - |cFF00FF00" .. ((L and L("ADDON_LOADED")) or "Successfully loaded!") .. "|r"
    
    DEFAULT_CHAT_FRAME:AddMessage(loaded)
end

-- World/Instance/Graveyard entering or leaves function (Функция входа/выхода игрока в мир, инстанс или на кладбище)
local function OnEnteringWorld()
	-- На сервере Turtle WoW доступна функция IsInInstance()
	---@diagnostic disable-next-line: undefined-global
	if IsInInstance and IsInInstance() == 1 then
		inInstance = true
		-- Определяем тип инстанса по составу группы/рейда
		local numRaidMembers = GetNumRaidMembers()
		local numPartyMembers = GetNumPartyMembers()
		
		if numRaidMembers > 0 then
			instanceType = "raid"
		elseif numPartyMembers > 0 then
			instanceType = "party"
		else
			instanceType = "none"  -- Соло в инстансе
		end
	else
		-- Не в инстансе - определяем состояние по группе
		local numPartyMembers = GetNumPartyMembers()
		local numRaidMembers = GetNumRaidMembers()
		
		inInstance = false
		if numRaidMembers > 0 then
			instanceType = "raid"
		elseif numPartyMembers > 0 then
			instanceType = "party"
		else
			instanceType = "none"
		end
	end

	--[[ DEBUG MESSAGE
	if inInstance then
		print("--- YOU ARE IN AN INSTANCE NOW ---")
		print("--- INSTANCE TYPE: " .. instanceType .. " ---")
	else
		print("--- YOU ARE IN THE WORLD ---")
		print("--- GROUP TYPE: " .. instanceType .. " ---")
	end
	--]]
end

-- Update function (Функция обновления)
T_OoM:SetScript("OnUpdate", function()
    -- Ensure settings are loaded
    if not settings or not settings.lowManaThreshold1 then
        LoadSettings()
        return
    end
    
    local unit = "player"
    local powerType = UnitPowerType(unit)
    local powerToken = (powerType == 0) and "MANA" or "UNKNOWN"
    local currentMana = UnitMana(unit)
    local maxMana = UnitManaMax(unit)
    local manaPercentage = currentMana / maxMana

    if settings.instanceTypeOptions[instanceType] then
        if powerToken == "MANA" then
            if manaPercentage <= settings.lowManaThreshold3 and lastManaPercentage > settings.lowManaThreshold3 then
                SendChatMessage(settings.outOfManaMessage, settings.chatChannel)
                ShowCustomMessage(settings.outOfManaMessage)
            elseif manaPercentage <= settings.lowManaThreshold2 and manaPercentage > settings.lowManaThreshold3 and lastManaPercentage > settings.lowManaThreshold2 then
                SendChatMessage(settings.criticalLowManaMsg, settings.chatChannel)
                ShowCustomMessage(settings.criticalLowManaMsg)
            elseif manaPercentage <= settings.lowManaThreshold1 and manaPercentage > settings.lowManaThreshold2 and lastManaPercentage > settings.lowManaThreshold1 then
                SendChatMessage(settings.lowManaMsg, settings.chatChannel)
                ShowCustomMessage(settings.lowManaMsg)
            end
        else
            HideCustomMessage()
        end
    else
        if powerToken == "MANA" then
            if manaPercentage <= settings.lowManaThreshold3 and lastManaPercentage > settings.lowManaThreshold3 then
                ShowCustomMessage(settings.outOfManaMessage)
            elseif manaPercentage <= settings.lowManaThreshold2 and manaPercentage > settings.lowManaThreshold3 and lastManaPercentage > settings.lowManaThreshold2 then
                ShowCustomMessage(settings.criticalLowManaMsg)
            elseif manaPercentage <= settings.lowManaThreshold1 and manaPercentage > settings.lowManaThreshold2 and lastManaPercentage > settings.lowManaThreshold1 then
                ShowCustomMessage(settings.lowManaMsg)
            end
        else
            HideCustomMessage()
        end
    end

    if currentMessage ~= "" and GetTime() - lastUpdateTime >= (settings.messageDuration or 3) then
        HideCustomMessage()
    end

    lastManaPercentage = manaPercentage
end)

-- Register events (Регистрация событий)
---@diagnostic disable-next-line: param-type-mismatch
T_OoM:RegisterEvent("ADDON_LOADED")
---@diagnostic disable-next-line: param-type-mismatch
T_OoM:RegisterEvent("PLAYER_LOGIN")
---@diagnostic disable-next-line: param-type-mismatch  
T_OoM:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Set event handlers (Установка обработчиков событий)
T_OoM:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" and arg1 == "T-OoM" then
        -- SavedVariables are now available but don't initialize here
        -- Initialize will happen in PLAYER_LOGIN event
        DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6EC[T-OoM]|r ADDON_LOADED: SavedVariables ready")
    elseif event == "PLAYER_LOGIN" then
        OnPlayerLogin()
		-- print("Event 'PLAYER_LOGIN' handled")
    elseif event == "PLAYER_ENTERING_WORLD" then
        OnEnteringWorld()
		-- print("Event 'PLAYER_ENTERING_WORLD' handled")
    end
end)

-- Slash commands for testing and configuration
SLASH_TOOM1 = "/toom"

SlashCmdList["TOOM"] = function(msg)
    local args = {}
    for word in string.gmatch(msg, "%S+") do
        table.insert(args, word) -- Don't lowercase - we'll handle case sensitivity per command
    end
    
    local command = string.lower(args[1] or "") -- Only lowercase the command, not arguments
      if command == "test" or command == "check" then
        -- Use test module if available
        if T_OoM_Modules and T_OoM_Modules.Test and T_OoM_Modules.Test.RunQuickTest then
            T_OoM_Modules.Test:RunQuickTest()
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r " .. ((L and L("TEST_ERROR")) or "Test module not available"))
        end
    elseif command == "testorder" or command == "order" then        -- Test settings order
        if T_OoM_SettingsOrderTest then 
            T_OoM_SettingsOrderTest()
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r Settings order test not available")
        end
    elseif command == "config" or command == "settings" then
        DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6ECT-OoM:|r " .. ((L and L("CONFIG_NOT_AVAILABLE")) or "Configuration interface not yet available."))
    elseif command == "export" then
        -- Export settings to string
        if T_OoM_Modules and T_OoM_Modules.Settings and T_OoM_Modules.Settings.Export then
            local exportData = T_OoM_Modules.Settings:Export()
            DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6ECT-OoM:|r " .. ((L and L("EXPORT_SUCCESS")) or "Settings exported. Copy from chat:"))
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00" .. exportData .. "|r")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r Settings module not available")
        end
    elseif command == "lang" or command == "language" then
        local newLang = args[2] -- Don't lowercase the language code
        if newLang and T_OoM_Modules and T_OoM_Modules.Localization then
            if T_OoM_Modules.Localization:SetLanguage(newLang) then
                -- Get actual current language after successful change
                local currentLang = T_OoM_Modules.Localization:GetLanguage()
                DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6ECT-OoM:|r " .. ((L and L("LANGUAGE_CHANGED")) or "Language changed to:") .. " " .. currentLang)
                -- Reload settings to get localized messages
                LoadSettings()
            else
                DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM:|r " .. ((L and L("LANGUAGE_NOT_FOUND")) or "Language pack not found:") .. " " .. newLang)
            end
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM:|r Localization module not available")
        end    elseif command == "help" or command == "" then
        DEFAULT_CHAT_FRAME:AddMessage((L and L("HELP_TITLE")) or "T-OoM Addon Commands:")
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_TEST")) or "/toom test - Run quick functionality test"))
        DEFAULT_CHAT_FRAME:AddMessage("  /toom testorder - Test settings keys order")
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_CONFIG")) or "/toom config - Open configuration window"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_EXPORT")) or "/toom export - Export current settings to chat"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_LANG")) or "/toom lang <en/ru> - Change language"))
        DEFAULT_CHAT_FRAME:AddMessage("  " .. ((L and L("HELP_HELP")) or "/toom help - Show this help message"))
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM:|r Unknown command. Use |cFFFFFF00/toom help|r")
    end
end