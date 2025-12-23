-- /Elements/Paragraph.lua
return function(parent, TextService, UserInputService, text) 
    local Frame = Instance.new("Frame", parent); 
    Frame.BackgroundTransparency = 1; 
    local Label = Instance.new("TextLabel", Frame); 
    Label.BackgroundTransparency = 1; 
    Label.Size = UDim2.new(1, 0, 1, 0); 
    Label.Font = Enum.Font.Gotham; 
    Label.Text = text; 
    Label.TextColor3 = Color3.fromRGB(200, 200, 200); 
    Label.TextSize = 14; 
    Label.TextWrapped = true; 
    Label.TextXAlignment = Enum.TextXAlignment.Left; 
    Label.TextYAlignment = Enum.TextYAlignment.Top; 
    local size = TextService:GetTextSize(text, 14, Enum.Font.Gotham, Vector2.new(parent.AbsoluteSize.X - 30, 1000)); 
    Frame.Size = UDim2.new(1, 0, 0, size.Y + 5); 
    return {} 
end
