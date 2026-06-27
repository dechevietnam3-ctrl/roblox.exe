local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- 1. Tạo GUI chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyMenuSystem"
ScreenGui.Parent = PlayerGui
ScreenGui.IgnoreGuiInset = true

-- 2. Chữ Intro
local WelcomeText = Instance.new("TextLabel", ScreenGui)
WelcomeText.Text = "roblox.exe"
WelcomeText.Size = UDim2.new(1, 0, 1, 0)
WelcomeText.BackgroundTransparency = 1
WelcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeText.TextSize = 50
WelcomeText.ZIndex = 10

-- 3. Menu Chính
local MenuFrame = Instance.new("Frame", ScreenGui)
MenuFrame.Size = UDim2.new(0, 370, 1, 0)
MenuFrame.Position = UDim2.new(1, 0, 0, 0)
MenuFrame.AnchorPoint = Vector2.new(0, 0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MenuFrame.BorderSizePixel = 0
MenuFrame.ZIndex = 5
MenuFrame.ClipsDescendants = true

local MenuCorner = Instance.new("UICorner", MenuFrame)
MenuCorner.CornerRadius = UDim.new(0, 15)

-- Bóng mờ
local MenuShadow = Instance.new("Frame", ScreenGui)
MenuShadow.Size = UDim2.new(1, 0, 1, 0)
MenuShadow.Position = UDim2.new(0, 0, 0, 0)
MenuShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MenuShadow.BackgroundTransparency = 1
MenuShadow.BorderSizePixel = 0
MenuShadow.ZIndex = 4
MenuShadow.Visible = false

-- Tiêu đề menu
local MenuTitle = Instance.new("TextLabel", MenuFrame)
MenuTitle.Text = "☰  MENU"
MenuTitle.Size = UDim2.new(1, 0, 0, 60)
MenuTitle.Position = UDim2.new(0, 0, 0, 0)
MenuTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
MenuTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
MenuTitle.TextSize = 22
MenuTitle.Font = Enum.Font.GothamBold
MenuTitle.BorderSizePixel = 0
MenuTitle.ZIndex = 6

local TitleCorner = Instance.new("UICorner", MenuTitle)
TitleCorner.CornerRadius = UDim.new(0, 15)

-- Nút đóng
local CloseBtn = Instance.new("TextButton", MenuFrame)
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 7

local CloseBtnCorner = Instance.new("UICorner", CloseBtn)
CloseBtnCorner.CornerRadius = UDim.new(1, 0)

-- ============================================================
-- SCROLLING CONTAINER cho toàn bộ nội dung menu
-- ============================================================
local ScrollFrame = Instance.new("ScrollingFrame", MenuFrame)
ScrollFrame.Size = UDim2.new(1, 0, 1, -60)
ScrollFrame.Position = UDim2.new(0, 0, 0, 60)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 180)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)   -- sẽ tự điều chỉnh
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.ZIndex = 6

local ContentList = Instance.new("UIListLayout", ScrollFrame)
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Padding = UDim.new(0, 4)

local ContentPad = Instance.new("UIPadding", ScrollFrame)
ContentPad.PaddingTop = UDim.new(0, 8)
ContentPad.PaddingLeft = UDim.new(0, 10)
ContentPad.PaddingRight = UDim.new(0, 10)
ContentPad.PaddingBottom = UDim.new(0, 16)

-- ============================================================
-- HOME PANEL - Hiển thị thông tin người chơi
-- ============================================================
local HomePanel = Instance.new("Frame", ScrollFrame)
HomePanel.Name = "HomePanel"
HomePanel.Size = UDim2.new(1, 0, 0, 260)
HomePanel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
HomePanel.BorderSizePixel = 0
HomePanel.ZIndex = 6
HomePanel.Visible = false
HomePanel.LayoutOrder = 2

local HomePanelCorner = Instance.new("UICorner", HomePanel)
HomePanelCorner.CornerRadius = UDim.new(0, 12)

