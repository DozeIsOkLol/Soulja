--[[
    License:
    This project is open source and free to use. You are permitted to modify,
    reuse, and redistribute this script for any purpose. Credit is appreciated but
    not required. Authored by the SouljaWitchSrc community.
]]

--================================================================================--
--[[ SERVICES & ENVIRONMENT CHECK ]]--
--================================================================================--
-- [POLISH] Optional executor-only guard.
--[[
if not (syn or getexecutorname or identifyexecutor) then
    warn("[SouljaLoader] Executor environment not detected. Halting script.")
    return
end
]]
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

--================================================================================--
--[[ CONFIGURATION ]]--
--================================================================================--
local Config = {
    HubName = "SOULJA HUB",
    LoadTime = 5,
    ReducedMotion = false,
    Messages = {"Connecting...", "Loading assets...", "Finalizing..."},
    Fonts = { Main = Enum.Font.GothamBold, Secondary = Enum.Font.Gotham },
    ThemeURL = "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/main/loader/themes.json",
    ActiveTheme = "Discord",
    Themes = {},
    KeySystem = {
        Enabled = true,
        GetKeyURL = "https://your-discord-link-here.com/get-key",
        CheckKeyFunction = function(key) local keys={"SOUJA-HUB-ROCKS", "TEST-KEY-123"}; task.wait(0.5); for _,v in ipairs(keys) do if key==v then return true end end; return false end
    }
}

--================================================================================--
--[[ THEME LOADER ]]--
--================================================================================--
local BaseTheme = {
    Primary = Color3.fromRGB(170, 70, 255), Background = Color3.fromRGB(20, 20, 30),
    Text = Color3.fromRGB(255, 255, 255), MutedText = Color3.fromRGB(120, 125, 135),
    ProgressBackground = Color3.fromRGB(30, 32, 38), Failure = Color3.fromRGB(200, 50, 50),
    Shine = Color3.fromRGB(255, 255, 255)
}

local function clone(tbl) local newTbl={}; for k,v in pairs(tbl) do newTbl[k]=v end; return newTbl end

local function RobustHttpGet(url)
    for i=1,3 do local s,r = pcall(game.HttpGet, game, url); if s and type(r)=="string" and #r>0 then return true,r end; warn(("[SouljaLoader] HTTP GET failed for '%s' (Attempt %d/3)"):format(url,i)); task.wait(0.5) end; return false
end

local function LoadThemes()
    local success, rawJson = RobustHttpGet(Config.ThemeURL)
    if success then
        local decodeSuccess, decodedThemes = pcall(HttpService.JSONDecode, HttpService, rawJson)
        if decodeSuccess and type(decodedThemes) == "table" then
            local count = 0
            for themeName, themeData in pairs(decodedThemes) do
                local newTheme = clone(BaseTheme) -- Start with a defensive copy of the base.
                for colorName, colorArray in pairs(themeData) do
                    if type(colorArray)=="table" and #colorArray==3 and newTheme[colorName] then
                        newTheme[colorName] = Color3.fromRGB(colorArray[1], colorArray[2], colorArray[3])
                    end
                end
                Config.Themes[themeName] = newTheme
                count = count + 1
            end
            print("[SouljaLoader] Successfully loaded", count, "external themes.")
            return
        end
    end
    warn("[SouljaLoader] Could not load remote themes. Using failsafe theme.")
    Config.Themes["Failsafe"] = clone(BaseTheme) -- [POLISH] Use a clone to prevent mutation.
    Config.ActiveTheme = "Failsafe"
end

