--[[
T-OoM - is a simple Out of Mana announcer addon for Turtle WoW.
T-OoM - это простой аддон для объявления об окончании маны для сервера Turtle WoW.

Addon GitHub link: 

Author: Mikhail Palagin (Wht Mst)
Website: https://band.link/whtmst
--]]


local T_OoM = CreateFrame("Frame")

-- Message settings (Настройки сообщений)
local outOfManaMessage = "--- OUT OF MANA ---"  -- Message at 5% of mana (Сообщение при 5% маны)
local lowManaMessage = "--- LOW MANA ---"  -- Message at 25% of mana (Сообщение при 25% маны)
local mana50Message = "--- MANA IS 50% ---"  -- Message at 50% of mana (Сообщение при 50% маны)
local chatChannel = "PARTY"  -- You can change the channel, for example, to "RAID" or "SAY" (channel for sending messages) (Вы можете изменить чат, например, на "RAID" или "SAY" (чат для отправки сообщений))

-- Mana thresholds (Пороги маны)
local lowManaThreshold1 = 0.50 -- Threshold at 50% of mana (Порог при 50% маны)
local lowManaThreshold2 = 0.25 -- Threshold at 25% of mana (Порог при 25% маны)
local lowManaThreshold3 = 0.05 -- Threshold at 5% of mana (Порог при 5% маны)
local messageDuration = 5  -- Время отображения сообщения в секундах

-- Initialize variables (Инициализация переменных)
local customFrame
local currentMessage = ""
local lastUpdateTime = 0

-- Create a custom frame (Создание собственного фрейма)
local function CreateCustomFrame()
    customFrame = CreateFrame("Frame", "CustomMessageFrame", UIParent)
    customFrame:SetWidth(400)
    customFrame:SetHeight(100)
    customFrame:SetPoint("CENTER", 0, 200)

    -- Create a background with transparency (Создание фона с прозрачностью)
    local background = customFrame:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints(customFrame)
    background:SetTexture(0, 0, 0, 0)

    -- Create a font string for text (Создание текстовой области для текста)
    local text = customFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    text:SetFont("Interface\\AddOns\\T-OoM\\Fonts\\ARIALN.ttf", 96, "OUTLINE")
    text:SetTextColor(1, 1, 1, 1)
    text:SetAllPoints(customFrame)
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

-- Update function (Функция обновления)
T_OoM:SetScript("OnUpdate", function()
    local unit = "player"
    local powerType = UnitPowerType(unit)
    local powerToken = (powerType == 0) and "MANA" or "UNKNOWN"
    local currentMana = UnitMana(unit)
    local maxMana = UnitManaMax(unit)
    local manaPercentage = currentMana / maxMana

    if powerToken == "MANA" then
        if manaPercentage <= lowManaThreshold3 and lastManaPercentage > lowManaThreshold3 then
            SendChatMessage(outOfManaMessage, chatChannel)
            ShowCustomMessage(outOfManaMessage)
        elseif manaPercentage <= lowManaThreshold2 and manaPercentage > lowManaThreshold3 and lastManaPercentage > lowManaThreshold2 then
            SendChatMessage(lowManaMessage, chatChannel)
            ShowCustomMessage(lowManaMessage)
        elseif manaPercentage <= lowManaThreshold1 and manaPercentage > lowManaThreshold2 and lastManaPercentage > lowManaThreshold1 then
            SendChatMessage(mana50Message, chatChannel)
            ShowCustomMessage(mana50Message)
        end
    else
        HideCustomMessage()
    end

    if currentMessage ~= "" and GetTime() - lastUpdateTime >= messageDuration then
        HideCustomMessage()
    end

    lastManaPercentage = manaPercentage
end)

-- On player login (При входе игрока)
local function OnPlayerLogin()
    local title = GetAddOnMetadata("T-OoM", "Title")
    local notes = GetAddOnMetadata("T-OoM", "Notes")
    local loaded = title .. " - |cFF00FF00Successfully loaded!|r"
    local message = notes

    DEFAULT_CHAT_FRAME:AddMessage(loaded)
    DEFAULT_CHAT_FRAME:AddMessage(message)
end

T_OoM:RegisterEvent("PLAYER_LOGIN")
T_OoM:SetScript("OnEvent", OnPlayerLogin)