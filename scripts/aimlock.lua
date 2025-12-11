--[WORKS VERY BAD!!!]--

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Configuration
local lockKey = Enum.KeyCode.C
local zoomFOV = 30        -- The Field of View when zoomed in
local defaultFOV = 70     -- Standard Field of View
local maxDistance = 200   -- How far away the lock can target (in studs)
local smoothFactor = 0.5  -- How fast the camera snaps (0 to 1)

-- State Variables
local isLocked = false
local targetPlayer = nil

-- Tween Info for smooth zooming
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

-- Function: Find the nearest player
local function getNearestPlayer()
	local closestPlayer = nil
	local shortestDistance = maxDistance
	local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	
	if not myRoot then return nil end

	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character then
			local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
			local otherHumanoid = otherPlayer.Character:FindFirstChild("Humanoid")
			
			-- Check if they are alive and have a root part
			if otherRoot and otherHumanoid and otherHumanoid.Health > 0 then
				local distance = (otherRoot.Position - myRoot.Position).Magnitude
				
				if distance < shortestDistance then
					closestPlayer = otherPlayer
					shortestDistance = distance
				end
			end
		end
	end
	
	return closestPlayer
end

-- Function: The Main Loop (Runs every frame)
RunService.RenderStepped:Connect(function()
	if isLocked and targetPlayer and targetPlayer.Character then
		local targetHead = targetPlayer.Character:FindFirstChild("Head")
		local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
		
		-- Check if target is still valid (alive and exists)
		if targetHead and myRoot then
			-- Vector math to calculate the new camera rotation
			local currentCamPos = camera.CFrame.Position
			local targetPos = targetHead.Position
			
			-- Create a new CFrame looking at the target
			local newLookCFrame = CFrame.lookAt(currentCamPos, targetPos)
			
			-- Smoothly interpolate (Lerp) the camera to face the target
			-- This keeps the aim locked to the center of your screen
			camera.CFrame = camera.CFrame:Lerp(newLookCFrame, smoothFactor)
		else
			-- If target dies or disappears, unlock automatically
			isLocked = false
			setZoom(false)
			targetPlayer = nil
		end
	end
end)

-- Function: Handle Input
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end -- Ignore if typing in chat
	
	if input.KeyCode == lockKey then
		if isLocked then
			-- Toggle Off
			isLocked = false
			targetPlayer = nil
			setZoom(false)
		else
			-- Toggle On
			local foundTarget = getNearestPlayer()
			if foundTarget then
				targetPlayer = foundTarget
				isLocked = true
				setZoom(true)
			end
		end
	end
end)
