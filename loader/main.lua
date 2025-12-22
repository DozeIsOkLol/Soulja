--[[
    - [FIX] Removed the non-functional 'ParticleEmitter' from the UI. It was dead
      code as particles do not render inside ScreenGuis. This cleans up the script
      and removes misleading function calls.
    - [FIX] Patched a critical memory leak in the 'RenderStepped' event. The connection
      is now properly disconnected when the loader finishes or is destroyed, preventing
      connections from stacking on re-execution.
    - [IMPROVEMENT] Hardened the whitelist authentication logic. It now checks for an
      exact UserID match on each line, preventing false positives where one ID is a
      substring of another (e.g., '123' matching '51234').
    - [FORMATTING] Performed a full formatting pass to ensure maximum readability,
      with logical code blocks clearly separated for easier debugging and modification.
]]

--================================================================================--
--[[ SERVICES ]]--
--================================================================================--
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

--================================================================================--
--[[ CONFIGURATION ]]--
--================================================================================--
local Config = {
    -- Main Settings
    HubName = "SOUJA HUB",
    Subtitle = "Public Version",
    LogoLetter = "S",
    ImageLogo = "", -- e.g., "rbxassetid/YOUR_DECAL_ID"
    LoadTime = 8,
    MinLoadTime = 2,
    Version = "2.0",

    -- Theme Customization
    ActiveTheme = "Discord", -- Themes: SolarFlareOrange, CyberpunkPink, OceanBlue, CrimsonRed, ForestGreen,
    ThemeURL = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/refs/heads/main/loader/themes.json", -- IMPORTANT: Replace with your actual URL

    -- The 'Themes' table is now empty and will be populated from the URL above.
    Themes = {},

    -- Script Features
    StatusCheckEnabled = true,
    WhitelistEnabled = false,
    VersionCheckEnabled = true,
    ChangelogEnabled = true,
    AudioVisEnabled = true, -- Note: This has a performance cost.

    -- URLs
    StatusURL = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/refs/heads/main/loader/status.json",
    WhitelistURL = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/refs/heads/main/loader/Whitelist.txt",
    VersionCheckURL = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/refs/heads/main/loader/Version.txt",
    ChangelogURL = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/refs/heads/main/loader/Changelog.txt",
    ScriptToLoad = "https://raw.githubusercontent.com/DozeIsOkLol/OpenSrcRBLX/refs/heads/main/GrowAMine",

    -- UI Text
    Messages = {"Connecting...","Authenticating...","Downloading assets...","Configuring environment...","Building interface...","Finalizing..."},
    Tips = {"Did you know? You can customize the settings in the hub.","Check out our community for support and updates!","New features are added regularly!"},
    TipDisplayChance = 0.3,

    -- Sounds
    Sounds = { Open = "rbxassetid/913363037", Update = "rbxassetid/6823769213", Success = "rbxassetid/10895847421", Failure = "rbxassetid/142642633", TipPing = "rbxassetid/5151558373" },
    SoundVolume = 0.7,

    -- Animation Timings
    IntroAnimationTime = 0.6, OutroAnimationTime = 0.5, TextFadeTime = 0.4, TipAnimationSpeed = 0.3, ProgressShineSpeed = 1.5, ProgressShimmerSpeed = 1.0, LogoHoverTime = 0.2,

    -- UI Dimensions & Radii
    LoaderWidth = 420, LoaderHeight = 260, LogoCircleSize = 70, LogoInnerSize = 58, LogoHoverScale = 1.07, LogoCircleCornerRadius = 15, LogoInnerCornerRadius = 12, ProgressBarHeight = 7, ProgressBarCornerRadius = 1, ContainerCornerRadius = 20, ContainerBorderThickness = 3,

    -- Theme-dependent Values (Advanced)
    ThemeValues = {
        SuccessFlashTransparency = 0.4, SuccessFlashThickness = 4, ProgressBarShineColor = Color3.fromRGB(255, 255, 255),
        ProgressBarShineTransparency = NumberSequence.new{ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.6), NumberSequenceKeypoint.new(1, 1) },
        ProgressBarShimmerTransparency = NumberSequence.new{ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.4, 0.8), NumberSequenceKeypoint.new(0.5, 0.7), NumberSequenceKeypoint.new(0.6, 0.8), NumberSequenceKeypoint.new(1, 1) }
    },

    -- Fonts & Effects
    Fonts = { Main = Enum.Font.GothamBold, Secondary = Enum.Font.Gotham, Code = Enum.Font.Code },
    InitialBlurSize = 12
}

