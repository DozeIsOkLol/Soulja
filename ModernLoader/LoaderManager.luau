--[[
    Controller: LoaderManager.luau
    Description: Fetches the 'loader.luau' UI module and uses it to execute
    a loading sequence. This script represents the core logic of your tool.
]]

-- Configuration: Point this to the RAW URL of your 'loader.luau' file on GitHub.
local LOADER_UI_URL = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/refs/heads/main/ModernLoader/Loader.luau"

-- Utility to fetch and compile a script from a URL.
local function fetchModule(url)
    local success, content = pcall(game.HttpGet, game, url)
    if not success or not content then
        warn("Failed to fetch module:", url, content)
        return nil
    end

    local success, compiled = pcall(loadstring(content))
    if not success or not compiled then
        warn("Failed to compile module:", url, compiled)
        return nil
    end
    
    return compiled()
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

-- Pretend to load other scripts/assets here
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

-- At this point, you would typically run the main code for your tool.
print("Loader finished. Main script would run now.")
