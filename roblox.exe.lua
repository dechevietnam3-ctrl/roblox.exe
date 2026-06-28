-- ╔══════════════════════════════════════════════╗
-- ║        NOVA UI  —  Modern Roblox Menu        ║
-- ║         Thiết kế lại hoàn toàn 2025          ║
-- ╚══════════════════════════════════════════════╝

local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local Lighting          = game:GetService("Lighting")

local Player    = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ══════════════════════════════════════════
-- THEME
-- ══════════════════════════════════════════
local T = {
	BG          = Color3.fromRGB(12, 12, 18),
	SURFACE     = Color3.fromRGB(20, 20, 30),
	SURFACE2    = Color3.fromRGB(28, 28, 42),
	ACCENT      = Color3.fromRGB(99, 102, 241),   -- indigo
	ACCENT2     = Color3.fromRGB(139, 92, 246),   -- violet
	SUCCESS     = Color3.fromRGB(34, 197, 94),
	WARN        = Color3.fromRGB(251, 191, 36),
	DANGER      = Color3.fromRGB(239, 68, 68),
	TEXT        = Color3.fromRGB(240, 240, 255),
	TEXT2       = Color3.fromRGB(150, 150, 185),
	TEXT3       = Color3.fromRGB(80, 80, 110),
	BORDER      = Color3.fromRGB(40, 40, 60),
	WHITE       = Color3.new(1, 1, 1),
}

local EZ = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local EZ_SLOW = TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- ══════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ══════════════════════════════════════════
local function tween(obj, props, info)
	TweenService:Create(obj, info or EZ, props):Play()
end

local function corner(parent, radius)
	local c = Instance.new("UICorner", parent)
	c.CornerRadius = UDim.new(0, radius or 10)
	return c
end

local function stroke(parent, color, thickness)
	local s = Instance.new("UIStroke", parent)
	s.Color = color or T.BORDER
	s.Thickness = thickness or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	return s
end

local function newFrame(parent, props)
	local f = Instance.new("Frame", parent)
	f.BackgroundTransparency = props.BT or 0
	f.BackgroundColor3 = props.BG or T.SURFACE
	f.Size = props.Size or UDim2.new(1, 0, 0, 40)
	f.Position = props.Position or UDim2.new(0, 0, 0, 0)
	f.BorderSizePixel = 0
	f.ZIndex = props.ZIndex or 5
	if props.ClipsDescendants then f.ClipsDescendants = true end
	if props.Name then f.Name = props.Name end
	return f
end

local function newLabel(parent, props)
	local l = Instance.new("TextLabel", parent)
	l.BackgroundTransparency = 1
	l.Text = props.Text or ""
	l.TextColor3 = props.Color or T.TEXT
	l.TextSize = props.Size or 14
	l.Font = props.Font or Enum.Font.Gotham
	l.Size = props.Sz or UDim2.new(1, 0, 1, 0)
	l.Position = props.Position or UDim2.new(0, 0, 0, 0)
	l.TextXAlignment = props.AlignX or Enum.TextXAlignment.Left
	l.TextYAlignment = props.AlignY or Enum.TextYAlignment.Center
	l.ZIndex = props.ZIndex or 6
	l.TextTruncate = props.Truncate and Enum.TextTruncate.AtEnd or Enum.TextTruncate.None
	if props.Wrapped then l.TextWrapped = true end
	return l
end

-- ══════════════════════════════════════════
-- ROOT GUI
-- ══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NovaUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- ══════════════════════════════════════════
-- SPLASH / INTRO
-- ══════════════════════════════════════════
local Splash = newFrame(ScreenGui, {
	BG = T.BG,
	Size = UDim2.new(1, 0, 1, 0),
	ZIndex = 20,
})

local SplashLogo = newLabel(Splash, {
	Text = "NOVA",
	Color = T.TEXT,
	Size = 52,
	Font = Enum.Font.GothamBold,
	Sz = UDim2.new(0, 300, 0, 70),
	Position = UDim2.new(0.5, -150, 0.5, -60),
	AlignX = Enum.TextXAlignment.Center,
	ZIndex = 21,
})

local SplashSub = newLabel(Splash, {
	Text = "Interface v1.0",
	Color = T.TEXT3,
	Size = 13,
	Sz = UDim2.new(0, 300, 0, 24),
	Position = UDim2.new(0.5, -150, 0.5, -10),
	AlignX = Enum.TextXAlignment.Center,
	ZIndex = 21,
})

-- Gradient bar
local SplashBar = newFrame(Splash, {
	BG = T.ACCENT,
	Size = UDim2.new(0, 0, 0, 2),
	Position = UDim2.new(0.5, -100, 0.5, 22),
	ZIndex = 21,
})
corner(SplashBar, 2)

-- ══════════════════════════════════════════
-- MAIN PANEL (bên phải, slide in từ phải)
-- ══════════════════════════════════════════
local PANEL_W = 340

local Panel = newFrame(ScreenGui, {
	BG = T.BG,
	Size = UDim2.new(0, PANEL_W, 1, 0),
	Position = UDim2.new(1, 0, 0, 0),   -- ẩn sang phải
	ZIndex = 10,
	ClipsDescendants = true,
	Name = "NovaPanel",
})
stroke(Panel, T.BORDER, 1)

-- Viền bên trái sáng
local PanelAccentLine = newFrame(Panel, {
	BG = T.ACCENT,
	Size = UDim2.new(0, 2, 1, 0),
	Position = UDim2.new(0, 0, 0, 0),
	ZIndex = 11,
})

-- ──────── HEADER ────────
local Header = newFrame(Panel, {
	BG = T.SURFACE,
	Size = UDim2.new(1, 0, 0, 64),
	ZIndex = 11,
})
stroke(Header, T.BORDER, 1)

-- Logo chữ
local HeaderLogo = newLabel(Header, {
	Text = "NOVA",
	Color = T.WHITE,
	Size = 18,
	Font = Enum.Font.GothamBold,
	Sz = UDim2.new(0, 80, 1, 0),
	Position = UDim2.new(0, 16, 0, 0),
	ZIndex = 12,
})

-- Dấu chấm accent
local HeaderDot = newFrame(Header, {
	BG = T.ACCENT,
	Size = UDim2.new(0, 6, 0, 6),
	Position = UDim2.new(0, 56, 0.5, -3),
	ZIndex = 12,
})
corner(HeaderDot, 4)

local HeaderSub = newLabel(Header, {
	Text = "UI System",
	Color = T.TEXT3,
	Size = 10,
	Sz = UDim2.new(0, 80, 0, 14),
	Position = UDim2.new(0, 16, 0.5, 6),
	ZIndex = 12,
})

-- Nút đóng
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -46, 0.5, -16)
CloseBtn.Text = "✕"
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = T.TEXT3
CloseBtn.BackgroundColor3 = T.SURFACE2
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 12
corner(CloseBtn, 8)

CloseBtn.MouseEnter:Connect(function()
	tween(CloseBtn, { BackgroundColor3 = T.DANGER, TextColor3 = T.WHITE })
end)
CloseBtn.MouseLeave:Connect(function()
	tween(CloseBtn, { BackgroundColor3 = T.SURFACE2, TextColor3 = T.TEXT3 })
end)