--================================================================================--
--[[ THEME LOADER ]]--
--================================================================================--
local function LoadThemes()
    local success, rawJson = pcall(function() return game:HttpGet(Config.ThemeURL) end)
    if success then
        local decodeSuccess, decodedThemes = pcall(function() return HttpService:JSONDecode(rawJson) end)
        if decodeSuccess and type(decodedThemes) == "table" then
            local count = 0
            for themeName, themeData in pairs(decodedThemes) do
                local newTheme = {}
                for colorName, colorArray in pairs(themeData) do
                    if type(colorArray) == "table" and #colorArray == 3 then
                        newTheme[colorName] = Color3.fromRGB(colorArray[1], colorArray[2], colorArray[3])
                    end
                end
                Config.Themes[themeName] = newTheme
                count = count + 1
            end
            warn("[SoujaHub] Successfully loaded " .. count .. " external themes.")
            return
        else
            warn("[SoujaHub] Failed to decode external themes JSON.")
        end
    else
        warn("[SoujaHub] Could not fetch external themes from URL.")
    end

    warn("[SoujaHub] Using failsafe default theme.")
    Config.Themes["DefaultPurple"] = {
        Primary = Color3.fromRGB(170, 70, 255), Background = Color3.fromRGB(20, 20, 30),
        BackgroundGradient = Color3.fromRGB(35, 35, 50), Text = Color3.fromRGB(255, 255, 255),
        MutedText = Color3.fromRGB(120, 125, 135), ProgressBackground = Color3.fromRGB(30, 32, 38),
        Failure = Color3.fromRGB(255, 80, 80), SuccessFlash = Color3.fromRGB(255, 255, 255),
    }
end

LoadThemes()

-- Store the active theme colors for easy access
local ActiveTheme = Config.Themes[Config.ActiveTheme]

-- [FIX] Check if the selected theme exists and warn the user if it doesn't
if not ActiveTheme then
    warn("[SoujaHub] The selected ActiveTheme '" .. Config.ActiveTheme .. "' was not found in the loaded themes.")
    -- Fallback to DefaultPurple, or if that somehow fails, the very first theme available
    ActiveTheme = Config.Themes.DefaultPurple or Config.Themes[next(Config.Themes)]
    if ActiveTheme then
        warn("[SoujaHub] Falling back to a default theme.")
    else
        -- This should be almost impossible to trigger, but is a final failsafe
        error("[SoujaHub] CRITICAL: No themes could be loaded, and the failsafe theme is missing.")
    end
end

--================================================================================--
--[[ SCRIPT SETUP & PRE-CHECKS ]]--
--================================================================================--
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function runPreChecks()
    -- Status Check
    if Config.StatusCheckEnabled then
        local success, rawJson = pcall(function() return game:HttpGet(Config.StatusURL) end)
        if success then
            local decodeSuccess, statusData = pcall(function() return HttpService:JSONDecode(rawJson) end)
            if decodeSuccess and statusData and statusData.allow_load == false then
                return false, statusData.message or "The hub is currently offline."
            end
        end
    end

    -- Whitelist Check
    if Config.WhitelistEnabled then
        if not Config.WhitelistURL or Config.WhitelistURL == "" then
            warn("[SoujaHub] Whitelist URL is not configured. Skipping authentication.")
            return true
        end

        local success, userListText = pcall(function() return game:HttpGet(Config.WhitelistURL) end)
        if not success then return false, "Could not connect to the authentication server." end

        -- [IMPROVEMENT] Hardened whitelist logic for exact matching.
        local isWhitelisted = false
        for line in userListText:gmatch("[^\r\n]+") do
            if line:gsub("%s+", "") == tostring(player.UserId) then
                isWhitelisted = true
                break
            end
        end
        if not isWhitelisted then
            return false, "You are not authorized to use this script."
        end
    end

    return true
