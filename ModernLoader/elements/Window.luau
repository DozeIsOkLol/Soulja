--[[
    Element: Window.luau (V3.0 - Library Enabled)
    Description: The core window component. It now contains the fluent API
    to add other elements, making it the central object for UI creation.
]]

local Window = {}
Window.__index = Window

-- This will be set to the main library object when a window is created.
local MainLibrary = nil

function Window.new(options, libraryRef)
    local self = setmetatable({}, Window)
    
    -- Store the reference to the main library so this window can create other elements.
    MainLibrary = libraryRef
    
    local screenGui = Instance.new("ScreenGui"); screenGui.Name = "SouljaUI_Window"; screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global; screenGui.ResetOnSpawn = false; screenGui.DisplayOrder = 99998
    self.Frame = Instance.new("Frame"); self.Frame.Name = "WindowFrame"; self.Frame.Size = UDim2.fromOffset(options.Size.X, options.Size.Y); self.Frame.Position = UDim2.fromScale(0.5, 0.5); self.Frame.AnchorPoint = Vector2.new(0.5, 0.5); self.Frame.BackgroundColor3 = Color3.fromRGB(30, 32, 36); self.Frame.BorderSizePixel = 0; self.Frame.Parent = screenGui
    Instance.new("UICorner", self.Frame).CornerRadius = UDim.new(0, 6); self.Header = Instance.new("Frame", self.Frame); self.Header.Name = "Header"; self.Header.Size = UDim2.new(1, 0, 0, 30); self.Header.BackgroundColor3 = Color3.fromRGB(20, 22, 25); self.Header.BorderSizePixel = 0; Instance.new("UICorner", self.Header).CornerRadius = UDim.new(0, 6)
    self.TitleLabel = Instance.new("TextLabel", self.Header); self.TitleLabel.Size = UDim2.new(1, -10, 1, 0); self.TitleLabel.Position = UDim2.fromOffset(10, 0); self.TitleLabel.Text = options.Title or "Window"; self.TitleLabel.Font = Enum.Font.GothamBold; self.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255); self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left; self.TitleLabel.BackgroundTransparency = 1
    self.Content = Instance.new("Frame", self.Frame); self.Content.Name = "Content"; self.Content.Size = UDim2.new(1, -20, 1, -40); self.Content.Position = UDim2.fromOffset(10, 35); self.Content.BackgroundTransparency = 1
    self.Layout = Instance.new("UIListLayout", self.Content); self.Layout.Padding = UDim.new(0, 10);
    
    -- Use the Dragger component from the pre-loaded library components.
    MainLibrary._components.Dragger.new(self.Frame, self.Header)
    screenGui.Parent = game:GetService("CoreGui")
    return self
end

-- =============================================================================
-- Fluent API: These are the methods you call on a window object.
-- =============================================================================

function Window:AddButton(options)
    local button = MainLibrary._components.Button.new(options)
    button.Frame.Parent = self.Content
    return button -- Return for chaining or storing
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

-- Add more methods here for new elements you create, like :AddEditor()

return Window
