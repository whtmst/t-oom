--[[
T-OoM UI Display Module
Handles visual display of mana messages and custom frames
Модуль отображения UI - управляет визуальным отображением сообщений о мане
--]]

-- Create the UIDisplay module
local UIDisplay = {}

-- Module state
local isInitialized = false
local customFrame = nil
local currentMessage = ""
local lastUpdateTime = 0
local settings = {}

-- Private variables for message management
local messageQueue = {}
local isShowingMessage = false

-- Initialize the module
function UIDisplay:Initialize()
    if isInitialized then
        return
    end
    
    isInitialized = true
    
    -- Load current settings
    self:UpdateSettings()
    
    -- Create update frame for message duration handling
    local updateFrame = CreateFrame("Frame", "T_OoM_UIDisplayUpdateFrame")
    updateFrame:SetScript("OnUpdate", function()
        self:OnUpdate()
    end)
    self.updateFrame = updateFrame
    
    -- Register callback with ManaMonitor if available
    if T_OoM_Modules and T_OoM_Modules.ManaMonitor then
        T_OoM_Modules.ManaMonitor:RegisterCallback("onManaThresholdReached", function(data)
            self:OnManaThresholdReached(data)
        end)
        
        T_OoM_Modules.ManaMonitor:RegisterCallback("onPowerTypeChanged", function(data)
            self:OnPowerTypeChanged(data)
        end)
    end
    
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00T-OoM:|r UI Display module initialized")
end

