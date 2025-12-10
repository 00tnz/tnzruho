local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()

local Window = Library:CreateWindow({
    Title = "Key System",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuSize = UDim2.fromOffset(300, 160)
})

local Tab = Window:AddTab("Login")
local Group = Tab:AddLeftGroupbox("Enter Key")

local CorrectKey = "WeAreCharliKirk"
local InputKey = ""

Group:AddInput("KeyBox", {
    Text = "Key",
    Finished = true,
    Placeholder = "Enter key...",
    Callback = function(v)
        InputKey = v
    end
})

Group:AddButton("Submit", function()
    if InputKey == CorrectKey then
        Library:Notify("Correct key.", 2)
        -- your safe script here
        print("put here loadstring")
    else
        Library:Notify("Invalid key.", 2)
    end
end)

ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToWindow(Window)
