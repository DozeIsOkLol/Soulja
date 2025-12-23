-- /init.lua
-- This script loads all SouljaUI components from GitHub.

local SouljaUI = {}

-- The base URL to your raw GitHub content.
local BASE_URL = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/SouljaUI/"

-- Custom loader function to fetch and run code from a URL.
local function LoadModule(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(BASE_URL .. path))()
    end)
    if not success then
        warn("SouljaUI Error: Failed to load module at path: " .. path, result)
        return nil
    end
    return result
end

-- 1. Load Shared Properties
SouljaUI.Properties = LoadModule("Core/Properties.lua")

-- 2. Load all UI Elements
local Elements = {
    AddButton = LoadModule("Elements/Button.lua"),
    AddKeybind = LoadModule("Elements/Keybind.lua"),
    AddLabel = LoadModule("Elements/Label.lua"),
    AddParagraph = LoadModule("Elements/Paragraph.lua"),
    AddSlider = LoadModule("Elements/Slider.lua"),
    AddTextbox = LoadModule("Elements/Textbox.lua"),
    AddToggle = LoadModule("Elements/Toggle.lua")
}

-- 3. Load Core Functions and inject dependencies
SouljaUI.CreateWindow = LoadModule("Core/CreateWindow.lua")(SouljaUI, Elements)
SouljaUI.Toggle = LoadModule("Core/Toggle.lua")(SouljaUI)
SouljaUI.Notify = LoadModule("Core/Notify.lua")(SouljaUI)

-- Return the fully constructed UI library
return SouljaUI
