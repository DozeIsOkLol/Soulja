--[[
    Element: Toggle.luau
    Description: An on/off switch component for boolean options.
]]

local TweenService = game:GetService("TweenService")
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(options)
    local self = setmetatable({}, Toggle)
    
    self.Text = options.Text or "Toggle"
    self.Callback = options.Callback or function() end
    self._value = options.Default or false

    self.Frame = Instance.new("Frame")
    self.Frame.Name = "Toggle"
    self.Frame.Size = UDim2.new(1, 0, 0, 25)
    self.Frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", self.Frame)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Text = self.Text
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    
    local switchBg = Instance.new("Frame", self.Frame)
    switchBg.Name = "Switch"
    switchBg.Size = UDim2.fromOffset(40, 20)
    switchBg.Position = UDim2.new(1, -40, 0.5, 0)
    switchBg.AnchorPoint = Vector2.new(0, 0.5)
    switchBg.BackgroundColor3 = Color3.fromRGB(43, 45, 49)
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(0.5, 0)
    
    local switchKnob = Instance.new("Frame", switchBg)
    switchKnob.Name = "Knob"
    switchKnob.Size = UDim2.fromOffset(16, 16)
    switchKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    switchKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", switchKnob).CornerRadius = UDim.new(0.5, 0)
    
    local button = Instance.new("TextButton", switchBg)
    button.Size = UDim2.fromScale(1, 1)
    button.BackgroundTransparency = 1
    button.Text = ""

    local function updateVisuals()
        local goalPos = self._value and UDim2.fromScale(0.75, 0.5) or UDim2.fromScale(0.25, 0.5)
        local goalColor = self._value and Color3.fromRGB(90, 81, 225) or Color3.fromRGB(43, 45, 49)
        TweenService:Create(switchKnob, TweenInfo.new(0.2), { Position = goalPos }):Play()
        TweenService:Create(switchBg, TweenInfo.new(0.2), { BackgroundColor3 = goalColor }):Play()
    end
    
    button.Activated:Connect(function()
        self._value = not self._value
        updateVisuals()
        self.Callback(self._value)
    end)
    
    updateVisuals() -- Set initial state
    return self
end

function Toggle:GetValue()
    return self._value
end

return Toggle