end

-- Run pre-checks and display failure message if needed
local isAuthorized, authMessage = runPreChecks()
if not isAuthorized then
    local authFailedGui = Instance.new("ScreenGui", playerGui)
    local frame = Instance.new("Frame", authFailedGui)
    frame.Size = UDim2.new(0, 400, 0, 100)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.BackgroundColor3 = ActiveTheme.Background
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "SOUJA HUB\n\nAuthentication Failed:\n" .. (authMessage or "An unknown error occurred.")
    textLabel.TextColor3 = ActiveTheme.Failure
    textLabel.Font = Config.Fonts.Main
    textLabel.TextSize = 16
    textLabel.TextWrapped = true
    return
end

-- Sound Player Setup
local SoundPlayer = {}
for name, id in pairs(Config.Sounds) do
    if id and id ~= "" then
        local sound = Instance.new("Sound")
        sound.SoundId = id
        sound.Volume = Config.SoundVolume
        sound.Parent = SoundService
        SoundPlayer[name] = sound
    end
end
local function PlaySound(name)
    if SoundPlayer[name] then
        SoundPlayer[name]:Play()
    end
end

-- Main UI Setup
local blur = Instance.new("BlurEffect", game:GetService("Lighting"))
blur.Size = 0
blur.Enabled = true

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SoujaHubLoader"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999

--================================================================================--
--[[ UI ELEMENT CREATION ]]--
--================================================================================--
local container = Instance.new("Frame", screenGui)
container.Name = "Container"
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.Size = UDim2.new(0, 0, 0, 0)
container.Position = UDim2.new(0.5, 0, 0.5, 0)
container.BackgroundColor3 = ActiveTheme.Background
container.BorderSizePixel = 0
Instance.new("UICorner", container).CornerRadius = UDim.new(0, Config.ContainerCornerRadius)

local containerGradient = Instance.new("UIGradient", container)
containerGradient.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, ActiveTheme.Background), ColorSequenceKeypoint.new(1, ActiveTheme.BackgroundGradient) }
containerGradient.Rotation = 90

local borderStroke = Instance.new("UIStroke", container)
borderStroke.Color = ActiveTheme.Primary
borderStroke.Thickness = Config.ContainerBorderThickness
borderStroke.Transparency = 0.2
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local logoCircle = Instance.new("Frame", container)
logoCircle.Name = "Logo"
logoCircle.AnchorPoint = Vector2.new(0.5, 0)
logoCircle.Size = UDim2.new(0, Config.LogoCircleSize, 0, Config.LogoCircleSize)
logoCircle.Position = UDim2.new(0.5, 0, 0, 25)
logoCircle.BackgroundColor3 = ActiveTheme.Primary
logoCircle.BorderSizePixel = 0
logoCircle.ClipsDescendants = true
Instance.new("UICorner", logoCircle).CornerRadius = UDim.new(0, Config.LogoCircleCornerRadius)

-- [REMOVED] The ParticleEmitter was non-functional and has been removed for performance and code clarity.

local logoInner = Instance.new("Frame", logoCircle)
logoInner.AnchorPoint = Vector2.new(0.5, 0.5)
logoInner.Size = UDim2.new(0, Config.LogoInnerSize, 0, Config.LogoInnerSize)
logoInner.Position = UDim2.new(0.5, 0, 0.5, 0)
logoInner.BackgroundColor3 = ActiveTheme.Background
logoInner.BorderSizePixel = 0
Instance.new("UICorner", logoInner).CornerRadius = UDim.new(0, Config.LogoInnerCornerRadius)

if Config.ImageLogo and Config.ImageLogo ~= "" then
    local i = Instance.new("ImageLabel", logoInner); i.Size = UDim2.new(1, 0, 1, 0); i.BackgroundTransparency = 1; i.Image = Config.ImageLogo
else
    local t = Instance.new("TextLabel", logoInner); t.Size = UDim2.new(1, 0, 1, 0); t.BackgroundTransparency = 1; t.Text = Config.LogoLetter; t.TextColor3 = ActiveTheme.Primary; t.TextSize = 36; t.Font = Config.Fonts.Main
