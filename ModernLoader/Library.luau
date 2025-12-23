--[[
    Title: Project Soulja - UI Library (V1.0)
    Description: A standalone, reusable UI library for creating modern interfaces, inspired by CompKiller.
    This is the single file to be hosted and loaded by end-users.
]]

-- The main library table that will be returned.
local Library = {
    _version = "1.0",
    _components = {} -- Private table to hold the raw component code
}
Library.__index = Library

-- =============================================================================
-- [INTERNAL COMPONENT] Dragger
-- =============================================================================
Library._components.Dragger = (function()
    local UserInputService = game:GetService("UserInputService")
    local Dragger = {}
    function Dragger.new(target, trigger)
        local dragging, dragStart, startPos
        trigger.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging, dragStart, startPos = true, input.Position, target.Position
                local c; c = input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false; c:Disconnect() end end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                local delta = input.Position - dragStart
                target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    return Dragger
end)()

-- =============================================================================
-- [INTERNAL COMPONENT] All other elements (Button, Input, Toggle, etc.)
-- =============================================================================
Library._components.Button = (function() local TweenService = game:GetService("TweenService"); local Button = {}; Button.__index = Button; function Button.new(options) local self = setmetatable({}, Button); self.Text = options.Text or "Button"; self.Callback = options.Callback or function() end; self.Frame = Instance.new("TextButton"); self.Frame.Name = "Button"; self.Frame.Size = UDim2.new(1, 0, 0, 35); self.Frame.BackgroundColor3 = Color3.fromRGB(90, 81, 225); self.Frame.Text = self.Text; self.Frame.Font = Enum.Font.GothamBold; self.Frame.TextColor3 = Color3.new(1, 1, 1); self.Frame.TextSize = 16; Instance.new("UICorner", self.Frame).CornerRadius = UDim.new(0, 4); self.Frame.MouseEnter:Connect(function() TweenService:Create(self.Frame, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(110, 101, 245) }):Play() end); self.Frame.MouseLeave:Connect(function() TweenService:Create(self.Frame, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(90, 81, 225) }):Play() end); self.Frame.Activated:Connect(self.Callback); return self end; return Button end)()
Library._components.Input = (function() local Input = {}; Input.__index = Input; function Input.new(options) local self = setmetatable({}, Input); self.PlaceholderText = options.PlaceholderText or "Enter text..."; self.Frame = Instance.new("TextBox"); self.Frame.Name = "Input"; self.Frame.Size = UDim2.new(1, 0, 0, 35); self.Frame.BackgroundColor3 = Color3.fromRGB(43, 45, 49); self.Frame.BorderSizePixel = 0; self.Frame.Font = Enum.Font.Gotham; self.Frame.TextColor3 = Color3.new(1, 1, 1); self.Frame.TextSize = 14; self.Frame.TextXAlignment = Enum.TextXAlignment.Left; self.Frame.ClearTextOnFocus = false; Instance.new("UIPadding", self.Frame).PaddingLeft = UDim.new(0, 10); Instance.new("UICorner", self.Frame).CornerRadius = UDim.new(0, 4); self.Frame.Text = self.PlaceholderText; self.Frame.TextColor3 = Color3.fromRGB(120, 120, 120); self.Frame.Focused:Connect(function() if self.Frame.Text == self.PlaceholderText then self.Frame.Text = ""; self.Frame.TextColor3 = Color3.new(1, 1, 1) end end); self.Frame.FocusLost:Connect(function() if self.Frame.Text == "" then self.Frame.Text = self.PlaceholderText; self.Frame.TextColor3 = Color3.fromRGB(120, 120, 120) end end); return self end; function Input:GetText() if self.Frame.Text == self.PlaceholderText then return "" end; return self.Frame.Text end; return Input end)()
Library._components.Toggle = (function() local TweenService = game:GetService("TweenService"); local Toggle = {}; Toggle.__index = Toggle; function Toggle.new(options) local self = setmetatable({}, Toggle); self.Text = options.Text or "Toggle"; self.Callback = options.Callback or function() end; self._value = options.Default or false; self.Frame = Instance.new("Frame"); self.Frame.Name = "Toggle"; self.Frame.Size = UDim2.new(1, 0, 0, 25); self.Frame.BackgroundTransparency = 1; local label = Instance.new("TextLabel", self.Frame); label.Size = UDim2.new(1, -50, 1, 0); label.Text = self.Text; label.Font = Enum.Font.Gotham; label.TextColor3 = Color3.new(1, 1, 1); label.TextSize = 16; label.TextXAlignment = Enum.TextXAlignment.Left; label.BackgroundTransparency = 1; local switchBg = Instance.new("Frame", self.Frame); switchBg.Name = "Switch"; switchBg.Size = UDim2.fromOffset(40, 20); switchBg.Position = UDim2.new(1, -40, 0.5, 0); switchBg.AnchorPoint = Vector2.new(0, 0.5); switchBg.BackgroundColor3 = Color3.fromRGB(43, 45, 49); Instance.new("UICorner", switchBg).CornerRadius = UDim.new(0.5, 0); local switchKnob = Instance.new("Frame", switchBg); switchKnob.Name = "Knob"; switchKnob.Size = UDim2.fromOffset(16, 16); switchKnob.AnchorPoint = Vector2.new(0.5, 0.5); switchKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 200); Instance.new("UICorner", switchKnob).CornerRadius = UDim.new(0.5, 0); local button = Instance.new("TextButton", switchBg); button.Size = UDim2.fromScale(1, 1); button.BackgroundTransparency = 1; button.Text = ""; local function updateVisuals() local goalPos = self._value and UDim2.fromScale(0.75, 0.5) or UDim2.fromScale(0.25, 0.5); local goalColor = self._value and Color3.fromRGB(90, 81, 225) or Color3.fromRGB(43, 45, 49); TweenService:Create(switchKnob, TweenInfo.new(0.2), { Position = goalPos }):Play(); TweenService:Create(switchBg, TweenInfo.new(0.2), { BackgroundColor3 = goalColor }):Play() end; button.Activated:Connect(function() self._value = not self._value; updateVisuals(); self.Callback(self._value) end); updateVisuals(); return self end; function Toggle:GetValue() return self._value end; return Toggle end)()

