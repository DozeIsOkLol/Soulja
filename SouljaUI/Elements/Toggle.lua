-- /Elements/Toggle.lua (Visually Corrected Version)
return function(parent, TextService, UserInputService, config)
    local TweenService = game:GetService("TweenService")
    local toggled = false
    
    local Frame = Instance.new("Frame", parent); Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45); Frame.Size = UDim2.new(1, 0, 0, 40); Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local Label = Instance.new("TextLabel", Frame); Label.BackgroundTransparency = 1; Label.Size = UDim2.new(0.7, 0, 1, 0); Label.Position = UDim2.new(0, 10, 0, 0); Label.Font = Enum.Font.Gotham; Label.Text = config.Name; Label.TextColor3 = Color3.fromRGB(255, 255, 255); Label.TextSize = 14; Label.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Off State Colors
    local SWITCH_OFF_COLOR = Color3.fromRGB(30, 30, 30)
    local CIRCLE_OFF_COLOR = Color3.fromRGB(180, 180, 180)
    -- On State Colors
    local SWITCH_ON_COLOR = Color3.fromRGB(0, 122, 255)
    local CIRCLE_ON_COLOR = Color3.fromRGB(255, 255, 255)

    local Switch = Instance.new("Frame", Frame); Switch.BackgroundColor3 = SWITCH_OFF_COLOR; Switch.Position = UDim2.new(1, -60, 0.5, 0); Switch.Size = UDim2.new(0, 50, 0, 24); Switch.AnchorPoint = Vector2.new(0, 0.5); Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
    local Circle = Instance.new("Frame", Switch); Circle.BackgroundColor3 = CIRCLE_OFF_COLOR; Circle.Position = UDim2.new(0, 4, 0.5, 0); Circle.Size = UDim2.new(0, 16, 0, 16); Circle.AnchorPoint = Vector2.new(0, 0.5); Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
    
    local Button = Instance.new("TextButton", Frame); Button.BackgroundTransparency = 1; Button.Size = UDim2.new(1, 0, 1, 0); Button.Text = ""
    
    Button.MouseButton1Click:Connect(function() 
        toggled = not toggled
        pcall(config.Callback, toggled)
        
        local pos = toggled and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 4, 0.5, 0)
        local cColor = toggled and CIRCLE_ON_COLOR or CIRCLE_OFF_COLOR
        local sColor = toggled and SWITCH_ON_COLOR or SWITCH_OFF_COLOR
        
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = pos, BackgroundColor3 = cColor}):Play()
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = sColor}):Play() 
    end)
    
    return {} 
end
