-- ╔══════════════════════════════════════════════╗
-- ║        NOVA UI  —  v2.1  (2025 Upgrade)      ║
-- ║  glassmorphism · remote spy · explorer tree  ║
-- ╚══════════════════════════════════════════════╝

local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local Lighting          = game:GetService("Lighting")
local GuiService        = game:GetService("GuiService")

local Player    = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ══════════════════════════════════════════
-- THEME  (glass palette)
-- ══════════════════════════════════════════
local T = {
	BG          = Color3.fromRGB(8,  8,  14),
	SURFACE     = Color3.fromRGB(18, 18, 28),
	SURFACE2    = Color3.fromRGB(26, 26, 40),
	GLASS       = Color3.fromRGB(30, 30, 50),
	ACCENT      = Color3.fromRGB(99,  102, 241),
	ACCENT2     = Color3.fromRGB(139, 92,  246),
	ACCENT3     = Color3.fromRGB(59,  130, 246),
	SUCCESS     = Color3.fromRGB(34,  197, 94),
	WARN        = Color3.fromRGB(251, 191, 36),
	DANGER      = Color3.fromRGB(239, 68,  68),
	TEXT        = Color3.fromRGB(240, 240, 255),
	TEXT2       = Color3.fromRGB(160, 160, 200),
	TEXT3       = Color3.fromRGB(90,  90,  130),
	BORDER      = Color3.fromRGB(50,  50,  80),
	BORDER2     = Color3.fromRGB(70,  70,  110),
	WHITE       = Color3.new(1, 1, 1),
	COPY_OK     = Color3.fromRGB(52, 211, 153),
}

local EZ      = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local EZ_MED  = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local EZ_SLOW = TweenInfo.new(0.5,  Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local EZ_SPR  = TweenInfo.new(0.6,  Enum.EasingStyle.Back,  Enum.EasingDirection.Out)

-- ══════════════════════════════════════════
-- UTILITY
-- ══════════════════════════════════════════
local function tween(obj, props, info)
	TweenService:Create(obj, info or EZ, props):Play()
end

local function corner(parent, radius)
	local c = Instance.new("UICorner", parent)
	c.CornerRadius = UDim.new(0, radius or 10)
	return c
end

local function stroke(parent, color, thickness, transparency)
	local s = Instance.new("UIStroke", parent)
	s.Color = color or T.BORDER
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	return s
end

local function gradient(parent, c0, c1, rotation)
	local g = Instance.new("UIGradient", parent)
	g.Color = ColorSequence.new(c0, c1)
	g.Rotation = rotation or 90
	return g
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

-- Copy to clipboard helper (executer env)
local function copyText(text)
	pcall(function()
		if setclipboard then setclipboard(text)
		elseif toclipboard then toclipboard(text)
		elseif Clipboard then Clipboard.set(text) end
	end)
end

-- ══════════════════════════════════════════
-- ROOT GUI
-- ══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NovaUI_v2"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- ══════════════════════════════════════════
-- BACKGROUND BLUR  (glassmorphism layer)
-- ══════════════════════════════════════════
local BlurEffect = Instance.new("BlurEffect", Lighting)
BlurEffect.Size = 0
BlurEffect.Name = "NovaBlur"

-- ══════════════════════════════════════════
-- SPLASH
-- ══════════════════════════════════════════
local Splash = newFrame(ScreenGui, { BG = T.BG, Size = UDim2.new(1,0,1,0), ZIndex = 20 })

-- Radial glow behind logo
local Glow = newFrame(Splash, {
	BG = T.ACCENT,
	BT = 0.85,
	Size = UDim2.new(0, 320, 0, 320),
	Position = UDim2.new(0.5, -160, 0.5, -200),
	ZIndex = 20,
})
corner(Glow, 160)

local SplashLogo = newLabel(Splash, {
	Text = "NOVA",
	Color = T.WHITE,
	Size = 56,
	Font = Enum.Font.GothamBold,
	Sz = UDim2.new(0, 300, 0, 72),
	Position = UDim2.new(0.5, -150, 0.5, -62),
	AlignX = Enum.TextXAlignment.Center,
	ZIndex = 21,
})

local SplashSub = newLabel(Splash, {
	Text = "Interface v2.0",
	Color = T.TEXT3,
	Size = 13,
	Sz = UDim2.new(0, 300, 0, 24),
	Position = UDim2.new(0.5, -150, 0.5, -2),
	AlignX = Enum.TextXAlignment.Center,
	ZIndex = 21,
})

-- Animated bar (gradient)
local SplashBarBg = newFrame(Splash, {
	BG = T.SURFACE2,
	Size = UDim2.new(0, 200, 0, 3),
	Position = UDim2.new(0.5, -100, 0.5, 30),
	ZIndex = 21,
})
corner(SplashBarBg, 2)

local SplashBar = newFrame(SplashBarBg, {
	BG = T.ACCENT,
	Size = UDim2.new(0, 0, 1, 0),
	ZIndex = 22,
})
corner(SplashBar, 2)
gradient(SplashBar, T.ACCENT, T.ACCENT2, 90)

-- ══════════════════════════════════════════
-- PANEL  (glass card)
-- ══════════════════════════════════════════
local PANEL_W = 350

local Panel = newFrame(ScreenGui, {
	BG = T.BG,
	Size = UDim2.new(0, PANEL_W, 1, 0),
	Position = UDim2.new(1, 0, 0, 0),
	ZIndex = 10,
	ClipsDescendants = true,
	Name = "NovaPanel",
})
stroke(Panel, T.BORDER, 1)

-- Subtle gradient on panel BG
gradient(Panel, Color3.fromRGB(12,12,22), Color3.fromRGB(8,8,16), 180)

-- Left accent bar (gradient)
local PanelAccentLine = newFrame(Panel, {
	BG = T.ACCENT,
	Size = UDim2.new(0, 2, 1, 0),
	ZIndex = 11,
})
gradient(PanelAccentLine, T.ACCENT, T.ACCENT2, 180)

-- ──────── HEADER (glassmorphism) ────────
local Header = newFrame(Panel, {
	BG = T.SURFACE,
	Size = UDim2.new(1, 0, 0, 66),
	ZIndex = 11,
})
gradient(Header,
	Color3.fromRGB(24,24,40),
	Color3.fromRGB(16,16,28), 180)
stroke(Header, T.BORDER, 1)

-- Glow dot behind logo
local HeaderGlow = newFrame(Header, {
	BG = T.ACCENT,
	BT = 0.82,
	Size = UDim2.new(0, 60, 0, 60),
	Position = UDim2.new(0, -10, 0.5, -30),
	ZIndex = 11,
})
corner(HeaderGlow, 30)

local HeaderLogo = newLabel(Header, {
	Text = "NOVA",
	Color = T.WHITE,
	Size = 19,
	Font = Enum.Font.GothamBold,
	Sz = UDim2.new(0, 80, 0, 26),
	Position = UDim2.new(0, 16, 0, 12),
	ZIndex = 12,
})

local HeaderDot = newFrame(Header, {
	BG = T.ACCENT,
	Size = UDim2.new(0, 6, 0, 6),
	Position = UDim2.new(0, 59, 0, 20),
	ZIndex = 12,
})
corner(HeaderDot, 4)

local HeaderSub = newLabel(Header, {
	Text = "v2.0  •  UI System",
	Color = T.TEXT3,
	Size = 10,
	Sz = UDim2.new(0, 160, 0, 16),
	Position = UDim2.new(0, 16, 0, 38),
	ZIndex = 12,
})

-- Status indicator
local StatusDot = newFrame(Header, {
	BG = T.SUCCESS,
	Size = UDim2.new(0, 7, 0, 7),
	Position = UDim2.new(0, 116, 0, 41),
	ZIndex = 12,
})
corner(StatusDot, 4)

-- Close button
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -46, 0.5, -16)
CloseBtn.Text = "✕"
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = T.TEXT3
CloseBtn.BackgroundColor3 = T.SURFACE2
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 12
corner(CloseBtn, 8)
stroke(CloseBtn, T.BORDER, 1)

CloseBtn.MouseEnter:Connect(function()
	tween(CloseBtn, { BackgroundColor3 = T.DANGER, TextColor3 = T.WHITE })
end)
CloseBtn.MouseLeave:Connect(function()
	tween(CloseBtn, { BackgroundColor3 = T.SURFACE2, TextColor3 = T.TEXT3 })
end)

-- ──────── NAV BAR ────────
local NavBar = newFrame(Panel, {
	BG = T.SURFACE,
	Size = UDim2.new(0, 60, 1, -66),
	Position = UDim2.new(0, 0, 0, 66),
	ZIndex = 11,
})
gradient(NavBar, Color3.fromRGB(22,22,36), Color3.fromRGB(16,16,26), 180)
stroke(NavBar, T.BORDER, 1)

local NavList = Instance.new("UIListLayout", NavBar)
NavList.SortOrder = Enum.SortOrder.LayoutOrder
NavList.Padding = UDim.new(0, 3)
NavList.HorizontalAlignment = Enum.HorizontalAlignment.Center
local navPad = Instance.new("UIPadding", NavBar)
navPad.PaddingTop = UDim.new(0, 12)

-- Active nav indicator (left strip)
local NavIndicator = newFrame(NavBar, {
	BG = T.ACCENT,
	Size = UDim2.new(0, 3, 0, 36),
	Position = UDim2.new(0, 0, 0, 0),
	ZIndex = 13,
})
corner(NavIndicator, 2)
gradient(NavIndicator, T.ACCENT, T.ACCENT2, 180)
NavIndicator.Visible = false

-- ──────── CONTENT AREA ────────
local ContentArea = newFrame(Panel, {
	BG = Color3.fromRGB(0,0,0),
	BT = 1,
	Size = UDim2.new(1, -60, 1, -66),
	Position = UDim2.new(0, 60, 0, 66),
	ZIndex = 10,
})

-- ══════════════════════════════════════════
-- NAV SYSTEM
-- ══════════════════════════════════════════
local navButtons    = {}
local pages         = {}
local currentPage   = nil
local pageCallbacks = {}   -- [pageName] = function()  called on first/every switch

local function switchPage(name)
	if currentPage == name then return end
	currentPage = name
	for n, page in pairs(pages) do
		if n == name then
			page.Visible = true
			page.BackgroundTransparency = 1
			-- Slide-in from right
			page.Position = UDim2.new(0.08, 0, 0, 0)
			tween(page, { Position = UDim2.new(0,0,0,0) }, EZ_MED)
		else
			page.Visible = false
		end
	end
	for n, btn in pairs(navButtons) do
		if n == name then
			tween(btn.bg,   { BackgroundColor3 = T.ACCENT })
			tween(btn.icon, { TextColor3 = T.WHITE })
			tween(btn.lbl,  { TextTransparency = 0 })
			-- Move nav indicator
			NavIndicator.Visible = true
			tween(NavIndicator, { Position = UDim2.new(0, 0, 0, btn.bg.AbsolutePosition.Y - NavBar.AbsolutePosition.Y + 3) }, EZ_MED)
		else
			tween(btn.bg,   { BackgroundColor3 = T.SURFACE })
			tween(btn.icon, { TextColor3 = T.TEXT3 })
			tween(btn.lbl,  { TextTransparency = 1 })
		end
	end
	-- Fire page-specific callback (e.g. lazy init)
	if pageCallbacks[name] then
		pageCallbacks[name]()
	end
end

local navDefs = {
	{ name = "Home",     icon = "⌂",  order = 1 },
	{ name = "Players",  icon = "◉",  order = 2 },
	{ name = "Events",   icon = "★",  order = 3 },
	{ name = "Explorer", icon = "❧",  order = 4 },
	{ name = "GUIEdit",  icon = "✏",  order = 5 },
	{ name = "Settings", icon = "⚙",  order = 6 },
	{ name = "Display",  icon = "◫",  order = 7 },
	{ name = "Perf",     icon = "📊", order = 8 },   -- Performance Monitor
	{ name = "Console",  icon = "📝", order = 9 },   -- Console
	{ name = "Keybinds", icon = "⌨",  order = 10 },  -- Keybind Manager
}


for _, def in ipairs(navDefs) do
	local wrap = Instance.new("TextButton", NavBar)
	wrap.Size = UDim2.new(0, 44, 0, 54)
	wrap.BackgroundTransparency = 1
	wrap.Text = ""
	wrap.BorderSizePixel = 0
	wrap.ZIndex = 12
	wrap.LayoutOrder = def.order

	local bg = newFrame(wrap, {
		BG = T.SURFACE,
		Size = UDim2.new(0, 38, 0, 44),
		Position = UDim2.new(0.5, -19, 0, 4),
		ZIndex = 12,
	})
	corner(bg, 12)
	stroke(bg, T.BORDER, 1)

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
		Size = 6,
		AlignX = Enum.TextXAlignment.Center,
		Sz = UDim2.new(1, 0, 0, 11),
		Position = UDim2.new(0, 0, 1, -12),
		ZIndex = 13,
	})
	lbl.TextTransparency = 1

	navButtons[def.name] = { bg = bg, icon = iconLbl, lbl = lbl }

	wrap.MouseButton1Click:Connect(function() switchPage(def.name) end)
	wrap.MouseEnter:Connect(function()
		if currentPage ~= def.name then
			tween(bg, { BackgroundColor3 = T.SURFACE2 })
			tween(iconLbl, { TextColor3 = T.TEXT2 })
		end
	end)
	wrap.MouseLeave:Connect(function()
		if currentPage ~= def.name then
			tween(bg, { BackgroundColor3 = T.SURFACE })
			tween(iconLbl, { TextColor3 = T.TEXT3 })
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
	pad.PaddingBottom = UDim.new(0, 16)
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
	local wrap = newFrame(parent, {
		BG = Color3.fromRGB(0,0,0), BT = 1,
		Size = UDim2.new(1, 0, 0, 22), ZIndex = 12,
	})
	wrap.LayoutOrder = order or 0

	local line = newFrame(wrap, {
		BG = T.BORDER,
		Size = UDim2.new(1, -80, 0, 1),
		Position = UDim2.new(0, 76, 0.5, 0),
		ZIndex = 12,
	})

	local lbl = newLabel(wrap, {
		Text = "◈  " .. string.upper(text),
		Color = T.ACCENT,
		Size = 9,
		Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0, 72, 1, 0),
		ZIndex = 13,
	})
	local pad = Instance.new("UIPadding", lbl)
	pad.PaddingLeft = UDim.new(0, 2)
	return wrap
end

-- ══════════════════════════════════════════
-- TOGGLE
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
	track.Size = UDim2.new(0, 42, 0, 22)
	track.AnchorPoint = Vector2.new(1, 0.5)
	track.Position = UDim2.new(1, -12, 0.5, 0)
	track.BackgroundColor3 = default and T.ACCENT or T.SURFACE2
	track.Text = ""
	track.BorderSizePixel = 0
	track.ZIndex = 13
	corner(track, 12)
	stroke(track, T.BORDER, 1)
	if default then gradient(track, T.ACCENT, T.ACCENT2, 90) end

	local thumb = newFrame(track, {
		BG = T.WHITE,
		Size = UDim2.new(0, 16, 0, 16),
		Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
		ZIndex = 14,
	})
	corner(thumb, 9)

	local isOn = default
	local function toggle()
		isOn = not isOn
		if isOn then
			tween(track, { BackgroundColor3 = T.ACCENT })
			gradient(track, T.ACCENT, T.ACCENT2, 90)
		else
			tween(track, { BackgroundColor3 = T.SURFACE2 })
		end
		tween(thumb, { Position = isOn and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8) })
		if onChange then onChange(isOn) end
	end

	track.MouseButton1Click:Connect(toggle)
	return row
end

-- ══════════════════════════════════════════
-- SLIDER
-- ══════════════════════════════════════════
local function makeSlider(parent, labelText, min, max, default, onChange, order)
	local row = newFrame(parent, {
		BG = T.SURFACE,
		Size = UDim2.new(1, 0, 0, 58),
		ZIndex = 12,
	})
	corner(row, 10)
	stroke(row, T.BORDER, 1)
	row.LayoutOrder = order or 0

	newLabel(row, {
		Text = labelText,
		Color = T.TEXT,
		Size = 12,
		Sz = UDim2.new(1,-60,0,20),
		Position = UDim2.new(0,14,0,6),
		ZIndex = 13,
	})

	local valLbl = newLabel(row, {
		Text = tostring(default),
		Color = T.ACCENT,
		Size = 12,
		Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0,46,0,20),
		Position = UDim2.new(1,-58,0,6),
		AlignX = Enum.TextXAlignment.Right,
		ZIndex = 13,
	})

	local track = newFrame(row, {
		BG = T.SURFACE2,
		Size = UDim2.new(1,-28,0,5),
		Position = UDim2.new(0,14,0,38),
		ZIndex = 13,
	})
	corner(track, 4)
	stroke(track, T.BORDER, 1)

	local fill = newFrame(track, {
		BG = T.ACCENT,
		Size = UDim2.new((default-min)/(max-min),0,1,0),
		ZIndex = 14,
	})
	corner(fill, 4)
	gradient(fill, T.ACCENT, T.ACCENT2, 90)

	local thumb = Instance.new("TextButton", track)
	thumb.Size = UDim2.new(0,16,0,16)
	thumb.AnchorPoint = Vector2.new(0.5,0.5)
	thumb.Position = UDim2.new((default-min)/(max-min),0,0.5,0)
	thumb.BackgroundColor3 = T.WHITE
	thumb.Text = ""
	thumb.BorderSizePixel = 0
	thumb.ZIndex = 15
	corner(thumb, 9)
	stroke(thumb, T.ACCENT, 1)

	local drag = false
	thumb.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = true
			tween(thumb, { Size = UDim2.new(0,20,0,20) })
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = false
			tween(thumb, { Size = UDim2.new(0,16,0,16) })
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local relX = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
			local val  = math.floor(min + relX*(max-min))
			fill.Size  = UDim2.new(relX,0,1,0)
			thumb.Position = UDim2.new(relX,0,0.5,0)
			valLbl.Text = tostring(val)
			if onChange then onChange(val) end
		end
	end)

	return row, valLbl
end

-- ══════════════════════════════════════════
-- NOTIFICATION TOAST
-- ══════════════════════════════════════════
local toastQ = {}
local toastActive = false

local function showToast(text, kind)
	table.insert(toastQ, {text=text, kind=kind or "info"})
	if toastActive then return end
	toastActive = true
	task.spawn(function()
		while #toastQ > 0 do
			local t = table.remove(toastQ, 1)
			local col = t.kind=="ok" and T.SUCCESS or t.kind=="warn" and T.WARN or t.kind=="err" and T.DANGER or T.ACCENT

			local toast = newFrame(ScreenGui, {
				BG = T.SURFACE,
				Size = UDim2.new(0, 220, 0, 36),
				Position = UDim2.new(0.5,-110,1,10),
				ZIndex = 50,
			})
			corner(toast, 10)
			stroke(toast, col, 1)

			local bar = newFrame(toast, {
				BG = col,
				Size = UDim2.new(0,3,1,-8),
				Position = UDim2.new(0,0,0,4),
				ZIndex = 51,
			})
			corner(bar, 2)

			newLabel(toast, {
				Text = t.text,
				Color = T.TEXT,
				Size = 11,
				Sz = UDim2.new(1,-10,1,0),
				Position = UDim2.new(0,10,0,0),
				ZIndex = 51,
			})

			tween(toast, { Position = UDim2.new(0.5,-110,1,-50) }, EZ_SPR)
			task.wait(2.2)
			tween(toast, { Position = UDim2.new(0.5,-110,1,10), BackgroundTransparency=1 }, EZ_MED)
			task.wait(0.4)
			toast:Destroy()
			task.wait(0.1)
		end
		toastActive = false
	end)
end

-- ══════════════════════════════════════════
-- ★ PAGE: HOME
-- ══════════════════════════════════════════
local homePage, _ = makePage("Home")

do
	local character = Player.Character or Player.CharacterAdded:Wait()
	local humanoid  = character:WaitForChild("Humanoid")

	-- Profile card (glass)
	local profCard = makeCard(homePage, 92, 1)
	gradient(profCard, Color3.fromRGB(22,22,40), Color3.fromRGB(16,16,28), 135)

	local avatar = Instance.new("ImageLabel", profCard)
	avatar.Size = UDim2.new(0,58,0,58)
	avatar.Position = UDim2.new(0,14,0.5,-29)
	avatar.BackgroundColor3 = T.SURFACE2
	avatar.BorderSizePixel = 0
	avatar.ZIndex = 13
	avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..Player.UserId.."&width=150&height=150&format=png"
	corner(avatar, 29)
	stroke(avatar, T.ACCENT, 2)

	newLabel(profCard, {
		Text = Player.DisplayName,
		Color = T.TEXT, Size = 15,
		Font = Enum.Font.GothamBold,
		Sz = UDim2.new(1,-100,0,24),
		Position = UDim2.new(0,84,0,16), ZIndex=13, Truncate=true,
	})

	newLabel(profCard, {
		Text = "@"..Player.Name,
		Color = T.TEXT3, Size = 11,
		Sz = UDim2.new(1,-100,0,18),
		Position = UDim2.new(0,84,0,40), ZIndex=13, Truncate=true,
	})

	newLabel(profCard, {
		Text = "  "..Player.AccountAge.." ngày tuổi",
		Color = T.TEXT2, Size = 10,
		Sz = UDim2.new(0,120,0,16),
		Position = UDim2.new(0,84,0,60), ZIndex=13,
	})

	-- Stats grid
	local statsCard = makeCard(homePage, 110, 2)

	local statDefs = {
		{ icon="❤", label="HP",    col=0, row=0 },
		{ icon="⚡", label="Speed", col=1, row=0 },
		{ icon="📶", label="Ping",  col=0, row=1 },
		{ icon="🏳", label="Team",  col=1, row=1 },
	}
	local statValues = {}
	for _, sd in ipairs(statDefs) do
		local cell = newFrame(statsCard, {
			BG = T.SURFACE2,
			Size = UDim2.new(0,120,0,44),
			Position = UDim2.new(0,10+sd.col*130,0,10+sd.row*50),
			ZIndex = 13,
		})
		corner(cell, 9)
		stroke(cell, T.BORDER, 1)

		newLabel(cell, {Text=sd.icon,Color=T.TEXT3,Size=13,
			Sz=UDim2.new(0,22,1,0),Position=UDim2.new(0,8,0,0),
			AlignX=Enum.TextXAlignment.Center,ZIndex=14})
		newLabel(cell, {Text=sd.label,Color=T.TEXT3,Size=9,Font=Enum.Font.GothamBold,
			Sz=UDim2.new(1,-32,0,16),Position=UDim2.new(0,30,0,6),ZIndex=14})
		local valL = newLabel(cell, {Text="…",Color=T.TEXT,Size=12,Font=Enum.Font.GothamBold,
			Sz=UDim2.new(1,-32,0,18),Position=UDim2.new(0,30,0,22),ZIndex=14,Truncate=true})
		statValues[sd.label] = valL
	end

	local function refreshStats()
		statValues["HP"].Text    = math.floor(humanoid.Health).."/"..math.floor(humanoid.MaxHealth)
		statValues["Speed"].Text = math.floor(humanoid.WalkSpeed).." st/s"
		statValues["Team"].Text  = Player.Team and Player.Team.Name or "None"
	end
	refreshStats()
	humanoid.HealthChanged:Connect(refreshStats)

	task.spawn(function()
		while true do
			task.wait(2)
			local ok, p = pcall(function() return math.floor(Player:GetNetworkPing()*1000) end)
			if ok then statValues["Ping"].Text = p.." ms" end
		end
	end)
end

-- ══════════════════════════════════════════
-- ★ PAGE: PLAYERS
-- ══════════════════════════════════════════
local playersPage, _ = makePage("Players")

local espEnabled    = false
local espHighlights = {}

local function applyESP(p)
	if p == Player or not espEnabled then return end
	local char = p.Character
	if not char then return end
	if espHighlights[p] then espHighlights[p]:Destroy() end
	local hl = Instance.new("Highlight", char)
	hl.Name = "_NovaESP"
	local isEnemy = p.Team and Player.Team and p.Team ~= Player.Team
	hl.FillColor          = isEnemy and T.DANGER or T.ACCENT
	hl.OutlineColor       = isEnemy and Color3.fromRGB(255,100,100) or T.ACCENT2
	hl.FillTransparency   = 0.6
	hl.OutlineTransparency = 0
	hl.DepthMode          = Enum.HighlightDepthMode.AlwaysOnTop
	espHighlights[p]      = hl
end

local function removeESP(p)
	if espHighlights[p] then espHighlights[p]:Destroy(); espHighlights[p] = nil end