-- ──────── NAV TABS (icon + text, dọc) ────────
local NavBar = newFrame(Panel, {
	BG = T.SURFACE,
	Size = UDim2.new(0, 58, 1, -64),
	Position = UDim2.new(0, 0, 0, 64),
	ZIndex = 11,
})
stroke(NavBar, T.BORDER, 1)

local NavList = Instance.new("UIListLayout", NavBar)
NavList.SortOrder = Enum.SortOrder.LayoutOrder
NavList.Padding = UDim.new(0, 2)
NavList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local navPad = Instance.new("UIPadding", NavBar)
navPad.PaddingTop = UDim.new(0, 10)

-- ──────── CONTENT AREA ────────
local ContentArea = newFrame(Panel, {
	BG = Color3.fromRGB(0,0,0),
	BT = 1,
	Size = UDim2.new(1, -58, 1, -64),
	Position = UDim2.new(0, 58, 0, 64),
	ZIndex = 10,
})

-- ══════════════════════════════════════════
-- NAV BUTTON FACTORY
-- ══════════════════════════════════════════
local navButtons = {}
local pages = {}
local currentPage = nil

-- pageCallbacks: hook thêm logic khi switch trang (dùng cho Events auto-scan)
local pageCallbacks = {}

local function switchPage(name)
	if currentPage == name then return end
	currentPage = name
	for n, page in pairs(pages) do
		page.Visible = (n == name)
	end
	for n, btn in pairs(navButtons) do
		if n == name then
			tween(btn.bg, { BackgroundColor3 = T.ACCENT })
			tween(btn.icon, { TextColor3 = T.WHITE })
			tween(btn.lbl, { TextTransparency = 0 })
		else
			tween(btn.bg, { BackgroundColor3 = T.SURFACE })
			tween(btn.icon, { TextColor3 = T.TEXT3 })
			tween(btn.lbl, { TextTransparency = 1 })
		end
	end
	-- Gọi callback nếu có
	if pageCallbacks[name] then pageCallbacks[name]() end
end

local navDefs = {
	{ name = "Home",     icon = "⌂",  order = 1 },
	{ name = "Players",  icon = "◉",  order = 2 },
	{ name = "Events",   icon = "★",  order = 3 },
	{ name = "Settings", icon = "⚙",  order = 4 },
	{ name = "Display",  icon = "◫",  order = 5 },
}

for _, def in ipairs(navDefs) do
	local wrap = Instance.new("TextButton", NavBar)
	wrap.Size = UDim2.new(0, 42, 0, 52)
	wrap.BackgroundTransparency = 1
	wrap.Text = ""
	wrap.BorderSizePixel = 0
	wrap.ZIndex = 12
	wrap.LayoutOrder = def.order

	local bg = newFrame(wrap, {
		BG = T.SURFACE,
		Size = UDim2.new(0, 36, 0, 42),
		Position = UDim2.new(0.5, -18, 0, 4),
		ZIndex = 12,
	})
	corner(bg, 10)

	local iconLbl = newLabel(bg, {
		Text = def.icon,
		Color = T.TEXT3,
		Size = 18,
		AlignX = Enum.TextXAlignment.Center,
		Sz = UDim2.new(1, 0, 0, 28),
		Position = UDim2.new(0, 0, 0, 4),
		ZIndex = 13,
	})

	local lbl = newLabel(bg, {
		Text = def.name,
		Color = T.WHITE,
		Size = 7,
		AlignX = Enum.TextXAlignment.Center,
		Sz = UDim2.new(1, 0, 0, 12),
		Position = UDim2.new(0, 0, 1, -13),
		ZIndex = 13,
	})
	lbl.TextTransparency = 1

	navButtons[def.name] = { bg = bg, icon = iconLbl, lbl = lbl }

	wrap.MouseButton1Click:Connect(function() switchPage(def.name) end)
	wrap.MouseEnter:Connect(function()
		if currentPage ~= def.name then
			tween(bg, { BackgroundColor3 = T.SURFACE2 })
		end
	end)
	wrap.MouseLeave:Connect(function()
		if currentPage ~= def.name then
			tween(bg, { BackgroundColor3 = T.SURFACE })
		end
	end)
end

-- ══════════════════════════════════════════
-- PAGE FACTORY
-- ══════════════════════════════════════════
local function makePage(name)
	local scroll = Instance.new("ScrollingFrame", ContentArea)
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 3
	scroll.ScrollBarImageColor3 = T.ACCENT
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.ZIndex = 11
	scroll.Visible = false

	local list = Instance.new("UIListLayout", scroll)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, 6)

	local pad = Instance.new("UIPadding", scroll)
	pad.PaddingTop    = UDim.new(0, 12)
	pad.PaddingBottom = UDim.new(0, 12)
	pad.PaddingLeft   = UDim.new(0, 10)
	pad.PaddingRight  = UDim.new(0, 10)

	pages[name] = scroll
	return scroll, list
end

-- ══════════════════════════════════════════
-- CARD COMPONENTS
-- ══════════════════════════════════════════
local function makeCard(parent, height, order)
	local card = newFrame(parent, {
		BG = T.SURFACE,
		Size = UDim2.new(1, 0, 0, height),
		ZIndex = 12,
	})
	corner(card, 12)
	stroke(card, T.BORDER, 1)
	if order then card.LayoutOrder = order end
	return card
end

local function makeSectionLabel(parent, text, order)
	local lbl = newLabel(parent, {
		Text = string.upper(text),
		Color = T.TEXT3,
		Size = 9,
		Font = Enum.Font.GothamBold,
		Sz = UDim2.new(1, 0, 0, 20),
		ZIndex = 12,
	})
	lbl.LayoutOrder = order or 0
	local pad = Instance.new("UIPadding", lbl)
	pad.PaddingLeft = UDim.new(0, 4)
	return lbl
end

-- ══════════════════════════════════════════
-- TOGGLE COMPONENT
-- ══════════════════════════════════════════
local function makeToggle(parent, labelText, default, onChange, order)
	local row = newFrame(parent, {
		BG = T.SURFACE,
		Size = UDim2.new(1, 0, 0, 44),
		ZIndex = 12,
	})
	corner(row, 10)
	stroke(row, T.BORDER, 1)
	row.LayoutOrder = order or 0

	newLabel(row, {
		Text = labelText,
		Color = T.TEXT,
		Size = 13,
		Sz = UDim2.new(1, -72, 1, 0),
		Position = UDim2.new(0, 14, 0, 0),
		ZIndex = 13,
	})

	local track = Instance.new("TextButton", row)
	track.Size = UDim2.new(0, 40, 0, 20)
	track.AnchorPoint = Vector2.new(1, 0.5)
	track.Position = UDim2.new(1, -12, 0.5, 0)
	track.BackgroundColor3 = default and T.ACCENT or T.SURFACE2
	track.Text = ""
	track.BorderSizePixel = 0
	track.ZIndex = 13
	corner(track, 12)
	stroke(track, T.BORDER, 1)

	local thumb = newFrame(track, {
		BG = T.WHITE,
		Size = UDim2.new(0, 14, 0, 14),
		Position = default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
		ZIndex = 14,
	})
	corner(thumb, 8)

	local isOn = default
	local function toggle()
		isOn = not isOn
		tween(track, { BackgroundColor3 = isOn and T.ACCENT or T.SURFACE2 })
		tween(thumb, { Position = isOn and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7) })
		if onChange then onChange(isOn) end
	end

	track.MouseButton1Click:Connect(toggle)
	row.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then toggle() end
	end)
	return row
