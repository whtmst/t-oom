--[[
T-OoM Minimap Button
Draggable minimap button for T-OoM addon configuration access
Перемещаемая кнопка у миникарты для доступа к настройкам T-OoM

WoW 1.12.1 Compatible Minimap Button
--]]

-- Create Minimap Button module
local MinimapButton = {}

-- Module constants
local MODULE_NAME = "MinimapButton"
local DEBUG_PREFIX = "|cFF11A6EC[T-OoM Minimap]|r"

-- Private variables
local minimapButton = nil
local isInitialized = false
local isDragging = false

-- Get localization function (fallback if not available)
local L = function(key) 
    if T_OoM_Modules and T_OoM_Modules.Localization and T_OoM_Modules.Localization.GetString then
        return T_OoM_Modules.Localization.GetString(key)
    end
    return key  -- Fallback to key if localization not available
end

-- Get Settings reference
local function GetSettings()
    if T_OoM_Modules and T_OoM_Modules.Settings then
        return T_OoM_Modules.Settings
    end
    return nil
end

-- Get ConfigGUI reference
local function GetConfigGUI()
    if T_OoM_Modules and T_OoM_Modules.ConfigGUI then
        return T_OoM_Modules.ConfigGUI
    end
    return nil
end

-- Calculate button position based on angle and radius
local function CalculatePosition(angle, radius)
    local x = radius * math.cos(angle)
    local y = radius * math.sin(angle)
    return x, y
end

-- Get current button position from settings
local function GetButtonPosition()
    local settings = GetSettings()
    if settings then
        local angle = settings:Get("minimapButtonAngle")
        local radius = settings:Get("minimapButtonRadius")
        
        -- Use settings defaults if no saved position
        if not angle or not radius then
            local defaultMinimapButton = settings:Get("minimapButton")
            if defaultMinimapButton then
                angle = angle or defaultMinimapButton.angle
                radius = radius or defaultMinimapButton.radius
            else
                -- Final fallback
                angle = angle or 0
                radius = radius or 80
            end
        end
        
        return angle, radius
    end
    
    -- Fallback if no settings module
    return 0, 80
end

-- Save button position to settings
local function SaveButtonPosition(angle, radius)
    local settings = GetSettings()
    if settings then
        settings:Set("minimapButtonAngle", angle)
        settings:Set("minimapButtonRadius", radius)
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Button position saved")
    end
end

-- Update button visual position
local function UpdateButtonPosition()
    if not minimapButton then return end
    
    local angle, radius = GetButtonPosition()
    local x, y = CalculatePosition(angle, radius)
    
    minimapButton:ClearAllPoints()
    minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- Handle button dragging
local function OnDragStart()
    if IsShiftKeyDown() and minimapButton then
        isDragging = true
        -- Don't use StartMoving - we'll handle positioning manually
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Dragging started (Shift+Drag)")
    else
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Hold Shift to drag button")
    end
end

-- Update button position during drag (called by OnUpdate)
local function UpdateDragPosition()
    if not isDragging or not minimapButton then return end
    
    local scale = UIParent:GetEffectiveScale()
    local cursorX, cursorY = GetCursorPosition()
    cursorX = cursorX / scale
    cursorY = cursorY / scale
    
    local minimapX, minimapY = Minimap:GetCenter()
    
    if minimapX and minimapY then
        local deltaX = cursorX - minimapX
        local deltaY = cursorY - minimapY
        local angle = math.atan2(deltaY, deltaX)
        
        -- Constrain to fixed radius (80 pixels from center)
        local constrainedRadius = 80
        local x = constrainedRadius * math.cos(angle)
        local y = constrainedRadius * math.sin(angle)
        
        -- Update button position in real-time
        minimapButton:ClearAllPoints()
        minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
    end
end

local function OnDragStop()
    if isDragging and minimapButton then
        -- Calculate final angle based on cursor position
        local scale = UIParent:GetEffectiveScale()
        local cursorX, cursorY = GetCursorPosition()
        cursorX = cursorX / scale
        cursorY = cursorY / scale
        
        local minimapX, minimapY = Minimap:GetCenter()
        
        if minimapX and minimapY then
            local deltaX = cursorX - minimapX
            local deltaY = cursorY - minimapY
            local newAngle = math.atan2(deltaY, deltaX)
            local newRadius = 80  -- Fixed radius
            
            -- Save new position
            SaveButtonPosition(newAngle, newRadius)
            
            -- Update to exact calculated position
            UpdateButtonPosition()
        end
        
        isDragging = false
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Button position updated")
    end
end

-- Handle button click
local function OnClick()
    local configGUI = GetConfigGUI()
    if configGUI then
        configGUI:ToggleWindow()
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Opening configuration window")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r Configuration GUI not available")
    end
end

