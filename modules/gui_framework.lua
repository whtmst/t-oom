--[[
T-OoM GUI Framework
Base GUI framework for T-OoM addon interface components
Базовый GUI фреймворк для компонентов интерфейса аддона T-OoM

WoW 1.12.0 Compatible GUI Components
--]]

-- Create GUI Framework module
local GUIFramework = {}

-- Module constants
local MODULE_NAME = "GUIFramework"
local DEBUG_PREFIX = "|cFF11A6EC[T-OoM GUI]|r"

-- Private variables
local activeFrames = {}  -- Track all created frames
local frameCounter = 0   -- Unique frame ID counter

-- Color constants for dark minimalist interface
local COLORS = {
    -- Dark theme
    BACKGROUND = {0.0, 0.0, 0.0, 0.9},       -- Pure black background
    BORDER = {0.2, 0.2, 0.2, 1.0},           -- Dark gray border
    TITLE_BAR = {0.05, 0.05, 0.05, 1.0},     -- Almost black title bar
    BUTTON_NORMAL = {0.1, 0.1, 0.1, 1.0},    -- Dark button
    BUTTON_HIGHLIGHT = {0.2, 0.2, 0.2, 1.0}, -- Subtle hover
    BUTTON_PRESSED = {0.05, 0.05, 0.05, 1.0}, -- Darker pressed
    TEXT_WHITE = {0.9, 0.9, 0.9, 1.0},       -- Slightly off-white text
    TEXT_YELLOW = {1.0, 1.0, 0.0, 1.0},      -- Yellow accent (kept for contrast)
    TEXT_GRAY = {0.6, 0.6, 0.6, 1.0},        -- Gray text for secondary info
    ACCENT_BLUE = {0.3, 0.6, 1.0, 1.0},      -- Brighter blue for accents
    CLOSE_BUTTON = {0.8, 0.2, 0.2, 1.0}      -- Red for close button
}

-- Font paths for WoW 1.12.0 (ASCII compatible)
local FONTS = {
    NORMAL = "Fonts\\FRIZQT__.TTF",
    BOLD = "Fonts\\MORPHEUS.TTF",
    CUSTOM = "Interface\\AddOns\\T-OoM\\fonts\\ARIALN.ttf"
    -- Note: Unicode emoji fonts (NCE.ttf) not supported in WoW 1.12.0
    -- Use ASCII alternatives: <3 ❤️, * ★, --> ➡️, (c) ©, (tm) ™
}

-- Standard sizes for components
local SIZES = {
    WINDOW_MIN_WIDTH = 300,
    WINDOW_MIN_HEIGHT = 200,
    BUTTON_HEIGHT = 32,
    EDITBOX_HEIGHT = 24,
    CHECKBOX_SIZE = 16,
    TITLE_BAR_HEIGHT = 24,
    BORDER_SIZE = 2,
    PADDING = 8
}

-- Helper function: Generate unique frame name
local function GenerateFrameName(prefix)
    frameCounter = frameCounter + 1
    return (prefix or "T_OoM_Frame") .. frameCounter
end

-- Helper function: Apply color to texture
local function ApplyColor(texture, color)
    if texture and color and color[1] and color[2] and color[3] then
        texture:SetVertexColor(color[1], color[2], color[3], color[4] or 1.0)
    end
end

-- Helper function: Create dark style backdrop (simple solid colors)
local function CreateFrameBackdrop()
    return {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 8,
        edgeSize = 8,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    }
end

-- Helper function: Create solid color texture
local function CreateSolidTexture(parent, color, layer)
    local texture = parent:CreateTexture(nil, layer or "BACKGROUND")
    texture:SetTexture(1, 1, 1, 1)  -- White texture to be colored
    if color then
        texture:SetVertexColor(color[1], color[2], color[3], color[4] or 1.0)
    end
    return texture
end

