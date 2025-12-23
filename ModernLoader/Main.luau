--[[
    Application Core: Main.luau (V3.0 - Production)
    Description: Final, clean version of the main application.
]]

local Dependencies = {
    Window = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Window.luau",
    Button = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Button.luau",
    Input = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Input.luau",
    Toggle = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Toggle.luau",
    Dragger = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/elements/Dragger.luau",
    NotificationManager = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/NotificationManager.luau"
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

local MainApp = {}

function MainApp:Init()
    local Modules = {}
    for name, url in pairs(Dependencies) do
        local module = fetchModule(url)
        if not module then
            warn("MainApp: A critical dependency failed to load:", name, "from", url, ". Aborting.")
            return
        end
        Modules[name] = module
    end

    local Notifier = Modules.NotificationManager.new()
    local mainWindow = Modules.Window.new({ Title = "Project Soulja", Size = Vector2.new(520, 420) })
    
    Modules.Dragger.new(mainWindow.Frame, mainWindow.Header)

    local scriptInput = Modules.Input.new({ PlaceholderText = "print('Hello, World!')" })
    local autoExecute = Modules.Toggle.new({
        Text = "Auto-Execute",
        Default = true,
        Callback = function(value) Notifier:Send("Info", "Auto-Execute is now " .. (value and "ON" or "OFF")) end
    })
    local executeButton = Modules.Button.new({
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
