--[[
    Controller: LoaderManager.luau (V1.1)
    Description: Corrected version that fixes the 'attempt to call a table value' error.
]]

-- Configuration: Point this to the RAW URL of your 'loader.luau' file on GitHub.
local LOADER_UI_URL = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/refs/heads/main/ModernLoader/Loader.luau"

-- Utility to fetch and execute a module from a URL.
local function fetchModule(url)
    local success, content = pcall(game.HttpGet, game, url)
    if not success or not content then
        warn("Failed to fetch module:", url, content)
        return nil
    end

    -- pcall executes the function created by loadstring.
    -- The 'result' is the value returned by the module script (the 'Loader' table).
    local success, result = pcall(loadstring(content))
    if not success or not result then
        warn("Failed to execute or compile module:", url, result)
        return nil
    end
    
    -- [FIXED] Return the result directly. Do not call it.
    return result
end

-- Main execution
local LoaderUI = fetchModule(LOADER_UI_URL)

if not LoaderUI then
    warn("Could not start: The Loader UI module failed to load.")
    return
end

-- 1. Create a new UI instance from the loaded module
local loaderWindow = LoaderUI.new("Project Doze", "System starting...")
loaderWindow:SetProgress(0.05)

-- 2. Simulate your project's loading sequence
task.wait(1.5)
loaderWindow:AddLabel("UI module loaded.", "Success")
loaderWindow:SetProgress(0.15)

task.wait(1)
loaderWindow:AddLabel("Checking dependencies...", "Info")
loaderWindow:SetProgress(0.3)

task.wait(1.5)
loaderWindow:AddLabel("Anti-cheat bypass loaded.", "Neutral")
loaderWindow:SetProgress(0.6)

task.wait(1)
loaderWindow:AddLabel("Main functions injected.", "Neutral")
loaderWindow:SetProgress(0.8)

task.wait(1)
loaderWindow:AddLabel("Authentication failed.", "Error")
loaderWindow:AddLabel("Retrying with fallback...", "Info")
loaderWindow:SetProgress(0.85)

task.wait(2)
loaderWindow:AddLabel("Authenticated successfully.", "Success")
loaderWindow:SetProgress(1.0)

task.wait(1.5)

-- 3. Close the loader and hand off to the main script
loaderWindow:Close()

print("Loader finished. Main script would run now.")
