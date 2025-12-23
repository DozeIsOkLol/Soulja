-- =============================================================================
-- Project Soulja UI Library - V2 Showcase
-- =============================================================================

local SouljaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/ModernLoader/UILibrary.luau"))()

if not SouljaUI then return end

local window = SouljaUI:CreateWindow({
    Title = "SouljaUI Showcase (Tabs!)",
    Size = Vector2.new(500, 350)
})

-- Add a tab group to the window
local tabGroup = window:AddTabGroup()

-- Add the first tab and get its page frame
local mainPage = tabGroup:AddTab({ Text = "Main" })

-- Add elements to the first page
local label = SouljaUI._components.Label.new({ Text = "Main Features" })
label.Frame.Parent = mainPage
local flyToggle = SouljaUI._components.Toggle.new({ Text = "Enable Fly" })
flyToggle.Frame.Parent = mainPage

-- Add the second tab and get its page frame
local settingsPage = tabGroup:AddTab({ Text = "Settings" })

-- Add elements to the second page
local speedSlider = SouljaUI._components.Slider.new({ Text = "WalkSpeed", Min = 16, Max = 200, Default = 16 })
speedSlider.Frame.Parent = settingsPage
local fovSlider = SouljaUI._components.Slider.new({ Text = "FOV", Min = 70, Max = 120, Default = 80 })
fovSlider.Frame.Parent = settingsPage

-- The script must not end
while true do task.wait(1) end
