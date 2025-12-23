-- Inside your LoaderManager.luau

-- ... (all the loading sequence code) ...

loaderWindow:AddLabel("Launching application...", "Info")
loaderWindow:SetProgress(1.0)
task.wait(1)

-- Fetch and run the main application
local mainAppSuccess, mainApp = pcall(fetchModule, "https://raw.githubusercontent.com/DozeIsOkLol/Soulja/refs/heads/main/ModernLoader/Main.luau")

if mainAppSuccess and mainApp then
    -- Hand control over to the main application
    mainApp:Init() -- Assuming your Main.luau has an Init function
    
    -- Now, close the loader UI
    loaderWindow:Close()
else
    loaderWindow:AddLabel("Failed to launch main app!", "Error")
    task.wait(2)
    loaderWindow:Close()
end

print("Loader has handed off control to the main application.")