end

local logoClickDetector = Instance.new("TextButton", logoCircle)
logoClickDetector.Name = "ClickDetector"; logoClickDetector.Size = UDim2.new(1, 0, 1, 0); logoClickDetector.BackgroundTransparency = 1; logoClickDetector.Text = ""

local title = Instance.new("TextLabel", container)
title.Size = UDim2.new(1, -40, 0, 35); title.Position = UDim2.new(0, 20, 0, 105); title.BackgroundTransparency = 1; title.Text = Config.HubName; title.TextColor3 = ActiveTheme.Text; title.TextSize = 28; title.Font = Config.Fonts.Main; title.TextXAlignment = Enum.TextXAlignment.Center

local versionText = Instance.new("TextLabel", container)
versionText.Size = UDim2.new(1, -40, 0, 18); versionText.Position = UDim2.new(0, 20, 0, 140); versionText.BackgroundTransparency = 1; versionText.Text = Config.Subtitle; versionText.TextColor3 = ActiveTheme.MutedText; versionText.TextSize = 13; versionText.Font = Config.Fonts.Secondary; versionText.TextXAlignment = Enum.TextXAlignment.Center

local progressBg = Instance.new("Frame", container)
progressBg.Name = "progressBg"; progressBg.Size = UDim2.new(1, -60, 0, Config.ProgressBarHeight); progressBg.Position = UDim2.new(0, 30, 0, 175); progressBg.BackgroundColor3 = ActiveTheme.ProgressBackground; progressBg.BorderSizePixel = 0
Instance.new("UICorner", progressBg).CornerRadius = UDim.new(Config.ProgressBarCornerRadius, 0)

local successGlowStroke = Instance.new("UIStroke", progressBg)
successGlowStroke.Color = ActiveTheme.SuccessFlash; successGlowStroke.Thickness = Config.ThemeValues.SuccessFlashThickness; successGlowStroke.Transparency = 1

local progressFill = Instance.new("Frame", progressBg)
progressFill.Name = "progressFill"; progressFill.Size = UDim2.new(0, 0, 1, 0); progressFill.BackgroundColor3 = ActiveTheme.Primary; progressFill.BorderSizePixel = 0; progressFill.ClipsDescendants = true
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(Config.ProgressBarCornerRadius, 0)
Instance.new("UIGradient", progressFill).Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ActiveTheme.Primary), ColorSequenceKeypoint.new(1, Color3.new(math.min(1, ActiveTheme.Primary.R * 1.5), math.min(1, ActiveTheme.Primary.G * 1.5), math.min(1, ActiveTheme.Primary.B * 1.5)))}

local progressShine = Instance.new("Frame", progressFill)
progressShine.Name = "progressShine"; progressShine.Size = UDim2.new(0.4, 0, 1, 0); progressShine.Position = UDim2.new(-1, 0, 0, 0); progressShine.BackgroundColor3 = Config.ThemeValues.ProgressBarShineColor; progressShine.BackgroundTransparency = 0.6; progressShine.BorderSizePixel = 0
Instance.new("UICorner", progressShine).CornerRadius = UDim.new(Config.ProgressBarCornerRadius, 0)
Instance.new("UIGradient", progressShine).Transparency = Config.ThemeValues.ProgressBarShineTransparency

local progressShimmer = Instance.new("UIGradient", progressFill)
progressShimmer.Rotation = 90; progressShimmer.Offset = Vector2.new(0, -1); progressShimmer.Transparency = Config.ThemeValues.ProgressBarShimmerTransparency

local percentText = Instance.new("TextLabel", container)
percentText.Size = UDim2.new(0, 100, 0, 28); percentText.Position = UDim2.new(0.5, -50, 0, 192); percentText.BackgroundTransparency = 1; percentText.Text = "0%"; percentText.TextColor3 = ActiveTheme.Primary; percentText.TextSize = 20; percentText.Font = Config.Fonts.Main