-- Show tooltip on mouse enter
local function OnEnter()
    if minimapButton then
        GameTooltip:SetOwner(minimapButton, "ANCHOR_LEFT")
        GameTooltip:SetText("T-OoM", 1, 1, 1)
        GameTooltip:AddLine(L("MINIMAP_TOOLTIP_DESC") or "Out of Mana announcer addon", 1, 0.8, 0)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(L("MINIMAP_TOOLTIP_CLICK") or "Click: Open configuration", 0, 1, 0)
        GameTooltip:AddLine(L("MINIMAP_TOOLTIP_DRAG") or "Shift+Drag: Move button", 0, 1, 0)
        GameTooltip:Show()
    end
end

-- Hide tooltip on mouse leave
local function OnLeave()
    GameTooltip:Hide()
end

-- Create the minimap button
function MinimapButton:CreateButton()
    if minimapButton then
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Button already exists")
        return minimapButton
    end
    
    -- Create button frame
    minimapButton = CreateFrame("Button", "T_OoM_MinimapButton", Minimap)
    minimapButton:SetClampedToScreen(true)
    minimapButton:SetMovable(true)
    minimapButton:EnableMouse(true)
    minimapButton:RegisterForDrag("LeftButton")
    minimapButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    minimapButton:SetFrameStrata("HIGH")
    minimapButton:SetWidth(31)
    minimapButton:SetHeight(31)
    minimapButton:SetFrameLevel(9)
    
    -- Set highlight texture
    minimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    
    -- Create overlay border (circular minimap button border)
    minimapButton.overlay = minimapButton:CreateTexture(nil, "OVERLAY")
    minimapButton.overlay:SetWidth(53)
    minimapButton.overlay:SetHeight(53)
    minimapButton.overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    minimapButton.overlay:SetPoint("TOPLEFT", 0, 0)
    
    -- Create icon layer (should be under border to be clipped)
    minimapButton.icon = minimapButton:CreateTexture(nil, "BACKGROUND")
    minimapButton.icon:SetWidth(18)
    minimapButton.icon:SetHeight(18)
    minimapButton.icon:SetTexture("Interface\\AddOns\\T-OoM\\textures\\miniMapIcon")
    minimapButton.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    minimapButton.icon:SetPoint("CENTER", 0, 0)
    
    -- Set event handlers
    minimapButton:SetScript("OnDragStart", OnDragStart)
    minimapButton:SetScript("OnDragStop", OnDragStop)
    minimapButton:SetScript("OnClick", OnClick)
    minimapButton:SetScript("OnEnter", OnEnter)
    minimapButton:SetScript("OnLeave", OnLeave)
    minimapButton:SetScript("OnUpdate", UpdateDragPosition)
    
    -- Position button
    minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)
    UpdateButtonPosition()
    
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Minimap button created")
    return minimapButton
end

-- Show the minimap button
function MinimapButton:ShowButton()
    if minimapButton then
        minimapButton:Show()
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Button shown")
    end
end

-- Hide the minimap button
function MinimapButton:HideButton()
    if minimapButton then
        minimapButton:Hide()
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Button hidden")
    end
end

-- Toggle button visibility
function MinimapButton:ToggleButton()
    if minimapButton then
        if minimapButton:IsVisible() then
            self:HideButton()
        else
            self:ShowButton()
        end
    end
end

-- Check if button is visible
function MinimapButton:IsButtonVisible()
    return minimapButton and minimapButton:IsVisible()
end

-- Reset button position to default
function MinimapButton:ResetPosition()
    local settings = GetSettings()
    if settings then
        local defaultMinimapButton = settings:Get("minimapButton")
        if defaultMinimapButton then
            SaveButtonPosition(defaultMinimapButton.angle, defaultMinimapButton.radius)
        else
            SaveButtonPosition(0, 80) -- Fallback default
        end
    else
        SaveButtonPosition(0, 80) -- Fallback default
    end
    UpdateButtonPosition()
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Position reset to default")
end

-- Update button appearance (for future customization)
function MinimapButton:UpdateButtonAppearance()
    -- Future customization options can be added here
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Button appearance updated")
end

-- Get button reference
function MinimapButton:GetButton()
    return minimapButton
end

-- Initialize minimap button
function MinimapButton:Initialize()
    if isInitialized then
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Already initialized")
        return true
    end
    
    -- Create and show button
    self:CreateButton()
    self:ShowButton()
    
    isInitialized = true
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Minimap button initialized")
    return true
end

-- Module cleanup
function MinimapButton:Cleanup()
    if minimapButton then
        minimapButton:Hide()
        minimapButton = nil
    end
    isInitialized = false
    isDragging = false
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Minimap button cleaned up")
end

-- Register module with loader
if T_OoM_Modules and T_OoM_Modules.Loader then
    T_OoM_Modules.Loader:RegisterModule(MODULE_NAME, MinimapButton)
else
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r Module loader not found! Minimap Button not registered.")
end
