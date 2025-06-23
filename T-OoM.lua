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

-- Load settings from Settings module
local function LoadSettings()
    if T_OoM_Modules and T_OoM_Modules.Settings then
        settings = T_OoM_Modules.Settings:GetAll()
    else
        -- Fallback settings if module not loaded
        settings = {
            lowManaThreshold1 = 0.30,
            lowManaThreshold2 = 0.15,
            lowManaThreshold3 = 0.05,
            lowManaMsg = "--- LOW ON MANA ---",
            criticalLowManaMsg = "--- CRITICAL LOW MANA ---",
            outOfManaMessage = "--- OUT OF MANA ---",
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
    LoadSettings()
    
    local title = GetAddOnMetadata("T-OoM", "Title")
    local notes = GetAddOnMetadata("T-OoM", "Notes")
    local loaded = title .. " - |cFF00FF00Successfully loaded!|r"
    local message = notes

    DEFAULT_CHAT_FRAME:AddMessage(loaded)
    DEFAULT_CHAT_FRAME:AddMessage(message)
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
T_OoM:RegisterEvent("PLAYER_LOGIN")
---@diagnostic disable-next-line: param-type-mismatch  
T_OoM:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Set event handlers (Установка обработчиков событий)
T_OoM:SetScript("OnEvent", function()
    if event == "PLAYER_LOGIN" then
        OnPlayerLogin()
		-- print("Event 'PLAYER_LOGIN' handled")
    elseif event == "PLAYER_ENTERING_WORLD" then
        OnEnteringWorld()
		-- print("Event 'PLAYER_ENTERING_WORLD' handled")
    end
end)