end

-- ══════════════════════════════════════════
-- SLIDER COMPONENT
-- ══════════════════════════════════════════
local function makeSlider(parent, labelText, min, max, default, onChange, order)
	local row = newFrame(parent, {
		BG = T.SURFACE,
		Size = UDim2.new(1, 0, 0, 56),
		ZIndex = 12,
	})
	corner(row, 10)
	stroke(row, T.BORDER, 1)
	row.LayoutOrder = order or 0

	newLabel(row, {
		Text = labelText,
		Color = T.TEXT,
		Size = 12,
		Sz = UDim2.new(1, -60, 0, 20),
		Position = UDim2.new(0, 14, 0, 6),
		ZIndex = 13,
	})

	local valLbl = newLabel(row, {
		Text = tostring(default),
		Color = T.ACCENT,
		Size = 12,
		Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0, 46, 0, 20),
		Position = UDim2.new(1, -58, 0, 6),
		AlignX = Enum.TextXAlignment.Right,
		ZIndex = 13,
	})

	-- Track
	local track = newFrame(row, {
		BG = T.SURFACE2,
		Size = UDim2.new(1, -28, 0, 4),
		Position = UDim2.new(0, 14, 0, 36),
		ZIndex = 13,
	})
	corner(track, 4)
	stroke(track, T.BORDER, 1)

	local fill = newFrame(track, {
		BG = T.ACCENT,
		Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
		ZIndex = 14,
	})
	corner(fill, 4)

	local thumb = Instance.new("TextButton", track)
	thumb.Size = UDim2.new(0, 14, 0, 14)
	thumb.AnchorPoint = Vector2.new(0.5, 0.5)
	thumb.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
	thumb.BackgroundColor3 = T.WHITE
	thumb.Text = ""
	thumb.BorderSizePixel = 0
	thumb.ZIndex = 15
	corner(thumb, 8)

	local drag = false
	thumb.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = true
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = false
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local relX = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			local val = math.floor(min + relX * (max - min))
			fill.Size = UDim2.new(relX, 0, 1, 0)
			thumb.Position = UDim2.new(relX, 0, 0.5, 0)
			valLbl.Text = tostring(val)
			if onChange then onChange(val) end
		end
	end)

	return row, valLbl
end

-- ══════════════════════════════════════════
-- ★ PAGE: HOME
-- ══════════════════════════════════════════
local homePage, _ = makePage("Home")

do
	local character = Player.Character or Player.CharacterAdded:Wait()
	local humanoid  = character:WaitForChild("Humanoid")

	-- Profile card
	local profCard = makeCard(homePage, 88, 1)

	local avatar = Instance.new("ImageLabel", profCard)
	avatar.Size = UDim2.new(0, 56, 0, 56)
	avatar.Position = UDim2.new(0, 16, 0.5, -28)
	avatar.BackgroundColor3 = T.SURFACE2
	avatar.BorderSizePixel = 0
	avatar.ZIndex = 13
	avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. Player.UserId .. "&width=150&height=150&format=png"
	corner(avatar, 28)
	stroke(avatar, T.ACCENT, 2)

	newLabel(profCard, {
		Text = Player.DisplayName,
		Color = T.TEXT,
		Size = 15,
		Font = Enum.Font.GothamBold,
		Sz = UDim2.new(1, -90, 0, 24),
		Position = UDim2.new(0, 84, 0, 18),
		ZIndex = 13,
		Truncate = true,
	})

	newLabel(profCard, {
		Text = "@" .. Player.Name,
		Color = T.TEXT3,
		Size = 11,
		Sz = UDim2.new(1, -90, 0, 18),
		Position = UDim2.new(0, 84, 0, 42),
		ZIndex = 13,
		Truncate = true,
	})

	-- Tham gia
	local joinLbl = newLabel(profCard, {
		Text = "  " .. Player.AccountAge .. " ngày",
		Color = T.TEXT2,
		Size = 11,
		Sz = UDim2.new(0, 90, 0, 18),
		Position = UDim2.new(0, 84, 0, 62),
		ZIndex = 13,
	})

	-- Stats grid (2x2)
	local statsCard = makeCard(homePage, 108, 2)

	local statDefs = {
		{ icon = "❤", label = "HP",    col = 0, row = 0 },
		{ icon = "⚡", label = "Speed", col = 1, row = 0 },
		{ icon = "📶", label = "Ping",  col = 0, row = 1 },
		{ icon = "🏳", label = "Team",  col = 1, row = 1 },
	}

	local statValues = {}

	for _, sd in ipairs(statDefs) do
		local cell = newFrame(statsCard, {
			BG = T.SURFACE2,
			Size = UDim2.new(0, 118, 0, 42),
			Position = UDim2.new(0, 10 + sd.col * 128, 0, 10 + sd.row * 48),
			ZIndex = 13,
		})
		corner(cell, 8)

		newLabel(cell, {
			Text = sd.icon,
			Color = T.TEXT3,
			Size = 13,
			Sz = UDim2.new(0, 22, 1, 0),
			Position = UDim2.new(0, 8, 0, 0),
			AlignX = Enum.TextXAlignment.Center,
			ZIndex = 14,
		})

		newLabel(cell, {
			Text = sd.label,
			Color = T.TEXT3,
			Size = 9,
			Font = Enum.Font.GothamBold,
			Sz = UDim2.new(1, -32, 0, 16),
			Position = UDim2.new(0, 30, 0, 6),
			ZIndex = 14,
		})

		local valL = newLabel(cell, {
			Text = "...",
			Color = T.TEXT,
			Size = 12,
			Font = Enum.Font.GothamBold,
			Sz = UDim2.new(1, -32, 0, 18),
			Position = UDim2.new(0, 30, 0, 20),
			ZIndex = 14,
			Truncate = true,
		})

		statValues[sd.label] = valL
	end

	-- Cập nhật live
	local function refreshStats()
		statValues["HP"].Text   = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
		statValues["Speed"].Text = math.floor(humanoid.WalkSpeed) .. " st/s"
		if Player.Team then
			statValues["Team"].Text = Player.Team.Name
		else
			statValues["Team"].Text = "None"
		end
	end
	refreshStats()

	humanoid.HealthChanged:Connect(refreshStats)

	task.spawn(function()
		while true do
			task.wait(2)
			local ok, p = pcall(function() return math.floor(Player:GetNetworkPing() * 1000) end)
			if ok then statValues["Ping"].Text = p .. " ms" end
		end
	end)
end

-- ══════════════════════════════════════════
-- ★ PAGE: PLAYERS
-- ══════════════════════════════════════════
local playersPage, _ = makePage("Players")

local espEnabled   = false
local espHighlights = {}

