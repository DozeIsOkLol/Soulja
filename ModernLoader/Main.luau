--[[
    Application Core: Main.luau
    Description: Fetches all necessary UI elements and managers, and then
    assembles the main application window and its functionality.
]]

local Dependencies = {
    Window = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Window.luau",
    Button = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Button.luau",
    NotificationManager = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/NotificationManager.luau"
}

local function fetchModule(url)
    local success, content = pcall(game.HttpGet, game, url)
    if not success or not content then return nil end
    local success, result = pcall(loadstring(content))
    if not success or not result then return nil end
    return result
end

local MainApp = {}

function MainApp:Init()
    local Window = fetchModule(Dependencies.Window)
    local Button = fetchModule(Dependencies.Button)
    local NotificationManager = fetchModule(Dependencies.NotificationManager)
    
    if not (Window and Button and NotificationManager) then
        warn("MainApp: A critical dependency failed to load. Aborting.")
        return
    end

    local Notifier = NotificationManager.new()

    local mainWindow = Window.new({
        Title = "Project Soulja",
        Size = Vector2.new(520, 380)
    })
    
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

    mainWindow:Add(testButton)
    mainWindow:Add(anotherButton)
end

return MainApp
