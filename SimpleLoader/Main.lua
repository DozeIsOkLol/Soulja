--[[
    License:
    This project is open source and free to use. You are permitted to modify,
    reuse, and redistribute this script for any purpose. Credit is appreciated but
    not required. Authored by the SouljaWitchSrc community.
]]

--================================================================================--
--[[ SERVICES & ENVIRONMENT CHECK ]]--
--================================================================================--
-- [POLISH] Optional executor-only guard. Uncomment if this should only run in an exploit environment.
--[[
if not (syn or getexecutorname or identifyexecutor) then
    warn("SOUJA HUB: Executor environment not detected. Halting script.")
    return
end
]]
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

--================================================================================--
--[[ CONFIGURATION ]]--
--================================================================================--
local Config = {
    HubName = "SOULJA HUB", -- [FIXED] Corrected typo.
    LoadTime = 5,
    ReducedMotion = false,
    Messages = {"Connecting...", "Loading assets...", "Finalizing..."},
    Colors = {
        Primary = Color3.fromRGB(170, 70, 255),
        Background = Color3.fromRGB(20, 20, 30),
        Text = Color3.fromRGB(255, 255, 255),
        MutedText = Color3.fromRGB(120, 125, 135),
        ProgressBackground = Color3.fromRGB(30, 32, 38),
        Failure = Color3.fromRGB(200, 50, 50)
    },
    Fonts = {
        Main = Enum.Font.GothamBold,
        Secondary = Enum.Font.Gotham
    },

    KeySystem = {
        Enabled = false,
        GetKeyURL = "https://your-discord-link-here.com/get-key",
        CheckKeyFunction = function(key)
            local validKeys = {"SOUJA-HUB-ROCKS", "TEST-KEY-123"}
            task.wait(0.5) -- Simulate network delay
            for _, validKey in ipairs(validKeys) do
                if key == validKey then return true end
            end
            return false
        end
    }
}