local function applyESP(p)
	if p == Player or not espEnabled then return end
	local char = p.Character
	if not char then return end
	if espHighlights[p] then espHighlights[p]:Destroy() end
	local hl = Instance.new("Highlight", char)
	hl.Name = "_NovaESP"
	local isEnemy = p.Team and Player.Team and p.Team ~= Player.Team
	hl.FillColor       = isEnemy and T.DANGER or T.ACCENT
	hl.OutlineColor    = isEnemy and Color3.fromRGB(255, 100, 100) or T.ACCENT2
	hl.FillTransparency   = 0.6
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	espHighlights[p]   = hl
end

local function removeESP(p)
	if espHighlights[p] then espHighlights[p]:Destroy(); espHighlights[p] = nil end
end

-- ESP toggle ở trên cùng
do
	makeSectionLabel(playersPage, "ESP", 1)
	makeToggle(playersPage, "ESP Highlight (xuyên tường)", false, function(on)
		espEnabled = on
		if on then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= Player then
					applyESP(p)
					p.CharacterAdded:Connect(function()
						task.wait(0.3)
						if espEnabled then applyESP(p) end
					end)
				end
			end
		else
			for _, p in ipairs(Players:GetPlayers()) do removeESP(p) end
		end
	end, 2)

	makeSectionLabel(playersPage, "Players in Server", 3)
end

-- Player rows
local playerRowMap = {}

local function hpColor(ratio)
	if ratio > 0.6 then return T.SUCCESS end
	if ratio > 0.3 then return T.WARN end
	return T.DANGER
end

local function buildPlayerRow(p, order)
	if p == Player then return end
	local row = newFrame(playersPage, {
		BG = T.SURFACE,
		Size = UDim2.new(1, 0, 0, 60),
		ZIndex = 12,
	})
	row.LayoutOrder = order + 10
	corner(row, 10)
	stroke(row, T.BORDER, 1)

	local av = Instance.new("ImageLabel", row)
	av.Size = UDim2.new(0, 38, 0, 38)
	av.Position = UDim2.new(0, 11, 0.5, -19)
	av.BackgroundColor3 = T.SURFACE2
	av.BorderSizePixel = 0
	av.ZIndex = 13
	av.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. p.UserId .. "&width=100&height=100&format=png"
	corner(av, 20)

	newLabel(row, {
		Text = p.DisplayName,
		Color = T.TEXT,
		Size = 13,
		Font = Enum.Font.GothamBold,
		Sz = UDim2.new(1, -120, 0, 20),
		Position = UDim2.new(0, 58, 0, 8),
		ZIndex = 13,
		Truncate = true,
	})

	newLabel(row, {
		Text = "@" .. p.Name,
		Color = T.TEXT3,
		Size = 10,
		Sz = UDim2.new(1, -120, 0, 16),
		Position = UDim2.new(0, 58, 0, 27),
		ZIndex = 13,
		Truncate = true,
	})

	local distLbl = newLabel(row, {
		Text = "—",
		Color = T.SUCCESS,
		Size = 11,
		Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0, 54, 0, 20),
		Position = UDim2.new(1, -62, 0, 8),
		AlignX = Enum.TextXAlignment.Right,
		ZIndex = 13,
	})

	-- HP bar
	local hpBg = newFrame(row, {
		BG = T.SURFACE2,
		Size = UDim2.new(1, -70, 0, 3),
		Position = UDim2.new(0, 58, 0, 52),
		ZIndex = 13,
	})
	corner(hpBg, 2)

	local hpFill = newFrame(hpBg, {
		BG = T.SUCCESS,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 14,
	})
	corner(hpFill, 2)

	playerRowMap[p] = { row = row, distLbl = distLbl, hpFill = hpFill }
end

local function rebuildPlayers()
	for _, data in pairs(playerRowMap) do
		if data.row and data.row.Parent then data.row:Destroy() end
	end
	playerRowMap = {}
	local i = 0
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= Player then
			i += 1
			buildPlayerRow(p, i)
		end
	end
end

rebuildPlayers()

Players.PlayerAdded:Connect(function(p)
	task.wait(0.5)
	rebuildPlayers()
	if espEnabled then
		p.CharacterAdded:Connect(function()
			task.wait(0.3)
			if espEnabled then applyESP(p) end
		end)
	end
end)
Players.PlayerRemoving:Connect(function(p)
	removeESP(p)
	if playerRowMap[p] then
		if playerRowMap[p].row and playerRowMap[p].row.Parent then
			playerRowMap[p].row:Destroy()
		end
		playerRowMap[p] = nil
	end
end)

-- Live update: dist + hp
task.spawn(function()
	while true do
		task.wait(1)
		if pages["Players"].Visible then
			for p, data in pairs(playerRowMap) do
				local myChar = Player.Character
				local theirChar = p.Character
				if myChar and theirChar then
					local myRoot    = myChar:FindFirstChild("HumanoidRootPart")
					local theirRoot = theirChar:FindFirstChild("HumanoidRootPart")
					if myRoot and theirRoot then
						local d = math.floor((myRoot.Position - theirRoot.Position).Magnitude)
						data.distLbl.Text = d .. " st"
					end

					local hum = theirChar:FindFirstChildOfClass("Humanoid")
					if hum and hum.MaxHealth > 0 then
						local ratio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
						data.hpFill.Size = UDim2.new(ratio, 0, 1, 0)
						tween(data.hpFill, { BackgroundColor3 = hpColor(ratio) })
					end
				end
			end
		end
	end
end)

-- ══════════════════════════════════════════
-- ★ PAGE: SETTINGS (Character & Camera)
-- ══════════════════════════════════════════
local settingsPage, _ = makePage("Settings")

do
	local character = Player.Character or Player.CharacterAdded:Wait()
	local humanoid  = character:WaitForChild("Humanoid")

	makeSectionLabel(settingsPage, "Character", 1)

	local _, walkValLbl = makeSlider(settingsPage, "Walk Speed", 8, 100, 16, function(v)
		if humanoid then humanoid.WalkSpeed = v end
	end, 2)

	makeSlider(settingsPage, "Jump Power", 20, 200, 50, function(v)
		if humanoid then
			humanoid.UseJumpPower = true
			humanoid.JumpPower = v
		end
	end, 3)

	makeSectionLabel(settingsPage, "Camera", 4)

	local cam = workspace.CurrentCamera
	makeSlider(settingsPage, "Field of View", 30, 120, cam and cam.FieldOfView or 70, function(v)
		if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = v end
	end, 5)

	makeSlider(settingsPage, "Max Zoom", 5, 100, 25, function(v)
		Player.CameraMaxZoomDistance = v
	end, 6)

	makeSlider(settingsPage, "Min Zoom", 0, 30, 0, function(v)
		Player.CameraMinZoomDistance = v
	end, 7)

	-- Reset btn
	local resetBtn = Instance.new("TextButton", settingsPage)
	resetBtn.Size = UDim2.new(1, 0, 0, 40)
	resetBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
	resetBtn.TextColor3 = T.DANGER
	resetBtn.Text = "↺  Reset defaults"
	resetBtn.TextSize = 12
	resetBtn.Font = Enum.Font.GothamBold
	resetBtn.BorderSizePixel = 0
	resetBtn.ZIndex = 12
	resetBtn.LayoutOrder = 10
	corner(resetBtn, 10)
	stroke(resetBtn, T.DANGER, 1)

	resetBtn.MouseEnter:Connect(function()
		tween(resetBtn, { BackgroundColor3 = Color3.fromRGB(80, 30, 30) })
	end)
	resetBtn.MouseLeave:Connect(function()
		tween(resetBtn, { BackgroundColor3 = Color3.fromRGB(40, 20, 20) })
	end)
	resetBtn.MouseButton1Click:Connect(function()
		if humanoid then humanoid.WalkSpeed = 16; humanoid.JumpPower = 50; humanoid.UseJumpPower = false end
		if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = 70 end
		Player.CameraMaxZoomDistance = 25
		Player.CameraMinZoomDistance = 0
		resetBtn.Text = "✓  Reset complete"
		task.delay(1.5, function() resetBtn.Text = "↺  Reset defaults" end)
	end)
