--[[
    Application Core: Main.luau (V2.1 - Robust Fetching)
    Description: Corrected version with a safer module fetching function.
]]

local Dependencies = {
    Window = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Window.luau",
    Button = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Button.luau",
    Input = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Input.luau",
    Toggle = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Toggle.luau",
    Dragger = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Dragger.luau",
    NotificationManager = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/NotificationManager.luau"
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

local MainApp = {}

function MainApp:Init()
    local Window = fetchModule(Dependencies.Window)
    local Button = fetchModule(Dependencies.Button)
    local Input = fetchModule(Dependencies.Input)
    local Toggle = fetchModule(Dependencies.Toggle)
    local Dragger = fetchModule(Dependencies.Dragger)
    local NotificationManager = fetchModule(Dependencies.NotificationManager)
    
    if not (Window and Button and Input and Toggle and Dragger and NotificationManager) then
        warn("MainApp: A critical dependency failed to load. Aborting.")
        return
    end

    local Notifier = NotificationManager.new()

    local mainWindow = Window.new({
        Title = "Project Soulja - Full UI",
        Size = Vector2.new(520, 420)
    })
    
    Dragger.new(mainWindow.Frame, mainWindow.Header)

    local scriptInput = Input.new({
        PlaceholderText = "print('Hello, World!')"
    })

    local autoExecute = Toggle.new({
        Text = "Auto-Execute",
        Default = true,
        Callback = function(value)
            Notifier:Send("Info", "Auto-Execute is now " .. (value and "ON" or "OFF"))
        end
    })
    
    local executeButton = Button.new({
        Text = "Execute",
        Callback = function()
            local text = scriptInput:GetText()
            if text and #text > 0 then
                Notifier:Send("Success", "Executed script!")
                print("Executing:", text)
            else
                Notifier:Send("Error", "Input is empty!")
            end
        end
    })

    mainWindow:Add(scriptInput)
    mainWindow:Add(autoExecute)
    mainWindow:Add(executeButton)
end

return MainApp