local statusText = Instance.new("TextLabel", container)
statusText.Size = UDim2.new(1, -40, 0, 20); statusText.Position = UDim2.new(0, 20, 0, 230); statusText.BackgroundTransparency = 1; statusText.Text = "Initializing..."; statusText.TextColor3 = ActiveTheme.MutedText; statusText.TextSize = 12; statusText.Font = Config.Fonts.Code; statusText.TextXAlignment = Enum.TextXAlignment.Center

if Config.ChangelogEnabled then
    local changelogButton = Instance.new("TextButton", container)
    changelogButton.Name = "ChangelogButton"; changelogButton.Size = UDim2.new(0, 80, 0, 20); changelogButton.Position = UDim2.new(1, -90, 0, 5); changelogButton.BackgroundTransparency = 1; changelogButton.Text = "What's New?"; changelogButton.Font = Config.Fonts.Code; changelogButton.TextSize = 12; changelogButton.TextColor3 = ActiveTheme.MutedText; changelogButton.TextXAlignment = Enum.TextXAlignment.Right
    changelogButton.MouseEnter:Connect(function() TweenService:Create(changelogButton, TweenInfo.new(0.2), {TextColor3 = ActiveTheme.Text}):Play() end)
    changelogButton.MouseLeave:Connect(function() TweenService:Create(changelogButton, TweenInfo.new(0.2), {TextColor3 = ActiveTheme.MutedText}):Play() end)
    changelogButton.MouseButton1Click:Connect(function()
        if container:FindFirstChild("ChangelogPanel") then container.ChangelogPanel:Destroy(); return end
        local success, text = pcall(function() return game:HttpGet(Config.ChangelogURL) end)
        local panel = Instance.new("Frame", container); panel.Name = "ChangelogPanel"; panel.ClipsDescendants = true; panel.Size = UDim2.new(0.9, 0, 0.7, 0); panel.AnchorPoint = Vector2.new(0.5, 0.5); panel.Position = UDim2.new(0.5, 0, 0.5, 0); panel.BackgroundColor3 = ActiveTheme.Background; panel.ZIndex = 10; Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10); Instance.new("UIStroke", panel).Color = ActiveTheme.Primary
        local scroll = Instance.new("ScrollingFrame", panel); scroll.Size = UDim2.new(1, -10, 1, -30); scroll.Position = UDim2.fromOffset(5, 5); scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0; scroll.CanvasSize = UDim2.new(0,0,0,0); scroll.ScrollBarThickness = 6
        local label = Instance.new("TextLabel", scroll); label.Size = UDim2.new(1, 0, 0, 0); label.AutomaticSize = Enum.AutomaticSize.Y; label.BackgroundTransparency = 1; label.Text = success and text or "Could not load the changelog."; label.TextColor3 = ActiveTheme.Text; label.Font = Config.Fonts.Secondary; label.TextSize = 14; label.TextXAlignment = Enum.TextXAlignment.Left; label.TextYAlignment = Enum.TextYAlignment.Top; label.TextWrapped = true
        local closeButton = Instance.new("TextButton", panel); closeButton.Size = UDim2.new(1, -10, 0, 20); closeButton.Position = UDim2.new(0, 5, 1, -25); closeButton.BackgroundTransparency = 1; closeButton.Text = "Close"; closeButton.Font = Config.Fonts.Main; closeButton.TextSize = 14; closeButton.TextColor3 = ActiveTheme.MutedText
        closeButton.MouseButton1Click:Connect(function() panel:Destroy() end)
        closeButton.MouseEnter:Connect(function() TweenService:Create(closeButton, TweenInfo.new(0.2), {TextColor3 = ActiveTheme.Text}):Play() end)
        closeButton.MouseLeave:Connect(function() TweenService:Create(closeButton, TweenInfo.new(0.2), {TextColor3 = ActiveTheme.MutedText}):Play() end)
    end)
end
screenGui.Parent = playerGui

--================================================================================--
--[[ CORE FUNCTIONS & ANIMATIONS ]]--
--================================================================================--
local currentPercent, loadingFinished, baseStatusText = 0, false, "Initializing..."