-- Helper function: Create dark style close button (without WoW textures)
local function CreateCloseButton(parent, size)
    local closeButton = CreateFrame("Button", nil, parent)
    closeButton:SetWidth(size or 16)
    closeButton:SetHeight(size or 16)
    
    -- Background texture
    local bg = CreateSolidTexture(closeButton, COLORS.BUTTON_NORMAL, "BACKGROUND")
    bg:SetAllPoints(closeButton)
    
    -- Border
    local border = CreateSolidTexture(closeButton, COLORS.BORDER, "BORDER")
    border:SetAllPoints(closeButton)
    
    -- Inner content (smaller than border)
    local inner = CreateSolidTexture(closeButton, COLORS.BUTTON_NORMAL, "ARTWORK")
    inner:SetPoint("TOPLEFT", closeButton, "TOPLEFT", 1, -1)
    inner:SetPoint("BOTTOMRIGHT", closeButton, "BOTTOMRIGHT", -1, 1)
    
    -- Close symbol text with emoji fallback
    local closeText = closeButton:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    closeText:SetPoint("CENTER", closeButton, "CENTER", 0, 0)
    
    -- Use simple X symbol for better compatibility
    closeText:SetFont(FONTS.NORMAL, 12, "OUTLINE")
    closeText:SetText("×")  -- Standard multiplication symbol
    
    closeText:SetTextColor(COLORS.TEXT_WHITE[1], COLORS.TEXT_WHITE[2], COLORS.TEXT_WHITE[3], 1.0)
    
    -- Store references
    closeButton.bg = bg
    closeButton.border = border
    closeButton.inner = inner
    closeButton.closeText = closeText
    
    -- Hover effects
    closeButton:SetScript("OnEnter", function()
        inner:SetVertexColor(COLORS.CLOSE_BUTTON[1], COLORS.CLOSE_BUTTON[2], COLORS.CLOSE_BUTTON[3], 0.8)
        closeText:SetTextColor(1.0, 1.0, 1.0, 1.0)
    end)
    
    closeButton:SetScript("OnLeave", function()
        inner:SetVertexColor(COLORS.BUTTON_NORMAL[1], COLORS.BUTTON_NORMAL[2], COLORS.BUTTON_NORMAL[3], COLORS.BUTTON_NORMAL[4])
        closeText:SetTextColor(COLORS.TEXT_WHITE[1], COLORS.TEXT_WHITE[2], COLORS.TEXT_WHITE[3], 1.0)
    end)
    
    return closeButton
end

-- GUI Framework API Functions

