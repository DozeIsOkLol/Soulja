--[[ Element: Tab.luau ]]
local TweenService = game:GetService("TweenService")
local Tab = {}
Tab.__index = Tab

local Colors = {
    Active = Color3.fromRGB(43, 45, 49),
    Inactive = Color3.fromRGB(30, 32, 36),
    TextActive = Color3.fromRGB(255, 255, 255),
    TextInactive = Color3.fromRGB(150, 150, 150)
}

function Tab.new(options)
    local self = setmetatable({}, Tab)
    self.Text = options.Text or "Tab"
    self.Frame = Instance.new("TextButton")
    self.Frame.Name = self.Text .. "Tab"
    self.Frame.Size = UDim2.new(0, 100, 1, 0)
    self.Frame.Text = self.Text
    self.Frame.Font = Enum.Font.GothamBold
    self.Frame.TextSize = 16
    self.Frame.BackgroundColor3 = Colors.Inactive
    self.Frame.TextColor3 = Colors.TextInactive
    Instance.new("UICorner", self.Frame).CornerRadius = UDim.new(0, 4)
    return self
end

function Tab:SetActive(active)
    local bgColor = active and Colors.Active or Colors.Inactive
    local textColor = active and Colors.TextActive or Colors.TextInactive
    TweenService:Create(self.Frame, TweenInfo.new(0.2), { BackgroundColor3 = bgColor, TextColor3 = textColor }):Play()
end

return Tab
