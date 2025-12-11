-- Fly script with built-in movable GUI
-- Place this LocalScript in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local DEFAULT_SPEED = 50      -- base speed studs/sec
local BOOST_MULTIPLIER = 2.4  -- when Shift held
local SMOOTHNESS = 0.15       -- interpolation for velocity smoothing

-- Utility: create UI
local function createGui()
    -- avoid duplicates
    if playerGui:FindFirstChild("FlyGui") then
        return playerGui:FindFirstChild("FlyGui")
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FlyGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    -- Main window
    local frame = Instance.new("Frame")
    frame.Name = "Window"
    frame.Size = UDim2.new(0, 260, 0, 140)
    frame.Position = UDim2.new(0, 20, 0, 80)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    frame.Active = true

    -- Title bar (draggable)
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 28)
    titleBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 8, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Fly — Press E to toggle"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 14
    title.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 20)
    closeBtn.Position = UDim2.new(1, -34, 0, 4)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 14
    closeBtn.BackgroundColor3 = Color3.fromRGB(170,50,50)
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Parent = titleBar

    -- Body area
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, -28)
    content.Position = UDim2.new(0, 0, 0, 28)
    content.BackgroundTransparency = 1
    content.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "Toggle"
    toggleBtn.Size = UDim2.new(0, 116, 0, 36)
    toggleBtn.Position = UDim2.new(0, 12, 0, 8)
    toggleBtn.Text = "Enable Fly"
    toggleBtn.Font = Enum.Font.SourceSansBold
    toggleBtn.TextSize = 15
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    toggleBtn.Parent = content

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(0, 120, 0, 18)
    speedLabel.Position = UDim2.new(0, 12, 0, 54)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed: " .. tostring(DEFAULT_SPEED)
    speedLabel.TextColor3 = Color3.new(1,1,1)
    speedLabel.Font = Enum.Font.SourceSans
    speedLabel.TextSize = 14
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = content

    local decrease = Instance.new("TextButton")
    decrease.Name = "Decrease"
    decrease.Size = UDim2.new(0, 28, 0, 28)
    decrease.Position = UDim2.new(0, 12, 0, 76)
    decrease.Text = "-"
    decrease.Font = Enum.Font.SourceSansBold
    decrease.TextSize = 20
    decrease.BackgroundColor3 = Color3.fromRGB(80,80,80)
    decrease.TextColor3 = Color3.new(1,1,1)
    decrease.Parent = content

    local speedBox = Instance.new("TextBox")
    speedBox.Name = "SpeedBox"
    speedBox.Size = UDim2.new(0, 96, 0, 28)
    speedBox.Position = UDim2.new(0, 44, 0, 76)
    speedBox.Text = tostring(DEFAULT_SPEED)
    speedBox.Font = Enum.Font.SourceSans
    speedBox.TextSize = 16
    speedBox.ClearTextOnFocus = false
    speedBox.BackgroundColor3 = Color3.fromRGB(80,80,80)
    speedBox.TextColor3 = Color3.new(1,1,1)
    speedBox.Parent = content

    local increase = Instance.new("TextButton")
    increase.Name = "Increase"
    increase.Size = UDim2.new(0, 28, 0, 28)
    increase.Position = UDim2.new(0, 144, 0, 76)
    increase.Text = "+"
    increase.Font = Enum.Font.SourceSansBold
    increase.TextSize = 20
    increase.BackgroundColor3 = Color3.fromRGB(80,80,80)
    increase.TextColor3 = Color3.new(1,1,1)
    increase.Parent = content

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, -24, 0, 18)
    hint.Position = UDim2.new(0, 12, 1, -26)
    hint.BackgroundTransparency = 1
    hint.Text = "WASD Move • Space Up • LeftCtrl Down • Shift Boost"
    hint.TextColor3 = Color3.fromRGB(200,200,200)
    hint.Font = Enum.Font.SourceSans
    hint.TextSize = 12
    hint.TextXAlignment = Enum.TextXAlignment.Left
    hint.Parent = content

    return {
        gui = screenGui,
        frame = frame,
        titleBar = titleBar,
        closeBtn = closeBtn,
        toggleBtn = toggleBtn,
        speedLabel = speedLabel,
        decrease = decrease,
        increase = increase,
        speedBox = speedBox,
    }
end

-- Draggable behavior for titlebar
local function makeDraggable(frame, dragHandle)
    local dragging = false
    local dragStart = nil
    local startPos = nil

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            -- track movement in RunService
            RunService:BindToRenderStep("FlyGuiDrag_" .. tostring(frame:GetDebugId()), Enum.RenderPriority.Camera.Value + 1, function()
                if not dragging then
                    RunService:UnbindFromRenderStep("FlyGuiDrag_" .. tostring(frame:GetDebugId()))
                    return
                end
                local current = UserInputService:GetMouseLocation()
                local delta = current - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end)
        end
    end)
end