-- Avatar người chơi
local AvatarImage = Instance.new("ImageLabel", HomePanel)
AvatarImage.Size = UDim2.new(0, 70, 0, 70)
AvatarImage.Position = UDim2.new(0, 10, 0, 10)
AvatarImage.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
AvatarImage.BorderSizePixel = 0
AvatarImage.ZIndex = 7
local userId = Player.UserId
AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150&format=png"

local AvatarCorner = Instance.new("UICorner", AvatarImage)
AvatarCorner.CornerRadius = UDim.new(1, 0)

local AvatarStroke = Instance.new("UIStroke", AvatarImage)
AvatarStroke.Color = Color3.fromRGB(100, 100, 200)
AvatarStroke.Thickness = 2

local NameLabel = Instance.new("TextLabel", HomePanel)
NameLabel.Text = Player.DisplayName
NameLabel.Size = UDim2.new(1, -100, 0, 28)
NameLabel.Position = UDim2.new(0, 90, 0, 12)
NameLabel.BackgroundTransparency = 1
NameLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
NameLabel.TextSize = 18
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.ZIndex = 7

local UsernameLabel = Instance.new("TextLabel", HomePanel)
UsernameLabel.Text = "@" .. Player.Name
UsernameLabel.Size = UDim2.new(1, -100, 0, 22)
UsernameLabel.Position = UDim2.new(0, 90, 0, 40)
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.TextColor3 = Color3.fromRGB(140, 140, 200)
UsernameLabel.TextSize = 13
UsernameLabel.Font = Enum.Font.Gotham
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
UsernameLabel.ZIndex = 7

local AccountAgeLabel = Instance.new("TextLabel", HomePanel)
AccountAgeLabel.Text = "🗓️  Tham gia: " .. Player.AccountAge .. " ngày trước"
AccountAgeLabel.Size = UDim2.new(1, -20, 0, 20)
AccountAgeLabel.Position = UDim2.new(0, 10, 0, 90)
AccountAgeLabel.BackgroundTransparency = 1
AccountAgeLabel.TextColor3 = Color3.fromRGB(170, 170, 220)
AccountAgeLabel.TextSize = 13
AccountAgeLabel.Font = Enum.Font.Gotham
AccountAgeLabel.TextXAlignment = Enum.TextXAlignment.Left
AccountAgeLabel.ZIndex = 7

local Divider = Instance.new("Frame", HomePanel)
Divider.Size = UDim2.new(1, -20, 0, 1)
Divider.Position = UDim2.new(0, 10, 0, 118)
Divider.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
Divider.BorderSizePixel = 0
Divider.ZIndex = 7

local function makeStatCard(parent, icon, label, value, xPos, yPos)
	local card = Instance.new("Frame", parent)
	card.Size = UDim2.new(0, 148, 0, 60)
	card.Position = UDim2.new(0, xPos, 0, yPos)
	card.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
	card.BorderSizePixel = 0
	card.ZIndex = 7

	local cardCorner = Instance.new("UICorner", card)
	cardCorner.CornerRadius = UDim.new(0, 8)

	local iconLbl = Instance.new("TextLabel", card)
	iconLbl.Text = icon
	iconLbl.Size = UDim2.new(0, 30, 1, 0)
	iconLbl.Position = UDim2.new(0, 5, 0, 0)
	iconLbl.BackgroundTransparency = 1
	iconLbl.TextSize = 20
	iconLbl.ZIndex = 8

	local labelLbl = Instance.new("TextLabel", card)
	labelLbl.Text = label
	labelLbl.Size = UDim2.new(1, -35, 0, 22)
	labelLbl.Position = UDim2.new(0, 35, 0, 5)
	labelLbl.BackgroundTransparency = 1
	labelLbl.TextColor3 = Color3.fromRGB(140, 140, 190)
	labelLbl.TextSize = 11
	labelLbl.Font = Enum.Font.Gotham
	labelLbl.TextXAlignment = Enum.TextXAlignment.Left
	labelLbl.ZIndex = 8

	local valueLbl = Instance.new("TextLabel", card)
	valueLbl.Text = value
	valueLbl.Size = UDim2.new(1, -35, 0, 28)
	valueLbl.Position = UDim2.new(0, 35, 0, 26)
	valueLbl.BackgroundTransparency = 1
	valueLbl.TextColor3 = Color3.fromRGB(220, 220, 255)
	valueLbl.TextSize = 15
	valueLbl.Font = Enum.Font.GothamBold
	valueLbl.TextXAlignment = Enum.TextXAlignment.Left
	valueLbl.ZIndex = 8

	return card, valueLbl
