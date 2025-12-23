--[[ Element: Editor.luau ]]
local Editor = {}
Editor.__index = Editor

function Editor.new(options)
    local self = setmetatable({}, Editor)
    
    self.PlaceholderText = options.PlaceholderText or "-- Your script here"
    
    self.Frame = Instance.new("TextBox")
    self.Frame.Name = "Editor"
    self.Frame.MultiLine = true
    self.Frame.TextWrapped = true
    self.Frame.TextXAlignment = Enum.TextXAlignment.Left
    self.Frame.TextYAlignment = Enum.TextYAlignment.Top
    self.Frame.ClearTextOnFocus = false
    self.Frame.Size = UDim2.new(1, 0, 1, 0)
    self.Frame.BackgroundColor3 = Color3.fromRGB(43, 45, 49)
    self.Frame.Font = Enum.Font.Code
    self.Frame.TextColor3 = Color3.new(1, 1, 1)
    self.Frame.TextSize = 16
    
    local padding = Instance.new("UIPadding", self.Frame)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    
    Instance.new("UICorner", self.Frame).CornerRadius = UDim.new(0, 4)

    -- Placeholder logic
    self.Frame.Text = self.PlaceholderText
    self.Frame.TextColor3 = Color3.fromRGB(120, 120, 120)

    self.Frame.Focused:Connect(function()
        if self.Frame.Text == self.PlaceholderText then
            self.Frame.Text = ""
            self.Frame.TextColor3 = Color3.new(1, 1, 1)
        end
    end)
    
    self.Frame.FocusLost:Connect(function()
        if self.Frame.Text == "" then
            self.Frame.Text = self.PlaceholderText
            self.Frame.TextColor3 = Color3.fromRGB(120, 120, 120)
        end
    end)
    
    return self
end

function Editor:GetText()
    if self.Frame.Text == self.PlaceholderText then return "" end
    return self.Frame.Text
end

return Editor
