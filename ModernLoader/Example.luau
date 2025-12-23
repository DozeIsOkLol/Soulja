-- =============================================================================
-- Project Soulja UI Library - Example Usage
-- =============================================================================

-- 1. Load the main library file from GitHub. This one line gives you everything.
local SouljaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/UILibrary.luau"))()

if not SouljaUI then
    warn("SouljaUI failed to load. Aborting example.")
    return
end

-- 2. Create the main window.
local window = SouljaUI:CreateWindow({
    Title = "SouljaUI Showcase",
    Size = Vector2.new(480, 320)
})

-- 3. Add elements to the window using the fluent API.
window:AddToggle({
    Text = "Enable Fly",
    Default = false,
    Callback = function(value)
        print("Fly is now:", value)
    end
})

local nameInput = window:AddInput({
    PlaceholderText = "Enter your username..."
})

window:AddButton({
    Text = "Greet",
    Callback = function()
        local name = nameInput:GetText()
        if name and #name > 0 then
            print("Hello, " .. name .. "!")
        else
            print("Please enter a name.")
        end
    end
})

-- This script must not end, or the UI will be garbage collected.
while true do
    task.wait(1)
end
