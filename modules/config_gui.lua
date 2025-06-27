--[[
T-OoM Configuration GUI
Main configuration window for T-OoM addon settings
Главное окно настроек аддона T-OоM

WoW 1.12.1 Compatible Configuration Interface
--]]

-- Create Configuration GUI module
local ConfigGUI = {}

-- Module constants
local MODULE_NAME = "ConfigGUI"
local DEBUG_PREFIX = "|cFF11A6EC[T-OoM Config]|r"

-- Private variables
local configWindow = nil
local isWindowOpen = false

-- GUI component references
local components = {}

-- Get localization function (fallback if not available)
local L = function(key) 
    if T_OoM_Modules and T_OoM_Modules.Localization and T_OoM_Modules.Localization.GetString then
        return T_OoM_Modules.Localization.GetString(key)
    end
    return key  -- Fallback to key if localization not available
end

-- Get GUI Framework reference
local function GetGUIFramework()
    if T_OoM_Modules and T_OoM_Modules.GUIFramework then
        return T_OoM_Modules.GUIFramework
    end
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r GUI Framework not found!")
    return nil
end

-- Get Settings reference
local function GetSettings()
    if T_OoM_Modules and T_OoM_Modules.Settings then
        return T_OoM_Modules.Settings
    end
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r Settings module not found!")
    return nil
end

-- Initialize configuration GUI
function ConfigGUI:Initialize()
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Configuration GUI initialized")
    return true
end

-- Create main configuration window
function ConfigGUI:CreateConfigWindow()
    local gui = GetGUIFramework()
    if not gui then return nil end
    
    -- Create main config window
    configWindow = gui:CreateWindow(L("T-OoM Configuration"), 500, 600)
    if not configWindow then
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r Failed to create config window!")
        return nil
    end
    
    -- Hide window initially (don't auto-show like test window)
    configWindow:Hide()
    
    -- Handle window hiding (Esc key support)
    configWindow:SetScript("OnHide", function()
        isWindowOpen = false
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Configuration window closed")
    end)
    
    -- Override close button to update our state
    if configWindow.closeButton then
        configWindow.closeButton:SetScript("OnClick", function()
            self:CloseWindow()
        end)
    end
    
    -- Create sections
    self:CreateGeneralSection(configWindow, gui)
    self:CreateMessageSection(configWindow, gui)
    self:CreateThresholdSection(configWindow, gui)
    self:CreateChannelSection(configWindow, gui)
    self:CreateActionButtons(configWindow, gui)
    
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Configuration window created successfully")
    return configWindow
end

-- Create General Settings section
function ConfigGUI:CreateGeneralSection(parent, gui)
    -- Section title
    local generalTitle = gui:CreateLabel("General Settings", parent, "GameFontNormalLarge")
    generalTitle:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, -50)
    
    -- Enable/Disable addon checkbox
    local enabledCheckbox = gui:CreateCheckBox("Enable T-OoM Addon", parent, function(checked)
        local settings = GetSettings()
        if settings then
            settings:Set("enabled", checked)
            DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Addon " .. (checked and "enabled" or "disabled"))
        end
    end)
    enabledCheckbox:SetPoint("TOPLEFT", generalTitle, "BOTTOMLEFT", 0, -10)
    
    -- Set initial state from settings
    local settings = GetSettings()
    if settings then
        local currentEnabled = settings:Get("enabled")
        if enabledCheckbox.SetChecked then
            enabledCheckbox:SetChecked(currentEnabled)
        end
    end
    
    -- Language selection (placeholder for now)
    local currentLang = "enUS"  -- Default fallback
    if GetLocale then
        currentLang = GetLocale()
    end
    local langLabel = gui:CreateLabel("Language: " .. currentLang, parent)
    langLabel:SetPoint("TOPLEFT", enabledCheckbox, "BOTTOMLEFT", 0, -15)
    
    -- Store references
    components.generalTitle = generalTitle
    components.enabledCheckbox = enabledCheckbox
    components.langLabel = langLabel