end

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
		Size = UDim2.new(1,0,0,62),
		ZIndex = 12,
	})
	row.LayoutOrder = order+10
	corner(row, 10)
	stroke(row, T.BORDER, 1)

	local av = Instance.new("ImageLabel", row)
	av.Size = UDim2.new(0,40,0,40)
	av.Position = UDim2.new(0,11,0.5,-20)
	av.BackgroundColor3 = T.SURFACE2
	av.BorderSizePixel = 0
	av.ZIndex = 13
	av.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..p.UserId.."&width=100&height=100&format=png"
	corner(av, 20)
	stroke(av, T.BORDER, 1)

	newLabel(row, {Text=p.DisplayName,Color=T.TEXT,Size=13,Font=Enum.Font.GothamBold,
		Sz=UDim2.new(1,-120,0,20),Position=UDim2.new(0,60,0,8),ZIndex=13,Truncate=true})
	newLabel(row, {Text="@"..p.Name,Color=T.TEXT3,Size=10,
		Sz=UDim2.new(1,-120,0,16),Position=UDim2.new(0,60,0,28),ZIndex=13,Truncate=true})

	local distLbl = newLabel(row, {
		Text="—",Color=T.SUCCESS,Size=11,Font=Enum.Font.GothamBold,
		Sz=UDim2.new(0,54,0,20),Position=UDim2.new(1,-62,0,8),
		AlignX=Enum.TextXAlignment.Right,ZIndex=13,
	})

	local hpBg = newFrame(row, {
		BG=T.SURFACE2,Size=UDim2.new(1,-72,0,4),
		Position=UDim2.new(0,60,0,52),ZIndex=13,
	})
	corner(hpBg, 3)
	local hpFill = newFrame(hpBg, {BG=T.SUCCESS,Size=UDim2.new(1,0,1,0),ZIndex=14})
	corner(hpFill, 3)

	playerRowMap[p] = { row=row, distLbl=distLbl, hpFill=hpFill }
end

local function rebuildPlayers()
	for _, data in pairs(playerRowMap) do
		if data.row and data.row.Parent then data.row:Destroy() end
	end
	playerRowMap = {}
	local i = 0
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= Player then i+=1; buildPlayerRow(p,i) end
	end
end
rebuildPlayers()

