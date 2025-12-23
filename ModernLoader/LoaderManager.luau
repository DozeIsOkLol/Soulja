--[[
    Controller: LoaderManager.luau (V2.0 - Bootstrapper)
    Description: Fetches the UI module, runs the loading sequence, and then
    fetches and launches the main application ('Main.luau').
]]

-- =============================================================================
-- Configuration: All your GitHub URLs go here for easy management.
-- =============================================================================
local Config = {
    -- The UI for the loader itself
    LoaderUI_URL = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/loader.luau",
    
    -- The main application script to launch after loading is complete
    MainApp_URL = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/Main.luau"
}

-- =============================================================================
-- Utility: Fetches and compiles a script from a URL.
-- =============================================================================
local function fetchModule(url)
    local success, content = pcall(game.HttpGet, game, url)
    if not success or not content then
        warn("Failed to fetch module:", url, content)
        return nil
    end

    local success, result = pcall(loadstring(content))
    if not success or not result then
        warn("Failed to execute or compile module:", url, result)
        return nil
    end
    
    return result
end

-- =============================================================================
-- Main Execution
-- =============================================================================

-- 1. Load the Loader's own UI
local LoaderUI = fetchModule(Config.LoaderUI_URL)
if not LoaderUI then
    warn("CRITICAL: The Loader UI module failed to load. Cannot continue.")
    return
end

-- 2. Create the loader window and run the loading sequence
local loaderWindow = LoaderUI.new("Project Soulja", "Bootstrapping application...")
loaderWindow:SetProgress(0.1)

task.wait(1)
loaderWindow:AddLabel("UI module loaded.", "Success")
loaderWindow:SetProgress(0.25)

task.wait(0.5)
loaderWindow:AddLabel("Fetching main application...", "Info")
loaderWindow:SetProgress(0.5)

-- 3. [NEW] Fetch the main application module
local MainApp = fetchModule(Config.MainApp_URL)

-- 4. [NEW] Check if the app was fetched successfully and launch it
if MainApp and MainApp.Init then
    loaderWindow:AddLabel("Application fetched.", "Success")
    loaderWindow:SetProgress(0.9)
    
    task.wait(0.5)
    loaderWindow:AddLabel("Initializing...", "Info")
    loaderWindow:SetProgress(1.0)
    
    task.wait(1)
    
    -- Hand control over to the main application
    MainApp:Init()
    
    -- Close the loader, leaving the main application on screen
    loaderWindow:Close()
    
    print("Bootstrap complete. Main application is now running.")
else
    loaderWindow:AddLabel("FATAL: Main application failed to load.", "Error")
    task.wait(3)
    loaderWindow:Close()
end```

---

### 2. `Main.luau` (Replace Your Existing File)

This is the new heart of your application. It defines all dependencies and builds the UI.

```lua
--[[
    Application Core: Main.luau
    Description: Fetches all necessary UI elements and managers, and then
    assembles the main application window and its functionality.
]]

-- =============================================================================
-- Configuration: URLs for all modules this application depends on.
-- =============================================================================
local Dependencies = {
    Window = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Window.luau",
    Button = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Button.luau",
    NotificationManager = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/NotificationManager.luau"
    -- Add Dragger.luau, Input.luau etc. here as you create them
}

-- =============================================================================
-- Utility: Fetches and compiles a script from a URL.
-- =============================================================================
local function fetchModule(url)
    local success, content = pcall(game.HttpGet, game, url)
    if not success or not content then return nil end
    local success, result = pcall(loadstring(content))
    if not success or not result then return nil end
    return result
end

-- =============================================================================
-- Main Application Table
-- =============================================================================
local MainApp = {}

function MainApp:Init()
    -- 1. Fetch all dependencies for the application
    local Window = fetchModule(Dependencies.Window)
    local Button = fetchModule(Dependencies.Button)
    local NotificationManager = fetchModule(Dependencies.NotificationManager)
    
    -- Check if all critical modules were loaded
    if not (Window and Button and NotificationManager) then
        warn("MainApp: A critical dependency failed to load. Aborting.")
        return
    end

    -- 2. Initialize the Notification Manager
    local Notifier = NotificationManager.new()

    -- 3. Create the main application window
    local mainWindow = Window.new({
        Title = "Project Soulja",
        Size = Vector2.new(520, 380)
    })
    
    -- 4. Create UI elements
    local testButton = Button.new({
        Text = "Show Notification",
        Callback = function()
            Notifier:Send("Info", "This is a test notification from the main application!")
        end
    })
    
    local anotherButton = Button.new({
        Text = "Another Button",
        Callback = function()
            Notifier:Send("Success", "You clicked the other button!")
        end
    })

    -- 5. Add elements to the window's content area
    mainWindow:Add(testButton)
    mainWindow:Add(anotherButton)
    
end

return MainApp
