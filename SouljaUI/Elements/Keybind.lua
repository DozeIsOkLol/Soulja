-- /Elements/Keybind.lua
return function(parent, TextService, UserInputService, config) 
    local key, listening = config.Key or Enum.KeyCode.RightControl, false; 
    local Frame = Instance.new("Frame", parent); 
    Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45); 
    Frame.Size = UDim2.new(1, 0, 0, 40); 
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6); 
    local Label = Instance.new("TextLabel", Frame); 
    Label.BackgroundTransparency = 1; 
    Label.Size = UDim2.new(0.7, 0, 1, 0); 
    Label.Position = UDim2.new(0, 10, 0, 0); 
    Label.Font = Enum.Font.Gotham; 
    Label.Text = config.Name; 
    Label.TextColor3 = Color3.fromRGB(255, 255, 255); 
    Label.TextSize = 14; 
    Label.TextXAlignment = Enum.TextXAlignment.Left; 
    local Button = Instance.new("TextButton", Frame); 
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30); 
    Button.Position = UDim2.new(1, -100, 0.5, 0); 
    Button.Size = UDim2.new(0, 90, 0, 25); 
    Button.AnchorPoint = Vector2.new(0, 0.5); 
    Button.Font = Enum.Font.GothamBold; 
    Button.Text = key.Name; 
    Button.TextColor3 = Color3.fromRGB(255, 255, 255); 
    Button.TextSize = 12; 
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6); 
    Button.MouseButton1Click:Connect(function() listening = true; Button.Text = ". . ." end); 
    UserInputService.InputBegan:Connect(function(i, p) if p then return end; if listening then key = i.KeyCode; Button.Text = key.Name; listening = false elseif i.KeyCode == key then pcall(config.Callback) end end); 
    return {} 
end
