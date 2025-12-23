--[[
    Manager: NotificationManager.luau
    Description: A standalone library for creating and managing pop-up notifications.
]]

local TweenService = game:GetService("TweenService")
local Notifier = {}
Notifier.__index = Notifier

local Palette = {
    Background = Color3.fromRGB(30, 32, 36),
    Success = Color3.fromRGB(87, 242, 135),
    Error = Color3.fromRGB(237, 66, 69),
    Info = Color3.fromRGB(90, 81, 225)
}

function Notifier.new()
    local self = setmetatable({}, Notifier)
    
    self.Container = Instance.new("Frame")
    self.Container.Name = "NotificationContainer"
    self.Container.Size = UDim2.fromOffset(300, 500)
    self.Container.Position = UDim2.new(1, -10, 1, -10)
    self.Container.AnchorPoint = Vector2.new(1, 1)
    self.Container.BackgroundTransparency = 1
    
    local layout = Instance.new("UIListLayout", self.Container)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Padding = UDim.new(0, 5)
    
    self.Container.Parent = game:GetService("CoreGui")
    return self
end

function Notifier:Send(status, text)
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "Notification"
    notifFrame.Size = UDim2.new(1, 0, 0, 40)
    notifFrame.BackgroundColor3 = Palette.Background
    notifFrame.Position = UDim2.new(1, 10, 0, 0) -- Start off-screen
    
    Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 4)
    
    local accent = Instance.new("Frame", notifFrame)
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.BackgroundColor3 = Palette[status] or Palette.Info
    Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 4)

    local label = Instance.new("TextLabel", notifFrame)
    label.Size = UDim2.new(1, -15, 1, 0)
    label.Position = UDim2.fromOffset(10, 0)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    notifFrame.Parent = self.Container
    
    -- Animate in
    TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.fromScale(0, 0) }):Play()
    
    -- Animate out and destroy
    task.delay(4, function()
        if notifFrame and notifFrame.Parent then
            TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Position = UDim2.new(1, 10, 0, 0) }):Play()
            task.wait(0.4)
            notifFrame:Destroy()
        end
    end)
end

return Notifier```

---

### 5. Elements Folder (`ModernLoader/elements/`)

#### a) `Window.luau`
*   **Location:** `ModernLoader/elements/Window.luau`

```lua
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

    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.fromOffset(self.Size.X, self.Size.Y)
    self.Frame.Position = UDim2.fromScale(0.5, 0.5)
    self.Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Frame.BackgroundColor3 = Color3.fromRGB(30, 32, 36)
    self.Frame.BorderSizePixel = 0
    
    Instance.new("UICorner", self.Frame).CornerRadius = UDim.new(0, 6)
    
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

    local dragging, dragStart, startPos
    self.Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, dragStart, startPos = true, input.Position, self.Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
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

function Window:Add(element)
    if element and element.Frame and element.Frame:IsA("GuiObject") then
        element.Frame.Parent = self.Content
    end
end

return Window
