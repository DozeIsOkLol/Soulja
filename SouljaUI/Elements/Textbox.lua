-- /Elements/Textbox.lua
return function(parent, TextService, UserInputService, config) 
    local Frame = Instance.new("Frame", parent); 
    Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45); 
    Frame.Size = UDim2.new(1, 0, 0, 40); 
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6); 
    local Label = Instance.new("TextLabel", Frame); 
    Label.BackgroundTransparency = 1; 
    Label.Size = UDim2.new(0.5, -10, 1, 0); 
    Label.Position = UDim2.new(0, 10, 0, 0); 
    Label.Font = Enum.Font.Gotham; 
    Label.Text = config.Name; 
    Label.TextColor3 = Color3.fromRGB(255, 255, 255); 
    Label.TextSize = 14; 
    Label.TextXAlignment = Enum.TextXAlignment.Left; 
    local Box = Instance.new("TextBox", Frame); 
    Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30); 
    Box.Position = UDim2.new(1, -160, 0.5, 0); 
    Box.Size = UDim2.new(0, 150, 0, 28); 
    Box.AnchorPoint = Vector2.new(0, 0.5); 
    Box.Font = Enum.Font.Gotham; 
    Box.PlaceholderText = config.Placeholder or "..."; 
    Box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150); 
    Box.TextColor3 = Color3.fromRGB(255, 255, 255); 
    Box.TextSize = 14; 
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6); 
    Box.FocusLost:Connect(function(enter) if enter then pcall(config.Callback, Box.Text) end end); 
    return {} 
end