-- Create main window frame
function GUIFramework:CreateWindow(title, width, height, parent)
    local frameName = GenerateFrameName("T_OoM_Window")
    
    -- Validate parameters
    width = width or SIZES.WINDOW_MIN_WIDTH
    height = height or SIZES.WINDOW_MIN_HEIGHT
    title = title or "T-OoM Window"
    parent = parent or UIParent
    
    -- Create main frame
    local frame = CreateFrame("Frame", frameName, parent)
    frame:SetWidth(width)
    frame:SetHeight(height)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    
    -- Ensure frame is visible and on top
    frame:SetFrameStrata("DIALOG")
    frame:SetFrameLevel(100)
    
    -- Set backdrop (WoW-style border and background)
    frame:SetBackdrop(CreateFrameBackdrop())
    frame:SetBackdropColor(COLORS.BACKGROUND[1], COLORS.BACKGROUND[2], COLORS.BACKGROUND[3], COLORS.BACKGROUND[4])
    frame:SetBackdropBorderColor(COLORS.BORDER[1], COLORS.BORDER[2], COLORS.BORDER[3], COLORS.BORDER[4])
    
    -- Make frame movable
    frame:SetMovable(true)
    frame:EnableMouse(true)
    
    -- Create title bar
    local titleBar = CreateFrame("Frame", frameName .. "_TitleBar", frame)
    titleBar:SetHeight(SIZES.TITLE_BAR_HEIGHT)
    titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", SIZES.BORDER_SIZE, -SIZES.BORDER_SIZE)
    titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -SIZES.BORDER_SIZE, -SIZES.BORDER_SIZE)
    
    -- Title bar background (dark style solid color)
    local titleBg = CreateSolidTexture(titleBar, COLORS.TITLE_BAR, "BACKGROUND")
    titleBg:SetAllPoints(titleBar)
    
    -- Title text
    local titleText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleText:SetPoint("CENTER", titleBar, "CENTER", 0, 0)
    titleText:SetText(title)
    titleText:SetTextColor(COLORS.TEXT_YELLOW[1], COLORS.TEXT_YELLOW[2], COLORS.TEXT_YELLOW[3], COLORS.TEXT_YELLOW[4])
    
    -- Make title bar draggable
    titleBar:SetScript("OnMouseDown", function()
        frame:StartMoving()
    end)
    titleBar:SetScript("OnMouseUp", function()
        frame:StopMovingOrSizing()
    end)
    titleBar:EnableMouse(true)
    
    -- Create dark style close button (without WoW textures)
    local closeButton = CreateCloseButton(frame, 16)
    closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
    
    -- Close button functionality
    closeButton:SetScript("OnClick", function()
        if frame then
            frame:Hide()
        end
    end)
    
    -- Ensure button is clickable and on top
    closeButton:EnableMouse(true)
    closeButton:SetFrameLevel(frame:GetFrameLevel() + 2)
    
    -- Register in the UI escape handler to close with ESC key
    table.insert(UISpecialFrames, frameName)
    
    -- Store references
    frame.titleBar = titleBar
    frame.titleText = titleText
    frame.titleBg = titleBg
    frame.closeButton = closeButton
    
    -- Start visible (for testing)
    frame:Show()
    
    -- Track frame
    activeFrames[frameName] = frame
    
    return frame
end

-- Create dark style button
function GUIFramework:CreateButton(text, width, height, parent, onClick)
    local buttonName = GenerateFrameName("T_OoM_Button")
    
    -- Validate parameters
    width = width or 100
    height = height or SIZES.BUTTON_HEIGHT
    text = text or "Button"
    parent = parent or UIParent
    
    -- Create button frame
    local button = CreateFrame("Button", buttonName, parent)
    button:SetWidth(width)
    button:SetHeight(height)
    
    -- Background texture (dark style)
    local bg = CreateSolidTexture(button, COLORS.BUTTON_NORMAL, "BACKGROUND")
    bg:SetAllPoints(button)
    
    -- Border
    local border = CreateSolidTexture(button, COLORS.BORDER, "BORDER")
    border:SetAllPoints(button)
    
    -- Inner content (smaller than border)
    local inner = CreateSolidTexture(button, COLORS.BUTTON_NORMAL, "ARTWORK")
    inner:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
    inner:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
    
    -- Button text
    local buttonText = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    buttonText:SetPoint("CENTER", button, "CENTER", 0, 0)
    buttonText:SetText(text)
    buttonText:SetTextColor(COLORS.TEXT_WHITE[1], COLORS.TEXT_WHITE[2], COLORS.TEXT_WHITE[3], COLORS.TEXT_WHITE[4])
    
    -- Store references
    button.bg = bg
    button.border = border
    button.inner = inner
    button.text = buttonText
    
    -- Hover effects
    button:SetScript("OnEnter", function()
        inner:SetVertexColor(COLORS.BUTTON_HIGHLIGHT[1], COLORS.BUTTON_HIGHLIGHT[2], COLORS.BUTTON_HIGHLIGHT[3], COLORS.BUTTON_HIGHLIGHT[4])
    end)
    
    button:SetScript("OnLeave", function()
        inner:SetVertexColor(COLORS.BUTTON_NORMAL[1], COLORS.BUTTON_NORMAL[2], COLORS.BUTTON_NORMAL[3], COLORS.BUTTON_NORMAL[4])
    end)
    
    -- Press effects
    button:SetScript("OnMouseDown", function()
        inner:SetVertexColor(COLORS.BUTTON_PRESSED[1], COLORS.BUTTON_PRESSED[2], COLORS.BUTTON_PRESSED[3], COLORS.BUTTON_PRESSED[4])
    end)
    
    button:SetScript("OnMouseUp", function()
        inner:SetVertexColor(COLORS.BUTTON_HIGHLIGHT[1], COLORS.BUTTON_HIGHLIGHT[2], COLORS.BUTTON_HIGHLIGHT[3], COLORS.BUTTON_HIGHLIGHT[4])
    end)
    
    -- Click handler
    if onClick and type(onClick) == "function" then
        button:SetScript("OnClick", onClick)
    end
    
    button:EnableMouse(true)
    
    return button
