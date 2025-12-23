--[[
    Element: Button.luau
    Description: A simple, interactive button component.
]]

local TweenService = game:GetService("TweenService")
local Button = {}
Button.__index = Button

function Button.new(options)
    local self = setmetatable({}, Button)
    
    self.Text = options.Text or "Button"
    self.Callback = options.Callback or function() end

    self.Frame = Instance.new("TextButton")
    self.Frame.Name = "Button"
    self.Frame.Size = UDim2.new(1, 0, 0, 35)
    self.Frame.BackgroundColor3 = Color3.fromRGB(90, 81, 225)
    self.Frame.Text = self.Text
    self.Frame.Font = Enum.Font.GothamBold
    self.Frame.TextColor3 = Color3.new(1, 1, 1)
    self.Frame.TextSize = 16
    
    Instance.new("UICorner", self.Frame).CornerRadius = UDim.new(0, 4)
    
    -- Hover effect
    self.Frame.MouseEnter:Connect(function()
        TweenService:Create(self.Frame, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(110, 101, 245) }):Play()
    end)
    self.Frame.MouseLeave:Connect(function()
        TweenService:Create(self.Frame, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(90, 81, 225) }):Play()
    end)
    
    -- Activation
    self.Frame.Activated:Connect(self.Callback)
    
    return self
end

return Button