end

-- ══════════════════════════════════════════
-- ★ PAGE: DISPLAY (Graphics & Lighting)
-- ══════════════════════════════════════════
local displayPage, _ = makePage("Display")

do
	makeSectionLabel(displayPage, "Lighting", 1)

	makeSlider(displayPage, "Brightness", 0, 20, math.floor(Lighting.Brightness * 10), function(v)
		Lighting.Brightness = v / 10 * 2
	end, 2)

	makeSlider(displayPage, "Fog Distance", 100, 2000, 1000, function(v)
		Lighting.FogEnd   = v
		Lighting.FogStart = v * 0.85
	end, 3)

	makeToggle(displayPage, "Global Shadows", true, function(on)
		Lighting.GlobalShadows = on
	end, 4)

	makeToggle(displayPage, "Bloom / Sun Rays", true, function(on)
		for _, e in ipairs(Lighting:GetChildren()) do
			if e:IsA("BloomEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") then
				e.Enabled = on
			end
		end
	end, 5)

	makeSectionLabel(displayPage, "Camera Effects", 6)

	makeSlider(displayPage, "Depth of Field", 0, 20, 0, function(v)
		local dof = Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
		if not dof then dof = Instance.new("DepthOfFieldEffect", Lighting) end
		dof.Enabled         = v > 0
		dof.FocusDistance   = v == 0 and 999 or v * 10
		dof.InFocusRadius   = v == 0 and 999 or 20
	end, 7)
end

-- ══════════════════════════════════════════
-- ★ PAGE: EVENTS → REMOTE SPY
-- ══════════════════════════════════════════
local eventsPage, _ = makePage("Events")