end

-- Create editbox (text input field) in dark style
function GUIFramework:CreateEditBox(width, height, parent, placeholder)
    local editBoxName = GenerateFrameName("T_OoM_EditBox")
    
    -- Validate parameters
    width = width or 200
    height = height or SIZES.EDITBOX_HEIGHT
    parent = parent or UIParent
    placeholder = placeholder or ""
    
    -- Create container frame for better styling control
    local container = CreateFrame("Frame", editBoxName.."_Container", parent)
    container:SetWidth(width)
    container:SetHeight(height)
    
    -- Add dark style background and border textures
    local bg = CreateSolidTexture(container, COLORS.BACKGROUND, "BACKGROUND")
    bg:SetAllPoints(container)
    
    local border = CreateSolidTexture(container, COLORS.BORDER, "BORDER")
    border:SetAllPoints(container)
    
    local inner = CreateSolidTexture(container, {0.1, 0.1, 0.1, 1.0}, "ARTWORK")
    inner:SetPoint("TOPLEFT", container, "TOPLEFT", 1, -1)
    inner:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -1, 1)
    
    -- Create editbox
    local editBox = CreateFrame("EditBox", editBoxName, container)
    editBox:SetPoint("TOPLEFT", container, "TOPLEFT", SIZES.PADDING, -SIZES.PADDING/2)
    editBox:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -SIZES.PADDING, SIZES.PADDING/2)
    editBox:SetAutoFocus(false)
    
    -- Set transparent background since we're using the container for visuals
    editBox:SetBackdrop(nil)
    
    -- Font settings
    editBox:SetFont(FONTS.CUSTOM, 12, "NONE")
    editBox:SetTextColor(COLORS.TEXT_WHITE[1], COLORS.TEXT_WHITE[2], COLORS.TEXT_WHITE[3], COLORS.TEXT_WHITE[4])
    
    -- Placeholder functionality
    if placeholder ~= "" then
        editBox:SetText(placeholder)
        editBox:SetTextColor(0.5, 0.5, 0.5, 1.0)  -- Gray for placeholder
        
        editBox:SetScript("OnEditFocusGained", function()
            if editBox:GetText() == placeholder then
                editBox:SetText("")
                editBox:SetTextColor(COLORS.TEXT_WHITE[1], COLORS.TEXT_WHITE[2], COLORS.TEXT_WHITE[3], COLORS.TEXT_WHITE[4])
            end
        end)
        
        editBox:SetScript("OnEditFocusLost", function()
            if editBox:GetText() == "" then
                editBox:SetText(placeholder)
                editBox:SetTextColor(0.5, 0.5, 0.5, 1.0)
            end
        end)
    end
    
    -- Store references
    container.editBox = editBox
    editBox.container = container
    
    return container  -- Return container for positioning, not editBox
end