end

local character = Player.Character or Player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local _, healthVal = makeStatCard(HomePanel, "❤️", "Máu",    math.floor(humanoid.Health) .. " / " .. math.floor(humanoid.MaxHealth), 10, 128)
local _, walkVal   = makeStatCard(HomePanel, "🏃", "Tốc độ", math.floor(humanoid.WalkSpeed) .. " studs/s", 162, 128)

local teamName = "Không có"
if Player.Team then teamName = Player.Team.Name end
makeStatCard(HomePanel, "🏳️", "Team", teamName, 10, 196)

local _, pingVal = makeStatCard(HomePanel, "📶", "Ping", "...", 162, 196)

task.spawn(function()
	while true do
		task.wait(2)
		local ok, p = pcall(function() return math.floor(Player:GetNetworkPing() * 1000) end)
		if ok then pingVal.Text = p .. " ms" end
	end
end)

humanoid.HealthChanged:Connect(function(hp)
	healthVal.Text = math.floor(hp) .. " / " .. math.floor(humanoid.MaxHealth)
end)

-- ============================================================
-- HELPER: tạo tiêu đề section trong Settings
-- ============================================================
local function makeSectionTitle(parent, text, yPos)
	local lbl = Instance.new("TextLabel", parent)
	lbl.Text = text
	lbl.Size = UDim2.new(1, -20, 0, 24)
	lbl.Position = UDim2.new(0, 10, 0, yPos)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.fromRGB(120, 120, 200)
	lbl.TextSize = 11
	lbl.Font = Enum.Font.GothamBold
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 7
	return lbl
end

-- ============================================================
-- HELPER: tạo slider row (label + thanh kéo + giá trị)
-- ============================================================
local function makeSliderRow(parent, icon, label, minVal, maxVal, defaultVal, yPos, onChange)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, -20, 0, 50)
	row.Position = UDim2.new(0, 10, 0, yPos)
	row.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
	row.BorderSizePixel = 0
	row.ZIndex = 7

	local rowCorner = Instance.new("UICorner", row)
	rowCorner.CornerRadius = UDim.new(0, 8)

	local iconLbl = Instance.new("TextLabel", row)
	iconLbl.Text = icon
	iconLbl.Size = UDim2.new(0, 28, 0, 24)
	iconLbl.Position = UDim2.new(0, 8, 0, 4)
	iconLbl.BackgroundTransparency = 1
	iconLbl.TextSize = 16
	iconLbl.ZIndex = 8

	local nameLbl = Instance.new("TextLabel", row)
	nameLbl.Text = label
	nameLbl.Size = UDim2.new(0, 110, 0, 20)
	nameLbl.Position = UDim2.new(0, 36, 0, 4)
	nameLbl.BackgroundTransparency = 1
	nameLbl.TextColor3 = Color3.fromRGB(200, 200, 240)
	nameLbl.TextSize = 12
	nameLbl.Font = Enum.Font.Gotham
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	nameLbl.ZIndex = 8

	local valLbl = Instance.new("TextLabel", row)
	valLbl.Text = tostring(defaultVal)
	valLbl.Size = UDim2.new(0, 50, 0, 20)
	valLbl.Position = UDim2.new(1, -58, 0, 4)
	valLbl.BackgroundTransparency = 1
	valLbl.TextColor3 = Color3.fromRGB(140, 200, 255)
	valLbl.TextSize = 12
	valLbl.Font = Enum.Font.GothamBold
	valLbl.TextXAlignment = Enum.TextXAlignment.Right
	valLbl.ZIndex = 8

	-- Track (nền)
	local track = Instance.new("Frame", row)
	track.Size = UDim2.new(1, -20, 0, 6)
	track.Position = UDim2.new(0, 10, 0, 34)
	track.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
	track.BorderSizePixel = 0
	track.ZIndex = 8

	local trackCorner = Instance.new("UICorner", track)
	trackCorner.CornerRadius = UDim.new(1, 0)

	-- Fill (phần đã kéo)
	local fill = Instance.new("Frame", track)
	fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(80, 100, 220)
	fill.BorderSizePixel = 0
	fill.ZIndex = 9

	local fillCorner = Instance.new("UICorner", fill)
	fillCorner.CornerRadius = UDim.new(1, 0)

	-- Thumb (nút kéo)
	local thumb = Instance.new("TextButton", track)
	thumb.Size = UDim2.new(0, 16, 0, 16)
	thumb.AnchorPoint = Vector2.new(0.5, 0.5)
	thumb.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 0.5, 0)
	thumb.BackgroundColor3 = Color3.fromRGB(150, 160, 255)
	thumb.Text = ""
	thumb.BorderSizePixel = 0
	thumb.ZIndex = 10

	local thumbCorner = Instance.new("UICorner", thumb)
	thumbCorner.CornerRadius = UDim.new(1, 0)

	-- Drag logic
	local draggingSlider = false
	thumb.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = true
		end
	end)
	UserInputService.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = false
		end
	end)
	UserInputService.InputChanged:Connect(function(inp)
		if draggingSlider and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
			local absPos = track.AbsolutePosition.X
			local absSize = track.AbsoluteSize.X
			local relX = math.clamp((inp.Position.X - absPos) / absSize, 0, 1)
			local value = math.floor(minVal + relX * (maxVal - minVal))
			fill.Size = UDim2.new(relX, 0, 1, 0)
			thumb.Position = UDim2.new(relX, 0, 0.5, 0)
			valLbl.Text = tostring(value)
			if onChange then onChange(value) end
		end
	end)

	return row, valLbl
