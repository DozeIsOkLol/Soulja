-- A conceptual Main.luau

-- Fetch all the UI elements your main app needs
local Window = fetchModule("https://raw.githubusercontent.com/DozeIsOkLol/Soulja/refs/heads/main/ModernLoader/elements/Window.luau")()
local Button = fetchModule("https://raw.githubusercontent.com/DozeIsOkLol/Soulja/refs/heads/main/ModernLoader/elements/Button.luau")()
local Dragger = fetchModule("https://raw.githubusercontent.com/DozeIsOkLol/Soulja/refs/heads/main/ModernLoader/elements/Dragger.luau")()
local NotificationManager = fetchModule("https://raw.githubusercontent.com/DozeIsOkLol/Soulja/refs/heads/main/ModernLoader/NotificationManager.luau")()

local MainApp = {}

function MainApp:Init()
    -- 1. Create the main window
    local mainWindow = Window.new({
        Title = "Project Soulja",
        Size = Vector2.new(500, 350)
    })
    
    -- 2. Make it draggable
    Dragger.new(mainWindow.Frame, mainWindow.Header)

    -- 3. Create a notification manager instance
    local Notifier = NotificationManager.new()

    -- 4. Add a button to the window
    local executeButton = Button.new({
        Text = "Execute",
        Callback = function()
            print("Execute button clicked!")
            Notifier:Send("Success", "Script executed!")
        end
    })
    
    mainWindow:Add(executeButton) -- Add the button to the window's content area
end

return MainApp
