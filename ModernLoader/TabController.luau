--[[
    Manager: TabController.luau (V1.1 - Corrected)
    Description: Manages tab buttons and their corresponding content pages.
    Fix: Corrected a subtle bug related to 'self' scope in button callbacks.
]]

local TabController = {}
TabController.__index = TabController

function TabController.new(tabContainer, contentContainer)
    local self = setmetatable({}, TabController)
    self.Tabs = {}
    self.ActiveTab = nil
    
    self.TabContainer = tabContainer
    self.ContentContainer = contentContainer
    
    return self
end

function TabController:AddTab(tabButton, pageFrame)
    local tabInfo = {
        Button = tabButton,
        Page = pageFrame
    }
    table.insert(self.Tabs, tabInfo)
    
    pageFrame.Parent = self.ContentContainer
    pageFrame.Visible = false -- Hide by default
    
    tabButton.Frame.Parent = self.TabContainer
    
    -- [FIX] Store 'self' in a local variable so it can be accessed inside the anonymous function.
    local controller = self
    tabButton.Frame.Activated:Connect(function()
        controller:SwitchToTab(tabInfo)
    end)
    
    -- If it's the first tab, make it active by default
    if #self.Tabs == 1 then
        self:SwitchToTab(tabInfo)
    end
end

function TabController:SwitchToTab(targetTab)
    if self.ActiveTab == targetTab then return end
    
    for _, tabInfo in ipairs(self.Tabs) do
        local isActive = (tabInfo == targetTab)
        tabInfo.Button:SetActive(isActive)
        tabInfo.Page.Visible = isActive
    end
    
    self.ActiveTab = targetTab
end

return TabController
