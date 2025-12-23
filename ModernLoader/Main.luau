--[[
    Application Core: Main.luau (V4.1 - Corrected)
    Description: Assembles a full, multi-tab application. Fixed a syntax error.
]]

-- Add the new dependencies
local Dependencies = {
    Window = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Window.luau",
    Button = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Button.luau",
    Editor = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Editor.luau",
    Toggle = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Toggle.luau",
    Dragger = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Dragger.luau",
    NotificationManager = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/NotificationManager.luau",
    TabButton = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/TabButton.luau",
    TabController = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/TabController.luau"
}

-- [FIXED] The complete, working fetchModule function
local function fetchModule(url)
    local success, content = pcall(game.HttpGet, game, url)
    if not success or not content then warn("FETCH FAILED:", url, content); return nil end
    local compiledFunc, compileError = loadstring(content)
    if not compiledFunc then warn("COMPILE FAILED:", url, compileError); return nil end
    local success, result = pcall(compiledFunc)
    if not success then warn("EXECUTION FAILED:", url, result); return nil end
    return result
end

local MainApp = {}

function MainApp:Init()
    -- 1. Load all modules
    local Modules = {}
    for name, url in pairs(Dependencies) do
        local module = fetchModule(url)
        if not module then
            warn("MainApp: CRITICAL FAILURE loading dependency:", name, "from", url, ". Aborting.")
            return
        end
        Modules[name] = module
    end

    -- 2. Create the main window and managers
    local Notifier = Modules.NotificationManager.new()
    local mainWindow = Modules.Window.new({ Title = "Project Soulja", Size = Vector2.new(600, 450) })
    Modules.Dragger.new(mainWindow.Frame, mainWindow.Header)
    
    -- 3. Create the containers for the tab system
    local tabContainer = Instance.new("Frame", mainWindow.Frame)
    tabContainer.Size = UDim2.new(1, 0, 0, 35)
    tabContainer.Position = UDim2.fromOffset(0, 30)
    tabContainer.BackgroundTransparency = 1
    local tabLayout = Instance.new("UIListLayout", tabContainer)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal

    local contentContainer = Instance.new("Frame", mainWindow.Frame)
    contentContainer.Size = UDim2.new(1, -20, 1, -85)
    contentContainer.Position = UDim2.fromOffset(10, 75)
    contentContainer.BackgroundTransparency = 1
    
    -- 4. Initialize the Tab Controller
    local tabController = Modules.TabController.new(tabContainer, contentContainer)

    -- 5. Build the Executor Tab
    local executorPage = Instance.new("Frame")
    executorPage.Name = "ExecutorPage"
    executorPage.Size = UDim2.fromScale(1, 1)
    executorPage.BackgroundTransparency = 1
    local executorLayout = Instance.new("UIListLayout", executorPage)
    executorLayout.Padding = UDim.new(0, 10)
    
    local scriptEditor = Modules.Editor.new({ PlaceholderText = "-- Welcome to Project Soulja" })
    scriptEditor.Frame.Size = UDim2.new(1, 0, 1, -50) -- Make room for button
    scriptEditor.Frame.Parent = executorPage
    
    local executeButton = Modules.Button.new({ Text = "Execute" })
    executeButton.Frame.Parent = executorPage

    -- 6. Build the Settings Tab
    local settingsPage = Instance.new("Frame")
    settingsPage.Name = "SettingsPage"
    settingsPage.Size = UDim2.fromScale(1, 1)
    settingsPage.BackgroundTransparency = 1
    local settingsLayout = Instance.new("UIListLayout", settingsPage)
    settingsLayout.Padding = UDim.new(0, 10)
    
    local autoAttachToggle = Modules.Toggle.new({ Text = "Auto Attach", Default = true })
    autoAttachToggle.Frame.Parent = settingsPage
    
    local fpsUnlockerToggle = Modules.Toggle.new({ Text = "Unlock FPS", Default = false })
    fpsUnlockerToggle.Frame.Parent = settingsPage

    -- 7. Add the created tabs to the controller
    tabController:AddTab(Modules.TabButton.new({ Text = "Executor" }), executorPage)
    tabController:AddTab(Modules.TabButton.new({ Text = "Settings" }), settingsPage)
end

return MainApp