local function updateProgress(target, duration)
    local startPercent = currentPercent; local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out); local fillTween = TweenService:Create(progressFill, tweenInfo, {Size = UDim2.new(target / 100, 0, 1, 0)}); fillTween:Play(); local tempNumber = Instance.new("NumberValue"); tempNumber.Value = startPercent; local textTween = TweenService:Create(tempNumber, tweenInfo, {Value = target}); textTween:Play(); local connection; connection = tempNumber.Changed:Connect(function() local newPercent = math.clamp(tempNumber.Value, 0, 100); percentText.Text = math.floor(newPercent) .. "%"; currentPercent = newPercent; if newPercent >= target then tempNumber:Destroy(); connection:Disconnect() end end)
end

local tipDebounce = false
local function updateStatus(text, instant)
    baseStatusText = text; if instant then statusText.Text = text; return end; if not tipDebounce and #Config.Tips > 0 and math.random() < Config.TipDisplayChance then tipDebounce = true; local textToRestore = text; task.spawn(function() task.wait(1.5); PlaySound("TipPing"); local outTween = TweenService:Create(statusText, TweenInfo.new(Config.TipAnimationSpeed), {TextTransparency = 1}); outTween:Play(); outTween.Completed:Wait(); statusText.Text = Config.Tips[math.random(1, #Config.Tips)]; local inTween = TweenService:Create(statusText, TweenInfo.new(Config.TipAnimationSpeed), {TextTransparency = 0}); inTween:Play(); inTween.Completed:Wait(); task.wait(3); local outTween2 = TweenService:Create(statusText, TweenInfo.new(Config.TipAnimationSpeed), {TextTransparency = 1}); outTween2:Play(); outTween2.Completed:Wait(); statusText.Text = textToRestore; baseStatusText = textToRestore; local inTween2 = TweenService:Create(statusText, TweenInfo.new(Config.TipAnimationSpeed), {TextTransparency = 0}); inTween2:Play(); task.wait(3); tipDebounce = false end) else PlaySound("Update"); local outTween = TweenService:Create(statusText, TweenInfo.new(0.15), {TextTransparency = 1}); outTween:Play(); outTween.Completed:Wait(); statusText.Text = text; local inTween = TweenService:Create(statusText, TweenInfo.new(0.15), {TextTransparency = 0}); inTween:Play() end
end

local function displayFatalError(userFriendlyMessage, technicalMessage)
    loadingFinished = true; updateStatus(userFriendlyMessage, true); PlaySound("Failure"); TweenService:Create(borderStroke, TweenInfo.new(0.3), {Color = ActiveTheme.Failure}):Play(); TweenService:Create(progressFill, TweenInfo.new(0.3), {BackgroundColor3 = ActiveTheme.Failure}):Play(); local grad = progressFill:FindFirstChildOfClass("UIGradient"); if grad then TweenService:Create(grad, TweenInfo.new(0.3), {Color = ColorSequence.new(ActiveTheme.Failure)}):Play() end; percentText.TextColor3 = ActiveTheme.Failure; local copyButton = Instance.new("TextButton", container); copyButton.Name = "CopyErrorButton"; copyButton.Size = UDim2.new(0, 100, 0, 20); copyButton.Position = UDim2.new(0, 5, 1, -25); copyButton.BackgroundTransparency = 1; copyButton.Text = "[Copy Error]"; copyButton.Font = Config.Fonts.Code; copyButton.TextSize = 12; copyButton.TextColor3 = ActiveTheme.MutedText; copyButton.TextXAlignment = Enum.TextXAlignment.Left; copyButton.MouseEnter:Connect(function() TweenService:Create(copyButton, TweenInfo.new(0.2), {TextColor3 = ActiveTheme.Text}):Play() end); copyButton.MouseLeave:Connect(function() TweenService:Create(copyButton, TweenInfo.new(0.2), {TextColor3 = ActiveTheme.MutedText}):Play() end); copyButton.MouseButton1Click:Connect(function() if setclipboard then setclipboard(technicalMessage or userFriendlyMessage); copyButton.Text = "[Copied!]"; PlaySound("Success"); task.wait(2); copyButton.Text = "[Copy Error]" else warn("[SoujaHub] Clipboard access not available.") end end)
end