end

-- Create Message Settings section
function ConfigGUI:CreateMessageSection(parent, gui)
    -- Section title
    local messageTitle = gui:CreateLabel("Message Settings", parent, "GameFontNormalLarge")
    messageTitle:SetPoint("TOPLEFT", components.langLabel, "BOTTOMLEFT", 0, -25)

    -- Low Mana Message
    local lowManaLabel = gui:CreateLabel("Low Mana Message (max 120 symbols):", parent)
    lowManaLabel:SetPoint("TOPLEFT", messageTitle, "BOTTOMLEFT", 0, -15)
    local lowManaEditBox = gui:CreateEditBox(300, 24, parent, "Enter low mana message (max 120 symbols)...")
    lowManaEditBox:SetPoint("TOPLEFT", lowManaLabel, "BOTTOMLEFT", 0, -5)

    -- Critical Low Mana Message
    local criticalLabel = gui:CreateLabel("Critical Low Mana Message (max 120 symbols):", parent)
    criticalLabel:SetPoint("TOPLEFT", lowManaEditBox, "BOTTOMLEFT", 0, -10)
    local criticalEditBox = gui:CreateEditBox(300, 24, parent, "Enter critical mana message (max 120 symbols)...")
    criticalEditBox:SetPoint("TOPLEFT", criticalLabel, "BOTTOMLEFT", 0, -5)

    -- Out of Mana Message
    local outOfManaLabel = gui:CreateLabel("Out of Mana Message (max 120 symbols):", parent)
    outOfManaLabel:SetPoint("TOPLEFT", criticalEditBox, "BOTTOMLEFT", 0, -10)
    local outOfManaEditBox = gui:CreateEditBox(300, 24, parent, "Enter out of mana message (max 120 symbols)...")
    outOfManaEditBox:SetPoint("TOPLEFT", outOfManaLabel, "BOTTOMLEFT", 0, -5)

    -- Валидация и обработка ввода
    local function validateAndSet(editBox, key, minLen, maxLen)
        local innerEditBox = editBox.editBox
        innerEditBox:SetScript("OnTextChanged", function()
            local text = innerEditBox:GetText()
            -- Truncate if over maxLen (no SetCursorPosition in 1.12.1)
            if string.len(text) > maxLen then
                text = string.sub(text, 1, maxLen)
                innerEditBox:SetText(text)
                DEFAULT_CHAT_FRAME:AddMessage("|cFFFFA500[T-OoM]|r Message truncated to "..maxLen.." symbols!")
            end
            if string.len(text) < minLen then
                innerEditBox:SetTextColor(1, 0.2, 0.2, 1)
            else
                innerEditBox:SetTextColor(0.9, 0.9, 0.9, 1)
                local settings = GetSettings()
                if settings then
                    settings:Set(key, text)
                end
            end
        end)
    end
    validateAndSet(lowManaEditBox, "lowManaMsg", 1, 120)
    validateAndSet(criticalEditBox, "criticalLowManaMsg", 1, 120)
    validateAndSet(outOfManaEditBox, "outOfManaMessage", 1, 120)

    -- Store references
    components.messageTitle = messageTitle
    components.lowManaLabel = lowManaLabel
    components.lowManaEditBox = lowManaEditBox
    components.criticalLabel = criticalLabel
    components.criticalEditBox = criticalEditBox
    components.outOfManaLabel = outOfManaLabel
    components.outOfManaEditBox = outOfManaEditBox
end