-- =============================================================================
-- [Internal Component] The Window (The Core of the Library's API)
-- =============================================================================
Library._components.Window = (function()
    local Window = {}
    Window.__index = Window
    
    -- The Window holds a reference to the main library to create elements
    local MainLibrary = nil

    function Window.new(options, libraryRef)
        local self = setmetatable({}, Window)
        MainLibrary = libraryRef -- Store reference to main library
        
        local screenGui = Instance.new("ScreenGui"); screenGui.Name = "SouljaUI_Window"; screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global; screenGui.ResetOnSpawn = false; screenGui.DisplayOrder = 99998
        self.Frame = Instance.new("Frame"); self.Frame.Name = "WindowFrame"; self.Frame.Size = UDim2.fromOffset(options.Size.X, options.Size.Y); self.Frame.Position = UDim2.fromScale(0.5, 0.5); self.Frame.AnchorPoint = Vector2.new(0.5, 0.5); self.Frame.BackgroundColor3 = Color3.fromRGB(30, 32, 36); self.Frame.BorderSizePixel = 0; self.Frame.Parent = screenGui
        Instance.new("UICorner", self.Frame).CornerRadius = UDim.new(0, 6); self.Header = Instance.new("Frame", self.Frame); self.Header.Name = "Header"; self.Header.Size = UDim2.new(1, 0, 0, 30); self.Header.BackgroundColor3 = Color3.fromRGB(20, 22, 25); self.Header.BorderSizePixel = 0; Instance.new("UICorner", self.Header).CornerRadius = UDim.new(0, 6)
        self.TitleLabel = Instance.new("TextLabel", self.Header); self.TitleLabel.Size = UDim2.new(1, -10, 1, 0); self.TitleLabel.Position = UDim2.fromOffset(10, 0); self.TitleLabel.Text = options.Title or "Window"; self.TitleLabel.Font = Enum.Font.GothamBold; self.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255); self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left; self.TitleLabel.BackgroundTransparency = 1
        self.Content = Instance.new("Frame", self.Frame); self.Content.Name = "Content"; self.Content.Size = UDim2.new(1, -20, 1, -40); self.Content.Position = UDim2.fromOffset(10, 35); self.Content.BackgroundTransparency = 1
        self.Layout = Instance.new("UIListLayout", self.Content); self.Layout.Padding = UDim.new(0, 10);
        
        MainLibrary._components.Dragger.new(self.Frame, self.Header)
        screenGui.Parent = game:GetService("CoreGui")
        return self
    end
    
    -- This is the fluent API, like CompKiller
    function Window:AddButton(options)
        local button = MainLibrary._components.Button.new(options)
        button.Frame.Parent = self.Content
        return button
    end
    
    function Window:AddInput(options)
        local input = MainLibrary._components.Input.new(options)
        input.Frame.Parent = self.Content
        return input
    end
    
    function Window:AddToggle(options)
        local toggle = MainLibrary._components.Toggle.new(options)
        toggle.Frame.Parent = self.Content
        return toggle
    end

    return Window
end)()

-- =============================================================================
-- Public API: This is what the user interacts with.
-- =============================================================================

function Library:CreateWindow(options)
    -- Pass a reference to the main library into the window so it can create elements
    local window = self._components.Window.new(options, self)
    return window
end

-- We keep the NotificationManager separate as it's a utility, not a window element.
Library.CreateNotificationManager = (function() ... end) -- You can paste the NotificationManager code here if you want it in the library

-- This is the final step. Return the public API to the user.
return Library