-- Create checkbox
function GUIFramework:CreateCheckBox(text, parent, onClick)
    local checkBoxName = GenerateFrameName("T_OoM_CheckBox")
    
    -- Validate parameters
    text = text or "Checkbox"
    parent = parent or UIParent
    
    -- Create checkbox button
    local checkBox = CreateFrame("CheckButton", checkBoxName, parent, "UICheckButtonTemplate")
    checkBox:SetWidth(SIZES.CHECKBOX_SIZE)
    checkBox:SetHeight(SIZES.CHECKBOX_SIZE)
    
    -- Checkbox text
    local checkText = checkBox:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    checkText:SetPoint("LEFT", checkBox, "RIGHT", 5, 0)
    checkText:SetText(text)
    checkText:SetTextColor(COLORS.TEXT_WHITE[1], COLORS.TEXT_WHITE[2], COLORS.TEXT_WHITE[3], COLORS.TEXT_WHITE[4])
    
    -- Click handler with proper state passing
    if onClick and type(onClick) == "function" then
        checkBox:SetScript("OnClick", function()
            local checked = checkBox:GetChecked() == 1
            onClick(checked)
        end)
    end
    
    -- Store references
    checkBox.text = checkText
    
    return checkBox
end

-- Create label (text display)
function GUIFramework:CreateLabel(text, parent, fontObject)
    local labelName = GenerateFrameName("T_OoM_Label")
    
    -- Validate parameters
    text = text or "Label"
    parent = parent or UIParent
    fontObject = fontObject or "GameFontNormal"
    
    -- Create label
    local label = CreateFrame("Frame", labelName, parent)
    
    -- Label text
    local labelText = label:CreateFontString(nil, "OVERLAY", fontObject)
    labelText:SetPoint("TOPLEFT", label, "TOPLEFT", 0, 0)
    labelText:SetText(text)
    labelText:SetTextColor(COLORS.TEXT_WHITE[1], COLORS.TEXT_WHITE[2], COLORS.TEXT_WHITE[3], COLORS.TEXT_WHITE[4])
    
    -- Auto-size frame to text
    label:SetWidth(labelText:GetWidth())
    label:SetHeight(labelText:GetHeight())
    
    -- Store references
    label.text = labelText
    
    return label
end

-- Create footer with ASCII symbols (WoW 1.12.0 compatible)
function GUIFramework:CreateFooter(text, parent, fontTemplate)
    local footerName = GenerateFrameName("T_OoM_Footer")
    
    -- Validate parameters - use ASCII heart since emoji doesn't work
    text = text or "Made with <3 by Wht Mst (Mikhail Palagin)"
    parent = parent or UIParent
    fontTemplate = fontTemplate or "GameFontNormalSmall"
    
    -- Create footer frame
    local footer = CreateFrame("Frame", footerName, parent)
    footer:SetHeight(20)
    
    -- Create footer text
    local footerText = footer:CreateFontString(nil, "OVERLAY", fontTemplate)
    footerText:SetPoint("CENTER", footer, "CENTER", 0, 0)
    
    -- Use standard WoW font since emoji doesn't work in 1.12.0
    footerText:SetFont(FONTS.NORMAL, 9, "NONE")
    footerText:SetText(text)
    footerText:SetTextColor(COLORS.TEXT_GRAY[1], COLORS.TEXT_GRAY[2], COLORS.TEXT_GRAY[3], COLORS.TEXT_GRAY[4])
    
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Footer created with ASCII symbols (WoW 1.12.0 compatible)")
    
    -- Store references
    footer.text = footerText
    
    return footer
end

-- Event system for GUI components
local eventHandlers = {}

function GUIFramework:RegisterEvent(eventName, handler)
    if not eventHandlers[eventName] then
        eventHandlers[eventName] = {}
    end
    table.insert(eventHandlers[eventName], handler)
end

function GUIFramework:TriggerEvent(eventName, arg1, arg2, arg3, arg4, arg5)
    if eventHandlers[eventName] then
        for _, handler in ipairs(eventHandlers[eventName]) do
            if type(handler) == "function" then
                local success, err = pcall(handler, arg1, arg2, arg3, arg4, arg5)
                if not success then
                    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Event error (" .. eventName .. "): " .. tostring(err))
                end
            end
        end
    end