end

-- ============================================================
-- HELPER: tạo toggle switch row
-- ============================================================
local function makeToggleRow(parent, icon, label, defaultOn, yPos, onChange)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, -20, 0, 42)
	row.Position = UDim2.new(0, 10, 0, yPos)
	row.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
	row.BorderSizePixel = 0
	row.ZIndex = 7

	local rowCorner = Instance.new("UICorner", row)
	rowCorner.CornerRadius = UDim.new(0, 8)

	local iconLbl = Instance.new("TextLabel", row)
	iconLbl.Text = icon
	iconLbl.Size = UDim2.new(0, 28, 1, 0)
	iconLbl.Position = UDim2.new(0, 8, 0, 0)
	iconLbl.BackgroundTransparency = 1
	iconLbl.TextSize = 16
	iconLbl.ZIndex = 8

	local nameLbl = Instance.new("TextLabel", row)
	nameLbl.Text = label
	nameLbl.Size = UDim2.new(1, -90, 1, 0)
	nameLbl.Position = UDim2.new(0, 36, 0, 0)
	nameLbl.BackgroundTransparency = 1
	nameLbl.TextColor3 = Color3.fromRGB(200, 200, 240)
	nameLbl.TextSize = 12
	nameLbl.Font = Enum.Font.Gotham
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	nameLbl.ZIndex = 8

	-- Switch track
	local switchTrack = Instance.new("TextButton", row)
	switchTrack.Size = UDim2.new(0, 44, 0, 22)
	switchTrack.AnchorPoint = Vector2.new(1, 0.5)
	switchTrack.Position = UDim2.new(1, -10, 0.5, 0)
	switchTrack.BackgroundColor3 = defaultOn and Color3.fromRGB(60, 100, 220) or Color3.fromRGB(60, 60, 80)
	switchTrack.Text = ""
	switchTrack.BorderSizePixel = 0
	switchTrack.ZIndex = 8

	local switchCorner = Instance.new("UICorner", switchTrack)
	switchCorner.CornerRadius = UDim.new(1, 0)

	-- Thumb
	local switchThumb = Instance.new("Frame", switchTrack)
	switchThumb.Size = UDim2.new(0, 16, 0, 16)
	switchThumb.AnchorPoint = Vector2.new(0, 0.5)
	switchThumb.Position = defaultOn and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 4, 0.5, 0)
	switchThumb.BackgroundColor3 = Color3.new(1, 1, 1)
	switchThumb.BorderSizePixel = 0
	switchThumb.ZIndex = 9

	local thumbCorner = Instance.new("UICorner", switchThumb)
	thumbCorner.CornerRadius = UDim.new(1, 0)

	local isOn = defaultOn
	switchTrack.MouseButton1Click:Connect(function()
		isOn = not isOn
		TweenService:Create(switchTrack, TweenInfo.new(0.2), {
			BackgroundColor3 = isOn and Color3.fromRGB(60, 100, 220) or Color3.fromRGB(60, 60, 80)
		}):Play()
		TweenService:Create(switchThumb, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = isOn and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 4, 0.5, 0)
		}):Play()
		if onChange then onChange(isOn) end
	end)

	return row