--================================================================================--
--[[ MAIN LOADER LOGIC (Unchanged) ]]--
--================================================================================--
local function startLoader(Theme)
    local player = Players.LocalPlayer; local playerGui = player:WaitForChild("PlayerGui")
    if playerGui:FindFirstChild("SouljaLoader") then playerGui.SouljaLoader:Destroy(); task.wait(0.1) end
    local screenGui = Instance.new("ScreenGui", playerGui); screenGui.Name = "SouljaLoader"; screenGui.ResetOnSpawn = false
    local container = Instance.new("Frame", screenGui); container.AnchorPoint = Vector2.new(0.5, 0.5); container.Position = UDim2.new(0.5, 0, 0.5, 0); local finalSize = UDim2.new(0, 380, 0, 220); container.Size = Config.ReducedMotion and finalSize or UDim2.new(0, 0, 0, 0); container.BackgroundColor3 = Theme.Background; Instance.new("UICorner", container).CornerRadius = UDim.new(0, 12)
    local containerGlow = Instance.new("UIStroke", container); containerGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; containerGlow.Color = Theme.Primary; containerGlow.Thickness = 1; containerGlow.Transparency = 0.85
    local title = Instance.new("TextLabel", container); title.Size = UDim2.new(1, 0, 0, 50); title.BackgroundTransparency = 1; title.Text = Config.HubName; title.Font = Config.Fonts.Main; title.TextColor3 = Theme.Text; title.TextSize = 28; title.TextYAlignment = Enum.TextYAlignment.Center
    local finalTitlePosition = UDim2.new(0, 0, 0, 20); if not Config.ReducedMotion then title.Position = finalTitlePosition + UDim2.fromOffset(0, 6); title.TextTransparency = 1 else title.Position = finalTitlePosition end
    local statusText = Instance.new("TextLabel", container); statusText.Size = UDim2.new(1, 0, 0, 30); statusText.Position = UDim2.new(0, 0, 0, 180); statusText.BackgroundTransparency = 1; statusText.Text = ""; statusText.Font = Config.Fonts.Secondary; statusText.TextColor3 = Theme.MutedText; statusText.TextSize = 14
    local function updateStatus(newText, color) color = color or Theme.MutedText; if Config.ReducedMotion then statusText.Text=newText; statusText.TextColor3=color; return end; TweenService:Create(statusText,TweenInfo.new(0.15),{TextTransparency=1}):Play(); task.wait(0.15); statusText.Text=newText; statusText.TextColor3=color; TweenService:Create(statusText,TweenInfo.new(0.15),{TextTransparency=0}):Play() end
    local function runLoadingSequence()
        if #Config.Messages == 0 then Config.Messages = {"Loading..."} end
        local progressBg = Instance.new("Frame", container); progressBg.Size = UDim2.new(1, -60, 0, 8); progressBg.Position = UDim2.new(0.5, 0, 0, 150); progressBg.AnchorPoint = Vector2.new(0.5, 0); progressBg.BackgroundColor3 = Theme.ProgressBackground; Instance.new("UICorner", progressBg).CornerRadius = UDim.new(0, 4)
        local progressFill = Instance.new("Frame", progressBg); progressFill.Size = UDim2.new(0, 0, 1, 0); progressFill.BackgroundColor3 = Theme.Primary; progressFill.ClipsDescendants = true; Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 4)
        local pulseTween; if not Config.ReducedMotion then local pulseColor = Theme.Primary:Lerp(Color3.new(1,1,1), 0.15); pulseTween = TweenService:Create(progressFill, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { BackgroundColor3 = pulseColor }); pulseTween:Play() end
        local stepDuration = Config.LoadTime / #Config.Messages; local activeProgressTween; local shinePlayed = false
        for i, message in ipairs(Config.Messages) do
            updateStatus(message); if activeProgressTween then activeProgressTween:Cancel() end; local progress = i / #Config.Messages
            activeProgressTween = TweenService:Create(progressFill, TweenInfo.new(stepDuration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { Size = UDim2.new(progress, 0, 1, 0) }); activeProgressTween:Play()
            if not Config.ReducedMotion and progress >= 0.75 and not shinePlayed then shinePlayed = true; local shine = Instance.new("Frame", progressFill); shine.Size = UDim2.new(0.3, 0, 1, 0); shine.Position = UDim2.new(-0.3, 0, 0, 0); shine.BackgroundColor3 = Theme.Shine; shine.BorderSizePixel = 0; shine.BackgroundTransparency = 0.8; local gradient = Instance.new("UIGradient", shine); gradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1)}); local shineTween = TweenService:Create(shine, TweenInfo.new(0.6, Enum.EasingStyle.Linear), {Position = UDim2.new(1, 0, 0, 0)}); shineTween:Play(); shineTween.Completed:Connect(function() shine:Destroy() end) end
            task.wait(stepDuration)
        end
        if pulseTween then pulseTween:Cancel() end; updateStatus("Launched!", Theme.Text); if not Config.ReducedMotion then local sB = TweenService:Create(progressFill, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(1.05, 0, 1, 0)}); sB:Play(); sB.Completed:Connect(function() TweenService:Create(progressFill, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 1, 0)}):Play() end) end; task.wait(1)
        local outroTween; if not Config.ReducedMotion then outroTween = TweenService:Create(container, TweenInfo.new(0.5), {BackgroundTransparency = 1}); outroTween:Play(); for _, child in ipairs(container:GetDescendants()) do if child:IsA("GuiObject") then local props = {}; if child:IsA("UIStroke") then props.Transparency = 1 else props.BackgroundTransparency = 1 end; if child:IsA("TextLabel") or child:IsA("TextButton") then props.TextTransparency = 1 end; TweenService:Create(child, TweenInfo.new(0.5), props):Play() end end end
        if outroTween then outroTween.Completed:Wait() end; screenGui:Destroy(); print(Config.HubName .. " has finished loading.")
    end
    local function showKeySystem()
        updateStatus("Awaiting verification...")
        local keyFrame = Instance.new("Frame", container); keyFrame.Size = UDim2.new(1, -60, 0, 100); keyFrame.Position = UDim2.new(0.5, 0, 0, 70); keyFrame.AnchorPoint = Vector2.new(0.5, 0); keyFrame.BackgroundTransparency = 1
        local keyInput = Instance.new("TextBox", keyFrame); keyInput.Size = UDim2.new(1, 0, 0, 35); keyInput.PlaceholderText = "Enter Key..."; keyInput.Font = Config.Fonts.Secondary; keyInput.TextColor3 = Theme.Text; keyInput.BackgroundColor3 = Theme.ProgressBackground; keyInput.TextSize = 16; Instance.new("UICorner", keyInput).CornerRadius = UDim.new(0, 6)
        local submitButton = Instance.new("TextButton", keyFrame); submitButton.Size = UDim2.new(0.65, -5, 0, 30); submitButton.Position = UDim2.new(0, 0, 0, 45); submitButton.Text = "Verify"; submitButton.Font = Config.Fonts.Main; submitButton.TextColor3 = Theme.Text; submitButton.BackgroundColor3 = Theme.Primary; submitButton.TextSize = 16; Instance.new("UICorner", submitButton).CornerRadius = UDim.new(0, 6)
        local getKeyButton = Instance.new("TextButton", keyFrame); getKeyButton.Size = UDim2.new(0.35, -5, 0, 30); getKeyButton.Position = UDim2.new(0.65, 5, 0, 45); getKeyButton.Text = "Get Key"; getKeyButton.Font = Config.Fonts.Secondary; getKeyButton.TextColor3 = Theme.MutedText; getKeyButton.BackgroundColor3 = Theme.ProgressBackground; getKeyButton.TextSize = 14; Instance.new("UICorner", getKeyButton).CornerRadius = UDim.new(0, 6)
        submitButton.MouseButton1Click:Connect(function() if not submitButton.Active then return end; local key = keyInput.Text; if key == "" then return end; submitButton.Active = false; submitButton.Text = "..."; updateStatus("Verifying key..."); local success, isValid = pcall(Config.KeySystem.CheckKeyFunction, key); if not success then updateStatus("Verification error.", Theme.Failure); submitButton.Text = "Verify"; submitButton.Active = true; return end; if isValid then updateStatus("Key accepted. Loading...", Theme.Primary); local glow = container:FindFirstChildOfClass("UIStroke"); if glow and not Config.ReducedMotion then TweenService:Create(glow, TweenInfo.new(0.5), {Transparency = 0.85}):Play() end; keyFrame:Destroy(); runLoadingSequence() else updateStatus("Invalid key. Please try again.", Theme.Failure); submitButton.Text = "Verify"; submitButton.Active = true; keyInput.Text = "" end end)
        getKeyButton.MouseButton1Click:Connect(function() if setclipboard then setclipboard(Config.KeySystem.GetKeyURL); getKeyButton.Text = "Copied!"; task.wait(2); getKeyButton.Text = "Get Key" else warn("Clipboard not available.") end end)
    end
    local glowPulseTween; if not Config.ReducedMotion then glowPulseTween = TweenService:Create(containerGlow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.6}); glowPulseTween:Play(); TweenService:Create(container, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = finalSize }):Play(); task.wait(0.4); TweenService:Create(title, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = finalTitlePosition, TextTransparency = 0}):Play() else container.Size = finalSize end
    if glowPulseTween and Config.KeySystem.Enabled then glowPulseTween:Pause() end
    if Config.KeySystem.Enabled then showKeySystem() else if glowPulseTween then glowPulseTween:Play() end; runLoadingSequence() end
end

--================================================================================--
--[[ INITIALIZATION ]]--
--================================================================================--
LoadThemes()
local ActiveTheme = Config.Themes[Config.ActiveTheme] or Config.Themes["Failsafe"] or next(Config.Themes)

if not ActiveTheme then
    warn("[SouljaLoader] CRITICAL: No theme could be selected. Halting execution.")
else
    -- [POLISH] Log active theme name for easier debugging.
    print(("[SouljaLoader] Initializing with theme: %s"):format(Config.ActiveTheme))
    startLoader(ActiveTheme)
end
