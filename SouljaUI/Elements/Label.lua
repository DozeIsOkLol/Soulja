-- /Elements/Label.lua
return function(parent, TextService, UserInputService, text) 
    local Label = Instance.new("TextLabel", parent); 
    Label.BackgroundTransparency = 1; 
    Label.Size = UDim2.new(1, 0, 0, 20); 
    Label.Font = Enum.Font.GothamSemibold; 
    Label.Text = text; 
    Label.TextColor3 = Color3.fromRGB(255, 255, 255); 
    Label.TextSize = 16; 
    Label.TextXAlignment = Enum.TextXAlignment.Left; 
    return {} 
end
