-- LocalScript placed inside StarterGui or StarterPlayerScripts
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoid = newChar:WaitForChild("Humanoid")
end)

-- State Variables
local speedActive = false
local jumpActive = false
local infJumpActive = false
local noclipActive = false

local NORMAL_SPEED = 16
local CHEAT_SPEED = 60
local NORMAL_JUMP = 50
local CHEAT_JUMP = 120

-- Create ScreenGui programmatically
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CheatMenuGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 320)
MainFrame.Position = UDim2.new(0.5, -125, 0.4, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Allows moving the menu around
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

-- Corner styling for Main Frame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Title Bar
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Title.BorderSizePixel = 0
Title.Text = "DEV / CHEAT MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Container for buttons
local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = Container

-- Helper function to generate standardized toggle buttons
local function createToggleButton(name, text, layoutOrder)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(1, 0, 0, 45)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
	button.BorderSizePixel = 0
	button.Text = text .. " [OFF]"
	button.TextColor3 = Color3.fromRGB(200, 200, 200)
	button.Font = Enum.Font.SourceSansSemibold
	button.TextSize = 16
	button.LayoutOrder = layoutOrder
	button.Parent = Container

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 6)
	buttonCorner.Parent = button

	return button
end

-- Create individual buttons
local SpeedBtn = createToggleButton("SpeedBtn", "Speed Hack (60)", 1)
local JumpBtn = createToggleButton("JumpBtn", "Super Jump (120)", 2)
local InfJumpBtn = createToggleButton("InfJumpBtn", "Infinite Jump", 3)
local NoclipBtn = createToggleButton("NoclipBtn", "Noclip", 4)

-- Helper to update button visual state
local function updateButtonState(button, active, text)
	if active then
		button.BackgroundColor3 = Color3.fromRGB(46, 117, 89) -- Green
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.Text = text .. " [ON]"
	else
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 55) -- Dark grey
		button.TextColor3 = Color3.fromRGB(200, 200, 200)
		button.Text = text .. " [OFF]"
	end
end

-- Speed Hack Logic
SpeedBtn.MouseButton1Click:Connect(function()
	speedActive = not speedActive
	updateButtonState(SpeedBtn, speedActive, "Speed Hack (60)")
end)

-- Super Jump Logic
JumpBtn.MouseButton1Click:Connect(function()
	jumpActive = not jumpActive
	updateButtonState(JumpBtn, jumpActive, "Super Jump (120)")
end)

-- Infinite Jump Logic
InfJumpBtn.MouseButton1Click:Connect(function()
	infJumpActive = not infJumpActive
	updateButtonState(InfJumpBtn, infJumpActive, "Infinite Jump")
end)

UserInputService.JumpRequest:Connect(function()
	if infJumpActive and humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- Noclip Logic
NoclipBtn.MouseButton1Click:Connect(function()
	noclipActive = not noclipActive
	updateButtonState(NoclipBtn, noclipActive, "Noclip")
end)

-- RunService loop to handle frame-by-frame updates (Noclip, Speed, and Jump updates)
RunService.Stepped:Connect(function()
	if character and humanoid then
		-- Apply Speed
		if speedActive then
			humanoid.WalkSpeed = CHEAT_SPEED
		else
			humanoid.WalkSpeed = NORMAL_SPEED
		end

		-- Apply Jump Power
		if jumpActive then
			humanoid.UseJumpPower = true
			humanoid.JumpPower = CHEAT_JUMP
		else
			humanoid.JumpPower = NORMAL_JUMP
		end

		-- Apply Noclip
		if noclipActive then
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide == true then
					part.CanCollide = false
				end
			end
		end
	end
end)

-- Hide / Show Menu with Right Shift Keybind
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.RightShift then
		MainFrame.Visible = not MainFrame.Visible
	end
end)