-- Update settings from Settings module
function UIDisplay:UpdateSettings()
    if T_OoM_Modules and T_OoM_Modules.Settings then
        settings = T_OoM_Modules.Settings:GetAll()
    else
        -- Fallback settings
        settings = {
            messageDuration = 3,
            fontSize = 96,
            frameColor = {0, 0, 0, 0},
            fontColor = {1, 1, 1, 1},
            fontPath = "Interface\\AddOns\\T-OoM\\fonts\\ARIALN.ttf",
            chatChannel = "SAY",
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

-- Create the custom message frame
function UIDisplay:CreateCustomFrame()
    if customFrame then
        return customFrame
    end
    
    customFrame = CreateFrame("Frame", "T_OoM_CustomMessageFrame", UIParent)
    customFrame:SetWidth(400)
    customFrame:SetHeight(100)
    ---@diagnostic disable-next-line: param-type-mismatch
    customFrame:SetPoint("CENTER", 0, 200)

    -- Create a background with transparency
    local background = customFrame:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints(customFrame)
    background:SetTexture(unpack(settings.frameColor or {0, 0, 0, 0}))

    -- Create a font string for text
    local text = customFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    text:SetFont(settings.fontPath or "Interface\\AddOns\\T-OoM\\fonts\\ARIALN.ttf", 
                 settings.fontSize or 96, "OUTLINE")
    text:SetTextColor(unpack(settings.fontColor or {1, 1, 1, 1}))
    text:SetAllPoints(customFrame)
    ---@diagnostic disable-next-line: inject-field
    customFrame.text = text

    customFrame:Hide()
    
    return customFrame
end

-- Update frame appearance with current settings
function UIDisplay:UpdateFrameAppearance()
    if not customFrame or not customFrame.text then
        return
    end
    
    -- Update font
    customFrame.text:SetFont(
        settings.fontPath or "Interface\\AddOns\\T-OoM\\fonts\\ARIALN.ttf", 
        settings.fontSize or 96, 
        "OUTLINE"
    )
    
    -- Update colors
    customFrame.text:SetTextColor(unpack(settings.fontColor or {1, 1, 1, 1}))
    
    -- Update background
    local background = customFrame:GetRegions()
    if background and background.SetTexture then
        background:SetTexture(unpack(settings.frameColor or {0, 0, 0, 0}))
    end
end

-- Show a custom message on screen
function UIDisplay:ShowCustomMessage(message)
    if not message or message == "" then
        return
    end
    
    -- Ensure frame exists
    self:CreateCustomFrame()
    self:UpdateFrameAppearance()
    
    if customFrame and customFrame.text then
        customFrame.text:SetText(message)
        currentMessage = message
        customFrame:Show()
        lastUpdateTime = GetTime()
        isShowingMessage = true
    end
end

-- Hide the custom message frame
function UIDisplay:HideCustomMessage()
    if customFrame and currentMessage ~= "" then
        customFrame:Hide()
        currentMessage = ""
        isShowingMessage = false
    end
end

-- Send message to chat channel
function UIDisplay:SendChatMessage(message, instanceType)
    if not message or message == "" then
        return
    end
    
    -- Check if we should send to chat based on instance type
    local instanceOptions = settings.instanceTypeOptions or {}
    if not instanceOptions[instanceType or "none"] then
        return -- Don't send to chat in this instance type
    end
    
    local chatChannel = settings.chatChannel or "SAY"
    
    -- Send the message
    local success, err = pcall(SendChatMessage, message, chatChannel)
    if not success then
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r Failed to send chat message: " .. tostring(err))
    end
end

-- Handle mana threshold reached event
function UIDisplay:OnManaThresholdReached(data)
    if not data or not data.message then
        return
    end
    
    -- Always show visual message
    self:ShowCustomMessage(data.message)
    
    -- Determine instance type (this should come from a location module in the future)
    local instanceType = self:GetCurrentInstanceType()
    
    -- Send to chat if appropriate
    self:SendChatMessage(data.message, instanceType)
end

-- Handle power type changed event
function UIDisplay:OnPowerTypeChanged(data)
    if not data then
        return
    end
    
    -- Hide message if player is no longer a mana user
    if not data.isManaUser then
        self:HideCustomMessage()
    end
end

-- Get current instance type (temporary implementation)
function UIDisplay:GetCurrentInstanceType()
    -- This logic should be moved to a separate location module in the future
    local numRaidMembers = GetNumRaidMembers()
    local numPartyMembers = GetNumPartyMembers()
    
    -- Try to detect instance (Turtle WoW specific)
    ---@diagnostic disable-next-line: undefined-global
    local inInstance = IsInInstance and IsInInstance() == 1
    
    if inInstance then
        if numRaidMembers > 0 then
            return "raid"
        elseif numPartyMembers > 0 then
            return "party"
        else
            return "none" -- Solo in instance
        end
    else
        -- Not in instance - determine by group
        if numRaidMembers > 0 then
            return "raid"
        elseif numPartyMembers > 0 then
            return "party"
        else
            return "none"
        end
    end
end

-- OnUpdate handler for message duration
function UIDisplay:OnUpdate()
    if not isShowingMessage or currentMessage == "" then
        return
    end
    
    local duration = settings.messageDuration or 3
    if GetTime() - lastUpdateTime >= duration then
        self:HideCustomMessage()
    end
end

-- Test function: show a test message
function UIDisplay:ShowTestMessage(message, duration)
    local testMessage = message or "TEST MESSAGE - UI Display Module"
    local testDuration = duration or 2
    
    -- Temporarily override duration
    local originalDuration = settings.messageDuration
    settings.messageDuration = testDuration
    
    self:ShowCustomMessage(testMessage)
    
    -- Restore original duration after a delay
    local restoreFrame = CreateFrame("Frame")
    local startTime = GetTime()
    restoreFrame:SetScript("OnUpdate", function()
        if GetTime() - startTime >= testDuration + 0.1 then
            settings.messageDuration = originalDuration
            restoreFrame:SetScript("OnUpdate", nil)
        end
    end)
    
    return true
end

-- Test function: simulate mana threshold event
function UIDisplay:SimulateManaEvent(level)
    local testData = {
        threshold = level or 1,
        level = "test",
        percentage = 0.25,
        message = "TEST MANA EVENT - Level " .. (level or 1)
    }
    
    self:OnManaThresholdReached(testData)
end

-- Get current display state
function UIDisplay:GetDisplayState()
    return {
        isInitialized = isInitialized,
        isShowingMessage = isShowingMessage,
        currentMessage = currentMessage,
        frameExists = (customFrame ~= nil),
        lastUpdateTime = lastUpdateTime
    }
end

-- Force refresh settings
function UIDisplay:RefreshSettings()
    self:UpdateSettings()
    if customFrame then
        self:UpdateFrameAppearance()
    end
end

-- Cleanup function
function UIDisplay:Cleanup()
    if customFrame then
        customFrame:Hide()
        customFrame = nil
    end
    
    if self.updateFrame then
        self.updateFrame:SetScript("OnUpdate", nil)
        self.updateFrame = nil
    end
    
    currentMessage = ""
    isShowingMessage = false
    isInitialized = false
    
    -- Unregister callbacks (if ManaMonitor supports it)
    -- This would need to be implemented in ManaMonitor module
end

-- Register the module
if T_OoM_Modules and T_OoM_Modules.Loader then
    T_OoM_Modules.Loader:RegisterModule("UIDisplay", UIDisplay)
else
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r Module loader not available for UIDisplay")
end