-- Create Threshold Settings section
function ConfigGUI:CreateThresholdSection(parent, gui)
    -- Section title
    local thresholdTitle = gui:CreateLabel("Mana Thresholds (%)", parent, "GameFontNormalLarge")
    thresholdTitle:SetPoint("TOPLEFT", components.outOfManaEditBox, "BOTTOMLEFT", 0, -25)
    
    -- Threshold labels (sliders will be added in future stages)
    local threshold1Label = gui:CreateLabel("Low Mana Threshold: 30%", parent)
    threshold1Label:SetPoint("TOPLEFT", thresholdTitle, "BOTTOMLEFT", 0, -15)
    
    local threshold2Label = gui:CreateLabel("Critical Mana Threshold: 15%", parent)
    threshold2Label:SetPoint("TOPLEFT", threshold1Label, "BOTTOMLEFT", 0, -10)
    
    local threshold3Label = gui:CreateLabel("Out of Mana Threshold: 5%", parent)
    threshold3Label:SetPoint("TOPLEFT", threshold2Label, "BOTTOMLEFT", 0, -10)
    
    -- Store references
    components.thresholdTitle = thresholdTitle
    components.threshold1Label = threshold1Label
    components.threshold2Label = threshold2Label
    components.threshold3Label = threshold3Label
end

-- Create Channel Settings section
function ConfigGUI:CreateChannelSection(parent, gui)
    -- Section title
    local channelTitle = gui:CreateLabel("Chat Channel Settings", parent, "GameFontNormalLarge")
    channelTitle:SetPoint("TOPLEFT", components.threshold3Label, "BOTTOMLEFT", 0, -25)
    
    -- Channel selection (dropdown will be added in future stages)
    local channelLabel = gui:CreateLabel("Current Channel: SAY", parent)
    channelLabel:SetPoint("TOPLEFT", channelTitle, "BOTTOMLEFT", 0, -15)
    
    -- Location checkboxes (simplified for now)
    local locationLabel = gui:CreateLabel("Active in:", parent)
    locationLabel:SetPoint("TOPLEFT", channelLabel, "BOTTOMLEFT", 0, -15)
    
    local worldCheckbox = gui:CreateCheckBox("Open World", parent, function(checked)
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Open World: " .. (checked and "enabled" or "disabled"))
    end)
    worldCheckbox:SetPoint("TOPLEFT", locationLabel, "BOTTOMLEFT", 0, -5)
    
    local dungeonCheckbox = gui:CreateCheckBox("Dungeons", parent, function(checked)
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Dungeons: " .. (checked and "enabled" or "disabled"))
    end)
    dungeonCheckbox:SetPoint("TOPLEFT", worldCheckbox, "BOTTOMLEFT", 0, -5)
    
    -- Set initial states (default to enabled for testing)
    if worldCheckbox.SetChecked then
        worldCheckbox:SetChecked(true)
    end
    if dungeonCheckbox.SetChecked then
        dungeonCheckbox:SetChecked(true)
    end
    
    -- Store references
    components.channelTitle = channelTitle
    components.channelLabel = channelLabel
    components.locationLabel = locationLabel
    components.worldCheckbox = worldCheckbox
    components.dungeonCheckbox = dungeonCheckbox
end

-- Create action buttons (Apply, Cancel, Reset)
function ConfigGUI:CreateActionButtons(parent, gui)
    -- Apply button
    local applyButton = gui:CreateButton("Apply Settings", 120, 32, parent, function()
        self:ApplySettings()
    end)
    applyButton:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -20, 20)
    
    -- Cancel button
    local cancelButton = gui:CreateButton("Cancel", 80, 32, parent, function()
        self:CancelSettings()
    end)
    cancelButton:SetPoint("RIGHT", applyButton, "LEFT", -10, 0)
    
    -- Reset to defaults button
    local resetButton = gui:CreateButton("Reset to Defaults", 140, 32, parent, function()
        self:ResetToDefaults()
    end)
    resetButton:SetPoint("RIGHT", cancelButton, "LEFT", -10, 0)
    
    -- Store references
    components.applyButton = applyButton
    components.cancelButton = cancelButton
    components.resetButton = resetButton
end

