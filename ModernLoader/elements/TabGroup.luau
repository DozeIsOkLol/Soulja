--[[ Element: TabGroup.luau ]]
local TabGroup = {}
TabGroup.__index = TabGroup

function TabGroup.new(libraryRef)
    local self = setmetatable({}, TabGroup)
    self.Library = libraryRef
    self.Tabs = {}
    self.ActiveTab = nil
    
    self.Frame = Instance.new("Frame")
    self.Frame.Name = "TabGroup"
    self.Frame.Size = UDim2.new(1, 0, 1, 0)
    self.Frame.BackgroundTransparency = 1
    
    self.TabContainer = Instance.new("Frame", self.Frame)
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(1, 0, 0, 35)
    self.TabContainer.BackgroundTransparency = 1
    local tabLayout = Instance.new("UIListLayout", self.TabContainer)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)

    self.ContentContainer = Instance.new("Frame", self.Frame)
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, 0, 1, -40)
    self.ContentContainer.Position = UDim2.fromOffset(0, 40)
    self.ContentContainer.BackgroundTransparency = 1
    
    return self
end

function TabGroup:AddTab(options)
    local pageFrame = Instance.new("Frame")
    pageFrame.Name = options.Text .. "Page"
    pageFrame.Size = UDim2.fromScale(1, 1)
    pageFrame.BackgroundTransparency = 1
    pageFrame.Visible = false
    pageFrame.Parent = self.ContentContainer
    
    local tabButton = self.Library._components.Tab.new(options)
    tabButton.Frame.Parent = self.TabContainer
    
    local tabInfo = { Button = tabButton, Page = pageFrame }
    table.insert(self.Tabs, tabInfo)
    
    local group = self
    tabButton.Frame.Activated:Connect(function()
        group:SwitchToTab(tabInfo)
    end)
    
    if #self.Tabs == 1 then
        self:SwitchToTab(tabInfo)
    end
    
    return pageFrame -- Return the page frame so the user can add elements to it
end

function TabGroup:SwitchToTab(targetTab)
    if self.ActiveTab == targetTab then return end
    for _, tabInfo in ipairs(self.Tabs) do
        local isActive = (tabInfo == targetTab)
        tabInfo.Button:SetActive(isActive)
        tabInfo.Page.Visible = isActive
    end
    self.ActiveTab = targetTab
end

return TabGroup