end

-- ============================================================
-- SETTINGS PANEL
-- ============================================================
local SettingsPanel = Instance.new("Frame", ScrollFrame)
SettingsPanel.Name = "SettingsPanel"
SettingsPanel.Size = UDim2.new(1, 0, 0, 10)   -- sẽ tự set sau khi thêm items
SettingsPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 45)
SettingsPanel.BorderSizePixel = 0
SettingsPanel.ZIndex = 6
SettingsPanel.Visible = false
SettingsPanel.LayoutOrder = 4

local SettingsPanelCorner = Instance.new("UICorner", SettingsPanel)
SettingsPanelCorner.CornerRadius = UDim.new(0, 12)

-- Tính toán vị trí Y để đặt từng mục trong SettingsPanel
local settingsY = 10

-- === SECTION: ĐỒ HỌA ===
makeSectionTitle(SettingsPanel, "🎨  ĐỒ HỌA", settingsY)
settingsY = settingsY + 26

-- Chất lượng đồ họa (1-10)
-- Lấy giá trị hiện tại (1-10)
local currentQuality = 5
pcall(function()
	local qVal = UserSettings():GetService("UserGameSettings").SavedQualityLevel.Value
	currentQuality = math.clamp(qVal, 1, 10)
end)
makeSliderRow(SettingsPanel, "🖥️", "Chất lượng đồ họa", 1, 10, currentQuality, settingsY, function(v)
	-- Cách đúng: dùng settings:SetSavedQualityLevel
	local gs = UserSettings():GetService("UserGameSettings")
	local ok, err = pcall(function()
		gs.SavedQualityLevel = Enum.SavedQualitySetting["QualityLevel" .. tostring(v)]
	end)
	if not ok then
		-- fallback: set trực tiếp qua UserGameSettings nếu API trên không dùng được
		pcall(function() gs:SetSavedQualityLevel(v) end)
	end
end)
settingsY = settingsY + 56

-- Tầm nhìn xa - dùng Fog (FarPlaneZ read-only trong LocalScript)
makeSliderRow(SettingsPanel, "🌄", "Tầm nhìn xa (Fog)", 100, 2000, 1000, settingsY, function(v)
	Lighting.FogEnd = v
	Lighting.FogStart = v * 0.85
end)
settingsY = settingsY + 56

-- Brightness
makeSliderRow(SettingsPanel, "☀️", "Độ sáng", 0, 10, math.floor(Lighting.Brightness * 10), settingsY, function(v)
	Lighting.Brightness = v / 10 * 2
end)
settingsY = settingsY + 56

-- Blur (DepthOfField)
makeSliderRow(SettingsPanel, "🔵", "Hiệu ứng blur", 0, 20, 0, settingsY, function(v)
	local dof = Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
	if not dof then
		dof = Instance.new("DepthOfFieldEffect", Lighting)
	end
	dof.InFocusRadius = v == 0 and 999 or 20
	dof.FocusDistance = v == 0 and 999 or v * 10
	dof.Enabled = v > 0
end)
settingsY = settingsY + 56

