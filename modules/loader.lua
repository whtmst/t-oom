--[[
T-OoM Module Loader
Base module loader for T-OoM addon architecture
Базовый загрузчик модулей для архитектуры аддона T-OoM
--]]

-- Create global namespace for T-OoM modules
if not T_OoM_Modules then
    T_OoM_Modules = {}
end

-- Debug message to confirm loader.lua is executed
DEFAULT_CHAT_FRAME:AddMessage("|cFF11A6EC[T-OoM]|r loader.lua loaded successfully!")

-- Module loader utility functions
T_OoM_Modules.Loader = {}

-- Register a module
function T_OoM_Modules.Loader:RegisterModule(name, module)
    if not name or not module then
        error("T-OoM: Invalid module registration - name and module required")
        return
    end
    
    T_OoM_Modules[name] = module
      -- Call module initialization if available
    if module.Initialize and type(module.Initialize) == "function" then
        local success, err = pcall(module.Initialize, module)
        if not success then
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r Failed to initialize module '" .. name .. "': " .. tostring(err))
        else
            -- DEBUG: Module loaded successfully
            -- DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00T-OoM:|r Module '" .. name .. "' loaded successfully")
        end
    end
end

-- Get a registered module
function T_OoM_Modules.Loader:GetModule(name)
    return T_OoM_Modules[name]
end

-- Check if module exists
function T_OoM_Modules.Loader:HasModule(name)
    return T_OoM_Modules[name] ~= nil
end

-- Initialize all modules (called after all modules are loaded)
function T_OoM_Modules.Loader:InitializeAll()
    for name, module in pairs(T_OoM_Modules) do        if name ~= "Loader" and module.PostInitialize and type(module.PostInitialize) == "function" then
            local success, err = pcall(module.PostInitialize, module)
            if not success then
                DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000T-OoM Error:|r Failed to post-initialize module '" .. name .. "': " .. tostring(err))
            end
        end
    end
end
