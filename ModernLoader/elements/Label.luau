--[[ Element: Label.luau ]]
local Label = {}
Label.__index = Label
function Label.new(options)
    local self = setmetatable({}, Label)
    self.Frame = Instance.new("TextLabel")
    self.Frame.Name = "Label"
    self.Frame.Size = UDim2.new(1, 0, 0, 20)
    self.Frame.Text = options.Text or "Label"
    self.Frame.Font = options.Font or Enum.Font.GothamBold
    self.Frame.TextColor3 = options.Color or Color3.new(1, 1, 1)
    self.Frame.TextSize = options.Size or 18
    self.Frame.TextXAlignment = options.Align or Enum.TextXAlignment.Left
    self.Frame.BackgroundTransparency = 1
    return self
end
return Label