-- Bóng đổ
makeToggleRow(SettingsPanel, "🌑", "Bóng đổ (Shadows)", true, settingsY, function(on)
	Lighting.GlobalShadows = on
end)
settingsY = settingsY + 48

-- Hiệu ứng ánh sáng
makeToggleRow(SettingsPanel, "✨", "Hiệu ứng ánh sáng", true, settingsY, function(on)
	for _, effect in ipairs(Lighting:GetChildren()) do
		if effect:IsA("BloomEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") then
			effect.Enabled = on
		end
	end
end)
settingsY = settingsY + 48

-- Divider
local divS1 = Instance.new("Frame", SettingsPanel)
divS1.Size = UDim2.new(1, -20, 0, 1)
divS1.Position = UDim2.new(0, 10, 0, settingsY)
divS1.BackgroundColor3 = Color3.fromRGB(50, 50, 90)
divS1.BorderSizePixel = 0
divS1.ZIndex = 7
settingsY = settingsY + 10

-- === SECTION: CAMERA ===
makeSectionTitle(SettingsPanel, "📷  CAMERA", settingsY)
settingsY = settingsY + 26

-- FOV
local camera = workspace.CurrentCamera
local defaultFOV = camera and camera.FieldOfView or 70
makeSliderRow(SettingsPanel, "🔭", "Góc nhìn (FOV)", 30, 120, defaultFOV, settingsY, function(v)
	if workspace.CurrentCamera then
		workspace.CurrentCamera.FieldOfView = v
	end
end)
settingsY = settingsY + 56

-- Camera Zoom tối đa
makeSliderRow(SettingsPanel, "🔎", "Zoom tối đa", 5, 100, 25, settingsY, function(v)
	Player.CameraMaxZoomDistance = v
end)
settingsY = settingsY + 56

-- Camera Zoom tối thiểu
makeSliderRow(SettingsPanel, "🔍", "Zoom tối thiểu", 0, 30, 0, settingsY, function(v)
	Player.CameraMinZoomDistance = v
end)
settingsY = settingsY + 56

-- Camera Sensitivity
makeSliderRow(SettingsPanel, "🖱️", "Độ nhạy chuột", 1, 20, 5, settingsY, function(v)
	UserSettings():GetService("UserGameSettings").MouseSensitivity = v / 10
end)
settingsY = settingsY + 56

-- Divider
local divS2 = Instance.new("Frame", SettingsPanel)
divS2.Size = UDim2.new(1, -20, 0, 1)
divS2.Position = UDim2.new(0, 10, 0, settingsY)
divS2.BackgroundColor3 = Color3.fromRGB(50, 50, 90)
divS2.BorderSizePixel = 0
divS2.ZIndex = 7
settingsY = settingsY + 10

-- === SECTION: NHÂN VẬT ===
makeSectionTitle(SettingsPanel, "🏃  NHÂN VẬT", settingsY)
settingsY = settingsY + 26

-- WalkSpeed
makeSliderRow(SettingsPanel, "⚡", "Tốc độ di chuyển", 8, 100, 16, settingsY, function(v)
	if humanoid then
		humanoid.WalkSpeed = v
		walkVal.Text = v .. " studs/s"
	end
end)
settingsY = settingsY + 56

-- Lực nhảy (phải bật UseJumpPower trước, Roblox mới dùng JumpHeight mặc định)
makeSliderRow(SettingsPanel, "🦘", "Lực nhảy", 20, 200, 50, settingsY, function(v)
	if humanoid then
		humanoid.UseJumpPower = true   -- bắt buộc phải bật, không thì JumpPower bị bỏ qua
		humanoid.JumpPower = v
	end
end)
settingsY = settingsY + 56

-- Divider
local divS3 = Instance.new("Frame", SettingsPanel)
divS3.Size = UDim2.new(1, -20, 0, 1)
divS3.Position = UDim2.new(0, 10, 0, settingsY)
divS3.BackgroundColor3 = Color3.fromRGB(50, 50, 90)
divS3.BorderSizePixel = 0
divS3.ZIndex = 7
settingsY = settingsY + 10

