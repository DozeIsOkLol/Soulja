--[[ Element: TabButton.luau ]]
local TweenService = game:GetService("TweenService")
local TabButton = {}
TabButton.__index = TabButton

local Colors = {
    Active = Color3.fromRGB(43, 45, 49),
    Inactive = Color3.fromRGB(30, 32, 36),
    TextActive = Color3.fromRGB(255, 255, 255),
    TextInactive = Color3.fromRGB(150, 150, 150)
}

function TabButton.new(options)
    local self = setmetatable({}, TabButton)
    self.Text = options.Text or "Tab"
    self.Callback = options.Callback or function() end
    
    self.Frame = Instance.new("TextButton")
    self.Frame.Name = self.Text .. "Tab"
    self.Frame.Size = UDim2.new(0, 100, 1, 0) -- Fixed width, full height
    self.Frame.Text = self.Text
    self.Frame.Font = Enum.Font.GothamBold
    self.Frame.TextSize = 16
    self.Frame.BackgroundColor3 = Colors.Inactive
    self.Frame.TextColor3 = Colors.TextInactive
    
    self.Frame.Activated:Connect(self.Callback)
    return self
end

function TabButton:SetActive(active)
    local bgColor = active and Colors.Active or Colors.Inactive
    local textColor = active and Colors.TextActive or Colors.TextInactive
    TweenService:Create(self.Frame, TweenInfo.new(0.2), { BackgroundColor3 = bgColor, TextColor3 = textColor }):Play()
end

return TabButton
