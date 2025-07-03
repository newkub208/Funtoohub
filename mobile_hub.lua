local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("FUNTOO HUB", "DarkTheme")
local Tab = Window:NewTab("Player")
local Section = Tab:NewSection("Hack")

Section:NewTextBox("ตั้งค่าความเร็ว", "พิมพ์ความเร็วที่ต้องการ", function(txt)
	local speed = tonumber(txt)
	if speed then
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = speed
	else
		warn("⚠️ พิมพ์ตัวเลขเท่านั้น เช่น 50, 100")
	end
end)

local function setSpeedPopup()
	game.StarterGui:SetCore("SendNotification", {
		Title = "ตั้งค่าความเร็ว",
		Text = "พิมพ์ในแชท: speed 100",
		Duration = 5
	})
	local player = game.Players.LocalPlayer
	local connection
	connection = player.Chatted:Connect(function(msg)
		local speedStr = msg:match("^speed%s+(%d+)")
		if speedStr then
			local speed = tonumber(speedStr)
			local character = player.Character or player.CharacterAdded:Wait()
			local humanoid = character:WaitForChild("Humanoid")
			humanoid.WalkSpeed = speed
			game.StarterGui:SetCore("SendNotification", {
				Title = "✅ ตั้งค่าแล้ว",
				Text = "เดินเร็ว: " .. speed,
				Duration = 3
			})
			connection:Disconnect()
		end
	end)
end

local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

if UserInputService.TouchEnabled then
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "MiniButtonUI"
	screenGui.Parent = gui
	screenGui.ResetOnSpawn = false

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 60, 0, 60)
	button.Position = UDim2.new(1, -70, 1, -80)
	button.BackgroundColor3 = Color3.fromRGB(140, 0, 200)
	button.Text = "⚙️"
	button.TextSize = 28
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.GothamBold
	button.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = button

	local dragging = false
	local dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		button.Position = UDim2.new(
			0, math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - button.AbsoluteSize.X),
			0, math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - button.AbsoluteSize.Y)
		)
	end

	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = button.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	button.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then update(input) end
	end)

	button.MouseButton1Click:Connect(function()
		Library:ToggleUI()
		setSpeedPopup()
	end)
end
