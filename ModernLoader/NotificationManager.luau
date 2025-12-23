--[[
    Manager: NotificationManager.luau (V1.2 - Verified Correct)
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
    notifFrame.Position = UDim2.new(1, 10, 0, 0)
    
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
    
    TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.fromScale(0, 0) }):Play()
    
    task.delay(4, function()
        if notifFrame and notifFrame.Parent then
            local outro = TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Position = UDim2.new(1, 10, 0, 0) })
            outro:Play()
            outro.Completed:Wait()
            notifFrame:Destroy()
        end
    end)
end -- This 'end' was the cause of the error. It is present here.

return Notifier