-- Main fly controller
local function flyController(guiRefs)
    local enabled = false
    local speed = DEFAULT_SPEED
    local keys = {w=false,a=false,s=false,d=false,space=false,ctrl=false,shift=false}
    local root, humanoid
    local bv, bg

    local function updateSpeedLabel()
        guiRefs.speedLabel.Text = "Speed: " .. tostring(math.floor(speed))
        guiRefs.speedBox.Text = tostring(math.floor(speed))
    end

    local function enableFly()
        local character = player.Character
        if not character then return end
        root = character:FindFirstChild("HumanoidRootPart")
        humanoid = character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end

        -- create BodyVelocity and BodyGyro
        bv = Instance.new("BodyVelocity")
        bv.Name = "FlyBodyVelocity"
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        bv.P = 9e4
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = root

        bg = Instance.new("BodyGyro")
        bg.Name = "FlyBodyGyro"
        bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
        bg.CFrame = root.CFrame
        bg.P = 9e4
        bg.Parent = root

        if humanoid then
            humanoid.PlatformStand = false
        end

        enabled = true
        guiRefs.toggleBtn.Text = "Disable Fly"
    end

    local function disableFly()
        enabled = false
        if bv and bv.Parent then bv:Destroy() end
        if bg and bg.Parent then bg:Destroy() end
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
        end
        guiRefs.toggleBtn.Text = "Enable Fly"
    end

    -- Input events
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local key = input.KeyCode
            if key == Enum.KeyCode.W then keys.w = true end
            if key == Enum.KeyCode.A then keys.a = true end
            if key == Enum.KeyCode.S then keys.s = true end
            if key == Enum.KeyCode.D then keys.d = true end
            if key == Enum.KeyCode.Space then keys.space = true end
            if key == Enum.KeyCode.LeftControl or key == Enum.KeyCode.RightControl then keys.ctrl = true end
            if key == Enum.KeyCode.LeftShift or key == Enum.KeyCode.RightShift then keys.shift = true end
            if key == Enum.KeyCode.E then
                if enabled then disableFly() else enableFly() end
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local key = input.KeyCode
            if key == Enum.KeyCode.W then keys.w = false end
            if key == Enum.KeyCode.A then keys.a = false end
            if key == Enum.KeyCode.S then keys.s = false end
            if key == Enum.KeyCode.D then keys.d = false end
            if key == Enum.KeyCode.Space then keys.space = false end
            if key == Enum.KeyCode.LeftControl or key == Enum.KeyCode.RightControl then keys.ctrl = false end
            if key == Enum.KeyCode.LeftShift or key == Enum.KeyCode.RightShift then keys.shift = false end
        end
    end)

    -- GUI interactions
    guiRefs.toggleBtn.MouseButton1Click:Connect(function()
        if enabled then disableFly() else enableFly() end
    end)

    guiRefs.closeBtn.MouseButton1Click:Connect(function()
        guiRefs.gui:Destroy()
    end)

    guiRefs.decrease.MouseButton1Click:Connect(function()
        speed = math.max(5, speed - 5)
        updateSpeedLabel()
    end)
    guiRefs.increase.MouseButton1Click:Connect(function()
        speed = speed + 5
        updateSpeedLabel()
    end)
    guiRefs.speedBox.FocusLost:Connect(function(enterPressed)
        local v = tonumber(guiRefs.speedBox.Text)
        if v and v >= 1 then
            speed = v
        else
            guiRefs.speedBox.Text = tostring(speed)
        end
        updateSpeedLabel()
    end)

    updateSpeedLabel()

    -- Heartbeat loop to set velocity
    local velocity = Vector3.new(0,0,0)
    local currentVel = Vector3.new(0,0,0)
    RunService.Heartbeat:Connect(function(dt)
        if not enabled then return end
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            disableFly()
            return
        end

        local char = player.Character
        root = char:FindFirstChild("HumanoidRootPart")
        humanoid = char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end

        -- camera relative movement
        local cam = workspace.CurrentCamera
        local camCFrame = cam and cam.CFrame or CFrame.new()
        local forward = camCFrame.LookVector
        local right = camCFrame.RightVector

        -- build movement vector
        local moveVec = Vector3.new(0,0,0)
        if keys.w then moveVec = moveVec + Vector3.new(forward.X, 0, forward.Z) end
        if keys.s then moveVec = moveVec - Vector3.new(forward.X, 0, forward.Z) end
        if keys.a then moveVec = moveVec - Vector3.new(right.X, 0, right.Z) end
        if keys.d then moveVec = moveVec + Vector3.new(right.X, 0, right.Z) end
        moveVec = moveVec.Unit ~= moveVec and moveVec or (moveVec.Magnitude > 0 and moveVec.Unit or Vector3.new(0,0,0))

        local vertical = 0
        if keys.space then vertical = 1 end
        if keys.ctrl then vertical = vertical - 1 end

        local effectiveSpeed = speed * (keys.shift and BOOST_MULTIPLIER or 1)
        velocity = (moveVec * effectiveSpeed) + Vector3.new(0, vertical * effectiveSpeed, 0)

        -- smooth
        currentVel = currentVel:Lerp(velocity, math.clamp(1 - math.exp(-SMOOTHNESS * 60 * dt), 0, 1))

        if bv and bv.Parent then
            bv.Velocity = currentVel
        end

        if bg and bg.Parent then
            bg.CFrame = CFrame.new(root.Position, root.Position + camCFrame.LookVector)
        end
    end)
end

-- Setup
local guiRefs = createGui()
makeDraggable(guiRefs.frame, guiRefs.titleBar)
flyController(guiRefs)

-- Friendly message in output (optional)
print("[FlyGui] Loaded. Press E to toggle fly.")