do
	local spyActive    = false
	local spyConns     = {}
	local logCount     = 0
	local totalFired   = 0
	local filterText   = ""

	-- ── Màu sắc theo loại ──
	local KIND_COLOR = {
		RE_fire   = Color3.fromRGB(99,  102, 241),   -- indigo  (C→S)
		RE_recv   = Color3.fromRGB(34,  197, 94),    -- green   (S→C)
		RF_invoke = Color3.fromRGB(251, 191, 36),    -- yellow  (C→S invoke)
		RF_result = Color3.fromRGB(96,  165, 250),   -- blue    (result)
		RF_cb     = Color3.fromRGB(167, 139, 250),   -- violet  (S→C callback)
		BE        = Color3.fromRGB(250, 204, 21),    -- amber   (bindable)
		BF        = Color3.fromRGB(244, 114, 182),   -- pink
	}
	local KIND_BG = {
		RE_fire   = Color3.fromRGB(18, 18, 45),
		RE_recv   = Color3.fromRGB(12, 35, 20),
		RF_invoke = Color3.fromRGB(40, 32, 8),
		RF_result = Color3.fromRGB(10, 22, 45),
		RF_cb     = Color3.fromRGB(28, 20, 48),
		BE        = Color3.fromRGB(40, 35, 5),
		BF        = Color3.fromRGB(40, 18, 30),
	}
	local KIND_TAG = {
		RE_fire   = "▶ Fire [C→S]",
		RE_recv   = "◀ Recv [S→C]",
		RF_invoke = "↗ Invoke [C→S]",
		RF_result = "↙ Result [S→C]",
		RF_cb     = "↙ Callback [S→C]",
		BE        = "⬡ Bindable",
		BF        = "⬡ BindFn",
	}

	-- ── Serialize args ──
	local function serializeArg(a)
		local t = typeof(a)
		if t == "Instance"  then return "[" .. a.ClassName .. "] " .. a.Name
		elseif t == "Vector3" then return string.format("V3(%.1f,%.1f,%.1f)", a.X, a.Y, a.Z)
		elseif t == "CFrame"  then
			local p = a.Position
			return string.format("CF(%.1f,%.1f,%.1f)", p.X, p.Y, p.Z)
		elseif t == "table"   then
			local parts = {}
			for k, v in pairs(a) do
				table.insert(parts, tostring(k) .. "=" .. tostring(v))
				if #parts >= 4 then table.insert(parts, "..."); break end
			end
			return "{" .. table.concat(parts, ", ") .. "}"
		elseif t == "boolean" then return a and "true" or "false"
		else
			local s = tostring(a)
			return #s > 60 and s:sub(1,57).."..." or s
		end
	end

	local function formatArgs(args)
		if #args == 0 then return "(no args)" end
		local parts = {}
		for i, a in ipairs(args) do
			table.insert(parts, "[" .. i .. "] " .. serializeArg(a))
		end
		return table.concat(parts, "   ")
	end

	-- ══════════════════════════════════
	-- HEADER + CONTROLS
	-- ══════════════════════════════════
	-- Title row
	local titleRow = newFrame(eventsPage, {
		BG=Color3.fromRGB(0,0,0), BT=1,
		Size=UDim2.new(1,0,0,28), ZIndex=12,
	})
	titleRow.LayoutOrder = 0
	newLabel(titleRow, {
		Text="REMOTE SPY", Color=T.TEXT3, Size=9,
		Font=Enum.Font.GothamBold,
		Sz=UDim2.new(0.5,0,1,0), ZIndex=12,
	}).Parent = titleRow
	local pad0 = Instance.new("UIPadding", titleRow:FindFirstChildOfClass("TextLabel"))
	pad0.PaddingLeft = UDim.new(0,4)

	-- Stats card (3 ô)
	local statsCard = makeCard(eventsPage, 52, 1)
	local statDefs2 = {
		{ label="TỔNG FIRED", key="total", col=0, color=T.TEXT },
		{ label="REMOTE",     key="remotes", col=1, color=T.ACCENT },
		{ label="FILTER",     key="filter",  col=2, color=T.WARN },
	}
	local statVals2 = {}
	for _, sd in ipairs(statDefs2) do
		local cell = newFrame(statsCard, {
			BG   = T.SURFACE2,
			Size = UDim2.new(0, 80, 0, 32),
			Position = UDim2.new(0, 10 + sd.col*84, 0, 10),
			ZIndex = 13,
		})
		corner(cell, 7)
		newLabel(cell, {Text=sd.label,Color=T.TEXT3,Size=8,Font=Enum.Font.GothamBold,
			Sz=UDim2.new(1,-6,0,14),Position=UDim2.new(0,4,0,2),ZIndex=14})
		local vl = newLabel(cell, {Text="0",Color=sd.color,Size=14,Font=Enum.Font.GothamBold,
			Sz=UDim2.new(1,-6,0,16),Position=UDim2.new(0,4,0,16),ZIndex=14})
		statVals2[sd.key] = vl
	end

	-- Nút Start/Stop + Clear
	local ctrlRow = newFrame(eventsPage, {
		BG=Color3.fromRGB(0,0,0), BT=1,
		Size=UDim2.new(1,0,0,34), ZIndex=12,
	})
	ctrlRow.LayoutOrder = 2

	local startBtn = Instance.new("TextButton", ctrlRow)
	startBtn.Size             = UDim2.new(0,110,0,28)
	startBtn.Position         = UDim2.new(0,0,0.5,-14)
	startBtn.Text             = "▶  Bắt đầu Spy"
	startBtn.TextSize         = 11
	startBtn.Font             = Enum.Font.GothamBold
	startBtn.TextColor3       = T.SUCCESS
	startBtn.BackgroundColor3 = Color3.fromRGB(12,35,20)
	startBtn.BorderSizePixel  = 0
	startBtn.ZIndex           = 13
	corner(startBtn, 8)
	stroke(startBtn, T.SUCCESS, 1)

	local clearBtn = Instance.new("TextButton", ctrlRow)
	clearBtn.Size             = UDim2.new(0,70,0,28)
	clearBtn.Position         = UDim2.new(0,118,0.5,-14)
	clearBtn.Text             = "🗑 Xóa log"
	clearBtn.TextSize         = 10
	clearBtn.Font             = Enum.Font.GothamBold
	clearBtn.TextColor3       = T.TEXT3
	clearBtn.BackgroundColor3 = T.SURFACE2
	clearBtn.BorderSizePixel  = 0
	clearBtn.ZIndex           = 13
	corner(clearBtn, 8)
	stroke(clearBtn, T.BORDER, 1)

	local pauseBtn = Instance.new("TextButton", ctrlRow)
	pauseBtn.Size             = UDim2.new(0,62,0,28)
	pauseBtn.Position         = UDim2.new(0,196,0.5,-14)
	pauseBtn.Text             = "⏸ Pause"
	pauseBtn.TextSize         = 10
	pauseBtn.Font             = Enum.Font.GothamBold
	pauseBtn.TextColor3       = T.TEXT3
	pauseBtn.BackgroundColor3 = T.SURFACE2
	pauseBtn.BorderSizePixel  = 0
	pauseBtn.ZIndex           = 13
	pauseBtn.Visible          = false
	corner(pauseBtn, 8)
	stroke(pauseBtn, T.BORDER, 1)

	-- Filter label
	local filterLabel = newLabel(eventsPage, {
		Text="FILTER: (tất cả)", Color=T.TEXT3, Size=8,
		Font=Enum.Font.GothamBold,
		Sz=UDim2.new(1,0,0,18), ZIndex=12,
	})
	filterLabel.LayoutOrder = 3
	local filterPad = Instance.new("UIPadding", filterLabel)
	filterPad.PaddingLeft = UDim.new(0,4)

	-- Filter buttons (quick filters)
	local filterRow = newFrame(eventsPage, {
		BG=Color3.fromRGB(0,0,0), BT=1,
		Size=UDim2.new(1,0,0,28), ZIndex=12,
	})
	filterRow.LayoutOrder = 4
	local filterList = Instance.new("UIListLayout", filterRow)
	filterList.FillDirection = Enum.FillDirection.Horizontal
	filterList.SortOrder = Enum.SortOrder.LayoutOrder
	filterList.Padding = UDim.new(0,4)

	local FILTERS = {
		{ label="Tất cả", key="" },
		{ label="C→S",    key="RE_fire" },
		{ label="S→C",    key="RE_recv" },
		{ label="Invoke", key="RF_invoke" },
		{ label="Bind",   key="BE" },
	}
	local filterBtns = {}
	for i, f in ipairs(FILTERS) do
		local fb = Instance.new("TextButton", filterRow)
		fb.Size             = UDim2.new(0,48,0,22)
		fb.Text             = f.label
		fb.TextSize         = 9
		fb.Font             = Enum.Font.GothamBold
		fb.TextColor3       = i==1 and T.WHITE or T.TEXT3
		fb.BackgroundColor3 = i==1 and T.ACCENT or T.SURFACE2
		fb.BorderSizePixel  = 0
		fb.ZIndex           = 13
		fb.LayoutOrder      = i
		corner(fb, 6)
		filterBtns[i] = { btn=fb, key=f.key, label=f.label }
	end

	-- ── Apply filter ──
	local activeFilterIdx = 1
	local function applyFilter(idx)
		activeFilterIdx = idx
		filterText = filterBtns[idx].key
		filterLabel.Text = "FILTER: " .. filterBtns[idx].label
		statVals2["filter"].Text = filterBtns[idx].label
		for i, fb in ipairs(filterBtns) do
			tween(fb.btn, {
				BackgroundColor3 = i==idx and T.ACCENT or T.SURFACE2,
				TextColor3       = i==idx and T.WHITE or T.TEXT3,
			})
		end
		-- Ẩn/hiện log rows theo filter
		for _, child in ipairs(logContainer:GetChildren()) do
			if child:IsA("Frame") and child:FindFirstChild("_kind") then
				local kind = child:FindFirstChild("_kind").Value
				child.Visible = (filterText == "" or kind == filterText)
			end
		end
	end
	for i, fb in ipairs(filterBtns) do
		fb.btn.MouseButton1Click:Connect(function() applyFilter(i) end)
	end

	-- ══════════════════════════════════
	-- LOG CONTAINER
	-- ══════════════════════════════════
	local logSep = newLabel(eventsPage, {
		Text="LOG", Color=T.TEXT3, Size=8,
		Font=Enum.Font.GothamBold,
		Sz=UDim2.new(1,0,0,16), ZIndex=12,
	})
	logSep.LayoutOrder = 5
	local lsPad = Instance.new("UIPadding", logSep); lsPad.PaddingLeft = UDim.new(0,4)

	local logContainer = newFrame(eventsPage, {
		BG=Color3.fromRGB(0,0,0), BT=1,
		Size=UDim2.new(1,0,0,10), ZIndex=11,
	})
	logContainer.LayoutOrder   = 6
	logContainer.AutomaticSize = Enum.AutomaticSize.Y
	local logLL = Instance.new("UIListLayout", logContainer)
	logLL.SortOrder = Enum.SortOrder.LayoutOrder
	logLL.Padding   = UDim.new(0,4)

	-- Empty state
	local emptyLbl = newLabel(logContainer, {
		Text="Nhấn ▶ để bắt đầu bắt remote...",
		Color=T.TEXT3, Size=11,
		Sz=UDim2.new(1,0,0,36), ZIndex=12,
	})
	emptyLbl.LayoutOrder = 99999

	local isPaused   = false
	local MAX_LOGS   = 80
	local remoteSet  = {}   -- tên remote đã gặp

	local function updateStats()
		statVals2["total"].Text   = tostring(totalFired)
		local rc = 0; for _ in pairs(remoteSet) do rc+=1 end
		statVals2["remotes"].Text = tostring(rc)
	end

	-- ── Thêm 1 dòng log ──
	local function addLog(kind, remoteName, argStr)
		if isPaused then return end
		if filterText ~= "" and kind ~= filterText then return end

		emptyLbl.Visible = false
		logCount += 1
		totalFired += 1
		remoteSet[remoteName] = true
		updateStats()

		-- Giới hạn MAX_LOGS
		local rows = {}
		for _, c in ipairs(logContainer:GetChildren()) do
			if c:IsA("Frame") then table.insert(rows, c) end
		end
		if #rows >= MAX_LOGS then
			rows[1]:Destroy()
		end

		local row = newFrame(logContainer, {
			BG   = KIND_BG[kind] or T.SURFACE2,
			Size = UDim2.new(1,0,0,50),
			ZIndex = 12,
		})
		row.LayoutOrder = logCount
		corner(row, 8)
		stroke(row, KIND_COLOR[kind] or T.BORDER, 1)

		-- Tag màu ở trái
		local tagF = newFrame(row, {
			BG   = KIND_COLOR[kind] or T.BORDER,
			Size = UDim2.new(0,3,1,-8),
			Position = UDim2.new(0,0,0,4),
			ZIndex = 13,
		})
		corner(tagF, 2)

		-- Kind badge
		local badge = newFrame(row, {
			BG   = (KIND_COLOR[kind] or T.BORDER),
			Size = UDim2.new(0,72,0,15),
			Position = UDim2.new(0,8,0,5),
			ZIndex = 13,
		})
		corner(badge, 4)
		local badgeLbl = newLabel(badge, {
			Text  = KIND_TAG[kind] or kind,
			Color = T.BG,
			Size  = 8,
			Font  = Enum.Font.GothamBold,
			AlignX = Enum.TextXAlignment.Center,
			Sz    = UDim2.new(1,0,1,0),
			ZIndex = 14,
		})

		-- Remote name
		newLabel(row, {
			Text  = remoteName,
			Color = T.TEXT,
			Size  = 12,
			Font  = Enum.Font.GothamBold,
			Sz    = UDim2.new(1,-100,0,18),
			Position = UDim2.new(0,84,0,4),
			ZIndex = 13,
			Truncate = true,
		})

		-- Timestamp
		newLabel(row, {
			Text  = os.date("%H:%M:%S"),
			Color = T.TEXT3,
			Size  = 9,
			Sz    = UDim2.new(0,54,0,18),
			Position = UDim2.new(1,-58,0,4),
			AlignX = Enum.TextXAlignment.Right,
			ZIndex = 13,
		})

		-- Args
		newLabel(row, {
			Text  = argStr,
			Color = T.TEXT2,
			Size  = 9,
			Sz    = UDim2.new(1,-12,0,20),
			Position = UDim2.new(0,8,0,28),
			ZIndex = 13,
			Truncate = true,
			Wrapped = false,
		})

		-- Lưu kind để filter
		local kindVal = Instance.new("StringValue", row)
		kindVal.Name  = "_kind"
		kindVal.Value = kind

		-- Ẩn nếu không khớp filter
		if filterText ~= "" and kind ~= filterText then
			row.Visible = false
		end

		return row
	end

	-- ══════════════════════════════════
	-- HOOK REMOTES (toàn game)
	-- ══════════════════════════════════
	local function hookAllRemotes()
		local function scan(root, depth)
			if depth > 6 then return end
			for _, c in ipairs(root:GetChildren()) do
				local name = c.Name

				-- RemoteEvent
				if c:IsA("RemoteEvent") then

					-- S→C (OnClientEvent)
					pcall(function()
						table.insert(spyConns, c.OnClientEvent:Connect(function(...)
							addLog("RE_recv", name, formatArgs({...}))
						end))
					end)

					-- C→S (hook FireServer)
					pcall(function()
						local mt = getrawmetatable and getrawmetatable(c)
						if mt then
							-- executer environment (Synapse/KRNL)
							local orig = mt.__index(c,"FireServer")
							local oldNamecall
							oldNamecall = hookmetamethod(game,"__namecall",function(self,...)
								if self == c and getnamecallmethod() == "FireServer" then
									local args = {...}
									task.defer(function()
										addLog("RE_fire", name, formatArgs(args))
									end)
								end
								return oldNamecall(self,...)
							end)
							table.insert(spyConns, {Disconnect=function()
								-- restore nếu cần
							end})
						else
							-- fallback (môi trường hạn chế)
							local origFS = c.FireServer
							c.FireServer = function(self,...)
								local args = {...}
								addLog("RE_fire", name, formatArgs(args))
								return origFS(self,...)
							end
							table.insert(spyConns, {Disconnect=function()
								c.FireServer = origFS
							end})
						end
					end)

					-- RemoteFunction
				elseif c:IsA("RemoteFunction") then

					-- S→C callback
					pcall(function()
						local origCB = c.OnClientInvoke
						c.OnClientInvoke = function(...)
							local args = {...}
							addLog("RF_cb", name, formatArgs(args))
							if origCB then return origCB(...) end
						end
						table.insert(spyConns, {Disconnect=function()
							c.OnClientInvoke = origCB
						end})
					end)

					-- C→S InvokeServer
					pcall(function()
						local origIS = c.InvokeServer
						c.InvokeServer = function(self,...)
							local args = {...}
							addLog("RF_invoke", name, formatArgs(args))
							local result = origIS(self,...)
							addLog("RF_result", name .. " ← result",
								formatArgs(type(result)=="table" and result or {result}))
							return result
						end
						table.insert(spyConns, {Disconnect=function()
							c.InvokeServer = origIS
						end})
					end)

					-- BindableEvent
				elseif c:IsA("BindableEvent") then
					pcall(function()
						table.insert(spyConns, c.Event:Connect(function(...)
							addLog("BE", name, formatArgs({...}))
						end))
					end)

					-- BindableFunction
				elseif c:IsA("BindableFunction") then
					pcall(function()
						local origOI = c.OnInvoke
						c.OnInvoke = function(...)
							local args = {...}
							addLog("BF", name, formatArgs(args))
							if origOI then return origOI(...) end
						end
						table.insert(spyConns, {Disconnect=function()
							c.OnInvoke = origOI
						end})
					end)
				end

				scan(c, depth+1)
			end
		end

		-- Quét toàn bộ các service có remote
		local services = {
			"ReplicatedStorage", "ReplicatedFirst",
			"Players", "Workspace",
		}
		for _, svcName in ipairs(services) do
			pcall(function() scan(game:GetService(svcName), 0) end)
		end

		-- Theo dõi remote mới được thêm vào
		local function watchNew(root, depth)
			if depth > 3 then return end
			table.insert(spyConns, root.ChildAdded:Connect(function(child)
				task.wait(0.1)
				if spyActive then scan(child, 0) end
			end))
			for _, c in ipairs(root:GetChildren()) do
				pcall(function() watchNew(c, depth+1) end)
			end
		end
		for _, svcName in ipairs(services) do
			pcall(function()
				watchNew(game:GetService(svcName), 0)
			end)
		end
	end

	-- ══════════════════════════════════
	-- BUTTON LOGIC
	-- ══════════════════════════════════
	startBtn.MouseButton1Click:Connect(function()
		if not spyActive then
			-- Bắt đầu
			spyActive  = true
			isPaused   = false
			totalFired = 0
			remoteSet  = {}
			spyConns   = {}
			updateStats()
			emptyLbl.Visible = true
			emptyLbl.Text    = "Đang theo dõi... chờ remote được fire"

			tween(startBtn, {
				BackgroundColor3 = Color3.fromRGB(40,15,15),
				TextColor3       = T.DANGER,
			})
			stroke(startBtn, T.DANGER, 1)
			startBtn.Text  = "■  Dừng Spy"
			pauseBtn.Visible = true

			hookAllRemotes()
		else
			-- Dừng
			spyActive = false
			isPaused  = false
			for _, conn in ipairs(spyConns) do
				pcall(function() conn:Disconnect() end)
			end
			spyConns = {}

			tween(startBtn, {
				BackgroundColor3 = Color3.fromRGB(12,35,20),
				TextColor3       = T.SUCCESS,
			})
			stroke(startBtn, T.SUCCESS, 1)
			startBtn.Text    = "▶  Bắt đầu Spy"
			pauseBtn.Visible = false
			pauseBtn.Text    = "⏸ Pause"
			tween(pauseBtn, {BackgroundColor3=T.SURFACE2, TextColor3=T.TEXT3})

			addLog("BE", "[ SPY STOPPED ]", "Đã ngắt tất cả hook · " .. totalFired .. " events bắt được")
		end
	end)

	pauseBtn.MouseButton1Click:Connect(function()
		isPaused = not isPaused
		if isPaused then
			pauseBtn.Text = "▶ Resume"
			tween(pauseBtn, {BackgroundColor3=Color3.fromRGB(40,35,5), TextColor3=T.WARN})
		else
			pauseBtn.Text = "⏸ Pause"
			tween(pauseBtn, {BackgroundColor3=T.SURFACE2, TextColor3=T.TEXT3})
		end
	end)

	clearBtn.MouseButton1Click:Connect(function()
		for _, c in ipairs(logContainer:GetChildren()) do
			if c:IsA("Frame") then c:Destroy() end
		end
		logCount   = 0
		totalFired = 0
		remoteSet  = {}
		updateStats()
		emptyLbl.Visible = true
		emptyLbl.Text    = spyActive
			and "Đã xóa log · đang tiếp tục theo dõi..."
			or  "Nhấn ▶ để bắt đầu bắt remote..."
	end)

	-- Hover effects
	startBtn.MouseEnter:Connect(function()
		if not spyActive then tween(startBtn,{BackgroundColor3=Color3.fromRGB(15,50,25)})
		else tween(startBtn,{BackgroundColor3=Color3.fromRGB(55,18,18)}) end
	end)
	startBtn.MouseLeave:Connect(function()
		if not spyActive then tween(startBtn,{BackgroundColor3=Color3.fromRGB(12,35,20)})
		else tween(startBtn,{BackgroundColor3=Color3.fromRGB(40,15,15)}) end
	end)
	clearBtn.MouseEnter:Connect(function() tween(clearBtn,{BackgroundColor3=T.SURFACE}) end)
	clearBtn.MouseLeave:Connect(function() tween(clearBtn,{BackgroundColor3=T.SURFACE2}) end)
