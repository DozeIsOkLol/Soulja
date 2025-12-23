--[[
    Controller: LoaderManager.luau (V2.1 - Robust Fetching)
    Description: Corrected version with a safer module fetching function.
]]

local Config = {
    LoaderUI_URL = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/loader.luau",
    MainApp_URL = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/Main.luau"
}

-- [FIXED] Using the new, robust fetchModule function
local function fetchModule(url)
    local success, content = pcall(game.HttpGet, game, url)
    if not success or not content then
        warn("FETCH FAILED:", url, content)
        return nil
    end
    local compiledFunc, compileError = loadstring(content)
    if not compiledFunc then
        warn("COMPILE FAILED:", url, compileError)
        return nil
    end
    local success, result = pcall(compiledFunc)
    if not success then
        warn("EXECUTION FAILED:", url, result)
        return nil
    end
    return result
end

local LoaderUI = fetchModule(Config.LoaderUI_URL)
if not LoaderUI then
    warn("CRITICAL: The Loader UI module failed to load. Cannot continue.")
    return
end

local loaderWindow = LoaderUI.new("Project Soulja", "Bootstrapping application...")
loaderWindow:SetProgress(0.1)
task.wait(1)
loaderWindow:AddLabel("UI module loaded.", "Success")
loaderWindow:SetProgress(0.25)
task.wait(0.5)
loaderWindow:AddLabel("Fetching main application...", "Info")
loaderWindow:SetProgress(0.5)

local MainApp = fetchModule(Config.MainApp_URL)

if MainApp and MainApp.Init then
    loaderWindow:AddLabel("Application fetched.", "Success")
    loaderWindow:SetProgress(0.9)
    task.wait(0.5)
    loaderWindow:AddLabel("Initializing...", "Info")
    loaderWindow:SetProgress(1.0)
    task.wait(1)
    MainApp:Init()
    loaderWindow:Close()
    print("Bootstrap complete. Main application is now running.")
else
    loaderWindow:AddLabel("FATAL: Main application failed to load.", "Error")
    task.wait(3)
    loaderWindow:Close()
end