local function runVersionCheck()
    if not Config.VersionCheckEnabled or not Config.VersionCheckURL or Config.VersionCheckURL == "" then return end; task.spawn(function() local success, currentVersion = pcall(function() return game:HttpGet(Config.VersionCheckURL) end); if success and currentVersion:gsub("%s+", "") ~= Config.Version:gsub("%s+", "") then warn("[SoujaHub] Outdated! Latest: " .. currentVersion); PlaySound("TipPing"); local updateText = Instance.new("TextLabel", container); updateText.AnchorPoint = Vector2.new(0, 0); updateText.Size = UDim2.new(0, 150, 0, 20); updateText.Position = UDim2.new(0, 10, 0, 5); updateText.BackgroundTransparency = 1; updateText.Text = "Update Available! (v" .. currentVersion:gsub("%s+", "") .. ")"; updateText.TextColor3 = ActiveTheme.SuccessFlash; updateText.Font = Config.Fonts.Code; updateText.TextSize = 12; updateText.TextXAlignment = Enum.TextXAlignment.Left end end)
end

--================================================================================--
--[[ MAIN EXECUTION SEQUENCE ]]--
--================================================================================--
for _, child in ipairs(container:GetDescendants()) do if child:IsA("TextLabel") or child:IsA("TextButton") then child.TextTransparency = 1 elseif child:IsA("ImageLabel") then child.ImageTransparency = 1 elseif child:IsA("Frame") then child.BackgroundTransparency = 1 elseif child:IsA("UIStroke") then child.Transparency = 1 end end
logoCircle.MouseEnter:Connect(function() TweenService:Create(logoCircle, TweenInfo.new(Config.LogoHoverTime), {Size = UDim2.new(0, Config.LogoCircleSize * Config.LogoHoverScale, 0, Config.LogoCircleSize * Config.LogoHoverScale)}):Play() end)
logoCircle.MouseLeave:Connect(function() TweenService:Create(logoCircle, TweenInfo.new(Config.LogoHoverTime), {Size = UDim2.new(0, Config.LogoCircleSize, 0, Config.LogoCircleSize)}):Play() end)
logoClickDetector.MouseButton1Click:Connect(function() PlaySound("Update") end) -- [NOTE] Particle emit call removed here.

PlaySound("Open"); TweenService:Create(blur, TweenInfo.new(Config.IntroAnimationTime), {Size = Config.InitialBlurSize}):Play(); local introTween = TweenService:Create(container, TweenInfo.new(Config.IntroAnimationTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, Config.LoaderWidth, 0, Config.LoaderHeight)}); introTween:Play(); introTween.Completed:Wait()
for _, child in ipairs(container:GetDescendants()) do if child:IsA("TextLabel") or child:IsA("TextButton") then TweenService:Create(child, TweenInfo.new(Config.TextFadeTime), {TextTransparency = 0}):Play() elseif child:IsA("ImageLabel") then TweenService:Create(child, TweenInfo.new(Config.TextFadeTime), {ImageTransparency = 0}):Play() elseif child:IsA("Frame") then local targetTransparency = (child.Name == "progressShine") and 0.6 or 0; TweenService:Create(child, TweenInfo.new(Config.TextFadeTime), {BackgroundTransparency = targetTransparency}):Play() elseif child:IsA("UIStroke") then local targetTransparency = (child == successGlowStroke) and 1 or 0.2; TweenService:Create(child, TweenInfo.new(Config.TextFadeTime), {Transparency = targetTransparency}):Play() end; task.wait(0.02) end
if not Config.ScriptToLoad or Config.ScriptToLoad == "" then displayFatalError("FATAL: Script URL missing!", "The Config.ScriptToLoad variable is empty."); return end

runVersionCheck()

