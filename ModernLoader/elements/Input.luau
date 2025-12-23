--[[
    Element: Input.luau (V1.1 - Verified Correct)
    Description: A styled text input box with placeholder functionality.
]]

local Input = {}
Input.__index = Input

function Input.new(options)
    local self = setmetatable({}, Input)
    
    self.PlaceholderText = options.PlaceholderText or "Enter text..."

    self.Frame = Instance.new("TextBox")
    self.Frame.Name = "Input"
    self.Frame.Size = UDim2.new(1, 0, 0, 35)
    self.Frame.BackgroundColor3 = Color3.fromRGB(43, 45, 49)
    self.Frame.BorderSizePixel = 0
    self.Frame.Font = Enum.Font.Gotham
    self.Frame.TextColor3 = Color3.new(1, 1, 1)
    self.Frame.TextSize = 14
    self.Frame.TextXAlignment = Enum.TextXAlignment.Left
    self.Frame.ClearTextOnFocus = false
    
    -- Add padding and corner
    Instance.new("UIPadding", self.Frame).PaddingLeft = UDim.new(0, 10)
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
    
    self.Frame.FocusLost:Connect(function(enterPressed)
        if self.Frame.Text == "" then
            self.Frame.Text = self.PlaceholderText
            self.Frame.TextColor3 = Color3.fromRGB(120, 120, 120)
        end
    end)
    
    return self
end

function Input:GetText()
    if self.Frame.Text == self.PlaceholderText then
        return ""
    end
    return self.Frame.Text
end

return Input
