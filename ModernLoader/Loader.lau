--[[
    Module: loader.luau (V4.1)
    Description: A production-ready UI library for creating modern, animated loaders.
    This script should be hosted on GitHub and required by a manager script.
    It exposes a single function: Loader.new(title, subtitle), which returns a UI instance API.
]]

local TweenService = game:GetService("TweenService")
local Loader = {}

-- Palette & Icons
local Palette = {
    Background = Color3.fromRGB(30, 32, 36),
    Primary = Color3.fromRGB(43, 45, 49),
    Accent = Color3.fromRGB(90, 81, 225),
    Text = Color3.fromRGB(255, 255, 255),
    MutedText = Color3.fromRGB(180, 180, 180),
    Success = Color3.fromRGB(87, 242, 135),
    Error = Color3.fromRGB(237, 66, 69),
    Info = Color3.fromRGB(200, 200, 200),
    Neutral = Color3.fromRGB(160, 160, 160)
}
local ICONS = {
    Success = "✔ ", Error = "✖ ", Info = "⟳ ", Neutral = "» "
}

-- The core constructor function
function Loader.new(title, subtitle)
    if game:GetService("CoreGui"):FindFirstChild("LoaderScreenGui_V4") then
        game:GetService("CoreGui"):FindFirstChild("LoaderScreenGui_V4"):Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoaderScreenGui_V4"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 450, 0, 250)
    mainFrame.Position = UDim2.fromScale(0.5, 0.5)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Palette.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    -- UI Elements
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
    local accentBar = Instance.new("Frame", mainFrame)
    accentBar.Size = UDim2.new(1, 0, 0, 4)
    accentBar.BackgroundColor3 = Palette.Accent
    accentBar.BorderSizePixel = 0
    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Size = UDim2.new(1, -20, 0, 30); titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.Text = title or "Loader"; titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Palette.Text; titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left; titleLabel.BackgroundTransparency = 1
    local subtitleLabel = Instance.new("TextLabel", mainFrame)
    subtitleLabel.Size = UDim2.new(1, -20, 0, 20); subtitleLabel.Position = UDim2.new(0, 10, 0, 35)
    subtitleLabel.Text = subtitle or "Initializing..."; subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.TextColor3 = Palette.MutedText; subtitleLabel.TextSize = 14
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left; subtitleLabel.BackgroundTransparency = 1
    local statusContainer = Instance.new("Frame", mainFrame)
    statusContainer.Size = UDim2.new(1, -20, 1, -105); statusContainer.Position = UDim2.new(0, 10, 0, 60)
    statusContainer.BackgroundColor3 = Palette.Primary; statusContainer.BorderSizePixel = 0
    statusContainer.ClipsDescendants = true
    Instance.new("UICorner", statusContainer).CornerRadius = UDim.new(0, 4)
    local uiListLayout = Instance.new("UIListLayout", statusContainer)
    uiListLayout.Padding = UDim.new(0, 5); uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    local progressBarBg = Instance.new("Frame", mainFrame)
    progressBarBg.Size = UDim2.new(1, -20, 0, 8); progressBarBg.Position = UDim2.new(0, 10, 1, -25)
    progressBarBg.BackgroundColor3 = Palette.Primary; progressBarBg.BorderSizePixel = 0
    Instance.new("UICorner", progressBarBg).CornerRadius = UDim.new(0, 4)
    local progressBarFill = Instance.new("Frame", progressBarBg)
    progressBarFill.Size = UDim2.new(0, 0, 1, 0); progressBarFill.BackgroundColor3 = Palette.Accent
    progressBarFill.BorderSizePixel = 0
    Instance.new("UICorner", progressBarFill).CornerRadius = UDim.new(0, 4)
    
    screenGui.Parent = game:GetService("CoreGui")
    mainFrame.Size = UDim2.new(0, 450, 0, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, 450, 0, 250) }):Play()

    local publicMethods = {}
    local activeMessages = {}
    local MAX_MESSAGES = 7

    function publicMethods:AddLabel(text, statusType)
        if #activeMessages >= MAX_MESSAGES then
            table.remove(activeMessages, 1):Destroy()
        end
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, -10, 0, 16); statusLabel.Text = (ICONS[statusType] or "") .. text
        statusLabel.Font = Enum.Font.Gotham; statusLabel.TextColor3 = Palette[statusType] or Palette.Info
        statusLabel.TextSize = 14; statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.BackgroundTransparency = 1; statusLabel.TextTransparency = 1
        statusLabel.Parent = statusContainer
        table.insert(activeMessages, statusLabel)
        TweenService:Create(statusLabel, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()
    end
    
    function publicMethods:SetProgress(percent)
        percent = math.clamp(percent, 0, 1)
        local targetSize = UDim2.new(percent, 0, 1, 0)
        TweenService:Create(progressBarFill, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = targetSize }):Play()
    end

    function publicMethods:Close()
        local outroTween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.new(0, 450, 0, 0) })
        outroTween:Play()
        outroTween.Completed:Wait()
        screenGui:Destroy()
    end

    return publicMethods
end

return Loader
