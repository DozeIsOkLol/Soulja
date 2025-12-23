-- /Core/Toggle.lua
return function(SouljaUI)
    return function()
        if SouljaUI.Properties.ScreenGui then
            SouljaUI.Properties.ScreenGui.Enabled = not SouljaUI.Properties.ScreenGui.Enabled
        end
    end
end
