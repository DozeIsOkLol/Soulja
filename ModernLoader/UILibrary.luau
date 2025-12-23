--[[
    Title: Project Soulja - UI Library (V1.0)
    Description: The main controller for the modular UI library. It fetches all
    necessary components from the 'elements' folder and provides the public API.
]]

local Library = {
    _version = "1.0",
    _components = {} -- Private table to hold the loaded component modules
}
Library.__index = Library

-- URLs for all the modular components the library depends on.
local Dependencies = {
    Window = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Window.luau",
    Button = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Button.luau",
    Input = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Input.luau",
    Toggle = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Toggle.luau",
    Dragger = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Dragger.luau"
    -- Add any new elements you create here
}

local function fetchModule(url)
    local success, content = pcall(game.HttpGet, game, url)
    if not success or not content then warn("FETCH FAILED:", url, content); return nil end
    local compiledFunc, compileError = loadstring(content)
    if not compiledFunc then warn("COMPILE FAILED:", url, compileError); return nil end
    local success, result = pcall(compiledFunc)
    if not success then warn("EXECUTION FAILED:", url, result); return nil end
    return result
end

-- Pre-load all components when the library is first required.
for name, url in pairs(Dependencies) do
    Library._components[name] = fetchModule(url)
    if not Library._components[name] then
        warn("SouljaUI Library: A critical component failed to load:", name, ". The library may not function correctly.")
    end
end

-- =============================================================================
-- Public API: This is what the user interacts with.
-- =============================================================================

function Library:CreateWindow(options)
    if not self._components.Window then return nil end
    -- Pass a reference to the main library into the window so it can create elements.
    local window = self._components.Window.new(options, self)
    return window
end

-- You can add other top-level functions here if needed, like a NotificationManager.

return Library
