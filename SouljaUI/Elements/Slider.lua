-- /Elements/Slider.lua
return function(parent, TextService, UserInputService, config) 
    local min, max = config.Min or 0, config.Max or 100; 
    local Frame = Instance.new("Frame", parent); 
    Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45); 
    Frame.Size = UDim2.new(1, 0, 0, 60); 
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6); 
    local Label = Instance.new("TextLabel", Frame); 
    Label.BackgroundTransparency = 1; 
    Label.Size = UDim2.new(1, -70, 0, 25); 
    Label.Position = UDim2.new(0, 10, 0, 0); 
    Label.Font = Enum.Font.Gotham; 
    Label.Text = config.Name; 
    Label.TextColor3 = Color3.fromRGB(255, 255, 255); 
    Label.TextSize = 14; 
    Label.TextXAlignment = Enum.TextXAlignment.Left; 
    local Value = Instance.new("TextLabel", Frame); 
    Value.BackgroundTransparency = 1; 
    Value.Size = UDim2.new(0, 50, 0, 25); 
    Value.Position = UDim2.new(1, -60, 0, 0); 
    Value.Font = Enum.Font.GothamBold; 
    Value.Text = tostring(min); 
    Value.TextColor3 = Color3.fromRGB(255, 255, 255); 
    Value.TextSize = 14; 
    Value.TextXAlignment = Enum.TextXAlignment.Right; 
    local Track = Instance.new("Frame", Frame); 
    Track.BackgroundColor3 = Color3.fromRGB(30, 30, 30); 
    Track.Position = UDim2.new(0.5, 0, 1, -18); 
    Track.Size = UDim2.new(1, -20, 0, 8); 
    Track.AnchorPoint = Vector2.new(0.5, 0); 
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0); 
    local Progress = Instance.new("Frame", Track); 
    Progress.BackgroundColor3 = Color3.fromRGB(0, 122, 255); 
    Progress.Size = UDim2.new(0, 0, 1, 0); 
    Instance.new("UICorner", Progress).CornerRadius = UDim.new(1, 0); 
    local Button = Instance.new("TextButton", Track); 
    Button.BackgroundTransparency = 1; 
    Button.Size = UDim2.new(1, 0, 1, 0); 
    Button.Text = ""; 
    local function update(pos) 
        local percent = math.clamp((pos.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1); 
        local val = math.floor(min + (max - min) * percent + 0.5); 
        Progress.Size = UDim2.new(percent, 0, 1, 0); 
        Value.Text = tostring(val); 
        pcall(config.Callback, val) 
    end; 
    local dragging = false; 
    Button.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; update(i.Position) end end); 
    Button.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end); 
    Button.InputChanged:Connect(function(i) if (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) and dragging then update(i.Position) end end); 
    return {} 
end
