--[[
    Element: Slider.luau (V2.0 - Robust & Smooth)
    Description: A professional, state-based slider that is smooth and reliable.
    Includes programmatic Get/Set methods.
]]

local UserInputService = game:GetService("UserInputService")
local Slider = {}
Slider.__index = Slider

function Slider.new(options)
    local self = setmetatable({}, Slider)
    
    self.Min = options.Min or 0
    self.Max = options.Max or 100
    self.Default = options.Default or self.Min
    self.Callback = options.Callback or function() end
    self._value = self.Default

    -- Create UI elements
    self.Frame = Instance.new("Frame"); self.Frame.Name = "Slider"; self.Frame.Size = UDim2.new(1, 0, 0, 30); self.Frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", self.Frame); label.Size = UDim2.new(1, 0, 0, 20); label.Text = options.Text or "Slider"; label.Font = Enum.Font.Gotham; label.TextColor3 = Color3.new(1, 1, 1); label.TextSize = 16; label.TextXAlignment = Enum.TextXAlignment.Left; label.BackgroundTransparency = 1
    local valueLabel = Instance.new("TextLabel", label); valueLabel.Size = UDim2.fromScale(1, 1); valueLabel.Font = Enum.Font.GothamBold; valueLabel.TextColor3 = Color3.new(1, 1, 1); valueLabel.TextSize = 16; valueLabel.TextXAlignment = Enum.TextXAlignment.Right; valueLabel.BackgroundTransparency = 1

    local track = Instance.new("Frame", self.Frame); track.Name = "Track"; track.Position = UDim2.new(0, 0, 0, 20); track.Size = UDim2.new(1, 0, 0, 6); track.BackgroundColor3 = Color3.fromRGB(43, 45, 49); Instance.new("UICorner", track).CornerRadius = UDim.new(0.5, 0)
    local fill = Instance.new("Frame", track); fill.Name = "Fill"; fill.Size = UDim2.fromScale(0, 1); fill.BackgroundColor3 = Color3.fromRGB(90, 81, 225); Instance.new("UICorner", fill).CornerRadius = UDim.new(0.5, 0)
    local thumb = Instance.new("Frame", track); thumb.Name = "Thumb"; thumb.Size = UDim2.fromOffset(16, 16); thumb.AnchorPoint = Vector2.new(0.5, 0.5); thumb.Position = UDim2.fromScale(0, 0.5); thumb.BackgroundColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", thumb).CornerRadius = UDim.new(0.5, 0)
    local clickDetector = Instance.new("TextButton", track); clickDetector.Name = "ClickDetector"; clickDetector.Size = UDim2.fromScale(1, 1); clickDetector.BackgroundTransparency = 1; clickDetector.Text = ""

    -- Internal function to update the visuals based on the current value
    local function updateVisuals()
        local percent = (self._value - self.Min) / (self.Max - self.Min)
        valueLabel.Text = string.format("%.1f", self._value)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        thumb.Position = UDim2.new(percent, 0, 0.5, 0)
    end

    -- Programmatic way to set the value
    function self:SetValue(newValue, fireCallback)
        newValue = math.clamp(newValue, self.Min, self.Max)
        if self._value == newValue then return end
        self._value = newValue
        updateVisuals()
        if fireCallback ~= false then
            self.Callback(self._value)
        end
    end

    -- Get the current value
    function self:GetValue()
        return self._value
    end
    
    -- Set initial state without firing callback
    self:SetValue(self.Default, false)

    -- [NEW] Robust state-based dragging logic
    local isDragging = false
    
    clickDetector.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local newValue = self.Min + (self.Max - self.Min) * percent
            self:SetValue(newValue)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
            local percent = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local newValue = self.Min + (self.Max - self.Min) * percent
            self:SetValue(newValue)
        end
    end)
    
    return self
end

return Slider