-- === SECTION: ÂM THANH ===
makeSectionTitle(SettingsPanel, "🔊  ÂM THANH", settingsY)
settingsY = settingsY + 26

-- Master volume
makeSliderRow(SettingsPanel, "🔊", "Âm lượng tổng", 0, 100, 100, settingsY, function(v)
	local soundService = game:GetService("SoundService")
	soundService.RespectFilteringEnabled = true
	soundService.AmbientReverb = Enum.ReverbType.NoReverb
	-- Volume không thể set trực tiếp qua SoundService trong LocalScript
	-- Nhưng có thể tắt/bật
end)
settingsY = settingsY + 56

-- Ambient sound toggle
makeToggleRow(SettingsPanel, "🎵", "Âm thanh môi trường", true, settingsY, function(on)
	for _, s in ipairs(workspace:GetDescendants()) do
		if s:IsA("Sound") then
			s.Volume = on and 1 or 0
		end
	end
end)
settingsY = settingsY + 48

-- Nút Reset về mặc định
local resetBtn = Instance.new("TextButton", SettingsPanel)
resetBtn.Text = "↺  Đặt lại mặc định"
resetBtn.Size = UDim2.new(1, -20, 0, 38)
resetBtn.Position = UDim2.new(0, 10, 0, settingsY + 8)
resetBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
resetBtn.TextColor3 = Color3.fromRGB(255, 180, 180)
resetBtn.TextSize = 13
resetBtn.Font = Enum.Font.GothamBold
resetBtn.BorderSizePixel = 0
resetBtn.ZIndex = 7

local resetBtnCorner = Instance.new("UICorner", resetBtn)
resetBtnCorner.CornerRadius = UDim.new(0, 8)

resetBtn.MouseEnter:Connect(function()
	TweenService:Create(resetBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(140, 50, 50) }):Play()
end)
resetBtn.MouseLeave:Connect(function()
	TweenService:Create(resetBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(80, 40, 40) }):Play()
end)
resetBtn.MouseButton1Click:Connect(function()
	if workspace.CurrentCamera then
		workspace.CurrentCamera.FieldOfView = 70
	end
	if humanoid then
		humanoid.WalkSpeed = 16
		humanoid.UseJumpPower = true
		humanoid.JumpPower = 50
	end
	Lighting.Brightness = 2
	Lighting.GlobalShadows = true
	Lighting.FogEnd = 100000
	Lighting.FogStart = 90000
	Player.CameraMaxZoomDistance = 25
	Player.CameraMinZoomDistance = 0
	resetBtn.Text = "✓  Đã đặt lại!"
	task.delay(1.5, function() resetBtn.Text = "↺  Đặt lại mặc định" end)
end)
settingsY = settingsY + 54

-- Cập nhật chiều cao panel
SettingsPanel.Size = UDim2.new(1, 0, 0, settingsY)

-- ============================================================
-- CÁC NÚT MENU
-- ============================================================
local buttonNames = {"🏠  Home", "⚙️  Settings", "👤  Profile", "📦  Inventory", "❓  Help"}
local menuButtons = {}

for i, name in ipairs(buttonNames) do
	local btn = Instance.new("TextButton", ScrollFrame)
	btn.Text = name
	btn.Size = UDim2.new(1, 0, 0, 46)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	btn.TextColor3 = Color3.fromRGB(220, 220, 255)
	btn.TextSize = 15
	btn.Font = Enum.Font.Gotham
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.BorderSizePixel = 0
	btn.ZIndex = 6
	btn.LayoutOrder = i * 2 - 1   -- lẻ để panel chèn vào giữa

	local btnPad = Instance.new("UIPadding", btn)
	btnPad.PaddingLeft = UDim.new(0, 12)

	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 10)

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(70, 70, 120) }):Play()
	end)
	btn.MouseLeave:Connect(function()
		if btn.BackgroundColor3 ~= Color3.fromRGB(60, 60, 120) then
			TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(40, 40, 60) }):Play()
		end
	end)

	menuButtons[name] = btn
end

