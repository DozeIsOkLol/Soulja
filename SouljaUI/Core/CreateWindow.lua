-- /Core/CreateWindow.lua (Visually Corrected Version)
return function(SouljaUI, Elements)
    return function(config)
        local Properties = SouljaUI.Properties
        local UserInputService = game:GetService("UserInputService"); local TweenService = game:GetService("TweenService"); local TextService = game:GetService("TextService")
        Properties.Title = config.Title or "My Hub"; Properties.Version = config.Version or "v1.0"; Properties.Tabs = {}
        
        -- Main Window
        local ScreenGui = Instance.new("ScreenGui"); Properties.ScreenGui = ScreenGui; ScreenGui.Name = "SouljaUI_" .. math.random(1, 1000); ScreenGui.Parent = game:GetService("CoreGui"); ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global; ScreenGui.ResetOnSpawn = false
        local Main = Instance.new("Frame"); Main.Name = "MainFrame"; Main.Parent = ScreenGui; Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Main.BorderColor3 = Color3.fromRGB(45, 45, 45); Main.BorderSizePixel = 1; Main.Position = UDim2.new(0.5, -275, 0.5, -200); Main.Size = UDim2.new(0, 550, 0, 400); local MainCorner = Instance.new("UICorner", Main); MainCorner.CornerRadius = UDim.new(0, 8)
        
        -- Header
        do
            local Header = Instance.new("Frame", Main); Header.Name = "Header"; Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Header.Size = UDim2.new(1, 0, 0, 40); local HeaderCorner = Instance.new("UICorner", Header); HeaderCorner.CornerRadius = UDim.new(0, 8); local HeaderBottomBorder = Instance.new("Frame", Header); HeaderBottomBorder.BackgroundColor3 = Color3.fromRGB(45, 45, 45); HeaderBottomBorder.BorderSizePixel = 0; HeaderBottomBorder.Size = UDim2.new(1, 0, 0, 1); HeaderBottomBorder.Position = UDim2.new(0, 0, 1, -1)
            local TitleLabel = Instance.new("TextLabel", Header); TitleLabel.BackgroundTransparency = 1; TitleLabel.Size = UDim2.new(0, 200, 1, 0); TitleLabel.Position = UDim2.new(0, 15, 0, 0); TitleLabel.Font = Enum.Font.GothamSemibold; TitleLabel.Text = Properties.Title; TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255); TitleLabel.TextSize = 18; TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            local VersionLabel = Instance.new("TextLabel", Header); VersionLabel.BackgroundTransparency = 1; VersionLabel.Size = UDim2.new(0, 100, 1, 0); VersionLabel.Position = UDim2.new(1, -115, 0, 0); VersionLabel.Font = Enum.Font.Gotham; VersionLabel.Text = Properties.Version; VersionLabel.TextColor3 = Color3.fromRGB(150, 150, 150); VersionLabel.TextSize = 14; VersionLabel.TextXAlignment = Enum.TextXAlignment.Right
            local dragging, dragInput, dragStart, startPos; local function update(input) local delta = input.Position - dragStart; Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end; Header.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = Main.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end); Header.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end); UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
        end

        -- Tab Container and Divider
        local TabContainer = Instance.new("ScrollingFrame", Main); TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25); TabContainer.BorderSizePixel = 0; TabContainer.Position = UDim2.new(0, 0, 0, 40); TabContainer.Size = UDim2.new(0, 130, 1, -40); TabContainer.ScrollBarThickness = 0
        local TabListLayout = Instance.new("UIListLayout", TabContainer); TabListLayout.Padding = UDim.new(0, 5); TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder; TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        -- ADDED: The vertical line divider
        local TabDivider = Instance.new("Frame", Main); TabDivider.BackgroundColor3 = Color3.fromRGB(45, 45, 45); TabDivider.BorderSizePixel = 0; TabDivider.Position = UDim2.new(0, 130, 0, 40); TabDivider.Size = UDim2.new(0, 1, 1, -40)

        -- Content Container
        local ContentContainer = Instance.new("Frame", Main); ContentContainer.BackgroundTransparency = 1; ContentContainer.Position = UDim2.new(0, 131, 0, 40); ContentContainer.Size = UDim2.new(1, -131, 1, -40)

        local WindowMethods = {}
        function WindowMethods:CreateTab(name)
            local Tab = { Name = name }
            
            -- Unselected Style: Color3.fromRGB(40, 40, 40)
            -- Selected Style:   Color3.fromRGB(0, 122, 255)
            local TabButton = Instance.new("TextButton", TabContainer); TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40); TabButton.Size = UDim2.new(1, -20, 0, 35); TabButton.Name = name; TabButton.Font = Enum.Font.GothamSemibold; TabButton.Text = name; TabButton.TextColor3 = Color3.fromRGB(200, 200, 200); TabButton.TextSize = 15; Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)
            
            local TabContent = Instance.new("ScrollingFrame", ContentContainer); Tab.ContentFrame = TabContent; TabContent.BackgroundTransparency = 1; TabContent.Size = UDim2.new(1, 0, 1, 0); TabContent.Visible = false; TabContent.ScrollBarThickness = 4; TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y; TabContent.CanvasSize = UDim2.new(); TabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
            local ContentLayout = Instance.new("UIListLayout", TabContent); ContentLayout.Padding = UDim.new(0, 10); ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            local ContentPadding = Instance.new("UIPadding", TabContent); ContentPadding.PaddingTop = UDim2.new(0, 15); ContentPadding.PaddingLeft = UDim2.new(0, 15); ContentPadding.PaddingRight = UDim2.new(0, 15)
            
            local function SwitchToTab()
                for _, v in pairs(Properties.Tabs) do
                    v.ContentFrame.Visible = false
                    TweenService:Create(v.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                end
                TabContent.Visible = true
                TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 122, 255)}):Play()
            end
            
            TabButton.MouseButton1Click:Connect(SwitchToTab); Tab.Button = TabButton; table.insert(Properties.Tabs, Tab); if #Properties.Tabs == 1 then SwitchToTab() end
            
            local ElementMethods = {}
            for methodName, creatorFunc in pairs(Elements) do
                -- Pass required services to each element module
                ElementMethods[methodName] = function(_, ...)
                    return creatorFunc(TabContent, TextService, UserInputService, ...)
                end
            end
            
            return ElementMethods
        end
        
        return WindowMethods
    end
end
