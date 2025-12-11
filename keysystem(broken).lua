local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()
local HttpService = game:GetService("HttpService")

-- Get key from raw GitHub
local key = HttpService:GetAsync("https://raw.githubusercontent.com/00tnz/tnzruho/refs/heads/main/key")
local CorrectKey = key:gsub("\n", "") -- clean newline so it matches correctly

local Window = Library:CreateWindow({
    Title = "Tnzruho Key System",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuSize = UDim2.fromOffset(300, 160)
})

local Tab = Window:AddTab("Login")
local Group = Tab:AddLeftGroupbox("Enter Key")

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
        print("put here loadstring")
    else
        Library:Notify("Invalid key.", 2)
    end
end)

ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToWindow(Window)