end

-- ══════════════════════════════════════════
-- OPEN / CLOSE LOGIC
-- ══════════════════════════════════════════
local menuOpen = false

local function openMenu()
	if menuOpen then return end
	menuOpen = true
	tween(Panel, { Position = UDim2.new(1, -PANEL_W, 0, 0) }, EZ_SLOW)
	if currentPage == nil then switchPage("Home") end
end

local function closeMenu()
	if not menuOpen then return end
	menuOpen = false
	tween(Panel, { Position = UDim2.new(1, 0, 0, 0) }, EZ_SLOW)
end

CloseBtn.MouseButton1Click:Connect(closeMenu)

-- ══════════════════════════════════════════
-- TOGGLE BUTTON (draggable, top-right)
-- ══════════════════════════════════════════
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 44, 0, 44)
ToggleBtn.Position = UDim2.new(1, -60, 0, 18)
ToggleBtn.Text = "N"
ToggleBtn.TextSize = 20
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextColor3 = T.WHITE
ToggleBtn.BackgroundColor3 = T.ACCENT
ToggleBtn.BorderSizePixel = 0
ToggleBtn.ZIndex = 9
ToggleBtn.Visible = false
corner(ToggleBtn, 14)

-- pulse ring
local Ring = newFrame(ScreenGui, {
	BG = T.ACCENT,
	Size = UDim2.new(0, 44, 0, 44),
	Position = UDim2.new(1, -60, 0, 18),
	BT = 0.5,
	ZIndex = 8,
})
corner(Ring, 14)
Ring.Visible = false