--================================================================================--
--[[ MAIN LOADER LOGIC ]]--
--================================================================================--
local function startLoader()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    if playerGui:FindFirstChild("SouljaLoader") then playerGui.SouljaLoader:Destroy(); task.wait(0.1) end

    local screenGui = Instance.new("ScreenGui", playerGui); screenGui.Name = "SouljaLoader"; screenGui.ResetOnSpawn = false
    local container = Instance.new("Frame", screenGui); container.AnchorPoint = Vector2.new(0.5, 0.5); container.Position = UDim2.new(0.5, 0, 0.5, 0); local finalSize = UDim2.new(0, 380, 0, 220); container.Size = Config.ReducedMotion and finalSize or UDim2.new(0, 0, 0, 0); container.BackgroundColor3 = Config.Colors.Background; Instance.new("UICorner", container).CornerRadius = UDim.new(0, 12)
    local title = Instance.new("TextLabel", container); title.Size = UDim2.new(1, 0, 0, 50); title.Position = UDim2.new(0, 0, 0, 20); title.BackgroundTransparency = 1; title.Text = Config.HubName; title.Font = Config.Fonts.Main; title.TextColor3 = Config.Colors.Text; title.TextSize = 28
    local statusText = Instance.new("TextLabel", container); statusText.Size = UDim2.new(1, 0, 0, 30); statusText.Position = UDim2.new(0, 0, 0, 180); statusText.BackgroundTransparency = 1; statusText.Text = "Awaiting verification..."; statusText.Font = Config.Fonts.Secondary; statusText.TextColor3 = Config.Colors.MutedText; statusText.TextSize = 14
    
    local function runLoadingSequence()
        if #Config.Messages == 0 then Config.Messages = {"Loading..."} end

        local progressBg = Instance.new("Frame", container); progressBg.Size = UDim2.new(1, -60, 0, 8); progressBg.Position = UDim2.new(0.5, 0, 0, 150); progressBg.AnchorPoint = Vector2.new(0.5, 0); progressBg.BackgroundColor3 = Config.Colors.ProgressBackground; Instance.new("UICorner", progressBg).CornerRadius = UDim.new(0, 4)
        local progressFill = Instance.new("Frame", progressBg); progressFill.Size = UDim2.new(0, 0, 1, 0); progressFill.BackgroundColor3 = Config.Colors.Primary; Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 4)
        
        local pulseTween; if not Config.ReducedMotion then local pulseColor = Config.Colors.Primary:Lerp(Color3.new(1,1,1), 0.15); pulseTween = TweenService:Create(progressFill, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { BackgroundColor3 = pulseColor }); pulseTween:Play() end

        local stepDuration = Config.LoadTime / #Config.Messages
        local activeProgressTween
        for i, message in ipairs(Config.Messages) do
            statusText.Text = message
            -- [POLISH] Cancel previous tween to prevent overlap
            if activeProgressTween then activeProgressTween:Cancel() end
            activeProgressTween = TweenService:Create(progressFill, TweenInfo.new(stepDuration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { Size = UDim2.new(i / #Config.Messages, 0, 1, 0) })
            activeProgressTween:Play()
            task.wait(stepDuration)
        end
        
        if pulseTween then pulseTween:Cancel() end
        statusText.Text = "Launched!"
        task.wait(1)

        local outroTween; if not Config.ReducedMotion then outroTween = TweenService:Create(container, TweenInfo.new(0.5), {BackgroundTransparency = 1}); outroTween:Play(); for _, child in ipairs(container:GetDescendants()) do if child:IsA("GuiObject") then local props = { BackgroundTransparency = 1 }; if child:IsA("TextLabel") or child:IsA("TextButton") then props.TextTransparency = 1 end; TweenService:Create(child, TweenInfo.new(0.5), props):Play() end end end
        if outroTween then outroTween.Completed:Wait() end
        screenGui:Destroy()
        print(Config.HubName .. " has finished loading.")
    end

    local function showKeySystem()
        local keyFrame = Instance.new("Frame", container); keyFrame.Size = UDim2.new(1, -60, 0, 100); keyFrame.Position = UDim2.new(0.5, 0, 0, 70); keyFrame.AnchorPoint = Vector2.new(0.5, 0); keyFrame.BackgroundTransparency = 1
        local keyInput = Instance.new("TextBox", keyFrame); keyInput.Size = UDim2.new(1, 0, 0, 35); keyInput.PlaceholderText = "Enter Key..."; keyInput.Font = Config.Fonts.Secondary; keyInput.TextColor3 = Config.Colors.Text; keyInput.BackgroundColor3 = Config.Colors.ProgressBackground; keyInput.TextSize = 16; Instance.new("UICorner", keyInput).CornerRadius = UDim.new(0, 6)
        local submitButton = Instance.new("TextButton", keyFrame); submitButton.Size = UDim2.new(0.65, -5, 0, 30); submitButton.Position = UDim2.new(0, 0, 0, 45); submitButton.Text = "Verify"; submitButton.Font = Config.Fonts.Main; submitButton.TextColor3 = Config.Colors.Text; submitButton.BackgroundColor3 = Config.Colors.Primary; submitButton.TextSize = 16; Instance.new("UICorner", submitButton).CornerRadius = UDim.new(0, 6)
        local getKeyButton = Instance.new("TextButton", keyFrame); getKeyButton.Size = UDim2.new(0.35, -5, 0, 30); getKeyButton.Position = UDim2.new(0.65, 5, 0, 45); getKeyButton.Text = "Get Key"; getKeyButton.Font = Config.Fonts.Secondary; getKeyButton.TextColor3 = Config.Colors.MutedText; getKeyButton.BackgroundColor3 = Config.Colors.ProgressBackground; getKeyButton.TextSize = 14; Instance.new("UICorner", getKeyButton).CornerRadius = UDim.new(0, 6)

        submitButton.MouseButton1Click:Connect(function()
            local key = keyInput.Text; if key == "" then return end
            submitButton.Active = false; submitButton.Text = "..."
            statusText.Text = "Verifying key..."; statusText.TextColor3 = Config.Colors.MutedText
            local success, isValid = pcall(Config.KeySystem.CheckKeyFunction, key)
            if not success then statusText.Text = "Verification error. Please retry."; statusText.TextColor3 = Config.Colors.Failure; submitButton.Text = "Verify"; submitButton.Active = true; return end
            if isValid then statusText.Text = "Key accepted. Loading..."; statusText.TextColor3 = Config.Colors.Primary; keyFrame:Destroy(); runLoadingSequence()
            else statusText.Text = "Invalid key. Please try again."; statusText.TextColor3 = Config.Colors.Failure; submitButton.Text = "Verify"; submitButton.Active = true; keyInput.Text = "" end -- [POLISH] Clear input on failure.
        end)
        
        getKeyButton.MouseButton1Click:Connect(function() if setclipboard then setclipboard(Config.KeySystem.GetKeyURL); getKeyButton.Text = "Copied!"; task.wait(2); getKeyButton.Text = "Get Key" else warn("Clipboard not available.") end end)
    end
    
    if not Config.ReducedMotion then TweenService:Create(container, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = finalSize }):Play(); task.wait(0.6) end
    if Config.KeySystem.Enabled then showKeySystem() else statusText.Text = "Loading..."; runLoadingSequence() end
end

startLoader()