Players.PlayerAdded:Connect(function(p)
	task.wait(0.5); rebuildPlayers()
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

task.spawn(function()
	while true do
		task.wait(1)
		if pages["Players"].Visible then
			for p, data in pairs(playerRowMap) do
				local myChar = Player.Character
				local theirChar = p.Character
				if myChar and theirChar then
					local myRoot = myChar:FindFirstChild("HumanoidRootPart")
					local theirRoot = theirChar:FindFirstChild("HumanoidRootPart")
					if myRoot and theirRoot then
						data.distLbl.Text = math.floor((myRoot.Position-theirRoot.Position).Magnitude).." st"
					end
					local hum = theirChar:FindFirstChildOfClass("Humanoid")
					if hum and hum.MaxHealth>0 then
						local ratio = math.clamp(hum.Health/hum.MaxHealth,0,1)
						data.hpFill.Size = UDim2.new(ratio,0,1,0)
						tween(data.hpFill,{BackgroundColor3=hpColor(ratio)})
					end
				end
			end
		end
	end
end)

-- ══════════════════════════════════════════
-- ★ PAGE: SETTINGS  (v2 — Full Upgrade)
-- ══════════════════════════════════════════
local settingsPage, _ = makePage("Settings")

do
	local character = Player.Character or Player.CharacterAdded:Wait()
	local humanoid  = character:WaitForChild("Humanoid")

	-- Re-fetch character nếu respawn
	Player.CharacterAdded:Connect(function(char)
		character = char
		humanoid  = char:WaitForChild("Humanoid")
	end)

	local function getHum()
		return character and character:FindFirstChildOfClass("Humanoid")
	end

	-- ════════════════════════════════
	-- SECTION 1: CHARACTER MOVEMENT
	-- ════════════════════════════════
	makeSectionLabel(settingsPage, "Character — Movement", 1)

	local _, wsValLbl = makeSlider(settingsPage, "Walk Speed", 8, 150, 16, function(v)
		local h = getHum(); if h then h.WalkSpeed = v end
	end, 2)

	local _, jpValLbl = makeSlider(settingsPage, "Jump Power", 20, 300, 50, function(v)
		local h = getHum()
		if h then h.UseJumpPower = true; h.JumpPower = v end
	end, 3)

	makeSlider(settingsPage, "Jump Height", 1, 30, 7, function(v)
		local h = getHum()
		if h then h.UseJumpPower = false; h.JumpHeight = v end
	end, 4)

	makeSlider(settingsPage, "Hip Height", 0, 10, 0, function(v)
		local h = getHum()
		if h then h.HipHeight = v end
	end, 5)

	makeToggle(settingsPage, "Infinite Jump 🚀", false, function(on)
		if on then
			_G._NovaInfJump = UserInputService.JumpRequest:Connect(function()
				local h = getHum()
				if h and h:GetState() ~= Enum.HumanoidStateType.Dead then
					h:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
		else
			if _G._NovaInfJump then _G._NovaInfJump:Disconnect(); _G._NovaInfJump = nil end
		end
	end, 6)

	makeToggle(settingsPage, "No Fall Damage 🛡", false, function(on)
		_G._NovaNoFall = on
		if on then
			local h = getHum()
			if h then
				h.StateChanged:Connect(function(_, new)
					if new == Enum.HumanoidStateType.Landed and _G._NovaNoFall then
						-- override fall damage by keeping full hp
					end
				end)
			end
		end
	end, 7)

	makeToggle(settingsPage, "Fly Mode ✈", false, function(on)
		if on then
			local char = Player.Character
			if not char then return end
			local root = char:FindFirstChild("HumanoidRootPart")
			if not root then return end

			local bg = Instance.new("BodyGyro", root)
			bg.Name = "_NovaFlyGyro"
			bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
			bg.D = 100; bg.P = 10000

			local bv = Instance.new("BodyVelocity", root)
			bv.Name = "_NovaFlyVel"
			bv.MaxForce = Vector3.new(9e9,9e9,9e9)
			bv.Velocity = Vector3.zero

			local flySpeed = 40
			_G._NovaFlying = true

			_G._NovaFlyConn = RunService.RenderStepped:Connect(function()
				if not _G._NovaFlying then return end
				local cam = workspace.CurrentCamera
				local dir = Vector3.zero
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then
					dir = dir + cam.CFrame.LookVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then
					dir = dir - cam.CFrame.LookVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then
					dir = dir - cam.CFrame.RightVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then
					dir = dir + cam.CFrame.RightVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					dir = dir + Vector3.new(0,1,0)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
					dir = dir - Vector3.new(0,1,0)
				end
				bv.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
				bg.CFrame = cam.CFrame
			end)
			local h = getHum()
			if h then h.PlatformStand = true end
			showToast("Fly ON — WASD + Space/Ctrl", "ok")
		else
			_G._NovaFlying = false
			if _G._NovaFlyConn then _G._NovaFlyConn:Disconnect(); _G._NovaFlyConn = nil end
			local char = Player.Character
			if char then
				local root = char:FindFirstChild("HumanoidRootPart")
				if root then
					local bg2 = root:FindFirstChild("_NovaFlyGyro")
					local bv2 = root:FindFirstChild("_NovaFlyVel")
					if bg2 then bg2:Destroy() end
					if bv2 then bv2:Destroy() end
				end
				local h = getHum()
				if h then h.PlatformStand = false end
			end
			showToast("Fly OFF", "warn")
		end
	end, 8)

	makeSlider(settingsPage, "Fly Speed", 10, 200, 40, function(v)
		-- update fly speed dynamically
		local char = Player.Character
		if char then
			local root = char:FindFirstChild("HumanoidRootPart")
			local bv = root and root:FindFirstChild("_NovaFlyVel")
			if bv then bv.MaxForce = Vector3.new(9e9,9e9,9e9) end
		end
		-- stored in closure via upvalue trick
		if _G._NovaFlySpeed then _G._NovaFlySpeed = v end
	end, 9)

	-- ════════════════════════════════
	-- SECTION 2: CHARACTER APPEARANCE
	-- ════════════════════════════════
	makeSectionLabel(settingsPage, "Character — Appearance", 10)

	-- Transparency
	makeSlider(settingsPage, "Character Transparency", 0, 10, 0, function(v)
		local char = Player.Character
		if not char then return end
		local t = v / 10
		for _, p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
				p.LocalTransparencyModifier = t
			end
		end
	end, 11)

	-- Invisible (full)
	makeToggle(settingsPage, "Full Invisible 👻", false, function(on)
		local char = Player.Character
		if not char then return end
		for _, p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") or p:IsA("Decal") then
				pcall(function()
					p.LocalTransparencyModifier = on and 1 or 0
				end)
			end
			if p:IsA("Accessory") then p.Handle.LocalTransparencyModifier = on and 1 or 0 end
		end
	end, 12)

	-- Walk anim speed
	makeSlider(settingsPage, "Animation Speed", 1, 30, 10, function(v)
		local char = Player.Character
		if not char then return end
		local anim = char:FindFirstChildOfClass("Animator")
		if anim then
			for _, track in ipairs(anim:GetPlayingAnimationTracks()) do
				track:AdjustSpeed(v / 10)
			end
		end
	end, 13)

	-- ════════════════════════════════
	-- SECTION 3: CAMERA
	-- ════════════════════════════════
	makeSectionLabel(settingsPage, "Camera", 14)

	makeSlider(settingsPage, "Field of View", 30, 120,
		workspace.CurrentCamera and math.floor(workspace.CurrentCamera.FieldOfView) or 70,
		function(v)
			if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = v end
		end, 15)

	makeSlider(settingsPage, "Max Zoom Distance", 5, 200, 25, function(v)
		Player.CameraMaxZoomDistance = v
	end, 16)

	makeSlider(settingsPage, "Min Zoom Distance", 0, 50, 0, function(v)
		Player.CameraMinZoomDistance = v
	end, 17)

	-- Camera mode selector
	local camModeCard = makeCard(settingsPage, 46, 18)
	newLabel(camModeCard, {
		Text = "Camera Mode",
		Color = T.TEXT, Size = 12,
		Sz = UDim2.new(0,110,1,0),
		Position = UDim2.new(0,14,0,0), ZIndex=13,
	})

	local CAM_MODES = {
		{ label="Classic",   mode=Enum.CameraMode.Classic       },
		{ label="LockFirst", mode=Enum.CameraMode.LockFirstPerson },
	}
	for i, cm in ipairs(CAM_MODES) do
		local b = Instance.new("TextButton", camModeCard)
		b.Size = UDim2.new(0,76,0,28)
		b.Position = UDim2.new(0, 120+(i-1)*82, 0.5, -14)
		b.Text = cm.label
		b.TextSize = 10
		b.Font = Enum.Font.GothamBold
		b.TextColor3 = i==1 and T.WHITE or T.TEXT3
		b.BackgroundColor3 = i==1 and T.ACCENT or T.SURFACE2
		b.BorderSizePixel = 0; b.ZIndex = 13
		corner(b, 8); stroke(b, i==1 and T.ACCENT or T.BORDER, 1)

		b.MouseButton1Click:Connect(function()
			Player.CameraMode = cm.mode
			for j, other in ipairs(CAM_MODES) do
				local ob = camModeCard:GetChildren()[j+2] -- skip layout
			end
			-- Re-style all
			for j = 1, #CAM_MODES do
				local ob = camModeCard:FindFirstChild("camBtn"..j)
			end
			tween(b, {BackgroundColor3=T.ACCENT, TextColor3=T.WHITE})
			stroke(b, T.ACCENT, 1)
			showToast("Camera: "..cm.label, "ok")
		end)
	end

	-- Third person lock
	makeToggle(settingsPage, "Shift Lock (Mouse Lock) 🔒", false, function(on)
		Player.DevEnableMouseLock = on
	end, 19)

	-- ════════════════════════════════
	-- SECTION 4: PLAYER INFO OVERRIDES
	-- ════════════════════════════════
	makeSectionLabel(settingsPage, "Player Overrides", 20)

	-- Auto-heal
	makeToggle(settingsPage, "Auto Heal (1 HP/s) ❤", false, function(on)
		if on then
			_G._NovaHealConn = RunService.Heartbeat:Connect(function(dt)
				local h = getHum()
				if h and h.Health < h.MaxHealth then
					h.Health = math.min(h.Health + dt * 1, h.MaxHealth)
				end
			end)
		else
			if _G._NovaHealConn then _G._NovaHealConn:Disconnect(); _G._NovaHealConn=nil end
		end
	end, 21)

	makeSlider(settingsPage, "Heal Rate (HP/s)", 1, 50, 1, function(v)
		-- Will be picked up by any existing heal loop via global
		_G._NovaHealRate = v
	end, 22)

	-- God Mode
	makeToggle(settingsPage, "God Mode (MaxHealth) ⚡", false, function(on)
		local h = getHum()
		if h then
			if on then
				h.MaxHealth = math.huge
				h.Health = math.huge
				_G._NovaGodConn = h.HealthChanged:Connect(function(hp)
					if _G._NovaGodOn and hp < math.huge then
						h.Health = math.huge
					end
				end)
				_G._NovaGodOn = true
			else
				_G._NovaGodOn = false
				if _G._NovaGodConn then _G._NovaGodConn:Disconnect(); _G._NovaGodConn=nil end
				h.MaxHealth = 100; h.Health = 100
			end
		end
	end, 23)

	-- Anti-AFK
	makeToggle(settingsPage, "Anti-AFK 🕐", false, function(on)
		if on then
			_G._NovaAFKConn = RunService.Heartbeat:Connect(function()
				if _G._NovaAFKOn then
					local vuw = VirtualUser
					if vuw then pcall(function() vuw:CaptureController() vuw:ClickButton2(Vector2.new()) end) end
				end
			end)
			_G._NovaAFKOn = true

			-- Simpler fallback: fire fake input every 15s
			task.spawn(function()
				while _G._NovaAFKOn do
					task.wait(15)
					if not _G._NovaAFKOn then break end
					pcall(function()
						local vu = game:GetService("VirtualUser")
						vu:CaptureController()
						vu:ClickButton2(Vector2.new())
					end)
				end
			end)
			showToast("Anti-AFK ON", "ok")
		else
			_G._NovaAFKOn = false
			if _G._NovaAFKConn then _G._NovaAFKConn:Disconnect(); _G._NovaAFKConn=nil end
			showToast("Anti-AFK OFF", "warn")
		end
	end, 24)

	-- ════════════════════════════════
	-- SECTION 5: UI PREFERENCES
	-- ════════════════════════════════
	makeSectionLabel(settingsPage, "UI Preferences", 25)

	-- Panel opacity
	makeSlider(settingsPage, "Panel Opacity", 1, 10, 10, function(v)
		local t = 1 - (v/10)
		tween(Panel, {BackgroundTransparency = t})
	end, 26)

	-- Toggle button size
	makeSlider(settingsPage, "Toggle Button Size", 30, 70, 46, function(v)
		ToggleBtn.Size = UDim2.new(0,v,0,v)
		Ring.Size = UDim2.new(0,v,0,v)
	end, 27)

	-- Accent color picker (4 presets)
	local accentCard = makeCard(settingsPage, 52, 28)
	newLabel(accentCard, {
		Text = "Accent Color",
		Color = T.TEXT, Size = 12,
		Sz = UDim2.new(0,110,0,20),
		Position = UDim2.new(0,14,0,6), ZIndex=13,
	})
	newLabel(accentCard, {
		Text = "Màu nhấn của UI",
		Color = T.TEXT3, Size = 9,
		Sz = UDim2.new(0,120,0,16),
		Position = UDim2.new(0,14,0,24), ZIndex=13,
	})

	local ACCENT_PRESETS = {
		{ color=Color3.fromRGB(99,102,241),  name="Indigo" },
		{ color=Color3.fromRGB(239,68,68),   name="Red"    },
		{ color=Color3.fromRGB(34,197,94),   name="Green"  },
		{ color=Color3.fromRGB(251,191,36),  name="Gold"   },
		{ color=Color3.fromRGB(236,72,153),  name="Pink"   },
	}

	for i, ap in ipairs(ACCENT_PRESETS) do
		local swatch = Instance.new("TextButton", accentCard)
		swatch.Size = UDim2.new(0,26,0,26)
		swatch.Position = UDim2.new(0, 140+(i-1)*32, 0.5, -13)
		swatch.BackgroundColor3 = ap.color
		swatch.Text = ""
		swatch.BorderSizePixel = 0
		swatch.ZIndex = 13
		corner(swatch, 13)
		stroke(swatch, Color3.new(1,1,1), 0, 0.7)

		swatch.MouseButton1Click:Connect(function()
			-- Update global accent color
			T.ACCENT = ap.color
			-- Re-tween key elements
			tween(PanelAccentLine, {BackgroundColor3=ap.color})
			tween(HeaderDot,       {BackgroundColor3=ap.color})
			tween(NavIndicator,    {BackgroundColor3=ap.color})
			tween(ToggleBtn,       {BackgroundColor3=ap.color})
			showToast("Accent: "..ap.name, "ok")
		end)
		swatch.MouseEnter:Connect(function()
			tween(swatch, {Size=UDim2.new(0,30,0,30), Position=UDim2.new(0,138+(i-1)*32,0.5,-15)})
		end)
		swatch.MouseLeave:Connect(function()
			tween(swatch, {Size=UDim2.new(0,26,0,26), Position=UDim2.new(0,140+(i-1)*32,0.5,-13)})
		end)
	end

	-- Notification toggle
	makeToggle(settingsPage, "Toast Notifications 🔔", true, function(on)
		_G._NovaToastEnabled = on
	end, 29)

	-- ════════════════════════════════
	-- SECTION 6: ABOUT / RESET
	-- ════════════════════════════════
	makeSectionLabel(settingsPage, "About & Reset", 30)

	-- About card
	local aboutCard = makeCard(settingsPage, 72, 31)
	gradient(aboutCard, Color3.fromRGB(16,16,32), Color3.fromRGB(10,10,20), 135)

	newLabel(aboutCard, {
		Text = "NOVA UI  v2.1",
		Color = T.WHITE, Size = 14, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(1,-20,0,22),
		Position = UDim2.new(0,14,0,8), ZIndex=13,
	})
	newLabel(aboutCard, {
		Text = "Glassmorphism executor interface",
		Color = T.TEXT3, Size = 10,
		Sz = UDim2.new(1,-20,0,18),
		Position = UDim2.new(0,14,0,28), ZIndex=13,
	})
	newLabel(aboutCard, {
		Text = "Remote Spy  ·  GUI Editor  ·  Explorer  ·  Console  ·  Keybinds  ·  Perf Monitor",
		Color = T.ACCENT, Size = 8,
		Sz = UDim2.new(1,-20,0,16),
		Position = UDim2.new(0,14,0,50), ZIndex=13,
	})

	-- Reset all settings
	local resetAllBtn = Instance.new("TextButton", settingsPage)
	resetAllBtn.Size = UDim2.new(1,0,0,40)
	resetAllBtn.BackgroundColor3 = Color3.fromRGB(38,18,18)
	resetAllBtn.TextColor3 = T.DANGER
	resetAllBtn.Text = "↺  Reset tất cả về mặc định"
	resetAllBtn.TextSize = 12
	resetAllBtn.Font = Enum.Font.GothamBold
	resetAllBtn.BorderSizePixel = 0
	resetAllBtn.ZIndex = 12
	resetAllBtn.LayoutOrder = 32
	corner(resetAllBtn, 10)
	stroke(resetAllBtn, T.DANGER, 1)

	resetAllBtn.MouseEnter:Connect(function()
		tween(resetAllBtn, {BackgroundColor3=Color3.fromRGB(70,25,25)})
	end)
	resetAllBtn.MouseLeave:Connect(function()
		tween(resetAllBtn, {BackgroundColor3=Color3.fromRGB(38,18,18)})
	end)
	resetAllBtn.MouseButton1Click:Connect(function()
		-- Movement
		local h = getHum()
		if h then
			h.WalkSpeed = 16; h.JumpPower = 50
			h.UseJumpPower = false; h.HipHeight = 0
			h.PlatformStand = false
		end

		-- Kill active systems
		_G._NovaFlying = false
		_G._NovaGodOn  = false
		_G._NovaAFKOn  = false

		for _, k in ipairs{"_NovaFlyConn","_NovaHealConn","_NovaGodConn","_NovaAFKConn","_NovaInfJump"} do
			if _G[k] then pcall(function() _G[k]:Disconnect() end); _G[k]=nil end
		end

		-- Remove fly forces
		local char = Player.Character
		if char then
			local root = char:FindFirstChild("HumanoidRootPart")
			if root then
				for _, c in ipairs(root:GetChildren()) do
					if c.Name == "_NovaFlyGyro" or c.Name == "_NovaFlyVel" then c:Destroy() end
				end
			end
			-- Reset transparency
			for _, p in ipairs(char:GetDescendants()) do
				if p:IsA("BasePart") then p.LocalTransparencyModifier = 0 end
			end
		end

		-- Camera
		if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = 70 end
		Player.CameraMaxZoomDistance = 25
		Player.CameraMinZoomDistance = 0

		-- Panel
		tween(Panel, {BackgroundTransparency=0})
		ToggleBtn.Size = UDim2.new(0,46,0,46)
		Ring.Size = UDim2.new(0,46,0,46)

		showToast("✓ Đã reset toàn bộ Settings", "ok")
		resetAllBtn.Text = "✓  Done"
		task.delay(2, function() resetAllBtn.Text = "↺  Reset tất cả về mặc định" end)
	end)
end

-- ══════════════════════════════════════════
-- ★ PAGE: DISPLAY  v3  (Upgrade đầy đủ)
--   + Nút "Máy Yếu" nổi bật
--   + Post-FX grid card đẹp hơn
--   + FX toggle cải tiến
--   + Weather / Camera effects gộp gọn
-- ══════════════════════════════════════════
local displayPage, _ = makePage("Display")

do
	-- ════════════════════════════════════════
	-- HELPERS: Apply/Remove hiệu ứng
	-- ════════════════════════════════════════
	local function setBloom(on, intensity)
		local b = Lighting:FindFirstChildOfClass("BloomEffect")
		if on then
			if not b then b = Instance.new("BloomEffect", Lighting) end
			b.Enabled = true
			if intensity then b.Intensity = intensity end
		else
			if b then b.Enabled = false end
		end
	end

	local function setSunRays(on)
		local s = Lighting:FindFirstChildOfClass("SunRaysEffect")
		if on then
			if not s then s = Instance.new("SunRaysEffect", Lighting) end
			s.Enabled = true
		else
			if s then s.Enabled = false end
		end
	end

	local function setColorCorrect(on, sat, con, bright)
		local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
		if on then
			if not cc then cc = Instance.new("ColorCorrectionEffect", Lighting) end
			cc.Enabled = true
			if sat    then cc.Saturation = sat end
			if con    then cc.Contrast = con end
			if bright then cc.Brightness = bright end
		else
			if cc then cc.Enabled = false end
		end
	end

	local function setAtmosphere(density, offset)
		local a = Lighting:FindFirstChildOfClass("Atmosphere")
		if a then a.Density = density; a.Offset = offset or 0 end
	end

	local function setDOF(val)
		local d = Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
		if val > 0 then
			if not d then d = Instance.new("DepthOfFieldEffect", Lighting) end
			d.Enabled = true
			d.FocusDistance = val * 8
			d.InFocusRadius = 18
			d.NearIntensity = val / 20
			d.FarIntensity  = val / 20
		else
			if d then d.Enabled = false end
		end
	end

	local function setParticles(on)
		pcall(function()
			for _, d in ipairs(workspace:GetDescendants()) do
				if d:IsA("ParticleEmitter") or d:IsA("Smoke")
					or d:IsA("Fire") or d:IsA("Sparkles") then
					d.Enabled = on
				end
			end
		end)
	end

	local function setDecals(on)
		pcall(function()
			for _, d in ipairs(workspace:GetDescendants()) do
				if d:IsA("Decal") or d:IsA("Texture") then
					d.Transparency = on and 0 or 1
				end
			end
		end)
	end

	local function applySkyById(assetId)
		local s = Lighting:FindFirstChildOfClass("Sky")
		if not s then s = Instance.new("Sky", Lighting) end
		s.SkyboxBk = assetId; s.SkyboxFt = assetId
		s.SkyboxLf = assetId; s.SkyboxRt = assetId
		s.SkyboxUp = assetId; s.SkyboxDn = assetId
	end

	-- ════════════════════════════════════════
	-- PRESET CONFIG TABLE
	-- ════════════════════════════════════════
	local PRESETS = {
		{
			name = "Ultra Low", icon = "🔋", fps = "~60+ FPS",
			color = T.SUCCESS,
			fn = function()
				Lighting.Brightness    = 1.5
				Lighting.FogEnd        = 250
				Lighting.FogStart      = 200
				Lighting.GlobalShadows = false
				setBloom(false); setSunRays(false); setColorCorrect(false)
				setAtmosphere(0, 0); setDOF(0); setParticles(false); setDecals(false)
			end,
		},
		{
			name = "Low", icon = "📉", fps = "~50 FPS",
			color = T.WARN,
			fn = function()
				Lighting.Brightness    = 3
				Lighting.FogEnd        = 600
				Lighting.FogStart      = 500
				Lighting.GlobalShadows = false
				setBloom(false); setSunRays(false); setColorCorrect(true)
				setAtmosphere(0.15, 0); setDOF(0); setParticles(true); setDecals(false)
			end,
		},
		{
			name = "Medium", icon = "⚖", fps = "~40 FPS",
			color = T.ACCENT3,
			fn = function()
				Lighting.Brightness    = 5
				Lighting.FogEnd        = 1000
				Lighting.FogStart      = 850
				Lighting.GlobalShadows = true
				setBloom(false); setSunRays(true); setColorCorrect(true)
				setAtmosphere(0.35, 0); setDOF(0); setParticles(true); setDecals(true)
			end,
		},
		{
			name = "High", icon = "🔥", fps = "~30 FPS",
			color = T.ACCENT,
			fn = function()
				Lighting.Brightness    = 7
				Lighting.FogEnd        = 1500
				Lighting.FogStart      = 1275
				Lighting.GlobalShadows = true
				setBloom(true, 0.6); setSunRays(true); setColorCorrect(true)
				setAtmosphere(0.55, 0.05); setDOF(0); setParticles(true); setDecals(true)
			end,
		},
		{
			name = "Ultra", icon = "✨", fps = "Max",
			color = T.ACCENT2,
			fn = function()
				Lighting.Brightness    = 10
				Lighting.FogEnd        = 2000
				Lighting.FogStart      = 1700
				Lighting.GlobalShadows = true
				setBloom(true, 1.0); setSunRays(true); setColorCorrect(true)
				setAtmosphere(0.75, 0.08); setDOF(8); setParticles(true); setDecals(true)
			end,
		},
	}

	-- ════════════════════════════════════════
	-- POTATO MODE CONFIG  (máy yếu)
	-- ════════════════════════════════════════
	local POTATO_CONFIG = {
		brightness    = 1,
		fogEnd        = 200,
		fogStart      = 170,
		shadows       = false,
		bloom         = false,
		sunrays       = false,
		colorcorrect  = false,
		atmosphere_d  = 0,
		atmosphere_o  = 0,
		dof           = 0,
		particles     = false,
		decals        = false,
	}

	local potatoActive = false

	local function applyPotatoMode(on)
		potatoActive = on
		if on then
			Lighting.Brightness    = POTATO_CONFIG.brightness
			Lighting.FogEnd        = POTATO_CONFIG.fogEnd
			Lighting.FogStart      = POTATO_CONFIG.fogStart
			Lighting.GlobalShadows = false
			setBloom(false); setSunRays(false); setColorCorrect(false)
			setAtmosphere(0, 0); setDOF(0); setParticles(false); setDecals(false)
			-- Tắt sky tốn tài nguyên
			pcall(function()
				local sky = Lighting:FindFirstChildOfClass("Sky")
				if sky then sky:Destroy() end
			end)
		else
			-- Về Medium khi tắt potato
			PRESETS[3].fn()
			showToast("Potato OFF — reset về Medium", "warn")
		end
	end

	-- ════════════════════════════════════════
	-- ► BANNER: MÁY YẾU  (nổi bật nhất trang)
	-- ════════════════════════════════════════
	local potatoBanner = newFrame(displayPage, {
		BG    = Color3.fromRGB(10, 32, 18),
		Size  = UDim2.new(1, 0, 0, 64),
		ZIndex = 12,
	})
	potatoBanner.LayoutOrder = 0
	corner(potatoBanner, 14)
	stroke(potatoBanner, T.SUCCESS, 2)

	-- Gradient background của banner
	gradient(potatoBanner,
		Color3.fromRGB(12, 40, 22),
		Color3.fromRGB(8, 20, 14), 135)

	-- Icon circle
	local potatoIcon = newFrame(potatoBanner, {
		BG   = T.SUCCESS,
		Size = UDim2.new(0, 40, 0, 40),
		Position = UDim2.new(0, 14, 0.5, -20),
		ZIndex = 13,
	})
	corner(potatoIcon, 12)
	newLabel(potatoIcon, {
		Text = "🖥", Size = 20,
		AlignX = Enum.TextXAlignment.Center,
		Sz = UDim2.new(1, 0, 1, 0), ZIndex = 14,
	})

	-- Texts
	newLabel(potatoBanner, {
		Text = "Chế Độ Máy Yếu",
		Color = T.SUCCESS, Size = 14, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0, 200, 0, 22),
		Position = UDim2.new(0, 66, 0, 10), ZIndex = 13,
	})
	newLabel(potatoBanner, {
		Text = "Tắt toàn bộ hiệu ứng nặng — tối ưu FPS tối đa",
		Color = T.TEXT3, Size = 10,
		Sz = UDim2.new(0, 200, 0, 16),
		Position = UDim2.new(0, 66, 0, 33), ZIndex = 13,
	})

	-- ON/OFF badge
	local potatoBadge = Instance.new("TextButton", potatoBanner)
	potatoBadge.Size = UDim2.new(0, 66, 0, 28)
	potatoBadge.AnchorPoint = Vector2.new(1, 0.5)
	potatoBadge.Position = UDim2.new(1, -12, 0.5, 0)
	potatoBadge.Text = "BẬT"
	potatoBadge.TextSize = 11
	potatoBadge.Font = Enum.Font.GothamBold
	potatoBadge.TextColor3 = T.BG
	potatoBadge.BackgroundColor3 = T.SUCCESS
	potatoBadge.BorderSizePixel = 0
	potatoBadge.ZIndex = 13
	corner(potatoBadge, 9)

	local function updatePotatoBadge()
		if potatoActive then
			potatoBadge.Text = "ĐANG BẬT"
			tween(potatoBadge, { BackgroundColor3 = T.SUCCESS })
			tween(potatoBanner, { BackgroundColor3 = Color3.fromRGB(10, 38, 20) })
			stroke(potatoBanner, T.SUCCESS, 2)
		else
			potatoBadge.Text = "BẬT"
			tween(potatoBadge, { BackgroundColor3 = Color3.fromRGB(30, 30, 50) })
			tween(potatoBanner, { BackgroundColor3 = Color3.fromRGB(12, 12, 22) })
			stroke(potatoBanner, T.TEXT3, 1)
		end
	end
	updatePotatoBadge()

	potatoBadge.MouseButton1Click:Connect(function()
		applyPotatoMode(not potatoActive)
		updatePotatoBadge()
		if potatoActive then
			showToast("🖥 Chế độ máy yếu BẬT — FPS tối đa!", "ok")
		end
		-- Reset preset highlights
		for _, pb in ipairs(presetBtnsRef) do
			tween(pb.btn, {BackgroundColor3=T.SURFACE2, TextColor3=T.TEXT3})
		end
	end)

	-- Click vào banner cũng toggle
	potatoBanner.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			applyPotatoMode(not potatoActive)
			updatePotatoBadge()
			if potatoActive then showToast("🖥 Máy yếu BẬT!", "ok") end
		end
	end)

	-- ════════════════════════════════════════
	-- SECTION: PRESETS (grid 5 nút)
	-- ════════════════════════════════════════
	makeSectionLabel(displayPage, "Graphics Presets", 1)

	local presetCard = makeCard(displayPage, 66, 2)
	gradient(presetCard, Color3.fromRGB(18, 18, 34), Color3.fromRGB(13, 13, 22), 135)

	local selectedPreset = nil
	local presetBtnsRef  = {}

	for i, preset in ipairs(PRESETS) do
		local btn = Instance.new("TextButton", presetCard)
		btn.Size     = UDim2.new(0, 54, 0, 46)
		btn.Position = UDim2.new(0, 4 + (i-1)*58, 0.5, -23)
		btn.Text     = preset.icon.."\n"..preset.name
		btn.TextSize = 8
		btn.Font     = Enum.Font.GothamBold
		btn.TextColor3 = T.TEXT3
		btn.BackgroundColor3 = T.SURFACE2
		btn.BorderSizePixel = 0
		btn.ZIndex = 13
		corner(btn, 10)
		stroke(btn, T.BORDER, 1)

		-- FPS label dưới
		local fpsLbl = newLabel(btn, {
			Text = preset.fps,
			Color = T.TEXT3, Size = 7,
			Sz = UDim2.new(1,0,0,10),
			Position = UDim2.new(0,0,1,-10),
			AlignX = Enum.TextXAlignment.Center,
			ZIndex = 14,
		})

		presetBtnsRef[i] = { btn = btn, fpsLbl = fpsLbl }

		btn.MouseButton1Click:Connect(function()
			potatoActive = false
			updatePotatoBadge()
			selectedPreset = i
			for j, pb in ipairs(presetBtnsRef) do
				if j == i then
					tween(pb.btn, { BackgroundColor3 = preset.color, TextColor3 = T.BG })
					stroke(pb.btn, preset.color, 2)
					tween(pb.fpsLbl, { TextColor3 = T.BG })
				else
					tween(pb.btn, { BackgroundColor3 = T.SURFACE2, TextColor3 = T.TEXT3 })
					stroke(pb.btn, T.BORDER, 1)
					tween(pb.fpsLbl, { TextColor3 = T.TEXT3 })
				end
			end
			preset.fn()
			showToast("Preset: "..preset.name.." ✓", "ok")
		end)
		btn.MouseEnter:Connect(function()
			if selectedPreset ~= i then tween(btn, {BackgroundColor3=T.GLASS}) end
		end)
		btn.MouseLeave:Connect(function()
			if selectedPreset ~= i then tween(btn, {BackgroundColor3=T.SURFACE2}) end
		end)
	end

	-- ════════════════════════════════════════
	-- SECTION: LIGHTING SLIDERS
	-- ════════════════════════════════════════
	makeSectionLabel(displayPage, "Lighting", 3)

	makeSlider(displayPage, "Brightness", 0, 20,
		math.clamp(math.floor(Lighting.Brightness * 2), 0, 20),
		function(v) Lighting.Brightness = v / 2 end, 4)

	makeSlider(displayPage, "Fog Distance", 100, 2000, 1000, function(v)
		Lighting.FogEnd   = v
		Lighting.FogStart = math.floor(v * 0.85)
	end, 5)

	makeSlider(displayPage, "Ambient (Indoor)", 0, 10, 5, function(v)
		local c = Color3.fromRGB(v*14, v*14, v*20)
		Lighting.Ambient = c; Lighting.OutdoorAmbient = c
	end, 6)

	makeToggle(displayPage, "Global Shadows  (nặng trên máy yếu ⚠)", Lighting.GlobalShadows, function(on)
		Lighting.GlobalShadows = on
	end, 7)

	-- ════════════════════════════════════════
	-- SECTION: POST-PROCESSING  (card grid đẹp)
	-- ════════════════════════════════════════
	makeSectionLabel(displayPage, "Post-Processing", 8)

	-- Dùng grid 2 cột thay vì list thẳng
	local FX_DEFS = {
		{
			icon = "✨", name = "Bloom",
			sub  = "Ánh sáng phát sáng",
			get  = function() local b = Lighting:FindFirstChildOfClass("BloomEffect"); return b and b.Enabled end,
			set  = function(on) setBloom(on) end,
		},
		{
			icon = "☀", name = "Sun Rays",
			sub  = "Tia nắng từ mặt trời",
			get  = function() local s = Lighting:FindFirstChildOfClass("SunRaysEffect"); return s and s.Enabled end,
			set  = function(on) setSunRays(on) end,
		},
		{
			icon = "🎨", name = "Color Correction",
			sub  = "Cân chỉnh màu sắc",
			get  = function() local c = Lighting:FindFirstChildOfClass("ColorCorrectionEffect"); return c and c.Enabled or true end,
			set  = function(on) setColorCorrect(on) end,
		},
		{
			icon = "📷", name = "Depth of Field",
			sub  = "Blur hậu cảnh",
			get  = function() local d = Lighting:FindFirstChildOfClass("DepthOfFieldEffect"); return d and d.Enabled end,
			set  = function(on) setDOF(on and 8 or 0) end,
		},
		{
			icon = "🌫", name = "Atmosphere",
			sub  = "Bầu khí quyển",
			get  = function() local a = Lighting:FindFirstChildOfClass("Atmosphere"); return a ~= nil end,
			set  = function(on) setAtmosphere(on and 0.4 or 0, on and 0.06 or 0) end,
		},
		{
			icon = "🔥", name = "Particles",
			sub  = "Lửa, khói, tia sáng",
			get  = function() return true end,
			set  = function(on) setParticles(on) end,
		},
	}

	-- Container grid tự động
	local fxGrid = newFrame(displayPage, {
		BG = Color3.fromRGB(0,0,0), BT = 1,
		Size = UDim2.new(1, 0, 0, 10), ZIndex = 12,
	})
	fxGrid.LayoutOrder = 9
	fxGrid.AutomaticSize = Enum.AutomaticSize.Y

	local fxGridLayout = Instance.new("UIGridLayout", fxGrid)
	fxGridLayout.CellSize = UDim2.new(0.5, -5, 0, 48)
	fxGridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
	fxGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local fxPad = Instance.new("UIPadding", fxGrid)
	fxPad.PaddingLeft = UDim.new(0, 0)
	fxPad.PaddingRight = UDim.new(0, 0)

	for i, fx in ipairs(FX_DEFS) do
		local cell = newFrame(fxGrid, {
			BG = T.SURFACE,
			Size = UDim2.new(1, 0, 0, 48), ZIndex = 12,
		})
		cell.LayoutOrder = i
		corner(cell, 10)
		stroke(cell, T.BORDER, 1)

		-- Icon box
		local iconBox = newFrame(cell, {
			BG = T.SURFACE2,
			Size = UDim2.new(0, 32, 0, 32),
			Position = UDim2.new(0, 10, 0.5, -16), ZIndex = 13,
		})
		corner(iconBox, 9)
		stroke(iconBox, T.BORDER, 1)
		newLabel(iconBox, {
			Text = fx.icon, Size = 15,
			AlignX = Enum.TextXAlignment.Center,
			Sz = UDim2.new(1, 0, 1, 0), ZIndex = 14,
		})

		-- Name + sub
		newLabel(cell, {
			Text = fx.name,
			Color = T.TEXT, Size = 11, Font = Enum.Font.GothamBold,
			Sz = UDim2.new(0, 80, 0, 16),
			Position = UDim2.new(0, 50, 0, 8), ZIndex = 13, Truncate = true,
		})
		newLabel(cell, {
			Text = fx.sub,
			Color = T.TEXT3, Size = 9,
			Sz = UDim2.new(0, 80, 0, 14),
			Position = UDim2.new(0, 50, 0, 26), ZIndex = 13, Truncate = true,
		})

		-- Toggle mini
		local curVal = fx.get() ~= false
		local track = Instance.new("TextButton", cell)
		track.Size = UDim2.new(0, 34, 0, 18)
		track.AnchorPoint = Vector2.new(1, 0.5)
		track.Position = UDim2.new(1, -8, 0.5, 0)
		track.BackgroundColor3 = curVal and T.SUCCESS or T.SURFACE2
		track.Text = ""; track.BorderSizePixel = 0; track.ZIndex = 13
		corner(track, 10); stroke(track, T.BORDER, 1)

		local thumb = newFrame(track, {
			BG = T.WHITE,
			Size = UDim2.new(0, 12, 0, 12),
			Position = curVal and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6),
			ZIndex = 14,
		})
		corner(thumb, 7)

		local isOn = curVal
		track.MouseButton1Click:Connect(function()
			isOn = not isOn
			tween(track, { BackgroundColor3 = isOn and T.SUCCESS or T.SURFACE2 })
			tween(thumb, { Position = isOn and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6) })
			fx.set(isOn)
			-- Tắt potato nếu user chỉnh tay
			if isOn and potatoActive then
				potatoActive = false; updatePotatoBadge()
			end
		end)
	end

	-- Saturation / Contrast sliders (sau grid)
	makeSlider(displayPage, "Saturation", -10, 10, 0, function(v)
		local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
		if not cc then cc = Instance.new("ColorCorrectionEffect", Lighting) end
		cc.Saturation = v / 5; cc.Enabled = true
	end, 10)

	makeSlider(displayPage, "Contrast", -10, 10, 0, function(v)
		local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
		if not cc then cc = Instance.new("ColorCorrectionEffect", Lighting) end
		cc.Contrast = v / 5; cc.Enabled = true
	end, 11)

	makeSlider(displayPage, "Bloom Intensity", 0, 20, 7, function(v)
		local b = Lighting:FindFirstChildOfClass("BloomEffect")
		if b then b.Intensity = v / 10 end
	end, 12)

	-- ════════════════════════════════════════
	-- SECTION: CAMERA
	-- ════════════════════════════════════════
	makeSectionLabel(displayPage, "Camera", 13)

	makeSlider(displayPage, "Field of View", 30, 120,
		workspace.CurrentCamera and math.floor(workspace.CurrentCamera.FieldOfView) or 70,
		function(v)
			if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = v end
		end, 14)

	makeSlider(displayPage, "Max Zoom", 5, 100, 25, function(v)
		Player.CameraMaxZoomDistance = v
	end, 15)

	makeSlider(displayPage, "Min Zoom", 0, 30, 0, function(v)
		Player.CameraMinZoomDistance = v
	end, 16)

	makeSlider(displayPage, "Depth of Field", 0, 20, 0, function(v) setDOF(v) end, 17)

	-- ════════════════════════════════════════
	-- SECTION: ATMOSPHERE
	-- ════════════════════════════════════════
	makeSectionLabel(displayPage, "Atmosphere & Fog", 18)

	local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
	makeSlider(displayPage, "Atmosphere Density", 0, 10,
		atmo and math.floor(atmo.Density * 10) or 4,
		function(v)
			local a = Lighting:FindFirstChildOfClass("Atmosphere")
			if a then a.Density = v / 10 end
		end, 19)

	makeSlider(displayPage, "Atmosphere Offset", 0, 10,
		atmo and math.floor((atmo.Offset or 0) * 100) or 6,
		function(v)
			local a = Lighting:FindFirstChildOfClass("Atmosphere")
			if a then a.Offset = v / 100 end
		end, 20)

	-- ════════════════════════════════════════
	-- SECTION: SKY CHANGER
	-- ════════════════════════════════════════
	makeSectionLabel(displayPage, "Sky Changer", 21)

	local SKIES = {
		{ name="Default", icon="☁", color=T.TEXT3,  ids=nil,
			bright=nil, fogColor=nil, fogEnd=nil, ambient=nil },
		{ name="Sunset",  icon="🌅", color=Color3.fromRGB(251,150,60),
			ids="159454296", bright=3, fogColor=Color3.fromRGB(255,160,80),
			fogEnd=800, ambient=Color3.fromRGB(90,50,30) },
		{ name="Night",   icon="🌙", color=Color3.fromRGB(96,165,250),
			ids="159455020", bright=0.5, fogColor=Color3.fromRGB(10,10,30),
			fogEnd=500, ambient=Color3.fromRGB(15,15,40) },
		{ name="Storm",   icon="⛈", color=Color3.fromRGB(130,130,160),
			ids="159455145", bright=1.5, fogColor=Color3.fromRGB(60,65,80),
			fogEnd=400, ambient=Color3.fromRGB(40,45,55) },
		{ name="Space",   icon="🚀", color=Color3.fromRGB(167,139,250),
			ids="159455265", bright=0.2, fogColor=Color3.fromRGB(0,0,10),
			fogEnd=300, ambient=Color3.fromRGB(5,5,20) },
		{ name="Neon",    icon="🌆", color=Color3.fromRGB(255,0,200),
			ids="6444719050", bright=2, fogColor=Color3.fromRGB(120,0,200),
			fogEnd=600, ambient=Color3.fromRGB(60,0,100) },
	}

	local skyCard = makeCard(displayPage, 116, 22)
	gradient(skyCard, Color3.fromRGB(16,16,32), Color3.fromRGB(10,10,20), 135)

	local selectedSky = nil
	local skyBtns     = {}

	for i, sky in ipairs(SKIES) do
		local col = (i-1) % 3
		local row = math.floor((i-1) / 3)

		local btn = Instance.new("TextButton", skyCard)
		btn.Size     = UDim2.new(0, 86, 0, 50)
		btn.Position = UDim2.new(0, 5 + col*91, 0, 5 + row*56)
		btn.Text     = sky.icon.."\n"..sky.name
		btn.TextSize = 9
		btn.Font     = Enum.Font.GothamBold
		btn.TextColor3 = T.TEXT2
		btn.BackgroundColor3 = T.SURFACE2
		btn.BorderSizePixel = 0
		btn.ZIndex = 13
		corner(btn, 10)
		stroke(btn, T.BORDER, 1)

		skyBtns[i] = btn

		btn.MouseButton1Click:Connect(function()
			selectedSky = i
			for j, sb in ipairs(skyBtns) do
				if j == i then
					tween(sb, { BackgroundColor3 = sky.color, TextColor3 = T.BG })
					stroke(sb, sky.color, 2)
				else
					tween(sb, { BackgroundColor3 = T.SURFACE2, TextColor3 = T.TEXT2 })
					stroke(sb, T.BORDER, 1)
				end
			end
			pcall(function()
				if sky.name == "Default" then
					local s = Lighting:FindFirstChildOfClass("Sky")
					if s then s:Destroy() end
					showToast("Sky về mặc định", "ok")
				else
					local assetId = "rbxassetid://"..sky.ids
					applySkyById(assetId)
					if sky.bright  then tween(Lighting,{Brightness=sky.bright},EZ_MED) end
					if sky.ambient then tween(Lighting,{Ambient=sky.ambient,OutdoorAmbient=sky.ambient},EZ_MED) end
					if sky.fogColor then
						tween(Lighting,{FogColor=sky.fogColor},EZ_MED)
						if sky.fogEnd then
							Lighting.FogEnd   = sky.fogEnd
							Lighting.FogStart = math.floor(sky.fogEnd * 0.8)
						end
					end
					showToast("Sky: "..sky.name.." ✨", "ok")
				end
			end)
		end)
		btn.MouseEnter:Connect(function()
			if selectedSky ~= i then tween(btn,{BackgroundColor3=T.GLASS}) end
		end)
		btn.MouseLeave:Connect(function()
			if selectedSky ~= i then tween(btn,{BackgroundColor3=T.SURFACE2}) end
		end)
	end

	-- Custom sky input
	local customSkyCard = makeCard(displayPage, 60, 23)
	newLabel(customSkyCard, {
		Text = "Custom Sky ID",
		Color = T.TEXT2, Size = 11, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0,110,0,20), Position = UDim2.new(0,12,0,6), ZIndex=13,
	})
	newLabel(customSkyCard, {
		Text = "Dán asset ID (số) — áp lên cả 6 mặt",
		Color = T.TEXT3, Size = 9,
		Sz = UDim2.new(1,-20,0,16), Position = UDim2.new(0,12,0,24), ZIndex=13,
	})

	local customBox = Instance.new("TextBox", customSkyCard)
	customBox.Size = UDim2.new(1,-72,0,24)
	customBox.Position = UDim2.new(0,10,1,-30)
	customBox.BackgroundColor3 = T.SURFACE2; customBox.BorderSizePixel = 0
	customBox.TextColor3 = T.TEXT; customBox.PlaceholderText = "e.g. 159454296"
	customBox.PlaceholderColor3 = T.TEXT3; customBox.Text = ""
	customBox.TextSize = 11; customBox.Font = Enum.Font.Gotham
	customBox.ClearTextOnFocus = false; customBox.ZIndex = 13
	corner(customBox, 7); stroke(customBox, T.BORDER, 1)
	local cbPad = Instance.new("UIPadding", customBox); cbPad.PaddingLeft = UDim.new(0,8)

	local applyCustomBtn = Instance.new("TextButton", customSkyCard)
	applyCustomBtn.Size = UDim2.new(0,52,0,24)
	applyCustomBtn.Position = UDim2.new(1,-62,1,-30)
	applyCustomBtn.Text = "Apply"; applyCustomBtn.TextSize = 10
	applyCustomBtn.Font = Enum.Font.GothamBold
	applyCustomBtn.TextColor3 = T.WHITE; applyCustomBtn.BackgroundColor3 = T.ACCENT
	applyCustomBtn.BorderSizePixel = 0; applyCustomBtn.ZIndex = 13
	corner(applyCustomBtn, 7)
	applyCustomBtn.MouseEnter:Connect(function() tween(applyCustomBtn,{BackgroundColor3=T.ACCENT2}) end)
	applyCustomBtn.MouseLeave:Connect(function() tween(applyCustomBtn,{BackgroundColor3=T.ACCENT}) end)
	applyCustomBtn.MouseButton1Click:Connect(function()
		local id = customBox.Text:match("%d+")
		if not id then showToast("ID không hợp lệ", "err"); return end
		applySkyById("rbxassetid://"..id)
		for _, sb in ipairs(skyBtns) do
			tween(sb, {BackgroundColor3=T.SURFACE2, TextColor3=T.TEXT2})
			stroke(sb, T.BORDER, 1)
		end
		selectedSky = nil
		showToast("Custom sky ID "..id.." đã áp dụng", "ok")
	end)

	-- ════════════════════════════════════════
	-- SECTION: TIME OF DAY
	-- ════════════════════════════════════════
	makeSectionLabel(displayPage, "Time of Day", 24)

	local timeCard = makeCard(displayPage, 72, 25)
	gradient(timeCard, Color3.fromRGB(18,18,36), Color3.fromRGB(12,12,22), 135)

	local TIME_PRESETS = {
		{ label="🌅\n06:00", time="06:00:00" },
		{ label="☀\n12:00",  time="14:00:00" },
		{ label="🌇\n18:00", time="18:00:00" },
		{ label="🌙\n00:00", time="00:00:00" },
	}
	local timeBtns = {}
	local selTime  = nil

	for i, tp in ipairs(TIME_PRESETS) do
		local b = Instance.new("TextButton", timeCard)
		b.Size = UDim2.new(0,66,0,48)
		b.Position = UDim2.new(0, 5+(i-1)*72, 0.5,-24)
		b.Text = tp.label; b.TextSize = 9; b.Font = Enum.Font.GothamBold
		b.TextColor3 = T.TEXT2; b.BackgroundColor3 = T.SURFACE2
		b.BorderSizePixel = 0; b.ZIndex = 13
		corner(b, 10); stroke(b, T.BORDER, 1)
		timeBtns[i] = b

		b.MouseButton1Click:Connect(function()
			selTime = i
			pcall(function() Lighting.TimeOfDay = tp.time end)
			for j, tb in ipairs(timeBtns) do
				if j==i then tween(tb,{BackgroundColor3=T.ACCENT,TextColor3=T.WHITE}); stroke(tb,T.ACCENT,2)
				else tween(tb,{BackgroundColor3=T.SURFACE2,TextColor3=T.TEXT2}); stroke(tb,T.BORDER,1) end
			end
			showToast("Time: "..tp.time, "ok")
		end)
		b.MouseEnter:Connect(function() if selTime~=i then tween(b,{BackgroundColor3=T.GLASS}) end end)
		b.MouseLeave:Connect(function() if selTime~=i then tween(b,{BackgroundColor3=T.SURFACE2}) end end)
	end

	-- Clock speed slider
	makeSectionLabel(displayPage, "Time Cycle Speed", 26)
	makeSlider(displayPage, "Clock Speed  (0 = dừng)", 0, 20, 0, function(v)
		if v == 0 then
			if _G._NovaTimeCycleConn then _G._NovaTimeCycleConn:Disconnect(); _G._NovaTimeCycleConn = nil end
		else
			if _G._NovaTimeCycleConn then _G._NovaTimeCycleConn:Disconnect() end
			_G._NovaTimeCycleConn = RunService.Heartbeat:Connect(function(dt)
				pcall(function()
					Lighting.ClockTime = (Lighting.ClockTime + dt * (v * 0.05)) % 24
				end)
			end)
		end
	end, 27)

	-- ════════════════════════════════════════
	-- SECTION: WEATHER EFFECTS  (gộp gọn)
	-- ════════════════════════════════════════
	makeSectionLabel(displayPage, "Weather & Camera Effects", 28)

	-- Rain
	local rainActive2, rainParts3 = false, {}
	local function startRain2(intensity)
		if rainActive2 then return end; rainActive2 = true
		task.spawn(function()
			local cam = workspace.CurrentCamera
			while rainActive2 and cam do
				for _ = 1, math.floor(intensity * 3) do
					if not rainActive2 then break end
					local p = Instance.new("Part")
					p.Size=Vector3.new(0.05,1.2,0.05); p.Material=Enum.Material.Neon
					p.Color=Color3.fromRGB(180,210,255); p.CastShadow=false; p.CanCollide=false; p.Anchored=true
					local o=cam.CFrame.Position
					p.CFrame=CFrame.new(o.X+math.random(-40,40),o.Y+30,o.Z+math.random(-40,40))
					p.Parent=workspace; table.insert(rainParts3,p)
					task.spawn(function()
						for _=1,30 do if not p.Parent then break end; p.CFrame=p.CFrame*CFrame.new(0,-3.5,0); task.wait(0.02) end
						pcall(function() p:Destroy() end)
					end)
				end
				task.wait(0.08)
			end
		end)
	end
	local function stopRain2()
		rainActive2=false
		for _,p in ipairs(rainParts3) do pcall(function() p:Destroy() end) end; rainParts3={}
	end

	-- Snow
	local snowActive2, snowParts3 = false, {}
	local function startSnow2(intensity)
		if snowActive2 then return end; snowActive2=true
		task.spawn(function()
			local cam = workspace.CurrentCamera
			while snowActive2 and cam do
				for _=1,math.floor(intensity*2) do
					if not snowActive2 then break end
					local p=Instance.new("Part"); p.Shape=Enum.PartType.Ball
					p.Size=Vector3.new(0.12,0.12,0.12); p.Material=Enum.Material.Neon
					p.Color=Color3.fromRGB(230,240,255); p.CastShadow=false; p.CanCollide=false; p.Anchored=true
					local o=cam.CFrame.Position
					p.CFrame=CFrame.new(o.X+math.random(-50,50),o.Y+35,o.Z+math.random(-50,50))
					p.Parent=workspace; table.insert(snowParts3,p)
					task.spawn(function()
						for i=1,40 do if not p.Parent then break end; p.CFrame=p.CFrame*CFrame.new(math.sin(i*.4)*.4,-1.2,0); task.wait(0.04) end
						pcall(function() p:Destroy() end)
					end)
				end
				task.wait(0.12)
			end
		end)
	end
	local function stopSnow2()
		snowActive2=false
		for _,p in ipairs(snowParts3) do pcall(function() p:Destroy() end) end; snowParts3={}
	end

	makeToggle(displayPage, "Rain 🌧",   false, function(on) if on then startRain2(6) else stopRain2() end end, 29)
	makeSlider(displayPage, "Rain Intensity", 1, 10, 6, function(v)
		if rainActive2 then stopRain2(); startRain2(v) end
	end, 30)
	makeToggle(displayPage, "Snow ❄",    false, function(on) if on then startSnow2(4) else stopSnow2() end end, 31)

	-- Camera shake
	local shakeActive = false; local shakeConn = nil; local shakeInt = 0.5
	makeToggle(displayPage, "Camera Shake 📳", false, function(on)
		if on then
			shakeActive=true
			shakeConn=RunService.RenderStepped:Connect(function()
				if not shakeActive then return end
				local cam=workspace.CurrentCamera
				if cam and cam.CameraType==Enum.CameraType.Custom then
					cam.CFrame=cam.CFrame*CFrame.Angles(
						math.rad(math.random(-100,100)*shakeInt*0.01),
						math.rad(math.random(-100,100)*shakeInt*0.01),0)
				end
			end)
		else
			shakeActive=false
			if shakeConn then shakeConn:Disconnect(); shakeConn=nil end
		end
	end, 32)
	makeSlider(displayPage, "Shake Intensity", 1, 20, 5, function(v) shakeInt=v/10 end, 33)

	-- Cinematic Mode
	local cinematicOn = false
	makeToggle(displayPage, "Cinematic Letterbox 🎬", false, function(on)
		local existing = Player.PlayerGui:FindFirstChild("_NovaCinematic")
		if on then
			if existing then existing:Destroy() end
			local sg = Instance.new("ScreenGui", Player.PlayerGui)
			sg.Name="_NovaCinematic"; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true
			local topBar=Instance.new("Frame",sg); topBar.Size=UDim2.new(1,0,0,0)
			topBar.BackgroundColor3=Color3.new(0,0,0); topBar.BorderSizePixel=0; topBar.ZIndex=999
			tween(topBar,{Size=UDim2.new(1,0,0,52)},EZ_SLOW)
			local botBar=Instance.new("Frame",sg); botBar.Size=UDim2.new(1,0,0,0)
			botBar.Position=UDim2.new(0,0,1,0); botBar.AnchorPoint=Vector2.new(0,1)
			botBar.BackgroundColor3=Color3.new(0,0,0); botBar.BorderSizePixel=0; botBar.ZIndex=999
			tween(botBar,{Size=UDim2.new(1,0,0,52)},EZ_SLOW)
			showToast("Cinematic ON 🎬","ok")
		else
			if existing then
				for _,bar in ipairs(existing:GetChildren()) do
					if bar:IsA("Frame") then tween(bar,{Size=UDim2.new(1,0,0,0)},EZ_MED) end
				end
				task.delay(0.4,function() if existing and existing.Parent then existing:Destroy() end end)
			end
			showToast("Cinematic OFF","warn")
		end
	end, 34)

	-- Night Vision
	makeToggle(displayPage, "Night Vision 🟢", false, function(on)
		local cc=Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
		if on then
			if not cc then cc=Instance.new("ColorCorrectionEffect",Lighting) end
			cc.TintColor=Color3.fromRGB(100,255,120); cc.Brightness=0.4
			cc.Contrast=0.3; cc.Saturation=-0.5; cc.Enabled=true
			Lighting.Brightness=6; showToast("Night Vision ON 🟢","ok")
		else
			if cc then tween(cc,{TintColor=Color3.new(1,1,1),Brightness=0,Contrast=0,Saturation=0}) end
			Lighting.Brightness=2; showToast("Night Vision OFF","warn")
		end
	end, 35)

	-- ════════════════════════════════════════
	-- RESET BUTTON
	-- ════════════════════════════════════════
	local resetBtn = Instance.new("TextButton", displayPage)
	resetBtn.Size=UDim2.new(1,0,0,42)
	resetBtn.BackgroundColor3=Color3.fromRGB(38,18,18)
	resetBtn.TextColor3=T.DANGER
	resetBtn.Text="↺  Reset tất cả về mặc định"
	resetBtn.TextSize=12; resetBtn.Font=Enum.Font.GothamBold
	resetBtn.BorderSizePixel=0; resetBtn.ZIndex=12; resetBtn.LayoutOrder=36
	corner(resetBtn,10); stroke(resetBtn,T.DANGER,1)

	resetBtn.MouseEnter:Connect(function() tween(resetBtn,{BackgroundColor3=Color3.fromRGB(70,25,25)}) end)
	resetBtn.MouseLeave:Connect(function() tween(resetBtn,{BackgroundColor3=Color3.fromRGB(38,18,18)}) end)
	resetBtn.MouseButton1Click:Connect(function()
		Lighting.Brightness=2; Lighting.FogEnd=100000; Lighting.FogStart=0
		Lighting.GlobalShadows=true
		Lighting.Ambient=Color3.fromRGB(70,70,70); Lighting.OutdoorAmbient=Color3.fromRGB(140,140,140)
		setBloom(true,0.75); setSunRays(false); setColorCorrect(true); setDOF(0); setParticles(true)
		if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=70 end
		Player.CameraMaxZoomDistance=25; Player.CameraMinZoomDistance=0
		local a=Lighting:FindFirstChildOfClass("Atmosphere")
		if a then a.Density=0.395; a.Offset=0.06 end
		stopRain2(); stopSnow2()
		potatoActive=false; updatePotatoBadge()
		for _,pb in ipairs(presetBtnsRef) do
			tween(pb.btn,{BackgroundColor3=T.SURFACE2,TextColor3=T.TEXT3})
		end
		selectedPreset=nil; selectedSky=nil
		for _,sb in ipairs(skyBtns) do
			tween(sb,{BackgroundColor3=T.SURFACE2,TextColor3=T.TEXT2}); stroke(sb,T.BORDER,1)
		end
		if _G._NovaTimeCycleConn then _G._NovaTimeCycleConn:Disconnect(); _G._NovaTimeCycleConn=nil end
		showToast("✓ Đã reset đồ họa về mặc định","ok")
		resetBtn.Text="✓  Done"
		task.delay(2,function() resetBtn.Text="↺  Reset tất cả về mặc định" end)
	end)