task.spawn(function() while container.Parent and not loadingFinished do progressShine.Position = UDim2.new(-0.4, 0, 0, 0); TweenService:Create(progressShine, TweenInfo.new(Config.ProgressShineSpeed, Enum.EasingStyle.Linear), {Position = UDim2.new(1.4, 0, 0, 0)}):Play(); task.wait(Config.ProgressShineSpeed + 0.5) end end)
task.spawn(function() while container.Parent and not loadingFinished do progressShimmer.Offset = Vector2.new(0, -1); TweenService:Create(progressShimmer, TweenInfo.new(Config.ProgressShimmerSpeed, Enum.EasingStyle.Linear), {Offset = Vector2.new(0, 1)}):Play(); task.wait(Config.ProgressShimmerSpeed + 0.5) end end)
task.spawn(function() while container.Parent and not loadingFinished do TweenService:Create(borderStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.05}):Play(); task.wait(1.5); if loadingFinished then break end; TweenService:Create(borderStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.2}):Play(); task.wait(1.5) end; borderStroke.Transparency = 0.2 end)
task.spawn(function() local dotCount = 0; while container.Parent and not loadingFinished do if not tipDebounce and baseStatusText:find("...") then dotCount = (dotCount % 3) + 1; statusText.Text = baseStatusText:gsub("...", string.rep(".", dotCount)) end; task.wait(0.5) end end)

if Config.AudioVisEnabled then
    -- [FIX] Patched RenderStepped memory leak by storing and disconnecting the connection.
    local audioVisualizerConnection
    audioVisualizerConnection = RunService.RenderStepped:Connect(function()
        if loadingFinished or not container.Parent then
            audioVisualizerConnection:Disconnect() -- Disconnect when done to prevent leak
            return
        end
        local targetThickness = Config.ContainerBorderThickness
        if SoundPlayer.Update and SoundPlayer.Update.IsPlaying then
            targetThickness = Config.ContainerBorderThickness + (SoundPlayer.Update.PlaybackLoudness / 1000) * 2
        end
        borderStroke.Thickness = borderStroke.Thickness + (targetThickness - borderStroke.Thickness) * 0.2
    end)
end

task.spawn(function()
    local startTime = tick(); local stepDuration = Config.LoadTime / #Config.Messages
    for i, msg in ipairs(Config.Messages) do updateStatus(msg, false); updateProgress((i / #Config.Messages) * 100, stepDuration * 0.9); task.wait(stepDuration) end
    local timeElapsed = tick() - startTime; if timeElapsed < Config.MinLoadTime then task.wait(Config.MinLoadTime - timeElapsed) end

    loadingFinished = true
    logoClickDetector.Active = false
    TweenService:Create(progressShine, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    updateStatus("Loading Script...", true)

    local success, result = pcall(function() loadstring(game:HttpGet(Config.ScriptToLoad))() end)

    if success then
        PlaySound("Success")
        updateStatus("Launched!", true)
        local flashIn = TweenService:Create(successGlowStroke, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = Config.ThemeValues.SuccessFlashTransparency})
        local flashOut = TweenService:Create(successGlowStroke, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Transparency = 1})
        flashIn:Play()
        flashIn.Completed:Connect(function() task.wait(0.1); flashOut:Play() end)
        flashOut.Completed:Connect(function()
            task.wait(0.5)
            TweenService:Create(blur, TweenInfo.new(Config.OutroAnimationTime), {Size = 0}):Play()
            local outroTween = TweenService:Create(container, TweenInfo.new(Config.OutroAnimationTime, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
            outroTween:Play()
            for _, child in ipairs(container:GetDescendants()) do if child:IsA("TextLabel") or child:IsA("TextButton") then TweenService:Create(child, TweenInfo.new(Config.OutroAnimationTime * 0.8), {TextTransparency = 1}):Play() elseif child:IsA("ImageLabel") then TweenService:Create(child, TweenInfo.new(Config.OutroAnimationTime * 0.8), {ImageTransparency = 1}):Play() elseif child:IsA("Frame") then TweenService:Create(child, TweenInfo.new(Config.OutroAnimationTime * 0.8), {BackgroundTransparency = 1}):Play() elseif child:IsA("UIStroke") then TweenService:Create(child, TweenInfo.new(Config.OutroAnimationTime * 0.8), {Transparency = 1}):Play() end end
            outroTween.Completed:Wait()
            screenGui:Destroy()
            blur:Destroy()
        end)
    else
        displayFatalError("Error: Script failed to execute.", tostring(result))
        warn("[SoujaHub] Critical Error: The main script failed to load.", result)
    end
end)
