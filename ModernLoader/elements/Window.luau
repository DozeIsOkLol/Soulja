--[[
    Element: Window.luau
    Description: A draggable window component for the main application.
]]

local Window = {}
Window.__index = Window

function Window.new(options)
    local self = setmetatable({}, Window)

    self.Title = options.Title or "Window"
    self.Size = options.Size or Vector2.new(500, 350)

    -- Create the UI instances
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.fromOffset(self.Size.X, self.Size.Y)
    self.Frame.Position = UDim2.fromScale(0.5, 0.5)
    self.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Frame.BackgroundColor3 = Color3.fromRGB(30, 32, 36)
    self.Frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", self.Frame)
    corner.CornerRadius = UDim.new(0, 6)
    
    self.Header = Instance.new("Frame", self.Frame)
    self.Header.Size = UDim2.new(1, 0, 0, 30)
    self.Header.BackgroundColor3 = Color3.fromRGB(20, 22, 25)
    self.Header.BorderSizePixel = 0
    
    local headerCorner = Instance.new("UICorner", self.Header)
    headerCorner.CornerRadius = UDim.new(0, 6)
    
    self.TitleLabel = Instance.new("TextLabel", self.Header)
    self.TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    self.TitleLabel.Position = UDim2.fromOffset(10, 0)
    self.TitleLabel.Text = self.Title
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.BackgroundTransparency = 1
    
    self.Content = Instance.new("Frame", self.Frame)
    self.Content.Size = UDim2.new(1, -20, 1, -40)
    self.Content.Position = UDim2.fromOffset(10, 35)
    self.Content.BackgroundTransparency = 1
    
    self.Layout = Instance.new("UIListLayout", self.Content)
    self.Layout.Padding = UDim.new(0, 10)
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Simple Dragger Logic
    local dragging = false
    local dragStart
    local startPos
    
    self.Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            self.Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    self.Frame.Parent = game:GetService("CoreGui")
    return self
end

-- Method to add other elements into this window's content area
function Window:Add(element)
    if element and element.Frame and element.Frame:IsA("GuiObject") then
        element.Frame.Parent = self.Content
    end
end

return Window