end

-- Utility functions

-- Show frame with fade-in effect
function GUIFramework:ShowFrame(frame)
    if frame and frame:IsVisible() == false then
        frame:Show()
        self:TriggerEvent("FRAME_SHOWN", frame)
    end
end

-- Hide frame with fade-out effect  
function GUIFramework:HideFrame(frame)
    if frame and frame:IsVisible() == true then
        frame:Hide()
        self:TriggerEvent("FRAME_HIDDEN", frame)
    end
end

-- Close all active frames
function GUIFramework:HideAllFrames()
    for name, frame in pairs(activeFrames) do
        if frame and frame:IsVisible() then
            frame:Hide()
        end
    end
end

-- Get frame by name
function GUIFramework:GetFrame(frameName)
    return activeFrames[frameName]
end

-- Module initialization
function GUIFramework:Initialize()
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " GUI Framework initialized successfully!")
    
    -- Register test event
    self:RegisterEvent("TEST_EVENT", function(message)
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Test event: " .. tostring(message))
    end)
    
    return true
end

-- Test function for GUI Framework
function GUIFramework:RunTest()
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Running GUI Framework test...")
    
    -- Test window creation
    local testWindow = self:CreateWindow("Test Window", 400, 300)
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Test window created and should be visible!")
    
    -- Debug information
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Window visible: " .. tostring(testWindow:IsVisible()))
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Window shown: " .. tostring(testWindow:IsShown()))
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Window strata: " .. tostring(testWindow:GetFrameStrata()))
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Window level: " .. tostring(testWindow:GetFrameLevel()))
    
    -- Test button creation
    local testButton = self:CreateButton("Test Button", 100, 32, testWindow, function()
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Test button clicked!")
        self:HideFrame(testWindow)
    end)
    testButton:SetPoint("CENTER", testWindow, "CENTER", 0, -50)
    
    -- Test editbox creation
    local testEditBox = self:CreateEditBox(200, 24, testWindow, "Enter text here...")
    testEditBox:SetPoint("CENTER", testWindow, "CENTER", 0, 0)
    
    -- Test checkbox creation
    local testCheckBox = self:CreateCheckBox("Test Checkbox", testWindow)
    testCheckBox:SetScript("OnClick", function()
        local checked = testCheckBox:GetChecked()
        DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " Checkbox: " .. (checked and "checked" or "unchecked"))
    end)
    testCheckBox:SetPoint("CENTER", testWindow, "CENTER", 0, 50)
    
    -- Test label creation
    local testLabel = self:CreateLabel("This is a test label", testWindow, "GameFontNormalLarge")
    testLabel:SetPoint("TOP", testWindow, "TOP", 0, -40)
    
    -- Test footer with ASCII symbols (WoW 1.12.0 compatible)
    local testFooter = self:CreateFooter("Made with <3 by Wht Mst (Mikhail Palagin)", testWindow)
    testFooter:SetPoint("BOTTOMLEFT", testWindow, "BOTTOMLEFT", 8, 8)
    testFooter:SetPoint("BOTTOMRIGHT", testWindow, "BOTTOMRIGHT", -8, 8)
    
    -- Show test window
    self:ShowFrame(testWindow)
    
    -- Test event system
    self:TriggerEvent("TEST_EVENT", "GUI Framework test completed!")
    
    DEFAULT_CHAT_FRAME:AddMessage(DEBUG_PREFIX .. " GUI Framework test completed! Close window with the button.")
end

-- Register module with loader
if T_OoM_Modules and T_OoM_Modules.Loader then
    T_OoM_Modules.Loader:RegisterModule(MODULE_NAME, GUIFramework)
else
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r Module loader not found! GUI Framework not registered.")
end