-- Apply settings and save to SavedVariables
function ConfigGUI:ApplySettings()
    local settings = GetSettings()
    if not settings then return end
    local function getTextSafe(editBox)
        if editBox and editBox.editBox then
            local text = editBox.editBox:GetText()
            if text and text ~= editBox.editBox.placeholder then
                return text
            end
        end
        return ""
    end
    local low = getTextSafe(components.lowManaEditBox)
    local crit = getTextSafe(components.criticalEditBox)
    local out = getTextSafe(components.outOfManaEditBox)
    -- Hard truncate before saving
    if string.len(low) > 120 then
        low = string.sub(low, 1, 120)
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFFA500[T-OoM]|r Low Mana Message truncated to 120 symbols!")
    end
    if string.len(crit) > 120 then
        crit = string.sub(crit, 1, 120)
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFFA500[T-OoM]|r Critical Low Mana Message truncated to 120 symbols!")
    end
    if string.len(out) > 120 then
        out = string.sub(out, 1, 120)
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFFA500[T-OoM]|r Out of Mana Message truncated to 120 symbols!")
    end
    if string.len(low) < 1 or string.len(crit) < 1 or string.len(out) < 1 then
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000[T-OoM]|r Message length must be 1-120 characters!")
        return
    end
    settings:Set("lowManaMsg", low)
    settings:Set("criticalLowManaMsg", crit)
    settings:Set("outOfManaMessage", out)
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Settings applied and saved!")
    self:CloseWindow()
end

-- Cancel settings (revert to saved values)
function ConfigGUI:CancelSettings()
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Settings cancelled")
    self:CloseWindow()
end

-- Reset all settings to defaults
function ConfigGUI:ResetToDefaults()
    local settings = GetSettings()
    if settings then
        -- Use existing Reset method instead of ResetToDefaults
        if settings.Reset then
            settings:Reset()
            DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Settings reset to defaults")
            self:LoadSettingsIntoGUI()
        else
            DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Reset function not available")
        end
    end
end

-- Load current settings into GUI components
function ConfigGUI:LoadSettingsIntoGUI()
    local settings = GetSettings()
    if not settings then return end
    -- Загрузка значений в поля ввода
    if components.lowManaEditBox and components.lowManaEditBox.editBox then
        components.lowManaEditBox.editBox:SetText(settings:Get("lowManaMsg") or "")
    end
    if components.criticalEditBox and components.criticalEditBox.editBox then
        components.criticalEditBox.editBox:SetText(settings:Get("criticalLowManaMsg") or "")
    end
    if components.outOfManaEditBox and components.outOfManaEditBox.editBox then
        components.outOfManaEditBox.editBox:SetText(settings:Get("outOfManaMessage") or "")
    end
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Settings loaded into GUI")
end

-- Open configuration window
function ConfigGUI:OpenWindow()
    if not configWindow then
        self:CreateConfigWindow()
    end
    
    if configWindow then
        configWindow:Show()
        isWindowOpen = true
        self:LoadSettingsIntoGUI()
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Configuration window opened")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r Failed to open configuration window!")
    end
end

-- Close configuration window
function ConfigGUI:CloseWindow()
    if configWindow then
        configWindow:Hide()
        isWindowOpen = false
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Configuration window closed")
    end
end

-- Toggle configuration window
function ConfigGUI:ToggleWindow()
    if isWindowOpen then
        self:CloseWindow()
    else
        self:OpenWindow()
    end
end

-- Check if window is open
function ConfigGUI:IsWindowOpen()
    return isWindowOpen
end

-- Get configuration window reference
function ConfigGUI:GetWindow()
    return configWindow
end

-- Module cleanup
function ConfigGUI:Cleanup()
    if configWindow then
        configWindow:Hide()
        configWindow = nil
    end
    components = {}
    isWindowOpen = false
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Configuration GUI cleaned up")
end

-- Register module with loader
if T_OoM_Modules and T_OoM_Modules.Loader then
    T_OoM_Modules.Loader:RegisterModule(MODULE_NAME, ConfigGUI)
else
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r Module loader not found! Configuration GUI not registered.")
end
