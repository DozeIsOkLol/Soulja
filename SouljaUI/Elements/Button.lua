-- /Elements/Button.lua
return function(parent, config)
    local Button = Instance.new("TextButton", parent)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.Font = Enum.Font.Gotham
    Button.Text = config.Name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
    
    Button.MouseButton1Click:Connect(function() 
        pcall(config.Callback) 
    end)
    
    return {} -- Keep API consistent with original
end