-- Gán LayoutOrder cho HomePanel và SettingsPanel
HomePanel.LayoutOrder = 2       -- sau nút Home (LayoutOrder=1)
SettingsPanel.LayoutOrder = 4   -- sau nút Settings (LayoutOrder=3)

-- Kết nối click Home
local homePanelShown = false
menuButtons["🏠  Home"].LayoutOrder = 1
menuButtons["🏠  Home"].MouseButton1Click:Connect(function()
	homePanelShown = not homePanelShown
	HomePanel.Visible = homePanelShown
	menuButtons["🏠  Home"].BackgroundColor3 = homePanelShown
		and Color3.fromRGB(60, 60, 120)
		or Color3.fromRGB(40, 40, 60)
end)

-- Kết nối click Settings
local settingsPanelShown = false
menuButtons["⚙️  Settings"].LayoutOrder = 3
menuButtons["⚙️  Settings"].MouseButton1Click:Connect(function()
	settingsPanelShown = not settingsPanelShown
	SettingsPanel.Visible = settingsPanelShown
	menuButtons["⚙️  Settings"].BackgroundColor3 = settingsPanelShown
		and Color3.fromRGB(60, 60, 120)
		or Color3.fromRGB(40, 40, 60)
end)

-- Gán LayoutOrder còn lại
menuButtons["👤  Profile"].LayoutOrder = 5
menuButtons["📦  Inventory"].LayoutOrder = 7
menuButtons["❓  Help"].LayoutOrder = 9

-- 4. Nút Toggle
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(1, -70, 0, 20)
ToggleButton.Text = "R"
ToggleButton.TextSize = 25
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
ToggleButton.Visible = false
ToggleButton.BorderSizePixel = 0
ToggleButton.ZIndex = 8

local ButtonCorner = Instance.new("UICorner", ToggleButton)
ButtonCorner.CornerRadius = UDim.new(1, 0)

-- 5. Nút trái
local LeftButton = Instance.new("TextButton", ScreenGui)
LeftButton.Size = UDim2.new(0, 50, 0, 50)
LeftButton.Position = UDim2.new(0, 20, 0, 20)
LeftButton.Text = "☰"
LeftButton.TextSize = 22
LeftButton.Font = Enum.Font.GothamBold
LeftButton.TextColor3 = Color3.new(1, 1, 1)
LeftButton.BackgroundColor3 = Color3.fromRGB(50, 80, 50)
LeftButton.Visible = false
LeftButton.BorderSizePixel = 0
LeftButton.ZIndex = 8

local LeftButtonCorner = Instance.new("UICorner", LeftButton)
LeftButtonCorner.CornerRadius = UDim.new(1, 0)

-- Drag Toggle Button
local dragging = false
local dragStart = nil
local startPos = nil

ToggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = ToggleButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		ToggleButton.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

-- Hàm mở/đóng menu
local menuOpen = false

local function openMenu()
	menuOpen = true
	MenuShadow.Visible = true
	TweenService:Create(MenuFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -370, 0, 0)
	}):Play()
	TweenService:Create(MenuShadow, TweenInfo.new(0.4), { BackgroundTransparency = 0.5 }):Play()
end

local function closeMenu()
	menuOpen = false
	local tween = TweenService:Create(MenuFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
		Position = UDim2.new(1, 0, 0, 0)
	})
	tween:Play()
	TweenService:Create(MenuShadow, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()
	tween.Completed:Connect(function() MenuShadow.Visible = false end)
end

LeftButton.MouseButton1Click:Connect(function()
	if not menuOpen then openMenu() end
end)
ToggleButton.MouseButton1Click:Connect(function()
	if menuOpen then closeMenu() else openMenu() end
end)
CloseBtn.MouseButton1Click:Connect(function() closeMenu() end)
MenuShadow.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		closeMenu()
	end
end)

-- Intro
task.spawn(function()
	task.wait(2)
	local tween = TweenService:Create(WelcomeText, TweenInfo.new(1), { TextTransparency = 1 })
	tween:Play()
	tween.Completed:Wait()
	WelcomeText:Destroy()
	ToggleButton.Visible = true
	LeftButton.Visible = true
end)
