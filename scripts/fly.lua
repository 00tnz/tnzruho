local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- Configuration
local flySpeed = 50
local isFlying = false
local bodyGyro, bodyVelocity

-- Function to handle flying movement
local function updateFlyPhysics()
	if not isFlying or not bodyVelocity or not bodyGyro then return end
	
	-- Make the character look where the camera is looking
	bodyGyro.CFrame = camera.CFrame
	
	-- Calculate movement direction based on camera and keys pressed
	local moveDir = Vector3.new()
	local lookVector = camera.CFrame.LookVector
	local rightVector = camera.CFrame.RightVector
	
	-- Check for WASD controls (or arrow keys)
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then
		moveDir = moveDir + lookVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
		moveDir = moveDir - lookVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then
		moveDir = moveDir + rightVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then
		moveDir = moveDir - rightVector
	end
	
	-- Apply the velocity
	bodyVelocity.Velocity = moveDir * flySpeed
end

-- Function to start flying
local function startFlying()
	if isFlying then return end
	isFlying = true
	
	-- Change humanoid state so physics don't fight us
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	
	-- Create BodyGyro to keep character upright and facing camera
	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
	bodyGyro.P = 3000
	bodyGyro.CFrame = rootPart.CFrame
	bodyGyro.Parent = rootPart
	
	-- Create BodyVelocity to move character and defy gravity
	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000) -- Infinite force to override gravity
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = rootPart
	
	-- Connect the movement loop
	RunService.RenderStepped:Connect(updateFlyPhysics)
end

-- Function to stop flying
local function stopFlying()
	if not isFlying then return end
	isFlying = false
	
	-- Return to normal gravity state
	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
end

-- Toggle flying when F is pressed
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end -- Don't run if typing in chat
	
	if input.KeyCode == Enum.KeyCode.F then
		if isFlying then
			stopFlying()
		else
			startFlying()
		end
	end
end)

-- Safety: Reset if character respawns
player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoid = newChar:WaitForChild("Humanoid")
	rootPart = newChar:WaitForChild("HumanoidRootPart")
	isFlying = false
end)