end

-- ══════════════════════════════════════════
-- ★ PAGE: CONSOLE  (print/warn/error catcher)
-- ══════════════════════════════════════════
local consolePage, _ = makePage("Console")

do
	local logs = {}
	local MAX_LOGS = 200
	local filterLevel = "all"  -- "all" | "print" | "warn" | "error"
	local paused = false

	local LEVEL_COLOR = {
		print = T.TEXT2,
		warn  = T.WARN,
		error = T.DANGER,
		info  = T.ACCENT,
	}
	local LEVEL_ICON = {
		print = "›",
		warn  = "⚠",
		error = "✕",
		info  = "ℹ",
	}

	-- ── Header card ──
	local hdrCard = makeCard(consolePage, 42, 1)
	gradient(hdrCard, Color3.fromRGB(18,18,32), Color3.fromRGB(12,12,20), 135)

	local statsLbl = newLabel(hdrCard, {
		Text = "0 entries",
		Color = T.TEXT3, Size = 10, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0,80,1,0),
		Position = UDim2.new(0,12,0,0),
		ZIndex = 13,
	})

	-- Filter buttons
	local filterDefs = {
		{ label="All",   key="all",   col=T.TEXT2  },
		{ label="Print", key="print", col=T.TEXT2  },
		{ label="Warn",  key="warn",  col=T.WARN   },
		{ label="Error", key="error", col=T.DANGER },
	}
	local filterBtns2 = {}
	for i, fd in ipairs(filterDefs) do
		local b = Instance.new("TextButton", hdrCard)
		b.Size = UDim2.new(0,44,0,26)
		b.Position = UDim2.new(0, 88+(i-1)*48, 0.5, -13)
		b.Text = fd.label
		b.TextSize = 9
		b.Font = Enum.Font.GothamBold
		b.TextColor3 = i==1 and T.WHITE or T.TEXT3
		b.BackgroundColor3 = i==1 and T.ACCENT or T.SURFACE2
		b.BorderSizePixel = 0
		b.ZIndex = 13
		corner(b, 7)
		filterBtns2[i] = { btn=b, key=fd.key }

		b.MouseButton1Click:Connect(function()
			filterLevel = fd.key
			for j, fb in ipairs(filterBtns2) do
				tween(fb.btn, {
					BackgroundColor3 = j==i and T.ACCENT or T.SURFACE2,
					TextColor3       = j==i and T.WHITE  or T.TEXT3,
				})
			end
			-- Show/hide log rows
			for _, lg in ipairs(logs) do
				if lg.row and lg.row.Parent then
					lg.row.Visible = (filterLevel=="all" or lg.level==filterLevel)
				end
			end
		end)
		b.MouseEnter:Connect(function() if filterLevel~=fd.key then tween(b,{BackgroundColor3=T.GLASS}) end end)
		b.MouseLeave:Connect(function() if filterLevel~=fd.key then tween(b,{BackgroundColor3=T.SURFACE2}) end end)
	end

	-- Pause + Clear
	local pauseBtn2 = Instance.new("TextButton", hdrCard)
	pauseBtn2.Size = UDim2.new(0,54,0,26)
	pauseBtn2.Position = UDim2.new(1,-120,0.5,-13)
	pauseBtn2.Text = "⏸ Pause"
	pauseBtn2.TextSize = 9
	pauseBtn2.Font = Enum.Font.GothamBold
	pauseBtn2.TextColor3 = T.TEXT3
	pauseBtn2.BackgroundColor3 = T.SURFACE2
	pauseBtn2.BorderSizePixel = 0
	pauseBtn2.ZIndex = 13
	corner(pauseBtn2, 7)
	stroke(pauseBtn2, T.BORDER, 1)

	local clearBtn2 = Instance.new("TextButton", hdrCard)
	clearBtn2.Size = UDim2.new(0,50,0,26)
	clearBtn2.Position = UDim2.new(1,-62,0.5,-13)
	clearBtn2.Text = "🗑 Clear"
	clearBtn2.TextSize = 9
	clearBtn2.Font = Enum.Font.GothamBold
	clearBtn2.TextColor3 = T.TEXT3
	clearBtn2.BackgroundColor3 = T.SURFACE2
	clearBtn2.BorderSizePixel = 0
	clearBtn2.ZIndex = 13
	corner(clearBtn2, 7)
	stroke(clearBtn2, T.BORDER, 1)

	-- ── Log container ──
	local logWrap = newFrame(consolePage, {
		BG = Color3.fromRGB(6,6,12),
		Size = UDim2.new(1,0,0,10), ZIndex=12,
	})
	logWrap.LayoutOrder = 2
	logWrap.AutomaticSize = Enum.AutomaticSize.Y
	corner(logWrap, 10)
	stroke(logWrap, T.BORDER, 1)

	local logLL2 = Instance.new("UIListLayout", logWrap)
	logLL2.SortOrder = Enum.SortOrder.LayoutOrder
	logLL2.Padding = UDim.new(0,0)
	local logPad2 = Instance.new("UIPadding", logWrap)
	logPad2.PaddingTop = UDim.new(0,4)
	logPad2.PaddingBottom = UDim.new(0,4)

	local emptyConsole = newLabel(logWrap, {
		Text = "Console rỗng — chờ output…",
		Color = T.TEXT3, Size = 10,
		Sz = UDim2.new(1,0,0,36), ZIndex=13,
		AlignX = Enum.TextXAlignment.Center,
	})
	emptyConsole.LayoutOrder = 99999

	local logOrder = 0

	local function addLog(level, msg)
		if paused then return end
		emptyConsole.Visible = false
		logOrder += 1

		-- Remove oldest if over limit
		if #logs >= MAX_LOGS then
			local oldest = table.remove(logs, 1)
			if oldest.row and oldest.row.Parent then oldest.row:Destroy() end
		end

		local col = LEVEL_COLOR[level] or T.TEXT2
		local icon = LEVEL_ICON[level] or "›"

		local row = newFrame(logWrap, {
			BG = level=="error" and Color3.fromRGB(24,8,8)
				or level=="warn" and Color3.fromRGB(24,18,4)
				or Color3.fromRGB(10,10,16),
			Size = UDim2.new(1,0,0,24), ZIndex=12,
		})
		row.LayoutOrder = logOrder
		row.Visible = (filterLevel=="all" or level==filterLevel)

		-- Left strip
		local strip = newFrame(row, {
			BG = col,
			Size = UDim2.new(0,2,1,0), ZIndex=13,
		})

		-- Icon
		newLabel(row, {
			Text = icon, Color = col, Size = 11,
			Font = Enum.Font.GothamBold,
			Sz = UDim2.new(0,18,1,0),
			Position = UDim2.new(0,6,0,0),
			AlignX = Enum.TextXAlignment.Center,
			ZIndex = 13,
		})

		-- Timestamp
		newLabel(row, {
			Text = os.date("%H:%M:%S"),
			Color = T.TEXT3, Size = 8,
			Sz = UDim2.new(0,52,1,0),
			Position = UDim2.new(0,24,0,0),
			ZIndex = 13,
		})

		-- Message
		local msgLbl = newLabel(row, {
			Text = tostring(msg),
			Color = col, Size = 10,
			Font = Enum.Font.Code,
			Sz = UDim2.new(1,-118,1,0),
			Position = UDim2.new(0,78,0,0),
			ZIndex = 13,
			Truncate = true,
		})

		-- Copy btn
		local cpBtn = Instance.new("TextButton", row)
		cpBtn.Size = UDim2.new(0,32,0,16)
		cpBtn.AnchorPoint = Vector2.new(1,0.5)
		cpBtn.Position = UDim2.new(1,-4,0.5,0)
		cpBtn.Text = "copy"
		cpBtn.TextSize = 8
		cpBtn.Font = Enum.Font.GothamBold
		cpBtn.TextColor3 = T.TEXT3
		cpBtn.BackgroundColor3 = T.SURFACE2
		cpBtn.BorderSizePixel = 0
		cpBtn.ZIndex = 14
		corner(cpBtn, 4)
		cpBtn.MouseButton1Click:Connect(function()
			copyText(tostring(msg))
			cpBtn.Text = "✓"
			tween(cpBtn, {TextColor3=T.SUCCESS})
			task.delay(1, function() cpBtn.Text="copy"; tween(cpBtn,{TextColor3=T.TEXT3}) end)
		end)

		table.insert(logs, { row=row, level=level })
		statsLbl.Text = #logs.." entries"
	end

	-- ── Hook print / warn / error ──
	local oldPrint = print
	local oldWarn  = warn
	local oldError = error

	print = function(...)
		local args = {...}
		local msg = table.concat(
			(function() local t={} for _,v in ipairs(args) do t[#t+1]=tostring(v) end return t end)(),
			"  "
		)
		task.defer(function() pcall(function() addLog("print", msg) end) end)
		return oldPrint(...)
	end

	warn = function(...)
		local args = {...}
		local msg = table.concat(
			(function() local t={} for _,v in ipairs(args) do t[#t+1]=tostring(v) end return t end)(),
			"  "
		)
		task.defer(function() pcall(function() addLog("warn", msg) end) end)
		return oldWarn(...)
	end

	-- Log info helper (accessible globally)
	_G.NovaLog = function(msg, level)
		addLog(level or "info", tostring(msg))
	end

	-- ── Input bar (execute expression) ──
	local inputCard = makeCard(consolePage, 44, 3)

	local inputBox = Instance.new("TextBox", inputCard)
	inputBox.Size = UDim2.new(1,-68,0,28)
	inputBox.Position = UDim2.new(0,10,0.5,-14)
	inputBox.BackgroundColor3 = Color3.fromRGB(6,6,12)
	inputBox.BorderSizePixel = 0
	inputBox.TextColor3 = T.SUCCESS
	inputBox.PlaceholderText = "› print('hello') …"
	inputBox.PlaceholderColor3 = T.TEXT3
	inputBox.Text = ""
	inputBox.TextSize = 11
	inputBox.Font = Enum.Font.Code
	inputBox.ClearTextOnFocus = false
	inputBox.ZIndex = 13
	corner(inputBox, 7)
	stroke(inputBox, T.BORDER, 1)
	local ibPad = Instance.new("UIPadding", inputBox); ibPad.PaddingLeft = UDim.new(0,8)

	local runBtn = Instance.new("TextButton", inputCard)
	runBtn.Size = UDim2.new(0,50,0,28)
	runBtn.Position = UDim2.new(1,-58,0.5,-14)
	runBtn.Text = "▶ Run"
	runBtn.TextSize = 10
	runBtn.Font = Enum.Font.GothamBold
	runBtn.TextColor3 = T.WHITE
	runBtn.BackgroundColor3 = T.ACCENT
	runBtn.BorderSizePixel = 0
	runBtn.ZIndex = 13
	corner(runBtn, 7)

	local function runInput()
		local code = inputBox.Text
		if code == "" then return end
		addLog("info", "> "..code)
		local fn, err = loadstring(code)
		if fn then
			local ok, result = pcall(fn)
			if not ok then
				addLog("error", tostring(result))
			elseif result ~= nil then
				addLog("print", "← "..tostring(result))
			end
		else
			addLog("error", tostring(err))
		end
		inputBox.Text = ""
	end

	runBtn.MouseButton1Click:Connect(runInput)
	runBtn.MouseEnter:Connect(function() tween(runBtn,{BackgroundColor3=T.ACCENT2}) end)
	runBtn.MouseLeave:Connect(function() tween(runBtn,{BackgroundColor3=T.ACCENT}) end)

	inputBox.FocusLost:Connect(function(enter)
		if enter then runInput() end
	end)

	pauseBtn2.MouseButton1Click:Connect(function()
		paused = not paused
		pauseBtn2.Text = paused and "▶ Resume" or "⏸ Pause"
		tween(pauseBtn2, {
			BackgroundColor3 = paused and Color3.fromRGB(38,30,4) or T.SURFACE2,
			TextColor3       = paused and T.WARN or T.TEXT3,
		})
	end)

	clearBtn2.MouseButton1Click:Connect(function()
		for _, lg in ipairs(logs) do
			if lg.row and lg.row.Parent then lg.row:Destroy() end
		end
		logs = {}; logOrder = 0
		statsLbl.Text = "0 entries"
		emptyConsole.Visible = true
		showToast("Console đã xóa", "ok")
	end)
end

-- ══════════════════════════════════════════
-- ★ PAGE: PERFORMANCE MONITOR
-- ══════════════════════════════════════════
-- (Thêm vào navDefs: { name="Perf", icon="📊", order=8 })
-- Sau đó tạo page:
local perfPage, _ = makePage("Perf")

do
	-- ── Big stat cells ──
	local statCard = makeCard(perfPage, 120, 1)
	gradient(statCard, Color3.fromRGB(14,14,26), Color3.fromRGB(10,10,18), 135)

	local BIG_STATS = {
		{ key="fps",    label="FPS",        col=0, row=0, color=T.SUCCESS },
		{ key="ping",   label="PING (ms)",  col=1, row=0, color=T.ACCENT  },
		{ key="mem",    label="MEM (MB)",   col=0, row=1, color=T.WARN    },
		{ key="parts",  label="PARTS",      col=1, row=1, color=T.ACCENT2 },
	}
	local bigVals = {}

	for _, sd in ipairs(BIG_STATS) do
		local cell = newFrame(statCard, {
			BG = T.SURFACE2,
			Size = UDim2.new(0,136,0,50),
			Position = UDim2.new(0, 8+sd.col*144, 0, 8+sd.row*56),
			ZIndex = 13,
		})
		corner(cell, 10)
		stroke(cell, T.BORDER, 1)

		-- Subtle gradient per cell
		gradient(cell,
			Color3.fromRGB(24,24,42),
			Color3.fromRGB(16,16,28), 135)

		newLabel(cell, {
			Text = sd.label,
			Color = T.TEXT3, Size = 8, Font = Enum.Font.GothamBold,
			Sz = UDim2.new(1,0,0,16), Position = UDim2.new(0,10,0,4), ZIndex=14,
		})

		local valLbl = newLabel(cell, {
			Text = "…",
			Color = sd.color, Size = 22, Font = Enum.Font.GothamBold,
			Sz = UDim2.new(1,0,0,28), Position = UDim2.new(0,10,0,18), ZIndex=14,
		})
		bigVals[sd.key] = valLbl

		-- Mini indicator dot (green/yellow/red)
		local dot = newFrame(cell, {
			BG = T.SUCCESS,
			Size = UDim2.new(0,6,0,6),
			Position = UDim2.new(1,-14,0,8),
			ZIndex = 14,
		})
		corner(dot, 4)
		bigVals[sd.key.."_dot"] = dot
	end

	-- ── FPS Graph ──
	makeSectionLabel(perfPage, "FPS Graph (60s)", 2)

	local graphCard = makeCard(perfPage, 80, 3)
	gradient(graphCard, Color3.fromRGB(10,10,18), Color3.fromRGB(8,8,14), 135)

	-- Grid lines
	for i = 1, 3 do
		local gridLine = newFrame(graphCard, {
			BG = T.BORDER,
			BT = 0.6,
			Size = UDim2.new(1,-20,0,1),
			Position = UDim2.new(0,10,0, 10+i*18),
			ZIndex = 12,
		})
		newLabel(graphCard, {
			Text = tostring(60-i*15),
			Color = T.TEXT3, Size = 7,
			Sz = UDim2.new(0,10,0,10),
			Position = UDim2.new(0,0,0, 5+i*18),
			AlignX = Enum.TextXAlignment.Right,
			ZIndex = 13,
		})
	end

	-- Graph bars (60 bars for 60 seconds)
	local NUM_BARS = 60
	local graphBars = {}
	local barWidth = math.floor((286 - 20) / NUM_BARS)

	for i = 1, NUM_BARS do
		local bar = newFrame(graphCard, {
			BG = T.ACCENT,
			BT = 0.4,
			Size = UDim2.new(0, barWidth-1, 0, 0),
			Position = UDim2.new(0, 10+(i-1)*barWidth, 1, -4),
			ZIndex = 13,
		})
		bar.AnchorPoint = Vector2.new(0,1)
		corner(bar, 1)
		graphBars[i] = bar
	end

	local barIndex   = 1
	local fpsHistory = {}
	for i = 1, NUM_BARS do fpsHistory[i] = 60 end

	-- ── Detail rows ──
	makeSectionLabel(perfPage, "Detailed Metrics", 4)

	local detailCard = makeCard(perfPage, 10, 5)
	detailCard.AutomaticSize = Enum.AutomaticSize.Y
	local detailList = Instance.new("UIListLayout", detailCard)
	detailList.SortOrder = Enum.SortOrder.LayoutOrder
	detailList.Padding = UDim.new(0,1)
	local detailPad = Instance.new("UIPadding", detailCard)
	detailPad.PaddingTop = UDim.new(0,6)
	detailPad.PaddingBottom = UDim.new(0,6)

	local DETAIL_DEFS = {
		{ key="scripts",  label="Running Scripts" },
		{ key="instances",label="Total Instances"  },
		{ key="sounds",   label="Active Sounds"    },
		{ key="network",  label="Data Received KB/s"},
		{ key="heartbeat",label="Heartbeat (ms)"   },
		{ key="render",   label="Render Step (ms)" },
		{ key="players",  label="Players in Server" },
	}
	local detailVals = {}

	for i, dd in ipairs(DETAIL_DEFS) do
		local drow = newFrame(detailCard, {
			BG = i%2==0 and T.SURFACE2 or T.SURFACE,
			BT = 0.3,
			Size = UDim2.new(1,0,0,28), ZIndex=13,
		})
		drow.LayoutOrder = i
		newLabel(drow, {
			Text = dd.label,
			Color = T.TEXT2, Size = 10,
			Sz = UDim2.new(0.55,0,1,0),
			Position = UDim2.new(0,12,0,0),
			ZIndex = 14,
		})
		local dval = newLabel(drow, {
			Text = "…",
			Color = T.ACCENT, Size = 11, Font = Enum.Font.GothamBold,
			Sz = UDim2.new(0.45,-12,1,0),
			Position = UDim2.new(0.55,0,0,0),
			AlignX = Enum.TextXAlignment.Right,
			ZIndex = 14,
		})
		local rPad = Instance.new("UIPadding",dval); rPad.PaddingRight=UDim.new(0,12)
		detailVals[dd.key] = dval
	end

	-- ── Live update loop ──
	local lastHB, lastRS = 0, 0
	local lastDataRecv = 0

	RunService.Heartbeat:Connect(function(dt)
		lastHB = dt * 1000  -- ms
	end)
	RunService.RenderStepped:Connect(function(dt)
		lastRS = dt * 1000
	end)

	-- Update every 1s
	local perfActive = true
	task.spawn(function()
		while perfActive do
			task.wait(1)
			if not pages["Perf"].Visible then continue end

			-- FPS
			local fps = math.floor(1 / math.max(lastRS, 0.001))
			fpsHistory[barIndex] = fps
			barIndex = (barIndex % NUM_BARS) + 1

			-- Update bars
			for i = 1, NUM_BARS do
				local idx = ((barIndex + i - 2) % NUM_BARS) + 1
				local f = fpsHistory[idx]
				local ratio = math.clamp(f / 60, 0, 1)
				local col = f >= 50 and T.SUCCESS or f >= 30 and T.WARN or T.DANGER
				local maxH = 62
				tween(graphBars[i], {
					Size = UDim2.new(0, barWidth-1, 0, math.floor(ratio * maxH)),
					BackgroundColor3 = col,
				}, TweenInfo.new(0.3))
			end

			bigVals["fps"].Text = tostring(fps)
			local fpsDot = bigVals["fps_dot"]
			if fpsDot then
				fpsDot.BackgroundColor3 = fps>=50 and T.SUCCESS or fps>=30 and T.WARN or T.DANGER
			end

			-- Ping
			local ok, ping = pcall(function() return math.floor(Player:GetNetworkPing()*1000) end)
			if ok then
				bigVals["ping"].Text = tostring(ping)
				local pDot = bigVals["ping_dot"]
				if pDot then
					pDot.BackgroundColor3 = ping<80 and T.SUCCESS or ping<200 and T.WARN or T.DANGER
				end
				detailVals["network"].Text = tostring(math.floor(ping/10)).." KB/s"
			end

			-- Memory
			local mem = math.floor(collectgarbage("count") / 1024)
			bigVals["mem"].Text = tostring(mem)
			local mDot = bigVals["mem_dot"]
			if mDot then
				mDot.BackgroundColor3 = mem<128 and T.SUCCESS or mem<256 and T.WARN or T.DANGER
			end

			-- Parts / Instances
			local partCount = 0
			local instCount = 0
			pcall(function()
				for _, d in ipairs(workspace:GetDescendants()) do
					instCount += 1
					if d:IsA("BasePart") then partCount += 1 end
				end
			end)
			bigVals["parts"].Text = tostring(partCount)
			detailVals["instances"].Text = tostring(instCount)
			detailVals["scripts"].Text = tostring(#(RunService:IsStudio() and {} or {}))  -- limited outside studio

			detailVals["sounds"].Text = (function()
				local n = 0
				pcall(function()
					for _, s in ipairs(workspace:GetDescendants()) do
						if s:IsA("Sound") and s.IsPlaying then n+=1 end
					end
				end)
				return tostring(n)
			end)()

			detailVals["heartbeat"].Text = string.format("%.2f ms", lastHB)
			detailVals["render"].Text    = string.format("%.2f ms", lastRS)
			detailVals["players"].Text   = tostring(#Players:GetPlayers())
		end
	end)
end

-- ══════════════════════════════════════════
-- ★ PAGE: KEYBINDS  v2  (nâng cấp đầy đủ)
-- ══════════════════════════════════════════
local keybindPage, _ = makePage("Keybinds")

do
	-- ════════════════════════════════════════
	-- REGISTRY  (tất cả actions có thể bind)
	-- ════════════════════════════════════════
	local BIND_ACTIONS = {
		-- ── Movement ──
		{
			id      = "toggle_menu",
			label   = "Toggle Menu",
			sub     = "Mở / đóng Nova UI panel",
			cat     = "Movement",
			default = Enum.KeyCode.RightShift,
			toggleable = false,
			action  = function()
				if menuOpen then closeMenu() else openMenu() end
			end,
		},
		{
			id      = "noclip",
			label   = "NoClip",
			sub     = "Đi xuyên tường (tắt va chạm)",
			cat     = "Movement",
			default = Enum.KeyCode.F2,
			toggleable = true,
			action  = nil,  -- gán bên dưới
		},
		{
			id      = "speed_boost",
			label   = "Speed ×3",
			sub     = "Tăng tốc gấp 3 lần WalkSpeed hiện tại",
			cat     = "Movement",
			default = Enum.KeyCode.F3,
			toggleable = false,
			action  = nil,
		},
		{
			id      = "reset_char",
			label   = "Reset Character",
			sub     = "Hạ HP về 0 để respawn",
			cat     = "Movement",
			default = Enum.KeyCode.F4,
			toggleable = false,
			action  = function()
				pcall(function()
					local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
					if hum then hum.Health = 0 end
				end)
			end,
		},
		{
			id      = "fly_toggle",
			label   = "Fly Mode",
			sub     = "Bay tự do — WASD + Space/Ctrl",
			cat     = "Movement",
			default = Enum.KeyCode.F5,
			toggleable = true,
			action  = nil,  -- gán bên dưới
		},
		{
			id      = "teleport_spawn",
			label   = "Teleport → Spawn",
			sub     = "Dịch chuyển về SpawnLocation",
			cat     = "Movement",
			default = Enum.KeyCode.F11,
			toggleable = false,
			action  = function()
				local char = Player.Character
				if not char then return end
				local root = char:FindFirstChild("HumanoidRootPart")
				if not root then return end
				local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
				if spawn then
					root.CFrame = spawn.CFrame + Vector3.new(0, 4, 0)
					showToast("Teleport → Spawn", "ok")
				else
					-- Fallback: về gốc toạ độ
					root.CFrame = CFrame.new(0, 10, 0)
					showToast("Spawn không tìm thấy — về gốc", "warn")
				end
			end,
		},

		-- ── Combat / Utility ──
		{
			id      = "toggle_esp",
			label   = "ESP Highlight",
			sub     = "Highlight xuyên tường tất cả player",
			cat     = "Combat",
			default = Enum.KeyCode.F1,
			toggleable = true,
			action  = function()
				espEnabled = not espEnabled
				if espEnabled then
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= Player then applyESP(p) end
					end
				else
					for _, p in ipairs(Players:GetPlayers()) do removeESP(p) end
				end
				showToast("ESP "..(espEnabled and "ON" or "OFF"), espEnabled and "ok" or "warn")
			end,
		},
		{
			id      = "god_mode",
			label   = "God Mode",
			sub     = "MaxHealth vô cực — không thể chết",
			cat     = "Combat",
			default = Enum.KeyCode.F6,
			toggleable = true,
			action  = nil,  -- gán bên dưới
		},
		{
			id      = "anti_afk",
			label   = "Anti-AFK",
			sub     = "Giả lập input để tránh bị kick",
			cat     = "Combat",
			default = Enum.KeyCode.F7,
			toggleable = true,
			action  = nil,  -- gán bên dưới
		},

		-- ── Visual ──
		{
			id      = "rain_toggle",
			label   = "Rain Effect",
			sub     = "Mưa rơi — kết hợp Sky Changer",
			cat     = "Visual",
			default = Enum.KeyCode.F8,
			toggleable = true,
			action  = nil,  -- gán bên dưới (tham chiếu Display page)
		},
		{
			id      = "cinematic",
			label   = "Cinematic Mode",
			sub     = "Letterbox đen trên/dưới màn hình",
			cat     = "Visual",
			default = Enum.KeyCode.F9,
			toggleable = true,
			action  = nil,
		},
		{
			id      = "night_vision",
			label   = "Night Vision",
			sub     = "Tăng sáng + tint xanh lá",
			cat     = "Visual",
			default = Enum.KeyCode.F10,
			toggleable = true,
			action  = nil,
		},
		{
			id      = "time_day",
			label   = "Time → Ngày (12:00)",
			sub     = "Đặt ClockTime về 14:00",
			cat     = "Visual",
			default = Enum.KeyCode.Unknown,  -- Không bind mặc định
			toggleable = false,
			action  = function()
				pcall(function() Lighting.ClockTime = 14 end)
				showToast("Time → 14:00 ☀", "ok")
			end,
		},
		{
			id      = "time_night",
			label   = "Time → Đêm (00:00)",
			sub     = "Đặt ClockTime về 00:00",
			cat     = "Visual",
			default = Enum.KeyCode.Unknown,
			toggleable = false,
			action  = function()
				pcall(function() Lighting.ClockTime = 0 end)
				showToast("Time → 00:00 🌙", "ok")
			end,
		},

		-- ── UI ──
		{
			id      = "console_clear",
			label   = "Clear Console",
			sub     = "Xóa toàn bộ log trong Console page",
			cat     = "UI",
			default = Enum.KeyCode.F12,
			toggleable = false,
			action  = function()
				-- Console page tự xử lý nếu muốn hook
				_G._NovaClearConsole = true
				showToast("Console cleared", "ok")
			end,
		},
	}

	-- ════════════════════════════════════════
	-- BINDINGS TABLE  +  TOGGLE STATES
	-- ════════════════════════════════════════
	local bindings     = {}   -- [id] = KeyCode
	local toggleStates = {}   -- [id] = bool (ON/OFF)

	for _, ba in ipairs(BIND_ACTIONS) do
		bindings[ba.id]     = ba.default
		toggleStates[ba.id] = false
	end

	-- Xuất ra global để các module khác (Settings, Display…) có thể đọc
	_G._NovaKeybinds      = bindings
	_G._NovaToggleStates  = toggleStates

	-- ════════════════════════════════════════
	-- IMPLEMENTATIONS cho các actions nil
	-- ════════════════════════════════════════

	-- NoClip
	local noclipConn = nil
	BIND_ACTIONS[2].action = function()    -- index 2 = noclip
		toggleStates["noclip"] = not toggleStates["noclip"]
		local on = toggleStates["noclip"]
		if on then
			noclipConn = RunService.Stepped:Connect(function()
				if Player.Character then
					for _, p in ipairs(Player.Character:GetDescendants()) do
						if p:IsA("BasePart") then p.CanCollide = false end
					end
				end
			end)
		else
			if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
			if Player.Character then
				for _, p in ipairs(Player.Character:GetDescendants()) do
					if p:IsA("BasePart") then p.CanCollide = true end
				end
			end
		end
		showToast("NoClip "..(on and "ON" or "OFF"), on and "ok" or "warn")
	end

	-- Speed ×3
	BIND_ACTIONS[3].action = function()
		local char = Player.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum then return end
		local boosted = hum.WalkSpeed > 32
		hum.WalkSpeed = boosted and 16 or hum.WalkSpeed * 3
		showToast("Speed "..(boosted and "→ normal" or "×3 ON"), boosted and "warn" or "ok")
	end

	-- Fly toggle (dùng lại logic từ Settings page)
	local flyKeyActive = false
	BIND_ACTIONS[5].action = function()    -- index 5 = fly_toggle
		flyKeyActive = not flyKeyActive
		toggleStates["fly_toggle"] = flyKeyActive

		if flyKeyActive then
			local char = Player.Character
			if not char then flyKeyActive=false; return end
			local root = char:FindFirstChild("HumanoidRootPart")
			if not root then flyKeyActive=false; return end

			local bg = Instance.new("BodyGyro", root)
			bg.Name = "_NovaFlyGyro"; bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
			bg.D = 100; bg.P = 10000

			local bv = Instance.new("BodyVelocity", root)
			bv.Name = "_NovaFlyVel"; bv.MaxForce = Vector3.new(9e9,9e9,9e9); bv.Velocity = Vector3.zero

			local flySpd = _G._NovaFlySpeed or 40
			_G._NovaFlying = true

			_G._NovaFlyConn = RunService.RenderStepped:Connect(function()
				if not _G._NovaFlying then return end
				local cam = workspace.CurrentCamera
				local dir = Vector3.zero
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space)       then dir = dir + Vector3.new(0,1,0) end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
				bv.Velocity = dir.Magnitude > 0 and dir.Unit * flySpd or Vector3.zero
				bg.CFrame = cam.CFrame
			end)

			local h = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
			if h then h.PlatformStand = true end
			showToast("Fly ON — WASD + Space/Ctrl ✈", "ok")
		else
			_G._NovaFlying = false
			if _G._NovaFlyConn then _G._NovaFlyConn:Disconnect(); _G._NovaFlyConn = nil end
			local char = Player.Character
			if char then
				local root = char:FindFirstChild("HumanoidRootPart")
				if root then
					local bg2 = root:FindFirstChild("_NovaFlyGyro")
					local bv2 = root:FindFirstChild("_NovaFlyVel")
					if bg2 then bg2:Destroy() end
					if bv2 then bv2:Destroy() end
				end
				local h = char:FindFirstChildOfClass("Humanoid")
				if h then h.PlatformStand = false end
			end
			showToast("Fly OFF", "warn")
		end
	end

	-- God Mode
	local godKeyActive = false
	BIND_ACTIONS[8].action = function()    -- index 8 = god_mode
		godKeyActive = not godKeyActive
		toggleStates["god_mode"] = godKeyActive
		local char = Player.Character
		local h = char and char:FindFirstChildOfClass("Humanoid")
		if h then
			if godKeyActive then
				h.MaxHealth = math.huge; h.Health = math.huge
				_G._NovaGodOn = true
				_G._NovaGodConn = h.HealthChanged:Connect(function(hp)
					if _G._NovaGodOn and hp < math.huge then h.Health = math.huge end
				end)
			else
				_G._NovaGodOn = false
				if _G._NovaGodConn then _G._NovaGodConn:Disconnect(); _G._NovaGodConn = nil end
				h.MaxHealth = 100; h.Health = 100
			end
		end
		showToast("God Mode "..(godKeyActive and "ON ⚡" or "OFF"), godKeyActive and "ok" or "warn")
	end

	-- Anti-AFK
	local afkKeyActive = false
	BIND_ACTIONS[9].action = function()    -- index 9 = anti_afk
		afkKeyActive = not afkKeyActive
		toggleStates["anti_afk"] = afkKeyActive
		_G._NovaAFKOn = afkKeyActive
		if afkKeyActive then
			task.spawn(function()
				while _G._NovaAFKOn do
					task.wait(15)
					if not _G._NovaAFKOn then break end
					pcall(function()
						local vu = game:GetService("VirtualUser")
						vu:CaptureController(); vu:ClickButton2(Vector2.new())
					end)
				end
			end)
			showToast("Anti-AFK ON 🕐", "ok")
		else
			showToast("Anti-AFK OFF", "warn")
		end
	end

	-- Rain toggle
	local rainKeyActive = false
	local rainParts2 = {}
	BIND_ACTIONS[10].action = function()   -- index 10 = rain_toggle
		rainKeyActive = not rainKeyActive
		toggleStates["rain_toggle"] = rainKeyActive
		if rainKeyActive then
			-- Inline rain (bản rút gọn — xem Display page để chỉnh intensity)
			task.spawn(function()
				local cam = workspace.CurrentCamera
				while rainKeyActive and cam do
					for _ = 1, 18 do
						if not rainKeyActive then break end
						local p = Instance.new("Part")
						p.Size = Vector3.new(0.05,1.2,0.05)
						p.Material = Enum.Material.Neon
						p.Color = Color3.fromRGB(180,210,255)
						p.CastShadow = false; p.CanCollide = false; p.Anchored = true
						local o = cam.CFrame.Position
						p.CFrame = CFrame.new(o.X+math.random(-40,40), o.Y+30, o.Z+math.random(-40,40))
						p.Parent = workspace; table.insert(rainParts2, p)
						task.spawn(function()
							for _ = 1, 30 do
								if not p.Parent then break end
								p.CFrame = p.CFrame * CFrame.new(0,-3.5,0)
								task.wait(0.02)
							end
							pcall(function() p:Destroy() end)
						end)
					end
					task.wait(0.08)
				end
			end)
			showToast("Rain ON 🌧", "ok")
		else
			for _, p in ipairs(rainParts2) do pcall(function() p:Destroy() end) end
			rainParts2 = {}
			showToast("Rain OFF", "warn")
		end
	end

	-- Cinematic Mode
	local cinematicOn = false
	BIND_ACTIONS[11].action = function()   -- index 11 = cinematic
		cinematicOn = not cinematicOn
		toggleStates["cinematic"] = cinematicOn
		local existing = Player.PlayerGui:FindFirstChild("_NovaCinematic")
		if cinematicOn then
			if existing then existing:Destroy() end
			local sg = Instance.new("ScreenGui", Player.PlayerGui)
			sg.Name = "_NovaCinematic"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true
			local topBar = Instance.new("Frame", sg)
			topBar.Size = UDim2.new(1,0,0,0)
			topBar.BackgroundColor3 = Color3.new(0,0,0); topBar.BorderSizePixel = 0; topBar.ZIndex = 999
			tween(topBar, {Size=UDim2.new(1,0,0,52)}, EZ_SLOW)
			local botBar = Instance.new("Frame", sg)
			botBar.Size = UDim2.new(1,0,0,0)
			botBar.Position = UDim2.new(0,0,1,0); botBar.AnchorPoint = Vector2.new(0,1)
			botBar.BackgroundColor3 = Color3.new(0,0,0); botBar.BorderSizePixel = 0; botBar.ZIndex = 999
			tween(botBar, {Size=UDim2.new(1,0,0,52)}, EZ_SLOW)
			showToast("Cinematic ON 🎬", "ok")
		else
			if existing then
				for _, bar in ipairs(existing:GetChildren()) do
					if bar:IsA("Frame") then tween(bar,{Size=UDim2.new(1,0,0,0)},EZ_MED) end
				end
				task.delay(0.4, function()
					if existing and existing.Parent then existing:Destroy() end
				end)
			end
			showToast("Cinematic OFF", "warn")
		end
	end

	-- Night Vision
	local nvOn = false
	BIND_ACTIONS[12].action = function()   -- index 12 = night_vision
		nvOn = not nvOn
		toggleStates["night_vision"] = nvOn
		local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
		if nvOn then
			if not cc then cc = Instance.new("ColorCorrectionEffect", Lighting) end
			cc.TintColor = Color3.fromRGB(100,255,120)
			cc.Brightness = 0.4; cc.Contrast = 0.3; cc.Saturation = -0.5; cc.Enabled = true
			Lighting.Brightness = 6
			showToast("Night Vision ON 🟢", "ok")
		else
			if cc then tween(cc,{TintColor=Color3.new(1,1,1),Brightness=0,Contrast=0,Saturation=0}) end
			Lighting.Brightness = 2
			showToast("Night Vision OFF", "warn")
		end
	end

	-- ════════════════════════════════════════
	-- CONFLICT DETECTION
	-- ════════════════════════════════════════
	local function getConflicts()
		local used = {}       -- [keyCode] = id
		local conflicts = {}  -- [id] = true
		for _, ba in ipairs(BIND_ACTIONS) do
			local kc = bindings[ba.id]
			if kc and kc ~= Enum.KeyCode.Unknown then
				local key = tostring(kc)
				if used[key] then
					conflicts[ba.id]    = true
					conflicts[used[key]] = true
				else
					used[key] = ba.id
				end
			end
		end
		return conflicts
	end

	-- ════════════════════════════════════════
	-- IMPORT / EXPORT
	-- ════════════════════════════════════════
	local function exportConfig()
		local lines = {}
		for _, ba in ipairs(BIND_ACTIONS) do
			local kc = bindings[ba.id]
			local ks = kc and tostring(kc):gsub("Enum.KeyCode.","") or "Unknown"
			table.insert(lines, ba.id.." = "..ks)
		end
		copyText(table.concat(lines, "\n"))
		showToast("Config đã copy vào clipboard 📋", "ok")
	end

	-- ════════════════════════════════════════
	-- UI  BUILD
	-- ════════════════════════════════════════

	-- Info banner
	local infoBanner = newFrame(keybindPage, {
		BG = Color3.fromRGB(16,16,36),
		Size = UDim2.new(1,0,0,34), ZIndex=12,
	})
	infoBanner.LayoutOrder = 1
	corner(infoBanner, 10); stroke(infoBanner, T.ACCENT, 1)
	newLabel(infoBanner, {
		Text = "  ℹ Click [BIND] → nhấn phím mới  ·  Esc để hủy  ·  Keybinds hoạt động khi menu đóng",
		Color = T.ACCENT, Size = 10,
		Sz = UDim2.new(1,-10,1,0), Position = UDim2.new(0,10,0,0), ZIndex=13,
	})

	-- Conflict banner (ẩn mặc định)
	local conflictBanner = newFrame(keybindPage, {
		BG = Color3.fromRGB(40,32,6), BT = 1,
		Size = UDim2.new(1,0,0,0), ZIndex=12,
	})
	conflictBanner.LayoutOrder = 2
	conflictBanner.ClipsDescendants = true
	corner(conflictBanner, 8); stroke(conflictBanner, T.WARN, 1)
	local conflictLbl = newLabel(conflictBanner, {
		Text = "", Color = T.WARN, Size = 10,
		Sz = UDim2.new(1,-10,1,0), Position = UDim2.new(0,10,0,0), ZIndex=13,
	})

	local function showConflict(msg)
		conflictLbl.Text = "⚠  "..msg
		tween(conflictBanner, {Size=UDim2.new(1,0,0,28)}, EZ)
	end
	local function hideConflict()
		tween(conflictBanner, {Size=UDim2.new(1,0,0,0)}, EZ)
	end

	-- Toolbar (Export / Import / Reset)
	local toolRow = newFrame(keybindPage, {
		BG=Color3.fromRGB(0,0,0), BT=1,
		Size=UDim2.new(1,0,0,36), ZIndex=12,
	})
	toolRow.LayoutOrder = 3

	local function makeToolBtn(label, color, x, w, onClick)
		local b = Instance.new("TextButton", toolRow)
		b.Size = UDim2.new(0,w,0,26); b.Position = UDim2.new(0,x,0.5,-13)
		b.Text = label; b.TextSize = 10; b.Font = Enum.Font.GothamBold
		b.TextColor3 = color; b.BackgroundColor3 = T.SURFACE2
		b.BorderSizePixel = 0; b.ZIndex = 13
		corner(b,7); stroke(b, color, 1)
		b.MouseButton1Click:Connect(onClick)
		b.MouseEnter:Connect(function() tween(b,{BackgroundColor3=T.GLASS}) end)
		b.MouseLeave:Connect(function() tween(b,{BackgroundColor3=T.SURFACE2}) end)
		return b
	end

	makeToolBtn("📋 Export Config", T.ACCENT, 0, 98, exportConfig)
	makeToolBtn("↺ Reset Tất Cả", T.TEXT3, 104, 94, function()
		for _, ba in ipairs(BIND_ACTIONS) do bindings[ba.id] = ba.default end
		hideConflict()
		showToast("Đã reset về mặc định", "ok")
		rebuildKeybindRows()
	end)
	makeToolBtn("🗑 Xóa Hết", T.DANGER, 204, 74, function()
		for _, ba in ipairs(BIND_ACTIONS) do bindings[ba.id] = Enum.KeyCode.Unknown end
		hideConflict()
		showToast("Đã xóa tất cả keybind", "warn")
		rebuildKeybindRows()
	end)

	-- ════════════════════════════════════════
	-- CATEGORIES  +  ROWS
	-- ════════════════════════════════════════
	local CAT_ORDER = { "Movement", "Combat", "Visual", "UI" }
	local CAT_ICONS = { Movement="⬡", Combat="★", Visual="◈", UI="⌂" }

	local waitingFor  = nil   -- id đang chờ phím
	local rowRegistry = {}    -- [id] = { keyLbl, bindBtn, statusDot }
	local rowFrames   = {}    -- list of frames để rebuild

	-- Clear & rebuild tất cả rows
	function rebuildKeybindRows()
		for _, f in ipairs(rowFrames) do if f.Parent then f:Destroy() end end
		rowFrames = {}; rowRegistry = {}

		local conflicts = getConflicts()
		local order = 10

		for _, cat in ipairs(CAT_ORDER) do
			local hasAny = false
			for _, ba in ipairs(BIND_ACTIONS) do
				if ba.cat == cat then hasAny = true; break end
			end
			if not hasAny then continue end

			-- Section label
			order += 1
			local sep = newFrame(keybindPage, {
				BG=Color3.fromRGB(0,0,0), BT=1,
				Size=UDim2.new(1,0,0,22), ZIndex=12,
			})
			sep.LayoutOrder = order
			table.insert(rowFrames, sep)

			local catLine = newFrame(sep, {
				BG=T.BORDER, Size=UDim2.new(1,-80,0,1),
				Position=UDim2.new(0,76,0.5,0), ZIndex=12,
			})
			newLabel(sep, {
				Text = "◈  "..string.upper(cat),
				Color = T.ACCENT, Size = 9, Font = Enum.Font.GothamBold,
				Sz = UDim2.new(0,72,1,0), ZIndex=13,
			})

			-- Rows cho cat này
			for _, ba in ipairs(BIND_ACTIONS) do
				if ba.cat ~= cat then continue end

				order += 1
				local kc      = bindings[ba.id]
				local isWait  = waitingFor == ba.id
				local hasConf = conflicts[ba.id]
				local isOn    = toggleStates[ba.id]
				local keyStr  = kc and kc ~= Enum.KeyCode.Unknown
					and tostring(kc):gsub("Enum.KeyCode.","") or "—"

				local row = newFrame(keybindPage, {
					BG = T.SURFACE,
					Size = UDim2.new(1,0,0,54), ZIndex=12,
				})
				row.LayoutOrder = order
				corner(row, 10)
				if isWait then
					stroke(row, T.ACCENT, 1.5)
				elseif hasConf then
					stroke(row, T.WARN, 1.5)
				else
					stroke(row, T.BORDER, 1)
				end
				table.insert(rowFrames, row)

				-- Store id
				local idVal = Instance.new("StringValue", row)
				idVal.Name = "_bindId"; idVal.Value = ba.id

				-- Label
				newLabel(row, {
					Text = ba.label,
					Color = T.TEXT, Size = 12, Font = Enum.Font.GothamBold,
					Sz = UDim2.new(0,150,0,20),
					Position = UDim2.new(0,14,0,8), ZIndex=13,
				})
				-- Sub
				newLabel(row, {
					Text = ba.sub,
					Color = T.TEXT3, Size = 9,
					Sz = UDim2.new(0,160,0,16),
					Position = UDim2.new(0,14,0,28), ZIndex=13,
				})

				-- Conflict badge
				if hasConf and not isWait then
					local confBadge = newFrame(row, {
						BG = Color3.fromRGB(52,36,6),
						Size = UDim2.new(0,54,0,16),
						Position = UDim2.new(0,14,0,36), ZIndex=13,
					})
					corner(confBadge, 5); stroke(confBadge, T.WARN, 1)
					newLabel(confBadge, {
						Text = "CONFLICT",
						Color = T.WARN, Size = 7, Font = Enum.Font.GothamBold,
						AlignX = Enum.TextXAlignment.Center,
						Sz = UDim2.new(1,0,1,0), ZIndex=14,
					})
				end

				-- Toggle status pill
				if ba.toggleable then
					local pillF = newFrame(row, {
						BG = isOn and T.ACCENT or T.SURFACE2,
						Size = UDim2.new(0,28,0,14),
						Position = UDim2.new(0,178,0,10), ZIndex=13,
					})
					corner(pillF, 7); stroke(pillF, isOn and T.ACCENT or T.BORDER, 1)
					newLabel(pillF, {
						Text = isOn and "ON" or "OFF",
						Color = isOn and T.WHITE or T.TEXT3,
						Size = 8, Font = Enum.Font.GothamBold,
						AlignX = Enum.TextXAlignment.Center,
						Sz = UDim2.new(1,0,1,0), ZIndex=14,
					})
				end

				-- Key badge
				local keyBadge = newFrame(row, {
					BG = isWait and Color3.fromRGB(20,20,50) or T.SURFACE2,
					Size = UDim2.new(0,84,0,28),
					Position = UDim2.new(0.5,2,0.5,-14), ZIndex=13,
				})
				corner(keyBadge, 8)
				stroke(keyBadge,
					isWait and T.ACCENT or (hasConf and T.WARN or T.BORDER), 1)

				local keyLbl = newLabel(keyBadge, {
					Text = isWait and "nhấn phím…" or keyStr,
					Color = isWait and T.ACCENT or (hasConf and T.WARN or T.TEXT),
					Size = isWait and 9 or 11,
					Font = Enum.Font.GothamBold,
					AlignX = Enum.TextXAlignment.Center,
					Sz = UDim2.new(1,0,1,0), ZIndex=14,
				})
				keyLbl.Name = "_keyLbl"

				-- Bind button
				local bindBtn = Instance.new("TextButton", row)
				bindBtn.Name = "_bindBtn"
				bindBtn.Size = UDim2.new(0,52,0,28)
				bindBtn.AnchorPoint = Vector2.new(1,0.5)
				bindBtn.Position = UDim2.new(1,-48,0.5,0)
				bindBtn.Text = isWait and "Hủy" or "BIND"
				bindBtn.TextSize = 10; bindBtn.Font = Enum.Font.GothamBold
				bindBtn.TextColor3 = isWait and T.WHITE or T.ACCENT
				bindBtn.BackgroundColor3 = isWait and T.ACCENT or T.SURFACE2
				bindBtn.BorderSizePixel = 0; bindBtn.ZIndex = 13
				corner(bindBtn, 8); stroke(bindBtn, isWait and T.ACCENT or T.ACCENT, 1)

				-- Reset individual
				local resetBtn = Instance.new("TextButton", row)
				resetBtn.Size = UDim2.new(0,32,0,28)
				resetBtn.AnchorPoint = Vector2.new(1,0.5)
				resetBtn.Position = UDim2.new(1,-10,0.5,0)
				resetBtn.Text = "↺"
				resetBtn.TextSize = 12; resetBtn.Font = Enum.Font.GothamBold
				resetBtn.TextColor3 = T.TEXT3
				resetBtn.BackgroundColor3 = T.SURFACE2
				resetBtn.BorderSizePixel = 0; resetBtn.ZIndex = 13
				corner(resetBtn, 8); stroke(resetBtn, T.BORDER, 1)
				resetBtn.MouseEnter:Connect(function() tween(resetBtn,{BackgroundColor3=T.GLASS,TextColor3=T.WARN}) end)
				resetBtn.MouseLeave:Connect(function() tween(resetBtn,{BackgroundColor3=T.SURFACE2,TextColor3=T.TEXT3}) end)
				resetBtn.MouseButton1Click:Connect(function()
					bindings[ba.id] = ba.default
					showToast(ba.label.." → reset về "..tostring(ba.default):gsub("Enum.KeyCode.",""), "ok")
					rebuildKeybindRows()
				end)

				rowRegistry[ba.id] = { keyLbl=keyLbl, bindBtn=bindBtn, keyBadge=keyBadge }

				-- Bind button logic
				bindBtn.MouseEnter:Connect(function()
					if waitingFor ~= ba.id then tween(bindBtn,{BackgroundColor3=T.GLASS}) end
				end)
				bindBtn.MouseLeave:Connect(function()
					if waitingFor ~= ba.id then tween(bindBtn,{BackgroundColor3=T.SURFACE2}) end
				end)
				bindBtn.MouseButton1Click:Connect(function()
					if waitingFor == ba.id then
						-- Hủy
						waitingFor = nil
						showToast("Đã hủy đổi keybind", "warn")
					else
						if waitingFor then
							-- Cancel trước
							waitingFor = nil
						end
						waitingFor = ba.id
						showToast("Nhấn phím mới… (Esc để hủy)", "info")
					end
					rebuildKeybindRows()
				end)
			end  -- end BIND_ACTIONS loop
		end  -- end CAT_ORDER loop

		-- Update conflict state
		local conflicts2 = getConflicts()
		local conflictList = {}
		for id, _ in pairs(conflicts2) do
			local ba = nil
			for _, b in ipairs(BIND_ACTIONS) do if b.id == id then ba = b; break end end
			if ba then table.insert(conflictList, ba.label) end
		end
		if #conflictList > 0 then
			showConflict("Conflict: "..table.concat(conflictList, ", ").." — dùng chung phím")
		else
			hideConflict()
		end
	end

	-- ════════════════════════════════════════
	-- GLOBAL KEY LISTENER
	-- ════════════════════════════════════════
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		-- ── Rebind mode ──
		if waitingFor then
			local kc = input.KeyCode
			if kc == Enum.KeyCode.Unknown then return end
			if kc == Enum.KeyCode.Escape then
				waitingFor = nil
				showToast("Đã hủy đổi keybind", "warn")
				rebuildKeybindRows()
				return
			end
			-- Check modifier keys — bỏ qua
			local ignored = {
				Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift,
				Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl,
				Enum.KeyCode.LeftAlt, Enum.KeyCode.RightAlt,
			}
			for _, ign in ipairs(ignored) do if kc == ign then return end end

			bindings[waitingFor] = kc
			local kcStr = tostring(kc):gsub("Enum.KeyCode.","")
			showToast("Keybind: "..kcStr.." ✓", "ok")
			waitingFor = nil
			rebuildKeybindRows()
			return
		end

		-- ── Normal hotkeys ──
		-- Cho phép kể cả khi gameProcessed nếu không có TextBox focus
		if gameProcessed and UserInputService:GetFocusedTextBox() then return end

		for _, ba in ipairs(BIND_ACTIONS) do
			local kc = bindings[ba.id]
			if kc and kc ~= Enum.KeyCode.Unknown and input.KeyCode == kc and ba.action then
				task.spawn(ba.action)
			end
		end
	end)

	-- ════════════════════════════════════════
	-- KHỞI TẠO key
	
	-- ════════════════════════════════════════
	rebuildKeybindRows()
end

-- ══════════════════════════════════════════
-- ★ PAGE: EVENTS — REMOTE SPY  v2
-- ══════════════════════════════════════════
local eventsPage, _ = makePage("Events")

do
	local spyActive  = false
	local spyConns   = {}
	local logCount   = 0
	local totalFired = 0
	local filterText = ""
	local isPaused   = false
	local remoteSet  = {}
	local MAX_LOGS   = 120

	-- ── Kind meta ──
	local KIND_COLOR = {
		RE_fire   = Color3.fromRGB(99, 102,241),
		RE_recv   = Color3.fromRGB(34, 197, 94),
		RF_invoke = Color3.fromRGB(251,191, 36),
		RF_result = Color3.fromRGB(96, 165,250),
		RF_cb     = Color3.fromRGB(167,139,250),
		BE        = Color3.fromRGB(250,204, 21),
		BF        = Color3.fromRGB(244,114,182),
	}
	local KIND_BG = {
		RE_fire   = Color3.fromRGB(16,16,44),
		RE_recv   = Color3.fromRGB(10,32,18),
		RF_invoke = Color3.fromRGB(38,30, 8),
		RF_result = Color3.fromRGB( 8,20,44),
		RF_cb     = Color3.fromRGB(26,18,48),
		BE        = Color3.fromRGB(38,32, 5),
		BF        = Color3.fromRGB(38,16,28),
	}
	local KIND_TAG = {
		RE_fire   = "▶ C→S Fire",
		RE_recv   = "◀ S→C Recv",
		RF_invoke = "↗ C→S Invoke",
		RF_result = "↙ S→C Result",
		RF_cb     = "↙ S→C CB",
		BE        = "⬡ BindEvent",
		BF        = "⬡ BindFn",
	}

	-- ── Serialize ──
	local function serializeArg(a)
		local t = typeof(a)
		if t=="Instance"  then return "["..a.ClassName.."] "..a.Name
		elseif t=="Vector3" then return string.format("V3(%.1f,%.1f,%.1f)",a.X,a.Y,a.Z)
		elseif t=="CFrame"  then local p=a.Position; return string.format("CF(%.1f,%.1f,%.1f)",p.X,p.Y,p.Z)
		elseif t=="table"   then
			local parts={}
			for k,v in pairs(a) do
				table.insert(parts,tostring(k).."="..tostring(v))
				if #parts>=5 then table.insert(parts,"…"); break end
			end
			return "{"..table.concat(parts,",").."}"
		elseif t=="boolean" then return a and "true" or "false"
		else local s=tostring(a); return #s>70 and s:sub(1,67).."…" or s end
	end

	local function formatArgs(args)
		if #args==0 then return "(no args)" end
		local parts={}
		for i,a in ipairs(args) do table.insert(parts,"["..i.."] "..serializeArg(a)) end
		return table.concat(parts,"   ")
	end

	-- ══════════════════════════════════
	-- HEADER AREA
	-- ══════════════════════════════════

	-- Stats row (3 cells)
	local statsCard = makeCard(eventsPage, 56, 1)
	gradient(statsCard, Color3.fromRGB(20,20,38), Color3.fromRGB(15,15,25), 135)

	local statDefs2 = {
		{label="TOTAL FIRED", key="total",   col=0, color=T.TEXT},
		{label="REMOTES",     key="remotes", col=1, color=T.ACCENT},
		{label="FILTER",      key="filter",  col=2, color=T.WARN},
	}
	local statVals2 = {}
	for _, sd in ipairs(statDefs2) do
		local cell = newFrame(statsCard, {
			BG   = T.SURFACE2,
			Size = UDim2.new(0,82,0,36),
			Position = UDim2.new(0,8+sd.col*88,0,10),
			ZIndex = 13,
		})
		corner(cell, 8)
		stroke(cell, T.BORDER, 1)
		newLabel(cell,{Text=sd.label,Color=T.TEXT3,Size=7,Font=Enum.Font.GothamBold,
			Sz=UDim2.new(1,-6,0,14),Position=UDim2.new(0,5,0,2),ZIndex=14})
		local vl=newLabel(cell,{Text="0",Color=sd.color,Size=15,Font=Enum.Font.GothamBold,
			Sz=UDim2.new(1,-6,0,18),Position=UDim2.new(0,5,0,16),ZIndex=14})
		statVals2[sd.key]=vl
	end

	-- Controls row
	local ctrlRow = newFrame(eventsPage,{BG=Color3.fromRGB(0,0,0),BT=1,Size=UDim2.new(1,0,0,36),ZIndex=12})
	ctrlRow.LayoutOrder=2

	local function makeCtrlBtn(text, color, bg, x, w)
		local b = Instance.new("TextButton", ctrlRow)
		b.Size = UDim2.new(0,w,0,28)
		b.Position = UDim2.new(0,x,0.5,-14)
		b.Text = text
		b.TextSize = 10
		b.Font = Enum.Font.GothamBold
		b.TextColor3 = color
		b.BackgroundColor3 = bg
		b.BorderSizePixel = 0
		b.ZIndex = 13
		corner(b,8)
		stroke(b, color, 1)
		return b
	end

	local startBtn = makeCtrlBtn("▶  Start Spy", T.SUCCESS, Color3.fromRGB(10,32,18), 0, 108)
	local pauseBtn = makeCtrlBtn("⏸ Pause",      T.TEXT3,   T.SURFACE2,               114, 66)
	local clearBtn = makeCtrlBtn("🗑 Clear",      T.TEXT3,   T.SURFACE2,               186, 56)
	local exportBtn= makeCtrlBtn("📋 Copy All",   T.ACCENT,  Color3.fromRGB(16,16,40), 248, 70)

	pauseBtn.Visible = false

	-- Filter quick buttons
	local filterRow = newFrame(eventsPage,{BG=Color3.fromRGB(0,0,0),BT=1,Size=UDim2.new(1,0,0,28),ZIndex=12})
	filterRow.LayoutOrder=3
	local filterList = Instance.new("UIListLayout",filterRow)
	filterList.FillDirection=Enum.FillDirection.Horizontal
	filterList.SortOrder=Enum.SortOrder.LayoutOrder
	filterList.Padding=UDim.new(0,4)

	local FILTERS = {
		{label="All",    key=""},
		{label="C→S",    key="RE_fire"},
		{label="S→C",    key="RE_recv"},
		{label="Invoke", key="RF_invoke"},
		{label="Bind",   key="BE"},
	}
	local filterBtns = {}
	for i,f in ipairs(FILTERS) do
		local fb=Instance.new("TextButton",filterRow)
		fb.Size=UDim2.new(0,50,0,22)
		fb.Text=f.label
		fb.TextSize=9
		fb.Font=Enum.Font.GothamBold
		fb.TextColor3 = i==1 and T.WHITE or T.TEXT3
		fb.BackgroundColor3 = i==1 and T.ACCENT or T.SURFACE2
		fb.BorderSizePixel=0
		fb.ZIndex=13
		fb.LayoutOrder=i
		corner(fb,6)
		filterBtns[i]={btn=fb,key=f.key,label=f.label}
	end

	-- Log separator
	local logSep = makeSectionLabel(eventsPage, "Event Log", 4)

	-- Log container
	local logContainer = newFrame(eventsPage,{
		BG=Color3.fromRGB(0,0,0),BT=1,
		Size=UDim2.new(1,0,0,10),ZIndex=11,
	})
	logContainer.LayoutOrder=5
	logContainer.AutomaticSize=Enum.AutomaticSize.Y
	local logLL = Instance.new("UIListLayout",logContainer)
	logLL.SortOrder=Enum.SortOrder.LayoutOrder
	logLL.Padding=UDim.new(0,4)

	local emptyLbl = newLabel(logContainer,{
		Text="▶ Nhấn Start Spy để theo dõi remotes…",
		Color=T.TEXT3, Size=11,
		Sz=UDim2.new(1,0,0,38), ZIndex=12,
		AlignX=Enum.TextXAlignment.Center,
		AlignY=Enum.TextYAlignment.Center,
	})
	emptyLbl.LayoutOrder=99999

	-- ── Apply filter ──
	local activeFilterIdx=1
	local function applyFilter(idx)
		activeFilterIdx=idx
		filterText=filterBtns[idx].key
		statVals2["filter"].Text=filterBtns[idx].label
		for i,fb in ipairs(filterBtns) do
			tween(fb.btn,{
				BackgroundColor3=i==idx and T.ACCENT or T.SURFACE2,
				TextColor3      =i==idx and T.WHITE  or T.TEXT3,
			})
		end
		for _,child in ipairs(logContainer:GetChildren()) do
			if child:IsA("Frame") and child:FindFirstChild("_kind") then
				local kind=child:FindFirstChild("_kind").Value
				child.Visible=(filterText=="" or kind==filterText)
			end
		end
	end
	for i,fb in ipairs(filterBtns) do
		fb.btn.MouseButton1Click:Connect(function() applyFilter(i) end)
	end

	local function updateStats()
		statVals2["total"].Text=tostring(totalFired)
		local rc=0; for _ in pairs(remoteSet) do rc+=1 end
		statVals2["remotes"].Text=tostring(rc)
	end

	-- ── Log entries store (for export) ──
	local logEntries = {}

	-- ══════════════════════════════════
	-- ADD LOG ROW  (v2: copy btn, expand)
	-- ══════════════════════════════════
	local function addLog(kind, remoteName, argStr)
		if isPaused then return end

		emptyLbl.Visible=false
		logCount+=1
		totalFired+=1
		remoteSet[remoteName]=true
		updateStats()

		-- Keep entry for export
		table.insert(logEntries,{
			kind=kind, name=remoteName, args=argStr,
			time=os.date("%H:%M:%S")
		})
		if #logEntries > MAX_LOGS then table.remove(logEntries,1) end

		-- Remove oldest row if over limit
		local rows={}
		for _,c in ipairs(logContainer:GetChildren()) do
			if c:IsA("Frame") then table.insert(rows,c) end
		end
		if #rows >= MAX_LOGS then rows[1]:Destroy() end

		local row = newFrame(logContainer,{
			BG   = KIND_BG[kind] or T.SURFACE2,
			Size = UDim2.new(1,0,0,56),
			ZIndex = 12,
		})
		row.LayoutOrder=logCount
		corner(row,9)
		stroke(row, KIND_COLOR[kind] or T.BORDER, 1)

		-- Left color strip
		local tagF=newFrame(row,{
			BG=KIND_COLOR[kind] or T.BORDER,
			Size=UDim2.new(0,3,1,-8),
			Position=UDim2.new(0,0,0,4),ZIndex=13,
		})
		corner(tagF,2)

		-- Kind badge
		local badge=newFrame(row,{
			BG=KIND_COLOR[kind] or T.BORDER,
			Size=UDim2.new(0,78,0,16),
			Position=UDim2.new(0,8,0,5),ZIndex=13,
		})
		corner(badge,5)
		newLabel(badge,{
			Text=KIND_TAG[kind] or kind,
			Color=T.BG, Size=8, Font=Enum.Font.GothamBold,
			AlignX=Enum.TextXAlignment.Center,
			Sz=UDim2.new(1,0,1,0), ZIndex=14,
		})

		-- Remote name
		newLabel(row,{
			Text=remoteName, Color=T.TEXT, Size=12, Font=Enum.Font.GothamBold,
			Sz=UDim2.new(1,-140,0,18),
			Position=UDim2.new(0,90,0,4),
			ZIndex=13, Truncate=true,
		})

		-- Timestamp
		newLabel(row,{
			Text=os.date("%H:%M:%S"), Color=T.TEXT3, Size=9,
			Sz=UDim2.new(0,52,0,18),
			Position=UDim2.new(1,-56,0,4),
			AlignX=Enum.TextXAlignment.Right, ZIndex=13,
		})

		-- Args text
		local argsLbl = newLabel(row,{
			Text=argStr, Color=T.TEXT2, Size=9,
			Sz=UDim2.new(1,-58,0,18),
			Position=UDim2.new(0,8,0,32),
			ZIndex=13, Truncate=true, Wrapped=false,
		})

		-- ── COPY BUTTON ──
		local copyBtn = Instance.new("TextButton", row)
		copyBtn.Size = UDim2.new(0,44,0,18)
		copyBtn.Position = UDim2.new(1,-50,0,33)
		copyBtn.Text = "📋 copy"
		copyBtn.TextSize = 8
		copyBtn.Font = Enum.Font.GothamBold
		copyBtn.TextColor3 = T.ACCENT
		copyBtn.BackgroundColor3 = T.SURFACE2
		copyBtn.BorderSizePixel = 0
		copyBtn.ZIndex = 14
		corner(copyBtn, 5)
		stroke(copyBtn, T.BORDER, 1)

		local copyCooldown = false
		copyBtn.MouseButton1Click:Connect(function()
			if copyCooldown then return end
			copyCooldown = true
			local payload = string.format(
				"[%s] %s | %s | Args: %s",
				os.date("%H:%M:%S"), KIND_TAG[kind] or kind, remoteName, argStr
			)
			copyText(payload)
			tween(copyBtn, {BackgroundColor3=T.COPY_OK, TextColor3=T.BG})
			copyBtn.Text = "✓ ok"
			showToast("Đã copy args: "..remoteName:sub(1,20),"ok")
			task.delay(1.5, function()
				copyCooldown = false
				tween(copyBtn, {BackgroundColor3=T.SURFACE2, TextColor3=T.ACCENT})
				copyBtn.Text = "📋 copy"
			end)
		end)
		copyBtn.MouseEnter:Connect(function()
			if not copyCooldown then tween(copyBtn,{BackgroundColor3=T.GLASS}) end
		end)
		copyBtn.MouseLeave:Connect(function()
			if not copyCooldown then tween(copyBtn,{BackgroundColor3=T.SURFACE2}) end
		end)

		-- Kind tag for filter
		local kindVal = Instance.new("StringValue", row)
		kindVal.Name="_kind"; kindVal.Value=kind

		if filterText~="" and kind~=filterText then row.Visible=false end

		-- Fade-in animation
		row.BackgroundTransparency = 1
		tween(row, {BackgroundTransparency=0}, EZ_MED)

		return row
	end

	-- ══════════════════════════════════
	-- HOOK REMOTES
	-- ══════════════════════════════════
	local function hookAllRemotes()
		local function scan(root, depth)
			if depth>6 then return end
			for _,c in ipairs(root:GetChildren()) do
				local name=c.Name

				if c:IsA("RemoteEvent") then
					pcall(function()
						table.insert(spyConns, c.OnClientEvent:Connect(function(...)
							addLog("RE_recv",name,formatArgs({...}))
						end))
					end)
					pcall(function()
						local mt=getrawmetatable and getrawmetatable(c)
						if mt then
							local oldNamecall
							oldNamecall=hookmetamethod(game,"__namecall",function(self,...)
								if self==c and getnamecallmethod()=="FireServer" then
									local args={...}
									task.defer(function() addLog("RE_fire",name,formatArgs(args)) end)
								end
								return oldNamecall(self,...)
							end)
							table.insert(spyConns,{Disconnect=function() end})
						else
							local origFS=c.FireServer
							c.FireServer=function(self,...)
								local args={...}
								addLog("RE_fire",name,formatArgs(args))
								return origFS(self,...)
							end
							table.insert(spyConns,{Disconnect=function() c.FireServer=origFS end})
						end
					end)

				elseif c:IsA("RemoteFunction") then
					pcall(function()
						local origCB=c.OnClientInvoke
						c.OnClientInvoke=function(...)
							local args={...}
							addLog("RF_cb",name,formatArgs(args))
							if origCB then return origCB(...) end
						end
						table.insert(spyConns,{Disconnect=function() c.OnClientInvoke=origCB end})
					end)
					pcall(function()
						local origIS=c.InvokeServer
						c.InvokeServer=function(self,...)
							local args={...}
							addLog("RF_invoke",name,formatArgs(args))
							local result=origIS(self,...)
							addLog("RF_result",name.." ← result",
								formatArgs(type(result)=="table" and result or {result}))
							return result
						end
						table.insert(spyConns,{Disconnect=function() c.InvokeServer=origIS end})
					end)

				elseif c:IsA("BindableEvent") then
					pcall(function()
						table.insert(spyConns, c.Event:Connect(function(...)
							addLog("BE",name,formatArgs({...}))
						end))
					end)

				elseif c:IsA("BindableFunction") then
					pcall(function()
						local origOI=c.OnInvoke
						c.OnInvoke=function(...)
							local args={...}
							addLog("BF",name,formatArgs(args))
							if origOI then return origOI(...) end
						end
						table.insert(spyConns,{Disconnect=function() c.OnInvoke=origOI end})
					end)
				end

				scan(c,depth+1)
			end
		end

		local services={"ReplicatedStorage","ReplicatedFirst","Players","Workspace"}
		for _,svcName in ipairs(services) do
			pcall(function() scan(game:GetService(svcName),0) end)
		end

		local function watchNew(root,depth)
			if depth>3 then return end
			table.insert(spyConns,root.ChildAdded:Connect(function(child)
				task.wait(0.1)
				if spyActive then scan(child,0) end
			end))
			for _,c in ipairs(root:GetChildren()) do
				pcall(function() watchNew(c,depth+1) end)
			end
		end
		for _,svcName in ipairs(services) do
			pcall(function() watchNew(game:GetService(svcName),0) end)
		end
	end

	-- ══════════════════════════════════
	-- BUTTON LOGIC
	-- ══════════════════════════════════
	startBtn.MouseButton1Click:Connect(function()
		if not spyActive then
			spyActive=true; isPaused=false
			totalFired=0; remoteSet={}; spyConns={}; logEntries={}
			updateStats()
			emptyLbl.Visible=true
			emptyLbl.Text="⚡ Đang theo dõi — chờ remote được fire…"
			tween(startBtn,{BackgroundColor3=Color3.fromRGB(40,14,14),TextColor3=T.DANGER})
			stroke(startBtn,T.DANGER,1)
			startBtn.Text="■  Stop Spy"
			pauseBtn.Visible=true
			hookAllRemotes()
			showToast("Remote Spy đã bắt đầu","ok")
		else
			spyActive=false; isPaused=false
			for _,conn in ipairs(spyConns) do pcall(function() conn:Disconnect() end) end
			spyConns={}
			tween(startBtn,{BackgroundColor3=Color3.fromRGB(10,32,18),TextColor3=T.SUCCESS})
			stroke(startBtn,T.SUCCESS,1)
			startBtn.Text="▶  Start Spy"
			pauseBtn.Visible=false
			pauseBtn.Text="⏸ Pause"
			tween(pauseBtn,{BackgroundColor3=T.SURFACE2,TextColor3=T.TEXT3})
			addLog("BE","[ SPY STOPPED ]","Đã ngắt hook · "..totalFired.." events bắt được")
			showToast("Spy dừng · "..totalFired.." events","warn")
		end
	end)

	pauseBtn.MouseButton1Click:Connect(function()
		isPaused=not isPaused
		if isPaused then
			pauseBtn.Text="▶ Resume"
			tween(pauseBtn,{BackgroundColor3=Color3.fromRGB(40,34,5),TextColor3=T.WARN})
			showToast("Spy đã tạm dừng","warn")
		else
			pauseBtn.Text="⏸ Pause"
			tween(pauseBtn,{BackgroundColor3=T.SURFACE2,TextColor3=T.TEXT3})
			showToast("Spy tiếp tục","ok")
		end
	end)

	clearBtn.MouseButton1Click:Connect(function()
		for _,c in ipairs(logContainer:GetChildren()) do
			if c:IsA("Frame") then c:Destroy() end
		end
		logCount=0; totalFired=0; remoteSet={}; logEntries={}
		updateStats()
		emptyLbl.Visible=true
		emptyLbl.Text=spyActive and "Đã xóa · đang tiếp tục theo dõi…" or "▶ Nhấn Start Spy để theo dõi remotes…"
		showToast("Đã xóa log","ok")
	end)

	-- Export / Copy All
	exportBtn.MouseButton1Click:Connect(function()
		if #logEntries==0 then showToast("Không có log để copy","warn"); return end
		local lines={}
		for _,e in ipairs(logEntries) do
			table.insert(lines, string.format("[%s] %s | %s | %s",
				e.time, KIND_TAG[e.kind] or e.kind, e.name, e.args))
		end
		copyText(table.concat(lines,"\n"))
		showToast("Đã copy "..#logEntries.." entries","ok")
	end)

	-- Hover effects
	startBtn.MouseEnter:Connect(function()
		tween(startBtn,{BackgroundColor3= not spyActive and Color3.fromRGB(14,48,22) or Color3.fromRGB(56,18,18)})
	end)
	startBtn.MouseLeave:Connect(function()
		tween(startBtn,{BackgroundColor3= not spyActive and Color3.fromRGB(10,32,18) or Color3.fromRGB(40,14,14)})
	end)
	for _,b in ipairs({clearBtn, exportBtn}) do
		b.MouseEnter:Connect(function() tween(b,{BackgroundColor3=T.SURFACE}) end)
		b.MouseLeave:Connect(function() tween(b,{BackgroundColor3=T.SURFACE2}) end)
	end
end

-- ══════════════════════════════════════════
-- ★ PAGE: GUI EDIT  (đọc + override PlayerGui)
-- ══════════════════════════════════════════
local guiEditPage, _ = makePage("GUIEdit")

do
	-- ── Loại element hỗ trợ chỉnh ──
	local EDITABLE = {
		Frame        = true,
		ImageLabel   = true,
		ImageButton  = true,
		TextLabel    = true,
		TextButton   = true,
		ScrollingFrame = true,
		ViewportFrame  = true,
	}

	-- ── State ──
	local selectedGui   = nil   -- GuiObject đang chọn
	local guiRows       = {}
	local originalProps = {}    -- [inst] = {BackgroundColor3=..., Transparency=..., ...}
	local overrides     = {}    -- [inst] = {prop=value, ...}
	local searchQ       = ""
	local guiInited     = false

	-- ── Lưu original để có thể restore ──
	local function saveOriginal(inst)
		if originalProps[inst] then return end
		local ok, _ = pcall(function()
			originalProps[inst] = {
				BackgroundColor3        = inst.BackgroundColor3,
				BackgroundTransparency  = inst.BackgroundTransparency,
				Visible                 = inst.Visible,
				Size                    = inst.Size,
				ZIndex                  = inst.ZIndex,
			}
			if inst:IsA("TextLabel") or inst:IsA("TextButton") then
				originalProps[inst].TextColor3       = inst.TextColor3
				originalProps[inst].TextTransparency = inst.TextTransparency
				originalProps[inst].TextSize         = inst.TextSize
				originalProps[inst].Text             = inst.Text
			end
			if inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
				originalProps[inst].ImageColor3       = inst.ImageColor3
				originalProps[inst].ImageTransparency = inst.ImageTransparency
				originalProps[inst].Image             = inst.Image
			end
		end)
	end

	-- ── Apply override an toàn ──
	local function applyProp(inst, prop, value)
		local ok, err = pcall(function() inst[prop] = value end)
		if not ok then
			showToast("Lỗi: "..tostring(err):sub(1,40), "err")
		end
	end

	-- ════════════════════════════════
	-- HEADER
	-- ════════════════════════════════

	-- Search + Scan bar
	local topCard = makeCard(guiEditPage, 42, 1)
	gradient(topCard, Color3.fromRGB(20,20,38), Color3.fromRGB(15,15,26), 135)

	newLabel(topCard,{Text="🔍",Size=13,
		Sz=UDim2.new(0,26,1,0),Position=UDim2.new(0,8,0,0),
		AlignX=Enum.TextXAlignment.Center,ZIndex=13})

	local guiSearch = Instance.new("TextBox", topCard)
	guiSearch.Size = UDim2.new(1,-80,0,26)
	guiSearch.Position = UDim2.new(0,32,0.5,-13)
	guiSearch.BackgroundColor3 = T.SURFACE2
	guiSearch.BorderSizePixel  = 0
	guiSearch.TextColor3       = T.TEXT
	guiSearch.PlaceholderText  = "Lọc theo tên element…"
	guiSearch.PlaceholderColor3= T.TEXT3
	guiSearch.Text = ""
	guiSearch.TextSize = 11
	guiSearch.Font = Enum.Font.Gotham
	guiSearch.ClearTextOnFocus = false
	guiSearch.ZIndex = 13
	corner(guiSearch, 7)
	stroke(guiSearch, T.BORDER, 1)
	local gsPad = Instance.new("UIPadding", guiSearch); gsPad.PaddingLeft = UDim.new(0,8)

	local scanBtn = Instance.new("TextButton", topCard)
	scanBtn.Size = UDim2.new(0,34,0,26)
	scanBtn.Position = UDim2.new(1,-40,0.5,-13)
	scanBtn.Text = "↺"
	scanBtn.TextSize = 16
	scanBtn.Font = Enum.Font.GothamBold
	scanBtn.TextColor3 = T.ACCENT
	scanBtn.BackgroundColor3 = T.SURFACE2
	scanBtn.BorderSizePixel = 0
	scanBtn.ZIndex = 13
	corner(scanBtn, 7)
	stroke(scanBtn, T.BORDER, 1)
	scanBtn.MouseEnter:Connect(function() tween(scanBtn,{BackgroundColor3=T.GLASS}) end)
	scanBtn.MouseLeave:Connect(function() tween(scanBtn,{BackgroundColor3=T.SURFACE2}) end)

	-- Info bar
	local infoRow = newFrame(guiEditPage,{BG=Color3.fromRGB(0,0,0),BT=1,
		Size=UDim2.new(1,0,0,18),ZIndex=12})
	infoRow.LayoutOrder=2
	local infoLbl = newLabel(infoRow,{Text="  Nhấn ↺ để quét PlayerGui",
		Color=T.TEXT3,Size=9,Font=Enum.Font.GothamBold,
		Sz=UDim2.new(1,0,1,0),ZIndex=12})
	local iPad=Instance.new("UIPadding",infoLbl); iPad.PaddingLeft=UDim.new(0,4)

	-- ════════════════════════════════
	-- ELEMENT LIST  (danh sách GUI objects)
	-- ════════════════════════════════
	local listWrap = newFrame(guiEditPage,{
		BG=T.SURFACE,Size=UDim2.new(1,0,0,10),ZIndex=12})
	listWrap.LayoutOrder=3
	listWrap.AutomaticSize=Enum.AutomaticSize.Y
	corner(listWrap,10)
	stroke(listWrap,T.BORDER,1)
	local listLayout=Instance.new("UIListLayout",listWrap)
	listLayout.SortOrder=Enum.SortOrder.LayoutOrder
	listLayout.Padding=UDim.new(0,1)
	local listPad=Instance.new("UIPadding",listWrap)
	listPad.PaddingTop=UDim.new(0,4); listPad.PaddingBottom=UDim.new(0,4)

	local emptyGuiLbl = newLabel(listWrap,{
		Text="Nhấn ↺ để quét GUI của game…",
		Color=T.TEXT3,Size=11,
		Sz=UDim2.new(1,0,0,36),ZIndex=13,
		AlignX=Enum.TextXAlignment.Center,
	})
	emptyGuiLbl.LayoutOrder=9999

	-- ════════════════════════════════
	-- PROPERTIES PANEL  (hiện khi chọn element)
	-- ════════════════════════════════
	local propSep = makeSectionLabel(guiEditPage,"Properties",4)
	propSep.Visible=false

	local propWrap = newFrame(guiEditPage,{
		BG=T.SURFACE,Size=UDim2.new(1,0,0,10),ZIndex=12})
	propWrap.LayoutOrder=5
	propWrap.AutomaticSize=Enum.AutomaticSize.Y
	propWrap.Visible=false
	corner(propWrap,10)
	stroke(propWrap,T.BORDER,1)
	local propLayout=Instance.new("UIListLayout",propWrap)
	propLayout.SortOrder=Enum.SortOrder.LayoutOrder
	propLayout.Padding=UDim.new(0,6)
	local propPad=Instance.new("UIPadding",propWrap)
	propPad.PaddingTop=UDim.new(0,8); propPad.PaddingBottom=UDim.new(0,8)
	propPad.PaddingLeft=UDim.new(0,10); propPad.PaddingRight=UDim.new(0,10)

	-- ── Restore All button ──
	local restoreCard = newFrame(guiEditPage,{
		BG=Color3.fromRGB(0,0,0),BT=1,
		Size=UDim2.new(1,0,0,36),ZIndex=12})
	restoreCard.LayoutOrder=6
	restoreCard.Visible=false

	local restoreBtn = Instance.new("TextButton",restoreCard)
	restoreBtn.Size=UDim2.new(1,0,0,28)
	restoreBtn.Position=UDim2.new(0,0,0.5,-14)
	restoreBtn.Text="↩  Restore tất cả về gốc"
	restoreBtn.TextSize=11
	restoreBtn.Font=Enum.Font.GothamBold
	restoreBtn.TextColor3=T.WARN
	restoreBtn.BackgroundColor3=Color3.fromRGB(40,32,10)
	restoreBtn.BorderSizePixel=0
	restoreBtn.ZIndex=13
	corner(restoreBtn,8)
	stroke(restoreBtn,T.WARN,1)
	restoreBtn.MouseEnter:Connect(function() tween(restoreBtn,{BackgroundColor3=Color3.fromRGB(60,46,12)}) end)
	restoreBtn.MouseLeave:Connect(function() tween(restoreBtn,{BackgroundColor3=Color3.fromRGB(40,32,10)}) end)

	-- ════════════════════════════════
	-- BUILD PROPERTY EDITORS
	-- ════════════════════════════════
	local function clearProps()
		for _,c in ipairs(propWrap:GetChildren()) do
			if c:IsA("Frame") or c:IsA("TextButton") or c:IsA("TextBox") then c:Destroy() end
		end
	end

	-- Row label helper
	local function propRow(order, labelTxt)
		local r = newFrame(propWrap,{
			BG=T.SURFACE2,Size=UDim2.new(1,0,0,36),ZIndex=13})
		r.LayoutOrder=order
		corner(r,8)
		stroke(r,T.BORDER,1)
		newLabel(r,{Text=labelTxt,Color=T.TEXT2,Size=10,Font=Enum.Font.GothamBold,
			Sz=UDim2.new(0,110,1,0),Position=UDim2.new(0,8,0,0),ZIndex=14})
		return r
	end

	-- ── Slider prop (0→1 transparency hoặc số) ──
	local function makePropSlider(order, labelTxt, minV, maxV, currentV, onChange)
		local r = propRow(order, labelTxt)

		local valLbl = newLabel(r,{
			Text=string.format("%.2f", currentV),
			Color=T.ACCENT,Size=10,Font=Enum.Font.GothamBold,
			Sz=UDim2.new(0,34,0,20),
			Position=UDim2.new(1,-38,0.5,-10),
			AlignX=Enum.TextXAlignment.Right,ZIndex=14})

		local track = newFrame(r,{
			BG=T.SURFACE,Size=UDim2.new(1,-160,0,5),
			Position=UDim2.new(0,118,0.5,-2),ZIndex=14})
		corner(track,3); stroke(track,T.BORDER,1)

		local fill = newFrame(track,{
			BG=T.ACCENT,
			Size=UDim2.new(math.clamp((currentV-minV)/(maxV-minV),0,1),0,1,0),ZIndex=15})
		corner(fill,3)

		local thumb=Instance.new("TextButton",track)
		thumb.Size=UDim2.new(0,13,0,13)
		thumb.AnchorPoint=Vector2.new(0.5,0.5)
		thumb.Position=UDim2.new(math.clamp((currentV-minV)/(maxV-minV),0,1),0,0.5,0)
		thumb.BackgroundColor3=T.WHITE
		thumb.Text=""; thumb.BorderSizePixel=0; thumb.ZIndex=16
		corner(thumb,7); stroke(thumb,T.ACCENT,1)

		local drag=false
		thumb.InputBegan:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true end
		end)
		UserInputService.InputEnded:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
		end)
		UserInputService.InputChanged:Connect(function(i)
			if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
				local rx=math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
				local v=minV+rx*(maxV-minV)
				fill.Size=UDim2.new(rx,0,1,0)
				thumb.Position=UDim2.new(rx,0,0.5,0)
				valLbl.Text=string.format("%.2f",v)
				onChange(v)
			end
		end)
		return r
	end

	-- ── Toggle prop ──
	local function makePropToggle(order, labelTxt, currentV, onChange)
		local r = propRow(order, labelTxt)
		local track=Instance.new("TextButton",r)
		track.Size=UDim2.new(0,38,0,20)
		track.AnchorPoint=Vector2.new(1,0.5)
		track.Position=UDim2.new(1,-8,0.5,0)
		track.BackgroundColor3=currentV and T.ACCENT or T.SURFACE
		track.Text=""; track.BorderSizePixel=0; track.ZIndex=14
		corner(track,11); stroke(track,T.BORDER,1)
		local thumb=newFrame(track,{BG=T.WHITE,
			Size=UDim2.new(0,14,0,14),
			Position=currentV and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
			ZIndex=15})
		corner(thumb,8)
		local isOn=currentV
		track.MouseButton1Click:Connect(function()
			isOn=not isOn
			tween(track,{BackgroundColor3=isOn and T.ACCENT or T.SURFACE})
			tween(thumb,{Position=isOn and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)})
			onChange(isOn)
		end)
		return r
	end

	-- ── Color picker (R G B sliders) ──
	local function makePropColor(order, labelTxt, currentColor, onChange)
		local wrap=newFrame(propWrap,{
			BG=Color3.fromRGB(0,0,0),BT=1,
			Size=UDim2.new(1,0,0,10),ZIndex=13})
		wrap.LayoutOrder=order
		wrap.AutomaticSize=Enum.AutomaticSize.Y
		local wl=Instance.new("UIListLayout",wrap)
		wl.SortOrder=Enum.SortOrder.LayoutOrder
		wl.Padding=UDim.new(0,3)

		-- preview + label row
		local headRow=newFrame(wrap,{BG=T.SURFACE2,Size=UDim2.new(1,0,0,28),ZIndex=13})
		headRow.LayoutOrder=0; corner(headRow,8); stroke(headRow,T.BORDER,1)

		local preview=newFrame(headRow,{
			BG=currentColor,Size=UDim2.new(0,18,0,18),
			Position=UDim2.new(0,8,0.5,-9),ZIndex=14})
		corner(preview,5)

		newLabel(headRow,{Text=labelTxt,Color=T.TEXT2,Size=10,Font=Enum.Font.GothamBold,
			Sz=UDim2.new(1,-40,1,0),Position=UDim2.new(0,32,0,0),ZIndex=14})

		local r,g,b = currentColor.R*255, currentColor.G*255, currentColor.B*255

		local function rebuild()
			local col=Color3.fromRGB(math.floor(r),math.floor(g),math.floor(b))
			tween(preview,{BackgroundColor3=col})
			onChange(col)
		end

		local channels={{"R",Color3.fromRGB(239,68,68)},{"G",Color3.fromRGB(34,197,94)},{"B",Color3.fromRGB(96,165,250)}}
		local vals={r,g,b}
		local refs={r,g,b}

		for i,ch in ipairs(channels) do
			local rowC=newFrame(wrap,{BG=T.SURFACE2,Size=UDim2.new(1,0,0,28),ZIndex=13})
			rowC.LayoutOrder=i; corner(rowC,7); stroke(rowC,T.BORDER,1)
			newLabel(rowC,{Text=ch[1],Color=ch[2],Size=10,Font=Enum.Font.GothamBold,
				Sz=UDim2.new(0,20,1,0),Position=UDim2.new(0,8,0,0),ZIndex=14})
			local vLbl=newLabel(rowC,{Text=tostring(math.floor(vals[i])),Color=T.TEXT,Size=10,
				Sz=UDim2.new(0,28,0,20),Position=UDim2.new(1,-32,0.5,-10),
				AlignX=Enum.TextXAlignment.Right,ZIndex=14})
			local tr=newFrame(rowC,{BG=T.SURFACE,Size=UDim2.new(1,-68,0,5),
				Position=UDim2.new(0,24,0.5,-2),ZIndex=14})
			corner(tr,3); stroke(tr,T.BORDER,1)
			local fi=newFrame(tr,{BG=ch[2],Size=UDim2.new(vals[i]/255,0,1,0),ZIndex=15})
			corner(fi,3)
			local th=Instance.new("TextButton",tr)
			th.Size=UDim2.new(0,12,0,12); th.AnchorPoint=Vector2.new(0.5,0.5)
			th.Position=UDim2.new(vals[i]/255,0,0.5,0)
			th.BackgroundColor3=T.WHITE; th.Text=""; th.BorderSizePixel=0; th.ZIndex=16
			corner(th,7); stroke(th,ch[2],1)

			local idx=i
			local drag=false
			th.InputBegan:Connect(function(inp)
				if inp.UserInputType==Enum.UserInputType.MouseButton1 then drag=true end
			end)
			UserInputService.InputEnded:Connect(function(inp)
				if inp.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
			end)
			UserInputService.InputChanged:Connect(function(inp)
				if drag and inp.UserInputType==Enum.UserInputType.MouseMovement then
					local rx=math.clamp((inp.Position.X-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
					local v=rx*255
					fi.Size=UDim2.new(rx,0,1,0)
					th.Position=UDim2.new(rx,0,0.5,0)
					vLbl.Text=tostring(math.floor(v))
					if idx==1 then r=v elseif idx==2 then g=v else b=v end
					rebuild()
				end
			end)
		end
		return wrap
	end

	-- ── Text input prop ──
	local function makePropTextInput(order, labelTxt, currentTxt, onChange)
		local r=propRow(order, labelTxt)
		local box=Instance.new("TextBox",r)
		box.Size=UDim2.new(1,-120,0,24)
		box.Position=UDim2.new(0,112,0.5,-12)
		box.BackgroundColor3=T.SURFACE
		box.BorderSizePixel=0
		box.TextColor3=T.TEXT
		box.Text=tostring(currentTxt)
		box.TextSize=10
		box.Font=Enum.Font.Gotham
		box.ClearTextOnFocus=false
		box.ZIndex=14
		corner(box,6); stroke(box,T.BORDER,1)
		local bp=Instance.new("UIPadding",box); bp.PaddingLeft=UDim.new(0,6)
		box.FocusLost:Connect(function() onChange(box.Text) end)
		return r
	end

	-- ════════════════════════════════
	-- SHOW PROPERTIES of selected GuiObject
	-- ════════════════════════════════
	local function showProps(inst)
		clearProps()
		propWrap.Visible=true
		propSep.Visible=true
		restoreCard.Visible=true
		saveOriginal(inst)

		local ord=0
		local function o() ord+=1; return ord end

		-- Tên instance (readonly)
		local nameRow=propRow(o(),"Instance")
		newLabel(nameRow,{
			Text=inst.ClassName.."  ·  "..inst.Name,
			Color=T.ACCENT,Size=10,Font=Enum.Font.GothamBold,
			Sz=UDim2.new(1,-118,1,0),Position=UDim2.new(0,112,0,0),
			ZIndex=14,Truncate=true})

		-- ── Visibility ──
		makePropToggle(o(),"Visible",inst.Visible,function(v)
			applyProp(inst,"Visible",v)
		end)

		-- ── BackgroundTransparency ──
		makePropSlider(o(),"BG Transparency",0,1,
			inst.BackgroundTransparency,function(v)
				applyProp(inst,"BackgroundTransparency",v)
			end)

		-- ── BackgroundColor3 ──
		makePropColor(o(),"Background Color",inst.BackgroundColor3,function(col)
			applyProp(inst,"BackgroundColor3",col)
		end)

		-- ── ZIndex ──
		makePropSlider(o(),"ZIndex",1,20,inst.ZIndex,function(v)
			applyProp(inst,"ZIndex",math.floor(v))
		end)

		-- ── TextLabel / TextButton extras ──
		if inst:IsA("TextLabel") or inst:IsA("TextButton") then
			makePropColor(o(),"Text Color",inst.TextColor3,function(col)
				applyProp(inst,"TextColor3",col)
			end)
			makePropSlider(o(),"Text Transparency",0,1,inst.TextTransparency,function(v)
				applyProp(inst,"TextTransparency",v)
			end)
			makePropSlider(o(),"Text Size",6,60,inst.TextSize,function(v)
				applyProp(inst,"TextSize",math.floor(v))
			end)
			makePropTextInput(o(),"Text",inst.Text,function(v)
				applyProp(inst,"Text",v)
			end)
		end

		-- ── ImageLabel / ImageButton extras ──
		if inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
			makePropColor(o(),"Image Color",inst.ImageColor3,function(col)
				applyProp(inst,"ImageColor3",col)
			end)
			makePropSlider(o(),"Image Transparency",0,1,inst.ImageTransparency,function(v)
				applyProp(inst,"ImageTransparency",v)
			end)
			makePropTextInput(o(),"Image (Asset ID)","rbxassetid://…",function(v)
				-- Cho phép nhập cả dạng số hoặc đầy đủ
				local assetStr = v
				if tonumber(v) then assetStr = "rbxassetid://"..v end
				applyProp(inst,"Image",assetStr)
			end)
		end
	end

	-- ════════════════════════════════
	-- SCAN PlayerGui  (không đụng Nova UI)
	-- ════════════════════════════════
	local function clearList()
		for _,r in ipairs(guiRows) do if r and r.Parent then r:Destroy() end end
		guiRows={}
	end

	local function buildList()
		clearList()
		local count=0
		local order=0

		local function scanGui(root, depth)
			if depth>8 then return end
			for _,child in ipairs(root:GetChildren()) do
				-- Bỏ qua Nova UI của chính mình
				if child.Name=="NovaUI_v2" then continue end

				if child:IsA("GuiObject") and EDITABLE[child.ClassName] then
					local name=child.Name
					local show=(searchQ=="" or name:lower():find(searchQ:lower(),1,true)~=nil)

					if show then
						count+=1
						order+=1

						local row=Instance.new("TextButton",listWrap)
						row.Size=UDim2.new(1,0,0,32)
						row.BackgroundColor3= selectedGui==child and T.ACCENT or T.SURFACE2
						row.BackgroundTransparency= selectedGui==child and 0 or 0.3
						row.Text=""
						row.BorderSizePixel=0
						row.ZIndex=13
						row.LayoutOrder=order

						-- Indent
						local indX=8+depth*12
						if depth>0 then
							newFrame(row,{BG=T.BORDER,BT=0.5,
								Size=UDim2.new(0,1,1,0),
								Position=UDim2.new(0,indX-8,0,0),ZIndex=13})
						end

						-- Class icon
						local classIcons={
							Frame="▭", ImageLabel="🖼", ImageButton="🖼",
							TextLabel="T", TextButton="⬜",
							ScrollingFrame="↕", ViewportFrame="📷",
						}
						newLabel(row,{
							Text=classIcons[child.ClassName] or "◦",
							Color=T.ACCENT,Size=11,
							Sz=UDim2.new(0,16,1,0),
							Position=UDim2.new(0,indX,0,0),
							AlignX=Enum.TextXAlignment.Center,ZIndex=14})

						-- Name
						newLabel(row,{
							Text=name,
							Color=selectedGui==child and T.WHITE or T.TEXT,
							Size=11,
							Font=selectedGui==child and Enum.Font.GothamBold or Enum.Font.Gotham,
							Sz=UDim2.new(1,-(indX+88),1,0),
							Position=UDim2.new(0,indX+18,0,0),
							ZIndex=14, Truncate=true})

						-- ClassName badge
						local badgeTxt=child.ClassName
						local badge=newFrame(row,{
							BG=T.SURFACE,Size=UDim2.new(0,70,0,16),
							Position=UDim2.new(1,-76,0.5,-8),ZIndex=14})
						corner(badge,5); stroke(badge,T.BORDER,1)
						newLabel(badge,{Text=badgeTxt,Color=T.TEXT3,Size=7,Font=Enum.Font.GothamBold,
							AlignX=Enum.TextXAlignment.Center,
							Sz=UDim2.new(1,0,1,0),ZIndex=15,Truncate=true})

						-- Visibility indicator dot
						local dot=newFrame(row,{
							BG=child.Visible and T.SUCCESS or T.DANGER,
							Size=UDim2.new(0,6,0,6),
							Position=UDim2.new(1,-8,0.5,-3),ZIndex=14})
						corner(dot,4)

						row.MouseEnter:Connect(function()
							if selectedGui~=child then tween(row,{BackgroundTransparency=0.1,BackgroundColor3=T.GLASS}) end
						end)
						row.MouseLeave:Connect(function()
							if selectedGui~=child then tween(row,{BackgroundTransparency=0.3,BackgroundColor3=T.SURFACE2}) end
						end)
						row.MouseButton1Click:Connect(function()
							selectedGui=child
							showProps(child)
							buildList()  -- re-highlight
						end)

						table.insert(guiRows,row)
					end
				end
				scanGui(child, depth+1)
			end
		end

		emptyGuiLbl.Visible=false
		for _,gui in ipairs(PlayerGui:GetChildren()) do
			if gui.Name~="NovaUI_v2" then
				scanGui(gui, 0)
			end
		end

		if count==0 then
			emptyGuiLbl.Visible=true
			emptyGuiLbl.Text= searchQ~="" and "Không tìm thấy: '"..searchQ.."'" or "Không có GUI element nào trong PlayerGui"
		end

		infoLbl.Text="  "..count.." elements"
			..(selectedGui and "  ·  đang chọn: "..selectedGui.Name or "  ·  click để chọn")
	end

	-- ── Restore all ──
	restoreBtn.MouseButton1Click:Connect(function()
		for inst,props in pairs(originalProps) do
			pcall(function()
				for prop,val in pairs(props) do
					inst[prop]=val
				end
			end)
		end
		originalProps={}
		overrides={}
		selectedGui=nil
		propWrap.Visible=false
		propSep.Visible=false
		restoreCard.Visible=false
		clearProps()
		buildList()
		showToast("Đã restore tất cả về gốc","ok")
	end)

	-- ── Search ──
	guiSearch:GetPropertyChangedSignal("Text"):Connect(function()
		searchQ=guiSearch.Text
		task.defer(buildList)
	end)

	-- ── Scan button ──
	scanBtn.MouseButton1Click:Connect(function()
		tween(scanBtn,{TextColor3=T.SUCCESS})
		task.delay(0.6,function() tween(scanBtn,{TextColor3=T.ACCENT}) end)
		searchQ=""; guiSearch.Text=""
		selectedGui=nil
		buildList()
		showToast("Đã quét "..#guiRows.." GUI elements","ok")
	end)

	-- Lazy init
	pageCallbacks["GUIEdit"]=function()
		if not guiInited then
			guiInited=true
			buildList()
		end
	end
end

-- ══════════════════════════════════════════
-- ★ PAGE: EXPLORER  (Instance tree browser)
-- ══════════════════════════════════════════
local explorerPage, _ = makePage("Explorer")

do
	-- ── Icon map theo ClassName ──
	local CLASS_ICON = {
		Workspace            = "🌍",
		ReplicatedStorage    = "📦",
		ReplicatedFirst      = "⚡",
		Players              = "👥",
		Lighting             = "💡",
		StarterGui           = "🖼",
		StarterPack          = "🎒",
		SoundService         = "🔊",
		LocalScript          = "📜",
		Script               = "📄",
		ModuleScript         = "🧩",
		RemoteEvent          = "📡",
		RemoteFunction       = "🔁",
		BindableEvent        = "⬡",
		BindableFunction     = "⬢",
		Model                = "📐",
		Part                 = "🔷",
		MeshPart             = "🔷",
		UnionOperation       = "🔷",
		BasePart             = "🔷",
		Folder               = "📁",
		Configuration        = "⚙",
		StringValue          = "T",
		IntValue             = "#",
		NumberValue          = "#",
		BoolValue            = "?",
		ObjectValue          = "○",
		Humanoid             = "🚶",
		HumanoidRootPart     = "⊕",
		Camera               = "📷",
		Highlight            = "✨",
		BillboardGui         = "🪧",
		ScreenGui            = "🖥",
		Frame                = "▭",
		TextLabel            = "T",
		TextButton           = "⬜",
		ImageLabel           = "🖼",
		Sound                = "🔉",
		Animation            = "▶",
		Animator             = "🎬",
		Team                 = "🏳",
		Decal                = "🎨",
		Texture              = "🎨",
		SpecialMesh          = "◈",
		WeldConstraint       = "🔗",
		Motor6D              = "🔗",
		Accessory            = "👒",
		Tool                 = "🔧",
		SpawnLocation        = "🚩",
		SurfaceGui           = "📋",
		SelectionBox         = "🔲",
	}

	local function getIcon(inst)
		return CLASS_ICON[inst.ClassName] or "◦"
	end

	-- ── Root services để duyệt ──
	local ROOT_SERVICES = {
		"Workspace",
		"ReplicatedStorage",
		"ReplicatedFirst",
		"Players",
		"Lighting",
		"StarterGui",
		"StarterPack",
	}

	-- ── State ──
	local expanded   = {}   -- [instance] = true/false
	local selectedInst = nil
	local searchQuery  = ""
	local nodeRows   = {}   -- list of rendered row frames

	-- ── Container bên trong explorerPage ──

	-- Search bar card
	local searchCard = makeCard(explorerPage, 42, 1)
	gradient(searchCard, Color3.fromRGB(20,20,38), Color3.fromRGB(15,15,26), 135)

	local searchIcon = newLabel(searchCard, {
		Text = "🔍", Size = 13,
		Sz = UDim2.new(0,28,1,0),
		Position = UDim2.new(0,8,0,0),
		AlignX = Enum.TextXAlignment.Center,
		ZIndex = 13,
	})

	local searchBox = Instance.new("TextBox", searchCard)
	searchBox.Size = UDim2.new(1,-80,0,26)
	searchBox.Position = UDim2.new(0,34,0.5,-13)
	searchBox.BackgroundColor3 = T.SURFACE2
	searchBox.BorderSizePixel = 0
	searchBox.TextColor3 = T.TEXT
	searchBox.PlaceholderText = "Tìm kiếm instance…"
	searchBox.PlaceholderColor3 = T.TEXT3
	searchBox.Text = ""
	searchBox.TextSize = 11
	searchBox.Font = Enum.Font.Gotham
	searchBox.ClearTextOnFocus = false
	searchBox.ZIndex = 13
	corner(searchBox, 7)
	stroke(searchBox, T.BORDER, 1)
	local sbPad = Instance.new("UIPadding", searchBox)
	sbPad.PaddingLeft = UDim.new(0,8)

	-- Refresh button
	local refreshBtn = Instance.new("TextButton", searchCard)
	refreshBtn.Size = UDim2.new(0,34,0,26)
	refreshBtn.Position = UDim2.new(1,-40,0.5,-13)
	refreshBtn.Text = "↺"
	refreshBtn.TextSize = 16
	refreshBtn.Font = Enum.Font.GothamBold
	refreshBtn.TextColor3 = T.ACCENT
	refreshBtn.BackgroundColor3 = T.SURFACE2
	refreshBtn.BorderSizePixel = 0
	refreshBtn.ZIndex = 13
	corner(refreshBtn, 7)
	stroke(refreshBtn, T.BORDER, 1)
	refreshBtn.MouseEnter:Connect(function() tween(refreshBtn,{BackgroundColor3=T.GLASS}) end)
	refreshBtn.MouseLeave:Connect(function() tween(refreshBtn,{BackgroundColor3=T.SURFACE2}) end)

	-- Stats row (count)
	local statsRow = newFrame(explorerPage, {
		BG=Color3.fromRGB(0,0,0), BT=1,
		Size=UDim2.new(1,0,0,18), ZIndex=12,
	})
	statsRow.LayoutOrder = 2
	local countLbl = newLabel(statsRow, {
		Text="", Color=T.TEXT3, Size=9,
		Font=Enum.Font.GothamBold,
		Sz=UDim2.new(1,0,1,0), ZIndex=12,
	})
	local cPad = Instance.new("UIPadding",countLbl); cPad.PaddingLeft=UDim.new(0,4)

	-- Tree container (treeFrame thay thế scrolling list bình thường)
	local treeWrap = newFrame(explorerPage, {
		BG = T.SURFACE,
		Size = UDim2.new(1,0,0,10),
		ZIndex = 12,
	})
	treeWrap.LayoutOrder = 3
	treeWrap.AutomaticSize = Enum.AutomaticSize.Y
	corner(treeWrap, 10)
	stroke(treeWrap, T.BORDER, 1)

	local treeList = Instance.new("UIListLayout", treeWrap)
	treeList.SortOrder = Enum.SortOrder.LayoutOrder
	treeList.Padding = UDim.new(0,0)
	local treePad = Instance.new("UIPadding", treeWrap)
	treePad.PaddingTop    = UDim.new(0,4)
	treePad.PaddingBottom = UDim.new(0,4)

	-- ── Màu nền xen kẽ ──
	local function rowBG(depth, selected)
		if selected then return T.ACCENT end
		return depth % 2 == 0 and T.SURFACE or T.SURFACE2
	end

	-- ── Xóa toàn bộ cây ──
	local function clearTree()
		for _,r in ipairs(nodeRows) do
			if r and r.Parent then r:Destroy() end
		end
		nodeRows = {}
	end

	-- ── Render 1 node ──
	local nodeOrder = 0
	local function renderNode(inst, depth, parentVisible)
		if not inst then return end
		local children = inst:GetChildren()
		local hasChildren = #children > 0
		local isExpanded = expanded[inst] == true

		-- Filter theo search
		local name = inst.Name
		local visible = parentVisible
		if searchQuery ~= "" then
			visible = name:lower():find(searchQuery:lower(), 1, true) ~= nil
		end

		nodeOrder += 1
		local row = Instance.new("TextButton", treeWrap)
		row.Size = UDim2.new(1,0,0,26)
		row.BackgroundColor3 = rowBG(depth, selectedInst == inst)
		row.BackgroundTransparency = selectedInst == inst and 0 or 0.3
		row.Text = ""
		row.BorderSizePixel = 0
		row.ZIndex = 13
		row.LayoutOrder = nodeOrder
		row.Visible = visible

		table.insert(nodeRows, row)

		-- Indent line (vertical guide)
		if depth > 0 then
			for d = 1, depth do
				local line = newFrame(row, {
					BG = d == depth and T.BORDER2 or T.BORDER,
					BT = d == depth and 0 or 0.5,
					Size = UDim2.new(0, 1, 1, 0),
					Position = UDim2.new(0, 8 + (d-1)*14, 0, 0),
					ZIndex = 13,
				})
			end
		end

		local indentX = 8 + depth * 14

		-- Expand arrow
		local arrowLbl = newLabel(row, {
			Text = hasChildren and (isExpanded and "▾" or "▸") or " ",
			Color = hasChildren and T.ACCENT or T.TEXT3,
			Size = 10,
			Font = Enum.Font.GothamBold,
			Sz = UDim2.new(0,14,1,0),
			Position = UDim2.new(0, indentX, 0, 0),
			AlignX = Enum.TextXAlignment.Center,
			ZIndex = 14,
		})

		-- Class icon
		local iconLbl = newLabel(row, {
			Text = getIcon(inst),
			Color = T.TEXT2,
			Size = 11,
			Sz = UDim2.new(0,18,1,0),
			Position = UDim2.new(0, indentX+15, 0, 0),
			AlignX = Enum.TextXAlignment.Center,
			ZIndex = 14,
		})

		-- Name label
		local nameLbl = newLabel(row, {
			Text = name,
			Color = selectedInst == inst and T.WHITE or T.TEXT,
			Size = 11,
			Font = selectedInst == inst and Enum.Font.GothamBold or Enum.Font.Gotham,
			Sz = UDim2.new(1, -(indentX+38), 1, 0),
			Position = UDim2.new(0, indentX+34, 0, 0),
			ZIndex = 14,
			Truncate = true,
		})

		-- ClassName badge (khi selected)
		if selectedInst == inst then
			local badge = newFrame(row, {
				BG = T.ACCENT2,
				BT = 0.3,
				Size = UDim2.new(0,0,0,16),
				Position = UDim2.new(1,-4,0.5,-8),
				ZIndex = 14,
			})
			corner(badge, 5)
			local badgeLbl = newLabel(badge, {
				Text = inst.ClassName,
				Color = T.WHITE,
				Size = 8,
				Font = Enum.Font.GothamBold,
				Sz = UDim2.new(1,-8,1,0),
				Position = UDim2.new(0,4,0,0),
				AlignX = Enum.TextXAlignment.Center,
				ZIndex = 15,
			})
			-- Auto-size badge
			task.defer(function()
				local w = badgeLbl.TextBounds.X + 14
				badge.Size = UDim2.new(0, w, 0, 16)
				badge.Position = UDim2.new(1, -(w+4), 0.5, -8)
				nameLbl.Size = UDim2.new(1, -(indentX+38+w+8), 1, 0)
			end)
		end

		-- Hover
		row.MouseEnter:Connect(function()
			if selectedInst ~= inst then
				tween(row, { BackgroundTransparency = 0.1, BackgroundColor3 = T.GLASS })
			end
		end)
		row.MouseLeave:Connect(function()
			if selectedInst ~= inst then
				tween(row, { BackgroundTransparency = 0.3, BackgroundColor3 = rowBG(depth, false) })
			end
		end)

		-- Click: expand/collapse OR select
		local lastClick = 0
		row.MouseButton1Click:Connect(function()
			local now = tick()
			if now - lastClick < 0.3 then
				-- Double-click: toggle expand
				if hasChildren then
					expanded[inst] = not expanded[inst]
				end
			else
				-- Single click: select
				selectedInst = inst
			end
			lastClick = now
			-- Rebuild tree
			task.defer(function() rebuildTree() end)
		end)

		-- Render children se xử lý ở rebuildTree
		return isExpanded, children
	end

	-- ── Full rebuild ──
	function rebuildTree()
		clearTree()
		nodeOrder = 0
		local totalNodes = 0

		local function renderBranch(inst, depth)
			totalNodes += 1
			local isExp, children = renderNode(inst, depth, true)
			if isExp and children then
				-- Sort: folders/models first, then alphabetical
				table.sort(children, function(a,b)
					local aHas = #a:GetChildren()>0
					local bHas = #b:GetChildren()>0
					if aHas ~= bHas then return aHas end
					return a.Name < b.Name
				end)
				for _, child in ipairs(children) do
					renderBranch(child, depth+1)
				end
			end
		end

		for _, svcName in ipairs(ROOT_SERVICES) do
			local ok, svc = pcall(function() return game:GetService(svcName) end)
			if ok and svc then
				renderBranch(svc, 0)
			end
		end

		countLbl.Text = "  "..totalNodes.." instances   |   " ..
			(selectedInst and ("selected: "..selectedInst.Name) or "click để chọn · double-click để mở")
	end

	-- ── Search ──
	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		searchQuery = searchBox.Text
		task.defer(rebuildTree)
	end)

	-- ── Refresh button ──
	refreshBtn.MouseButton1Click:Connect(function()
		tween(refreshBtn, { TextColor3 = T.SUCCESS })
		task.delay(0.6, function() tween(refreshBtn, { TextColor3 = T.ACCENT }) end)
		searchQuery = ""
		searchBox.Text = ""
		selectedInst = nil
		expanded = {}
		rebuildTree()
		showToast("Explorer đã refresh", "ok")
	end)

	-- Tự động expand root services khi mở trang lần đầu
	local explorerInited = false
	local function initExplorer()
		if explorerInited then return end
		explorerInited = true
		for _, svcName in ipairs(ROOT_SERVICES) do
			local ok, svc = pcall(function() return game:GetService(svcName) end)
			if ok and svc then
				expanded[svc] = (svcName == "Workspace" or svcName == "ReplicatedStorage")
			end
		end
		rebuildTree()
	end

	-- Hook vào switchPage callback
	pageCallbacks = pageCallbacks or {}
	pageCallbacks["Explorer"] = initExplorer
end

-- ══════════════════════════════════════════
-- OPEN / CLOSE  (with blur)
-- ══════════════════════════════════════════
local menuOpen = false

local function openMenu()
	if menuOpen then return end
	menuOpen = true
	tween(Panel, { Position = UDim2.new(1,-PANEL_W,0,0) }, EZ_SLOW)
	tween(BlurEffect, { Size = 8 }, EZ_SLOW)
	if currentPage == nil then switchPage("Home") end
end

local function closeMenu()
	if not menuOpen then return end
	menuOpen = false
	tween(Panel, { Position = UDim2.new(1,0,0,0) }, EZ_SLOW)
	tween(BlurEffect, { Size = 0 }, EZ_SLOW)
end

CloseBtn.MouseButton1Click:Connect(closeMenu)

-- ══════════════════════════════════════════
-- TOGGLE BUTTON  (draggable)
-- ══════════════════════════════════════════
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0,46,0,46)
ToggleBtn.Position = UDim2.new(1,-62,0,20)
ToggleBtn.Text = "N"
ToggleBtn.TextSize = 20
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextColor3 = T.WHITE
ToggleBtn.BackgroundColor3 = T.ACCENT
ToggleBtn.BorderSizePixel = 0
ToggleBtn.ZIndex = 9
ToggleBtn.Visible = false
corner(ToggleBtn, 15)
gradient(ToggleBtn, T.ACCENT, T.ACCENT2, 135)
stroke(ToggleBtn, Color3.fromRGB(120,100,255), 1)

-- Pulse ring
local Ring = newFrame(ScreenGui, {
	BG=T.ACCENT, BT=0.5,
	Size=UDim2.new(0,46,0,46),
	Position=UDim2.new(1,-62,0,20),
	ZIndex=8,
})
corner(Ring,15)
Ring.Visible=false

-- Drag
local dragOn,dragStart,btnStartPos=false,nil,nil
ToggleBtn.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		dragOn=true; dragStart=i.Position; btnStartPos=ToggleBtn.Position
	end
end)
UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		dragOn=false
	end
end)
UserInputService.InputChanged:Connect(function(i)
	if dragOn and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local d=i.Position-dragStart
		local np=UDim2.new(btnStartPos.X.Scale,btnStartPos.X.Offset+d.X,
			btnStartPos.Y.Scale,btnStartPos.Y.Offset+d.Y)
		ToggleBtn.Position=np; Ring.Position=np
	end
end)

ToggleBtn.MouseButton1Click:Connect(function()
	if menuOpen then closeMenu() else openMenu() end
end)
ToggleBtn.MouseEnter:Connect(function() tween(ToggleBtn,{BackgroundColor3=T.ACCENT2}) end)
ToggleBtn.MouseLeave:Connect(function() tween(ToggleBtn,{BackgroundColor3=T.ACCENT}) end)

-- ══════════════════════════════════════════
-- INTRO ANIMATION
-- ══════════════════════════════════════════
task.spawn(function()
	tween(SplashBar, {Size=UDim2.new(1,0,1,0)}, TweenInfo.new(1.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out))
	tween(Glow, {Size=UDim2.new(0,400,0,400),Position=UDim2.new(0.5,-200,0.5,-250),BackgroundTransparency=0.95},
	TweenInfo.new(1.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out))
	task.wait(1.5)

	tween(SplashLogo, {TextTransparency=1}, TweenInfo.new(0.45))
	tween(SplashSub,  {TextTransparency=1}, TweenInfo.new(0.45))
	tween(SplashBar,  {BackgroundTransparency=1}, TweenInfo.new(0.45))
	tween(SplashBarBg,{BackgroundTransparency=1}, TweenInfo.new(0.45))
	tween(Glow,       {BackgroundTransparency=1}, TweenInfo.new(0.4))
	task.wait(0.3)
	tween(Splash, {BackgroundTransparency=1}, TweenInfo.new(0.5))
	task.wait(0.55)
	Splash:Destroy()

	ToggleBtn.Visible=true
	Ring.Visible=true

	-- Pulse
	task.spawn(function()
		while ToggleBtn and ToggleBtn.Parent do
			tween(Ring,{
				Size=UDim2.new(0,62,0,62),
				Position=UDim2.new(Ring.Position.X.Scale,Ring.Position.X.Offset-8,
					Ring.Position.Y.Scale,Ring.Position.Y.Offset-8),
				BackgroundTransparency=1,
			}, TweenInfo.new(0.9,Enum.EasingStyle.Quad,Enum.EasingDirection.Out))
			task.wait(0.95)
			Ring.Size=UDim2.new(0,46,0,46)
			Ring.Position=ToggleBtn.Position
			Ring.BackgroundTransparency=0.5
			task.wait(1.8)
		end
	end)
end)