-- Drag
local dragOn = false
local dragStart, btnStartPos

ToggleBtn.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragOn = true
		dragStart = i.Position
		btnStartPos = ToggleBtn.Position
	end
end)
UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragOn = false
	end
end)
UserInputService.InputChanged:Connect(function(i)
	if dragOn and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local d = i.Position - dragStart
		local np = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + d.X,
			btnStartPos.Y.Scale, btnStartPos.Y.Offset + d.Y)
		ToggleBtn.Position = np
		Ring.Position = np
	end
end)

ToggleBtn.MouseButton1Click:Connect(function()
	if menuOpen then closeMenu() else openMenu() end
end)

ToggleBtn.MouseEnter:Connect(function()
	tween(ToggleBtn, { BackgroundColor3 = T.ACCENT2 })
end)
ToggleBtn.MouseLeave:Connect(function()
	tween(ToggleBtn, { BackgroundColor3 = T.ACCENT })
end)

-- ══════════════════════════════════════════
-- INTRO ANIMATION
-- ══════════════════════════════════════════
task.spawn(function()
	-- Bar load animation
	tween(SplashBar, { Size = UDim2.new(0, 200, 0, 2) }, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
	task.wait(1.4)

	tween(SplashLogo,  { TextTransparency = 1 }, TweenInfo.new(0.5))
	tween(SplashSub,   { TextTransparency = 1 }, TweenInfo.new(0.5))
	tween(SplashBar,   { BackgroundTransparency = 1 }, TweenInfo.new(0.5))
	task.wait(0.3)
	tween(Splash, { BackgroundTransparency = 1 }, TweenInfo.new(0.5))
	task.wait(0.55)
	Splash:Destroy()

	ToggleBtn.Visible = true
	Ring.Visible = true

	-- Pulse animation
	task.spawn(function()
		while ToggleBtn and ToggleBtn.Parent do
			tween(Ring, { Size = UDim2.new(0, 58, 0, 58), Position = UDim2.new(
				Ring.Position.X.Scale, Ring.Position.X.Offset - 7,
				Ring.Position.Y.Scale, Ring.Position.Y.Offset - 7
				), BackgroundTransparency = 1 }, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
			task.wait(0.85)
			Ring.Size = UDim2.new(0, 44, 0, 44)
			Ring.Position = ToggleBtn.Position
			Ring.BackgroundTransparency = 0.5
			task.wait(1.5)
		end
	end)
end)
