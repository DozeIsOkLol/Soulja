-- /Core/Notify.lua
-- This is the final, correct version that supports Title, Text, and the SouljaUI brand.

return function(SouljaUI)
    -- This helper function creates the notification container on the screen.
    local function getNotifyContainer()
        if not SouljaUI.Properties.NotifyContainer or not SouljaUI.Properties.NotifyContainer.Parent then
            local NotifyGui = Instance.new("ScreenGui")
            NotifyGui.Name = "SouljaUI_Notifications"
            NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
            NotifyGui.ResetOnSpawn = false
            
            local Container = Instance.new("Frame", NotifyGui)
            Container.Name = "Container"
            Container.BackgroundTransparency = 1
            Container.Position = UDim2.new(1, -10, 1, -10)
            Container.AnchorPoint = Vector2.new(1, 1)
            Container.Size = UDim2.new(0, 250, 1, 0)
            
            local ListLayout = Instance.new("UIListLayout", Container)
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 5)
            ListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            
            SouljaUI.Properties.NotifyContainer = Container
            NotifyGui.Parent = game:GetService("CoreGui")
        end
        return SouljaUI.Properties.NotifyContainer
    end

    -- This is the main notification function.
    return function(config)
        task.spawn(function()
            local TweenService = game:GetService("TweenService")
            local container = getNotifyContainer()

            -- All parameters are now used
            local title = config.Title or "Notification"
            local message = config.Text or ""
            local duration = config.Duration or 5
            
            -- Main frame for the notification pop-up
            local notifyFrame = Instance.new("Frame")
            notifyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            notifyFrame.Size = UDim2.fromOffset(0, 60) -- Start animation from 0 width, height is 60
            notifyFrame.Parent = container
            
            local corner = Instance.new("UICorner", notifyFrame); corner.CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", notifyFrame); stroke.Color = Color3.fromRGB(50,50,50)

            -- "SouljaUI" brand label (top right)
            local brandLabel = Instance.new("TextLabel", notifyFrame)
            brandLabel.Name = "BrandLabel"; brandLabel.BackgroundTransparency = 1; brandLabel.Font = Enum.Font.Gotham
            brandLabel.Text = "SouljaUI"; brandLabel.TextColor3 = Color3.fromRGB(150, 150, 150); brandLabel.TextSize = 12
            brandLabel.TextXAlignment = Enum.TextXAlignment.Right; brandLabel.Position = UDim2.new(1, -10, 0, 5)
            brandLabel.Size = UDim2.new(0, 50, 0, 15); brandLabel.AnchorPoint = Vector2.new(1, 0)
            
            -- Main title label (top left)
            local titleLabel = Instance.new("TextLabel", notifyFrame)
            titleLabel.BackgroundTransparency = 1; titleLabel.Font = Enum.Font.GothamSemibold; titleLabel.Text = title
            titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255); titleLabel.TextSize = 16
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left; titleLabel.Position = UDim2.new(0, 10, 0, 5)
            titleLabel.Size = UDim2.new(1, -70, 0, 24)

            -- Message/Text label (below the title)
            local messageLabel = Instance.new("TextLabel", notifyFrame)
            messageLabel.BackgroundTransparency = 1; messageLabel.Font = Enum.Font.Gotham; messageLabel.Text = message
            messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200); messageLabel.TextSize = 14; messageLabel.TextWrapped = true
            messageLabel.TextXAlignment = Enum.TextXAlignment.Left; messageLabel.Position = UDim2.new(0, 10, 0, 28)
            messageLabel.Size = UDim2.new(1, -15, 0, 24)

            -- Blue progress bar at the bottom
            local bar = Instance.new("Frame", notifyFrame)
            bar.BackgroundColor3 = Color3.fromRGB(0, 122, 255); bar.BorderSizePixel = 0
            bar.Position = UDim2.new(0, 0, 1, -3); bar.Size = UDim2.new(1, 0, 0, 3)

            -- Animation setup
            local tweenInfoIn = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            local tweenInfoOut = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            local slideIn = TweenService:Create(notifyFrame, tweenInfoIn, { Size = UDim2.fromOffset(250, 60) })
            local slideOut = TweenService:Create(notifyFrame, tweenInfoOut, { Size = UDim2.fromOffset(0, 60) })
            local barDecay = TweenService:Create(bar, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 0, 3) })
            
            -- Play animations
            slideIn:Play(); barDecay:Play(); task.wait(duration); slideOut:Play(); task.wait(0.4); notifyFrame:Destroy()
        end)
    end
end
