-- This is an example of how a user would use your new UI Library.

-- 1. Load the library from GitHub
local SouljaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/Library.luau"))()

-- 2. Create the main window
-- The API is clean and simple.
local window = SouljaUI:CreateWindow({
    Title = "My First App with SouljaUI",
    Size = Vector2.new(450, 300)
})

-- 3. Add elements to the window using the new methods
-- The methods return the element, so you can interact with it later.
local myInput = window:AddInput({
    PlaceholderText = "Enter your name..."
})

local myToggle = window:AddToggle({
    Text = "Enable Godmode",
    Default = false
})

window:AddButton({
    Text = "Submit",
    Callback = function()
        local name = myInput:GetText()
        local godmode = myToggle:GetValue()
        print("Hello,", name, "- Godmode:", godmode)
    end
})

-- The script must not end, or the UI will be destroyed.
while true do task.wait(1) end
