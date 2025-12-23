-- Conceptual ConfigManager.luau
local Config = {}
local Binds = {}

function Config:Bind(element, key)
    -- Store a reference to the element and a key to save it under
    table.insert(Binds, { Element = element, Key = key })
end

function Config:Save(name)
    local settings = {}
    for _, bind in ipairs(Binds) do
        settings[bind.Key] = bind.Element:GetValue() -- Assumes elements have a GetValue() method
    end
    -- Use writefile() to save the 'settings' table as a JSON string
    writefile(name .. ".json", game:GetService("HttpService"):JSONEncode(settings))
end

-- Load function would do the reverse using readfile()
