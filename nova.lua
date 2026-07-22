-- ╔══════════════════════════════════════════════════════════════╗
-- ║         NOVA UI  v2.2  —  MENU UPGRADE PATCH                 ║
-- ║   Thay thế toàn bộ phần: NavBar, Header, ToggleBtn, Splash  ║
-- ╚══════════════════════════════════════════════════════════════╝

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local Lighting         = game:GetService("Lighting")

local Player    = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ══════════════════════════════════════════
-- THEME
-- ══════════════════════════════════════════
local T = {
	BG       = Color3.fromRGB(6,   6,  12),
	SURFACE  = Color3.fromRGB(14,  14, 24),
	SURFACE2 = Color3.fromRGB(22,  22, 36),
	GLASS    = Color3.fromRGB(30,  30, 52),
	ACCENT   = Color3.fromRGB(99,  102,241),
	ACCENT2  = Color3.fromRGB(139, 92, 246),
	ACCENT3  = Color3.fromRGB(59,  130,246),
	SUCCESS  = Color3.fromRGB(34,  197,94),
	WARN     = Color3.fromRGB(251, 191,36),
	DANGER   = Color3.fromRGB(239, 68, 68),
	TEXT     = Color3.fromRGB(240, 240,255),
	TEXT2    = Color3.fromRGB(160, 160,200),
	TEXT3    = Color3.fromRGB(90,  90, 130),
	BORDER   = Color3.fromRGB(44,  44, 72),
	BORDER2  = Color3.fromRGB(66,  66, 104),
	WHITE    = Color3.new(1,1,1),
	COPY_OK  = Color3.fromRGB(52,  211,153),
	NAV_W    = 72,   -- sidebar width (px)
}

local EZ      = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local EZ_MED  = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local EZ_SLOW = TweenInfo.new(0.50, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local EZ_SPR  = TweenInfo.new(0.60, Enum.EasingStyle.Back,  Enum.EasingDirection.Out)

-- ══════════════════════════════════════════
-- UTILITY (copy từ gốc)
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
	s.Color             = color or T.BORDER
	s.Thickness         = thickness or 1
	s.Transparency      = transparency or 0
	s.ApplyStrokeMode   = Enum.ApplyStrokeMode.Border
	return s
end
local function gradient(parent, c0, c1, rotation)
	local g = Instance.new("UIGradient", parent)
	g.Color    = ColorSequence.new(c0, c1)
	g.Rotation = rotation or 90
	return g
end
local function newFrame(parent, props)
	local f = Instance.new("Frame", parent)
	f.BackgroundTransparency = props.BT   or 0
	f.BackgroundColor3       = props.BG   or T.SURFACE
	f.Size                   = props.Size or UDim2.new(1,0,0,40)
	f.Position               = props.Position or UDim2.new(0,0,0,0)
	f.BorderSizePixel        = 0
	f.ZIndex                 = props.ZIndex or 5
	if props.ClipsDescendants then f.ClipsDescendants = true end
	if props.Name then f.Name = props.Name end
	return f
end
local function newLabel(parent, props)
	local l = Instance.new("TextLabel", parent)
	l.BackgroundTransparency = 1
	l.Text          = props.Text     or ""
	l.TextColor3    = props.Color    or T.TEXT
	l.TextSize      = props.Size     or 14
	l.Font          = props.Font     or Enum.Font.Gotham
	l.Size          = props.Sz       or UDim2.new(1,0,1,0)
	l.Position      = props.Position or UDim2.new(0,0,0,0)
	l.TextXAlignment= props.AlignX   or Enum.TextXAlignment.Left
	l.TextYAlignment= props.AlignY   or Enum.TextYAlignment.Center
	l.ZIndex        = props.ZIndex   or 6
	l.TextTruncate  = props.Truncate and Enum.TextTruncate.AtEnd or Enum.TextTruncate.None
	if props.Wrapped then l.TextWrapped = true end
	return l
end
local function copyText(text)
	pcall(function()
		if setclipboard      then setclipboard(text)
		elseif toclipboard   then toclipboard(text)
		elseif Clipboard     then Clipboard.set(text) end
	end)
end

-- ══════════════════════════════════════════
-- ROOT GUI
-- ══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "NovaUI_v2"
ScreenGui.IgnoreGuiInset  = true
ScreenGui.ResetOnSpawn    = false
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent          = PlayerGui

local BlurEffect = Instance.new("BlurEffect", Lighting)
BlurEffect.Size = 0
BlurEffect.Name = "NovaBlur"

-- ══════════════════════════════════════════════════════════════
-- NOVA UI v2.2 — INTRO UPGRADE
-- Thay thế toàn bộ block "SPLASH" trong script gốc bằng block này
-- ══════════════════════════════════════════════════════════════

-- ══════════════════════════════════════════
-- SPLASH ROOT
-- ══════════════════════════════════════════
local Splash = newFrame(ScreenGui, {
	BG   = T.BG,
	Size = UDim2.new(1,0,1,0),
	ZIndex = 30,
	Name = "NovaSplash",
})

-- ── Scanline overlay (CRT feel)
local Scanlines = newFrame(Splash, {
	BG = Color3.fromRGB(0,0,0), BT = 0.92,
	Size = UDim2.new(1,0,1,0),
	ZIndex = 39,
})
local slGrad = Instance.new("UIGradient", Scanlines)
slGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0,   Color3.fromRGB(0,0,0)),
	ColorSequenceKeypoint.new(0.49,Color3.fromRGB(0,0,0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20,20,40)),
	ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,0,0)),
})
slGrad.Rotation = 180
slGrad.Enabled  = true

-- ── Background radial glow layers
local glowColors = {
	{T.ACCENT,  0.88, 340, 340, -170, -230},
	{T.ACCENT2, 0.92, 260, 260, -80,  -160},
	{T.ACCENT3, 0.94, 200, 200, -50,  -100},
}
for _, gc in ipairs(glowColors) do
	local g = newFrame(Splash, {
		BG = gc[1], BT = gc[2],
		Size = UDim2.new(0, gc[3], 0, gc[4]),
		Position = UDim2.new(0.5, gc[5], 0.5, gc[6]),
		ZIndex = 31,
	})
	corner(g, gc[3]/2)
end

-- ── Grid pattern (subtle)
local Grid = newFrame(Splash, {
	BG=Color3.fromRGB(0,0,0), BT=1,
	Size=UDim2.new(1,0,1,0), ZIndex=32,
})
-- Horizontal grid lines
for i=0, 20 do
	local gl = newFrame(Splash,{
		BG=Color3.fromRGB(60,60,120), BT=0.93,
		Size=UDim2.new(1,0,0,1),
		Position=UDim2.new(0,0,0,i*36),
		ZIndex=32,
	})
end
-- Vertical grid lines
for i=0, 30 do
	local vl = newFrame(Splash,{
		BG=Color3.fromRGB(60,60,120), BT=0.95,
		Size=UDim2.new(0,1,1,0),
		Position=UDim2.new(0,i*40,0,0),
		ZIndex=32,
	})
end

-- ══════════════════════════════════════════
-- CENTER STAGE
-- ══════════════════════════════════════════

-- Outer ring (spins during load)
local OuterRing = newFrame(Splash, {
	BG=T.ACCENT, BT=0.85,
	Size=UDim2.new(0,180,0,180),
	Position=UDim2.new(0.5,-90,0.5,-140),
	ZIndex=33,
})
corner(OuterRing, 90)
stroke(OuterRing, T.ACCENT, 1.5, 0.3)

-- Inner ring
local InnerRing = newFrame(Splash, {
	BG=T.ACCENT2, BT=0.88,
	Size=UDim2.new(0,140,0,140),
	Position=UDim2.new(0.5,-70,0.5,-110),
	ZIndex=34,
})
corner(InnerRing, 70)
stroke(InnerRing, T.ACCENT2, 1, 0.4)

-- Logo card (glass)
local LogoCard = newFrame(Splash, {
	BG=Color3.fromRGB(14,14,26), BT=0,
	Size=UDim2.new(0,100,0,100),
	Position=UDim2.new(0.5,-50,0.5,-90),
	ZIndex=35,
})
corner(LogoCard, 28)
stroke(LogoCard, T.ACCENT, 1.5, 0.2)
gradient(LogoCard, Color3.fromRGB(22,22,44), Color3.fromRGB(10,10,20), 135)

-- "N" glyph
local NLbl = newLabel(LogoCard,{
	Text="N", Color=T.WHITE, Size=52, Font=Enum.Font.GothamBold,
	AlignX=Enum.TextXAlignment.Center,
	Sz=UDim2.new(1,0,1,0), ZIndex=36,
})
NLbl.BackgroundTransparency=1

-- Glow behind N
local NGlow = newFrame(LogoCard,{
	BG=T.ACCENT, BT=0.7,
	Size=UDim2.new(0,60,0,60),
	Position=UDim2.new(0.5,-30,0.5,-30),
	ZIndex=35,
})
corner(NGlow,30)

-- Arc segments around the ring (decorative)
local arcAngles = {0, 72, 144, 216, 288}
local arcFrames = {}
for i, ang in ipairs(arcAngles) do
	local arc = newFrame(Splash,{
		BG=i%2==0 and T.ACCENT or T.ACCENT2,
		BT=0.6,
		Size=UDim2.new(0,12,0,12),
		Position=UDim2.new(
			0.5 + math.cos(math.rad(ang))*0.12 - 0.02,
			math.cos(math.rad(ang))*2,
			0.5 + math.sin(math.rad(ang))*0.12 - 0.12,
			math.sin(math.rad(ang))*2 - 90
		),
		ZIndex=35,
	})
	corner(arc,6)
	arcFrames[i]=arc
end

-- ══════════════════════════════════════════
-- WORDMARK  (bên dưới logo)
-- ══════════════════════════════════════════
local WordmarkWrap = newFrame(Splash,{
	BG=Color3.fromRGB(0,0,0), BT=1,
	Size=UDim2.new(0,280,0,70),
	Position=UDim2.new(0.5,-140,0.5,40),
	ZIndex=35,
})

-- "NOVA" main
local NovaText = newLabel(WordmarkWrap,{
	Text="NOVA",
	Color=T.WHITE, Size=42, Font=Enum.Font.GothamBold,
	AlignX=Enum.TextXAlignment.Center,
	Sz=UDim2.new(1,0,0,50), ZIndex=36,
})
NovaText.TextTransparency=1

-- Gradient on text via UIGradient
local textGrad=Instance.new("UIGradient",NovaText)
textGrad.Color=ColorSequence.new(T.WHITE, Color3.fromRGB(200,190,255))
textGrad.Rotation=90

-- Subtitle row
local SubWrap = newFrame(WordmarkWrap,{
	BG=Color3.fromRGB(0,0,0),BT=1,
	Size=UDim2.new(1,0,0,20),
	Position=UDim2.new(0,0,0,50),
	ZIndex=36,
})
local subLL=Instance.new("UIListLayout",SubWrap)
subLL.FillDirection=Enum.FillDirection.Horizontal
subLL.HorizontalAlignment=Enum.HorizontalAlignment.Center
subLL.Padding=UDim.new(0,8)

local subItems = {
	{text="UI System",   color=T.ACCENT},
	{text="·",           color=T.TEXT3},
	{text="v2.2",        color=T.ACCENT2},
	{text="·",           color=T.TEXT3},
	{text="Powered",     color=T.SUCCESS},
}
local subLabels={}
for i,si in ipairs(subItems) do
	local sl=newLabel(SubWrap,{
		Text=si.text, Color=si.color, Size=11, Font=Enum.Font.GothamBold,
		Sz=UDim2.new(0,0,1,0), ZIndex=37,
	})
	sl.AutomaticSize=Enum.AutomaticSize.X
	sl.TextTransparency=1
	subLabels[i]=sl
end

-- ══════════════════════════════════════════
-- FEATURE CHIPS  (hiện lần lượt)
-- ══════════════════════════════════════════
local ChipWrap = newFrame(Splash,{
	BG=Color3.fromRGB(0,0,0),BT=1,
	Size=UDim2.new(0,320,0,28),
	Position=UDim2.new(0.5,-160,0.5,120),
	ZIndex=35,
})
local chipLL2=Instance.new("UIListLayout",ChipWrap)
chipLL2.FillDirection=Enum.FillDirection.Horizontal
chipLL2.HorizontalAlignment=Enum.HorizontalAlignment.Center
chipLL2.Padding=UDim.new(0,6)

local FEATURES = {
	{label="Remote Spy",   icon="📡", color=T.ACCENT},
	{label="Explorer",     icon="❧",  color=T.SUCCESS},
	{label="GUI Editor",   icon="✏",  color=T.ACCENT2},
	{label="Keybinds",     icon="⌨",  color=T.WARN},
	{label="Anti-Cheat",   icon="🛡", color=T.DANGER},
	{label="Perf Monitor", icon="📊", color=T.ACCENT3},
}
local chipFrames={}
for i,feat in ipairs(FEATURES) do
	local ch=newFrame(ChipWrap,{
		BG=Color3.fromRGB(14,14,28),
		Size=UDim2.new(0,10,0,24), ZIndex=36,
	})
	ch.AutomaticSize=Enum.AutomaticSize.X
	corner(ch,8)
	stroke(ch, feat.color, 1, 0.5)
	ch.BackgroundTransparency=1  -- hidden initially

	-- Icon dot
	local dot=newFrame(ch,{
		BG=feat.color,
		Size=UDim2.new(0,6,0,6),
		Position=UDim2.new(0,8,0.5,-3),
		ZIndex=37,
	})
	corner(dot,3)

	local cl=newLabel(ch,{
		Text=feat.label,
		Color=feat.color, Size=9, Font=Enum.Font.GothamBold,
		Sz=UDim2.new(0,10,1,0), ZIndex=37,
	})
	cl.AutomaticSize=Enum.AutomaticSize.X
	cl.TextTransparency=1
	local cp=Instance.new("UIPadding",cl)
	cp.PaddingLeft=UDim.new(0,18); cp.PaddingRight=UDim.new(0,8)

	chipFrames[i]={frame=ch, label=cl, dot=dot, color=feat.color}
end

-- ══════════════════════════════════════════
-- PROGRESS BAR  (bottom)
-- ══════════════════════════════════════════
local ProgressBg = newFrame(Splash,{
	BG=T.SURFACE2,
	Size=UDim2.new(0,260,0,3),
	Position=UDim2.new(0.5,-130,0.5,168),
	ZIndex=36,
})
corner(ProgressBg,2)

local ProgressFill = newFrame(ProgressBg,{
	BG=T.ACCENT, Size=UDim2.new(0,0,1,0), ZIndex=37,
})
corner(ProgressFill,2)
gradient(ProgressFill, T.ACCENT, T.ACCENT2, 90)

-- Progress glow tip
local ProgressTip = newFrame(ProgressFill,{
	BG=T.WHITE, BT=0.5,
	Size=UDim2.new(0,6,0,6),
	Position=UDim2.new(1,-3,0.5,-3),
	ZIndex=38,
})
corner(ProgressTip,3)

-- Progress label
local ProgressLbl = newLabel(Splash,{
	Text="Đang khởi động…",
	Color=T.TEXT3, Size=9, Font=Enum.Font.Gotham,
	AlignX=Enum.TextXAlignment.Center,
	Sz=UDim2.new(0,260,0,16),
	Position=UDim2.new(0.5,-130,0.5,176),
	ZIndex=36,
})
ProgressLbl.TextTransparency=1

-- Status messages
local STATUS_MSGS = {
	"Khởi tạo môi trường…",
	"Nạp Remote Spy module…",
	"Chuẩn bị Explorer tree…",
	"Kết nối GUI Editor…",
	"Tải Keybind Manager…",
	"Khởi động Anti-Cheat…",
	"Hoàn tất — Welcome!",
}

-- ══════════════════════════════════════════
-- VERSION TAG (bottom-right corner)
-- ══════════════════════════════════════════
local VersionTag = newFrame(Splash,{
	BG=T.SURFACE2,
	Size=UDim2.new(0,0,0,20),
	Position=UDim2.new(1,-8,1,-28),
	ZIndex=36,
})
VersionTag.AutomaticSize=Enum.AutomaticSize.X
VersionTag.AnchorPoint=Vector2.new(1,1)
corner(VersionTag,6)
stroke(VersionTag,T.BORDER,1)
local vtLbl=newLabel(VersionTag,{
	Text="Nova UI  v2.2",
	Color=T.TEXT3, Size=9,
	Sz=UDim2.new(0,10,1,0), ZIndex=37,
})
vtLbl.AutomaticSize=Enum.AutomaticSize.X
local vtPad=Instance.new("UIPadding",vtLbl)
vtPad.PaddingLeft=UDim.new(0,8); vtPad.PaddingRight=UDim.new(0,8)

-- ══════════════════════════════════════════
-- INTRO ANIMATION SEQUENCE
-- ══════════════════════════════════════════
task.spawn(function()

	-- Phase 0: rings pulse in
	OuterRing.BackgroundTransparency=1
	InnerRing.BackgroundTransparency=1
	LogoCard.BackgroundTransparency=1
	NGlow.BackgroundTransparency=1
	NLbl.TextTransparency=1

	task.wait(0.1)

	-- Outer ring zoom in
	OuterRing.Size=UDim2.new(0,20,0,20)
	OuterRing.Position=UDim2.new(0.5,-10,0.5,-50)
	tween(OuterRing,{
		Size=UDim2.new(0,180,0,180),
		Position=UDim2.new(0.5,-90,0.5,-140),
		BackgroundTransparency=0.85,
	}, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
	task.wait(0.12)

	tween(InnerRing,{
		Size=UDim2.new(0,140,0,140),
		Position=UDim2.new(0.5,-70,0.5,-110),
		BackgroundTransparency=0.88,
	}, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
	task.wait(0.1)

	-- Logo card appear
	LogoCard.Size=UDim2.new(0,60,0,60)
	LogoCard.Position=UDim2.new(0.5,-30,0.5,-60)
	tween(LogoCard,{
		Size=UDim2.new(0,100,0,100),
		Position=UDim2.new(0.5,-50,0.5,-90),
		BackgroundTransparency=0,
	}, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out))

	tween(NGlow,{BackgroundTransparency=0.7}, TweenInfo.new(0.4))
	task.wait(0.25)

	tween(NLbl,{TextTransparency=0}, TweenInfo.new(0.3))
	task.wait(0.2)

	-- Arc dots spin into place
	for i,arc in ipairs(arcFrames) do
		task.spawn(function()
			arc.BackgroundTransparency=1
			task.wait((i-1)*0.05)
			tween(arc,{BackgroundTransparency=0.6}, TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out))
		end)
	end
	task.wait(0.3)

	-- Phase 1: wordmark slides up
	WordmarkWrap.Position=UDim2.new(0.5,-140,0.5,60)
	tween(WordmarkWrap,{Position=UDim2.new(0.5,-140,0.5,40)},
	TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
	tween(NovaText,{TextTransparency=0}, TweenInfo.new(0.35))
	task.wait(0.2)

	-- Subtitle items appear one by one
	for i,sl in ipairs(subLabels) do
		task.spawn(function()
			task.wait((i-1)*0.05)
			tween(sl,{TextTransparency=0},TweenInfo.new(0.25))
		end)
	end
	task.wait(0.4)

	-- Phase 2: progress bar + chips + status
	tween(ProgressLbl,{TextTransparency=0},TweenInfo.new(0.3))

	-- Spin the outer ring continuously
	task.spawn(function()
		local rot=0
		while Splash and Splash.Parent do
			task.wait(0.02)
			rot=(rot+1.2)%360
			for i,arc in ipairs(arcFrames) do
				local ang=rot + (i-1)*72
				arc.Position=UDim2.new(
					0.5 + math.cos(math.rad(ang))*0.12 - 0.02,
					math.cos(math.rad(ang))*2,
					0.5 + math.sin(math.rad(ang))*0.12 - 0.12,
					math.sin(math.rad(ang))*2 - 90
				)
			end
		end
	end)

	-- Inner ring counter-spin (subtle pulse)
	task.spawn(function()
		while Splash and Splash.Parent do
			tween(InnerRing,{BackgroundTransparency=0.82},
			TweenInfo.new(0.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut))
			task.wait(0.7)
			tween(InnerRing,{BackgroundTransparency=0.92},
			TweenInfo.new(0.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut))
			task.wait(0.7)
		end
	end)

	-- Progress + chips + status messages
	local totalSteps = #FEATURES
	for i,cf in ipairs(chipFrames) do
		task.wait(0.18)

		-- Update status label
		if STATUS_MSGS[i] then
			ProgressLbl.Text = STATUS_MSGS[i]
		end

		-- Reveal chip
		tween(cf.frame,{BackgroundTransparency=0},
		TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out))
		tween(cf.label,{TextTransparency=0},TweenInfo.new(0.2))

		-- Progress bar advance
		local prog = i/totalSteps
		tween(ProgressFill,{Size=UDim2.new(prog,0,1,0)},
		TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out))
	end

	-- Final status
	task.wait(0.18)
	ProgressLbl.Text = STATUS_MSGS[#STATUS_MSGS]
	tween(ProgressFill,{Size=UDim2.new(1,0,1,0)},
	TweenInfo.new(0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out))

	-- Flash: all chips pulse white briefly
	task.wait(0.25)
	for _,cf in ipairs(chipFrames) do
		tween(cf.frame,{BackgroundColor3=cf.color},TweenInfo.new(0.15))
		tween(cf.label,{TextColor3=T.WHITE},TweenInfo.new(0.15))
	end
	task.wait(0.3)
	for _,cf in ipairs(chipFrames) do
		tween(cf.frame,{BackgroundColor3=Color3.fromRGB(14,14,28)},TweenInfo.new(0.3))
		tween(cf.label,{TextColor3=cf.color},TweenInfo.new(0.3))
	end

	-- Phase 3: logo scale up briefly then fade out
	task.wait(0.4)
	tween(LogoCard,{
		Size=UDim2.new(0,112,0,112),
		Position=UDim2.new(0.5,-56,0.5,-96),
	}, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
	tween(NLbl,{TextTransparency=0.1,TextColor3=T.ACCENT},TweenInfo.new(0.2))

	task.wait(0.22)

	-- Phase 4: full screen flash then wipe out
	local Flash = newFrame(Splash,{
		BG=T.WHITE, BT=1,
		Size=UDim2.new(1,0,1,0), ZIndex=50,
	})
	tween(Flash,{BackgroundTransparency=0.92},TweenInfo.new(0.12))
	task.wait(0.12)
	tween(Flash,{BackgroundTransparency=1},TweenInfo.new(0.3))

	-- Wipe upward
	tween(Splash,{
		Position=UDim2.new(0,0,-1,0),
		BackgroundTransparency=0.3,
	}, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.In))

	task.wait(0.5)
	Splash:Destroy()

	-- ── Show toggle button ──
	ToggleBtn.Size    = UDim2.new(0,20,0,20)
	ToggleBtn.Visible = true
	Ring.Size         = UDim2.new(0,20,0,20)
	Ring.Visible      = true
	tween(ToggleBtn,{Size=UDim2.new(0,50,0,50)},
	TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
	tween(Ring,{Size=UDim2.new(0,50,0,50)},
	TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))

	task.wait(0.3)
	showToast("Nova UI v2.2  —  Ready ✓","ok")

	-- Pulse ring loop
	task.spawn(function()
		while ToggleBtn and ToggleBtn.Parent do
			task.wait(2.8)
			if not menuOpen then
				Ring.Size=UDim2.new(0,50,0,50)
				Ring.Position=ToggleBtn.Position
				Ring.BackgroundTransparency=0.5
				tween(Ring,{
					Size=UDim2.new(0,76,0,76),
					Position=UDim2.new(
						Ring.Position.X.Scale,
						Ring.Position.X.Offset-13,
						Ring.Position.Y.Scale,
						Ring.Position.Y.Offset-13
					),
					BackgroundTransparency=1,
				},TweenInfo.new(0.9,Enum.EasingStyle.Quad,Enum.EasingDirection.Out))
				task.wait(0.9)
			end
		end
	end)
end)
-- ══════════════════════════════════════════
-- PANEL
-- ══════════════════════════════════════════
local PANEL_W = 360

local Panel = newFrame(ScreenGui, {
	BG   = T.BG,
	Size = UDim2.new(0, PANEL_W, 1, 0),
	Position = UDim2.new(1, 0, 0, 0),
	ZIndex = 10,
	ClipsDescendants = true,
	Name = "NovaPanel",
})
gradient(Panel, Color3.fromRGB(10,10,20), Color3.fromRGB(6,6,12), 180)
stroke(Panel, T.BORDER, 1)

-- ══════════════════════════════════════════
-- HEADER  (v2.2 — nâng cấp)
-- ══════════════════════════════════════════
local HEADER_H = 72

local Header = newFrame(Panel, {
	BG   = Color3.fromRGB(12,12,22),
	Size = UDim2.new(1, 0, 0, HEADER_H),
	ZIndex = 11,
})
gradient(Header, Color3.fromRGB(18,18,36), Color3.fromRGB(10,10,20), 180)
stroke(Header, T.BORDER, 1)

-- Accent top line
local HeaderTopLine = newFrame(Header, {
	BG   = T.ACCENT,
	Size = UDim2.new(1, 0, 0, 2),
	ZIndex = 12,
})
gradient(HeaderTopLine, T.ACCENT, T.ACCENT2, 90)

-- Logo icon bg
local LogoBg = newFrame(Header, {
	BG   = T.ACCENT,
	Size = UDim2.new(0,42,0,42),
	Position = UDim2.new(0,16,0.5,-21),
	ZIndex = 12,
})
corner(LogoBg, 13)
gradient(LogoBg, T.ACCENT, T.ACCENT2, 135)
stroke(LogoBg, Color3.fromRGB(140,120,255), 1, 0.4)

newLabel(LogoBg, {
	Text="N", Color=T.WHITE, Size=22, Font=Enum.Font.GothamBold,
	AlignX=Enum.TextXAlignment.Center, ZIndex=13,
})

-- Logo text
newLabel(Header, {
	Text="NOVA UI",
	Color=T.WHITE, Size=16, Font=Enum.Font.GothamBold,
	Sz=UDim2.new(0,120,0,22),
	Position=UDim2.new(0,68,0,13),
	ZIndex=12,
})
newLabel(Header, {
	Text="v2.2  ·  Executor Interface",
	Color=T.TEXT3, Size=9,
	Sz=UDim2.new(0,160,0,16),
	Position=UDim2.new(0,68,0,36),
	ZIndex=12,
})

-- Status pill
local StatusPill = newFrame(Header, {
	BG   = Color3.fromRGB(10,32,16),
	Size = UDim2.new(0,68,0,18),
	Position = UDim2.new(0,68,0,54),
	ZIndex = 12,
})
corner(StatusPill, 6)
stroke(StatusPill, T.SUCCESS, 1, 0.5)

local StatusDot = newFrame(StatusPill, {
	BG   = T.SUCCESS,
	Size = UDim2.new(0,6,0,6),
	Position = UDim2.new(0,7,0.5,-3),
	ZIndex = 13,
})
corner(StatusDot, 3)

newLabel(StatusPill, {
	Text="Online",
	Color=T.SUCCESS, Size=9, Font=Enum.Font.GothamBold,
	Sz=UDim2.new(1,-20,1,0),
	Position=UDim2.new(0,18,0,0),
	ZIndex=13,
})

-- Pulse anim trên status dot
task.spawn(function()
	while StatusDot and StatusDot.Parent do
		tween(StatusDot, {BackgroundTransparency=0.6},
		TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
		task.wait(0.8)
		tween(StatusDot, {BackgroundTransparency=0},
		TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
		task.wait(0.8)
	end
end)

-- Minimize button
local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0,30,0,30)
MinBtn.Position = UDim2.new(1,-76,0.5,-15)
MinBtn.Text = "—"
MinBtn.TextSize = 13
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextColor3 = T.TEXT3
MinBtn.BackgroundColor3 = T.SURFACE2
MinBtn.BorderSizePixel = 0
MinBtn.ZIndex = 12
corner(MinBtn, 8)
stroke(MinBtn, T.BORDER, 1)
MinBtn.MouseEnter:Connect(function() tween(MinBtn,{BackgroundColor3=T.WARN,TextColor3=T.BG}) end)
MinBtn.MouseLeave:Connect(function() tween(MinBtn,{BackgroundColor3=T.SURFACE2,TextColor3=T.TEXT3}) end)

-- Close button
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-40,0.5,-15)
CloseBtn.Text = "✕"
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = T.TEXT3
CloseBtn.BackgroundColor3 = T.SURFACE2
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 12
corner(CloseBtn, 8)
stroke(CloseBtn, T.BORDER, 1)
CloseBtn.MouseEnter:Connect(function() tween(CloseBtn,{BackgroundColor3=T.DANGER,TextColor3=T.WHITE}) end)
CloseBtn.MouseLeave:Connect(function() tween(CloseBtn,{BackgroundColor3=T.SURFACE2,TextColor3=T.TEXT3}) end)

-- ══════════════════════════════════════════
-- NAV SIDEBAR  v2.2 (hoàn toàn mới)
-- ══════════════════════════════════════════
local NAV_W = T.NAV_W

local NavBar = newFrame(Panel, {
	BG   = Color3.fromRGB(8,8,16),
	Size = UDim2.new(0, NAV_W, 1, -HEADER_H),
	Position = UDim2.new(0, 0, 0, HEADER_H),
	ZIndex = 11,
})
gradient(NavBar, Color3.fromRGB(12,12,22), Color3.fromRGB(7,7,14), 180)
stroke(NavBar, T.BORDER, 1)

-- Top fade overlay
local NavTopFade = newFrame(NavBar, {
	BG=T.BG, BT=1,
	Size=UDim2.new(1,0,0,8), ZIndex=14,
})
-- Gradient fade từ trên xuống
local ntfg = Instance.new("UIGradient", NavTopFade)
ntfg.Color    = ColorSequence.new(Color3.fromRGB(8,8,16), Color3.fromRGB(8,8,16))
ntfg.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0,0),
	NumberSequenceKeypoint.new(1,1),
})
ntfg.Rotation = 180

-- Scrollable nav list
local NavScroll = Instance.new("ScrollingFrame", NavBar)
NavScroll.Size = UDim2.new(1,0,1,-8)
NavScroll.Position = UDim2.new(0,0,0,8)
NavScroll.BackgroundTransparency = 1
NavScroll.BorderSizePixel = 0
NavScroll.ScrollBarThickness = 0
NavScroll.CanvasSize = UDim2.new(0,0,0,0)
NavScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
NavScroll.ZIndex = 12

local NavList = Instance.new("UIListLayout", NavScroll)
NavList.SortOrder = Enum.SortOrder.LayoutOrder
NavList.Padding = UDim.new(0,2)
NavList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local navTopPad = Instance.new("UIPadding", NavScroll)
navTopPad.PaddingTop    = UDim.new(0,6)
navTopPad.PaddingBottom = UDim.new(0,6)

-- Active selection indicator (pill trái)
local NavPill = newFrame(NavBar, {
	BG   = T.ACCENT,
	Size = UDim2.new(0,3,0,38),
	Position = UDim2.new(0,0,0,0),
	ZIndex = 15,
})
corner(NavPill, 2)
gradient(NavPill, T.ACCENT, T.ACCENT2, 180)
NavPill.Visible = false

-- Tooltip frame
local NavTooltip = newFrame(ScreenGui, {
	BG   = Color3.fromRGB(20,20,36),
	Size = UDim2.new(0,10,0,26),
	Position = UDim2.new(0,0,0,0),
	ZIndex = 60,
})
NavTooltip.AutomaticSize = Enum.AutomaticSize.X
NavTooltip.Visible = false
corner(NavTooltip, 7)
stroke(NavTooltip, T.BORDER2, 1)

-- Tooltip arrow (triangle pointing left)
local TooltipArrow = newFrame(NavTooltip, {
	BG   = Color3.fromRGB(20,20,36),
	Size = UDim2.new(0,7,0,7),
	Position = UDim2.new(0,-4,0.5,-4),
	ZIndex = 59,
})
TooltipArrow.Rotation = 45

local TooltipLabel = newLabel(NavTooltip, {
	Text = "",
	Color = T.TEXT, Size = 11, Font = Enum.Font.GothamBold,
	Sz = UDim2.new(1,0,1,0),
	ZIndex = 61,
})
TooltipLabel.AutomaticSize = Enum.AutomaticSize.X
local ttpPad = Instance.new("UIPadding", TooltipLabel)
ttpPad.PaddingLeft  = UDim.new(0,10)
ttpPad.PaddingRight = UDim.new(0,10)

-- ── Nav Definitions ──
local navDefs = {
	{ name="Home",      icon="⌂",  order=1,  color=T.ACCENT,  divAfter=false },
	{ name="Players",   icon="◉",  order=2,  color=T.ACCENT3, divAfter=false },
	{ name="Events",    icon="★",  order=3,  color=T.WARN,    divAfter=false },
	{ name="Explorer",  icon="❧",  order=4,  color=T.SUCCESS, divAfter=true  },
	{ name="GUIEdit",   icon="✏",  order=5,  color=T.ACCENT2, divAfter=false },
	{ name="Display",   icon="◫",  order=6,  color=T.ACCENT3, divAfter=true  },
	{ name="Settings",  icon="⚙",  order=7,  color=T.TEXT2,   divAfter=false },
	{ name="Perf",      icon="📊", order=8,  color=T.WARN,    divAfter=false },
	{ name="Console",   icon="📝", order=9,  color=T.SUCCESS, divAfter=false },
	{ name="AntiCheat", icon="🛡", order=10, color=T.DANGER,  divAfter=true  },
	{ name="Keybinds",  icon="⌨",  order=11, color=T.ACCENT,  divAfter=false },
	{ name="Scripts",   icon="📝", order=12, color=T.SUCCESS, divAfter=false },
	{ name="Combat",    icon="⚔",  order=13, color=T.DANGER,  divAfter=false },
	{ name="Host",      icon="👑",  order=14, color=T.WARN,    divAfter=false },
}

-- ══════════════════════════════════════════
-- HOST SYSTEM (QuirkyCMD Ultimate)         👈 ĐẶT Ở ĐÂY
-- ══════════════════════════════════════════
local hostSystem = {
	hostPlayer = nil,
	hostCommands = {},
	isHost = function(plr)
		return plr == hostSystem.hostPlayer
	end,
	setHost = function(plr)
		hostSystem.hostPlayer = plr
		showToast("👑 " .. (plr and plr.Name or "Không có ai") .. " là chủ phòng!", "ok")
		if hostSystem.onHostChanged then
			hostSystem.onHostChanged(plr)
		end
	end,
	onHostChanged = nil,
}

-- ── State ──
local navButtons  = {}
local pages       = {}
local currentPage = nil
local pageCallbacks = {}

-- ── Page content area ──
local ContentArea = newFrame(Panel, {
	BG=Color3.fromRGB(0,0,0), BT=1,
	Size=UDim2.new(1,-NAV_W,1,-HEADER_H),
	Position=UDim2.new(0,NAV_W,0,HEADER_H),
	ZIndex=10,
})

-- ── Divider helper ──
local function makeNavDivider(parent, order)
	local div = newFrame(parent, {
		BG=T.BORDER, BT=0.5,
		Size=UDim2.new(0,36,0,1),
		ZIndex=12,
	})
	div.LayoutOrder = order
	local dPad = Instance.new("UIPadding",div)
	dPad.PaddingTop=UDim.new(0,3); dPad.PaddingBottom=UDim.new(0,3)
	return div
end

-- ── State ──
local navButtons  = {}
local pages       = {}
local currentPage = nil
local pageCallbacks = {}

-- ── Page content area ──
local ContentArea = newFrame(Panel, {
	BG=Color3.fromRGB(0,0,0), BT=1,
	Size=UDim2.new(1,-NAV_W,1,-HEADER_H),
	Position=UDim2.new(0,NAV_W,0,HEADER_H),
	ZIndex=10,
})

-- ── Switch page (upgraded: slide + fade) ──
local function switchPage(name)
	if currentPage == name then return end
	currentPage = name

	for n, page in pairs(pages) do
		if n == name then
			page.Visible = true
			page.BackgroundTransparency = 1
			page.Position = UDim2.new(0.06, 0, 0, 0)
			tween(page, {Position=UDim2.new(0,0,0,0)}, EZ_MED)
		else
			page.Visible = false
		end
	end

	for n, btn in pairs(navButtons) do
		local def = nil
		for _, d in ipairs(navDefs) do if d.name == n then def = d; break end end
		local accentCol = def and def.color or T.ACCENT

		if n == name then
			tween(btn.bg,    {BackgroundColor3 = accentCol})
			tween(btn.icon,  {TextColor3 = T.WHITE})
			tween(btn.label, {TextColor3 = T.WHITE, TextTransparency=0})
			-- Move pill indicator
			NavPill.Visible = true
			local targetY = btn.bg.AbsolutePosition.Y - NavBar.AbsolutePosition.Y
			tween(NavPill, {
				Position = UDim2.new(0,0,0, targetY+3),
				Size     = UDim2.new(0,3,0,38),
				BackgroundColor3 = accentCol,
			}, EZ_MED)
		else
			tween(btn.bg,    {BackgroundColor3 = T.SURFACE})
			tween(btn.icon,  {TextColor3 = T.TEXT3})
			tween(btn.label, {TextColor3 = T.TEXT3, TextTransparency=0})
		end
	end

	if pageCallbacks[name] then pageCallbacks[name]() end
end

-- ── Build each nav button ──
local divOrder = 100
for _, def in ipairs(navDefs) do

	-- Wrapper button
	local wrap = Instance.new("TextButton", NavScroll)
	wrap.Size = UDim2.new(0, NAV_W-6, 0, 58)
	wrap.BackgroundTransparency = 1
	wrap.Text = ""
	wrap.BorderSizePixel = 0
	wrap.ZIndex = 12
	wrap.LayoutOrder = def.order * 2

	-- Background card
	local bg = newFrame(wrap, {
		BG   = T.SURFACE,
		Size = UDim2.new(0, NAV_W-12, 0, 52),
		Position = UDim2.new(0, 3, 0, 3),
		ZIndex = 12,
	})
	corner(bg, 12)
	stroke(bg, T.BORDER, 1)

	-- Glow dot (top-right corner, shows when active)
	local glowDot = newFrame(bg, {
		BG   = def.color,
		Size = UDim2.new(0,5,0,5),
		Position = UDim2.new(1,-8,0,6),
		ZIndex = 14,
	})
	corner(glowDot, 3)
	glowDot.Visible = false

	-- Icon
	local iconLbl = newLabel(bg, {
		Text   = def.icon,
		Color  = T.TEXT3,
		Size   = 20,
		AlignX = Enum.TextXAlignment.Center,
		Sz     = UDim2.new(1,0,0,30),
		Position = UDim2.new(0,0,0,5),
		ZIndex = 13,
	})

	-- Label bên dưới icon
	local label = newLabel(bg, {
		Text   = def.name,
		Color  = T.TEXT3,
		Size   = 7,
		Font   = Enum.Font.GothamBold,
		AlignX = Enum.TextXAlignment.Center,
		Sz     = UDim2.new(1,0,0,13),
		Position = UDim2.new(0,0,0,35),
		ZIndex = 13,
	})

	navButtons[def.name] = {
		bg       = bg,
		icon     = iconLbl,
		label    = label,
		glowDot  = glowDot,
		def      = def,
	}

	-- Click
	wrap.MouseButton1Click:Connect(function()
		switchPage(def.name)
	end)

	-- Hover
	wrap.MouseEnter:Connect(function()
		if currentPage ~= def.name then
			tween(bg, {BackgroundColor3=T.SURFACE2})
			tween(iconLbl, {TextColor3=T.TEXT2})
		end
		-- Show tooltip
		TooltipLabel.Text = def.name
		NavTooltip.Visible = true
		local absPos = bg.AbsolutePosition
		NavTooltip.Position = UDim2.new(0, absPos.X + NAV_W - 2, 0, absPos.Y + 13)
		tween(NavTooltip, {BackgroundTransparency=0}, EZ)
	end)

	wrap.MouseLeave:Connect(function()
		if currentPage ~= def.name then
			tween(bg, {BackgroundColor3=T.SURFACE})
			tween(iconLbl, {TextColor3=T.TEXT3})
		end
		NavTooltip.Visible = false
	end)

	-- Divider setelah item
	if def.divAfter then
		divOrder += 1
		local div = newFrame(NavScroll, {
			BG=T.BORDER, BT=0.6,
			Size=UDim2.new(0,40,0,1),
			ZIndex=12,
		})
		div.LayoutOrder = def.order * 2 + 1
		local divPad = Instance.new("UIPadding",div)
		divPad.PaddingTop=UDim.new(0,2); divPad.PaddingBottom=UDim.new(0,2)
	end
end

-- ── Update glow dots khi switch ──
local function updateNavDots()
	for name, btn in pairs(navButtons) do
		btn.glowDot.Visible = (name == currentPage)
	end
end

-- Patch switchPage để cập nhật dots
local _origSwitch = switchPage
switchPage = function(name)
	_origSwitch(name)
	updateNavDots()
end

-- ══════════════════════════════════════════
-- PAGE FACTORY  (giữ nguyên)
-- ══════════════════════════════════════════
local function makePage(name)
	local scroll = Instance.new("ScrollingFrame", ContentArea)
	scroll.Size                  = UDim2.new(1,0,1,0)
	scroll.BackgroundTransparency= 1
	scroll.BorderSizePixel       = 0
	scroll.ScrollBarThickness    = 3
	scroll.ScrollBarImageColor3  = T.ACCENT
	scroll.CanvasSize            = UDim2.new(0,0,0,0)
	scroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
	scroll.ZIndex                = 11
	scroll.Visible               = false

	local list = Instance.new("UIListLayout", scroll)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding   = UDim.new(0,6)

	local pad = Instance.new("UIPadding", scroll)
	pad.PaddingTop    = UDim.new(0,12)
	pad.PaddingBottom = UDim.new(0,16)
	pad.PaddingLeft   = UDim.new(0,10)
	pad.PaddingRight  = UDim.new(0,10)

	pages[name] = scroll
	return scroll, list
end

-- ══════════════════════════════════════════
-- NOTIFICATION TOAST  (upgraded: position-aware, icon)
-- ══════════════════════════════════════════
local toastQ      = {}
local toastActive = false

local function showToast(text, kind)
	table.insert(toastQ, {text=text, kind=kind or "info"})
	if toastActive then return end
	toastActive = true
	task.spawn(function()
		while #toastQ > 0 do
			local t = table.remove(toastQ,1)
			local col  = t.kind=="ok"   and T.SUCCESS
				or t.kind=="warn" and T.WARN
				or t.kind=="err"  and T.DANGER
				or T.ACCENT
			local icon = t.kind=="ok"   and "✓"
				or t.kind=="warn" and "⚠"
				or t.kind=="err"  and "✕"
				or "ℹ"

			local toast = newFrame(ScreenGui, {
				BG   = Color3.fromRGB(14,14,26),
				Size = UDim2.new(0,240,0,40),
				Position = UDim2.new(0.5,-120,1,10),
				ZIndex = 50,
			})
			corner(toast, 12)
			stroke(toast, col, 1, 0.2)
			gradient(toast,
				Color3.fromRGB(18,18,32),
				Color3.fromRGB(12,12,22), 180)

			-- Color accent left bar
			local bar = newFrame(toast, {
				BG=col, Size=UDim2.new(0,3,1,-10),
				Position=UDim2.new(0,0,0,5), ZIndex=51,
			})
			corner(bar,2)

			-- Icon circle
			local iconF = newFrame(toast, {
				BG=col, BT=0.8,
				Size=UDim2.new(0,24,0,24),
				Position=UDim2.new(0,9,0.5,-12), ZIndex=51,
			})
			corner(iconF, 7)
			newLabel(iconF, {
				Text=icon, Color=col, Size=11, Font=Enum.Font.GothamBold,
				AlignX=Enum.TextXAlignment.Center, ZIndex=52,
			})

			newLabel(toast, {
				Text=t.text, Color=T.TEXT, Size=11,
				Sz=UDim2.new(1,-46,1,0),
				Position=UDim2.new(0,40,0,0),
				ZIndex=51, Truncate=true,
			})

			tween(toast, {Position=UDim2.new(0.5,-120,1,-54)}, EZ_SPR)
			task.wait(2.2)
			tween(toast, {
				Position=UDim2.new(0.5,-120,1,10),
				BackgroundTransparency=1,
			}, EZ_MED)
			task.wait(0.4)
			toast:Destroy()
			task.wait(0.08)
		end
		toastActive = false
	end)
end

-- ══════════════════════════════════════════
-- OPEN / CLOSE
-- ══════════════════════════════════════════
local menuOpen = false

local function openMenu()
	if menuOpen then return end
	menuOpen = true
	tween(Panel,       {Position=UDim2.new(1,-PANEL_W,0,0)}, EZ_SLOW)
	tween(BlurEffect,  {Size=10},                             EZ_SLOW)
	if currentPage == nil then switchPage("Home") end
end

local function closeMenu()
	if not menuOpen then return end
	menuOpen = false
	tween(Panel,      {Position=UDim2.new(1,0,0,0)}, EZ_SLOW)
	tween(BlurEffect, {Size=0},                       EZ_SLOW)
	NavTooltip.Visible = false
end

CloseBtn.MouseButton1Click:Connect(closeMenu)

-- Minimize: collapse to just header
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		tween(Panel, {Size=UDim2.new(0,PANEL_W,0,HEADER_H)}, EZ_MED)
		MinBtn.Text = "□"
	else
		tween(Panel, {Size=UDim2.new(0,PANEL_W,1,0)}, EZ_MED)
		MinBtn.Text = "—"
	end
end)

-- ══════════════════════════════════════════
-- TOGGLE BUTTON  v2.2 (draggable, animated)
-- ══════════════════════════════════════════
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size            = UDim2.new(0,50,0,50)
ToggleBtn.Position        = UDim2.new(1,-66,0,22)
ToggleBtn.Text            = "N"
ToggleBtn.TextSize        = 22
ToggleBtn.Font            = Enum.Font.GothamBold
ToggleBtn.TextColor3      = T.WHITE
ToggleBtn.BackgroundColor3= T.ACCENT
ToggleBtn.BorderSizePixel = 0
ToggleBtn.ZIndex          = 9
ToggleBtn.Visible         = false
corner(ToggleBtn, 16)
gradient(ToggleBtn, T.ACCENT, T.ACCENT2, 135)
stroke(ToggleBtn, Color3.fromRGB(140,120,255), 1, 0.3)

-- Outer glow ring
local Ring = newFrame(ScreenGui, {
	BG=T.ACCENT, BT=0.6,
	Size=UDim2.new(0,50,0,50),
	Position=UDim2.new(1,-66,0,22),
	ZIndex=8,
})
corner(Ring, 16)
Ring.Visible = false

-- Badge (notification count, dùng khi muốn thêm badge)
local Badge = newFrame(ToggleBtn, {
	BG=T.DANGER,
	Size=UDim2.new(0,14,0,14),
	Position=UDim2.new(1,-4,0,-4),
	ZIndex=10,
})
corner(Badge, 7)
Badge.Visible = false
local BadgeLbl = newLabel(Badge, {
	Text="0", Color=T.WHITE, Size=8, Font=Enum.Font.GothamBold,
	AlignX=Enum.TextXAlignment.Center, ZIndex=11,
})

-- Drag
local dragOn, dragStart, btnStartPos = false, nil, nil
ToggleBtn.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1
		or i.UserInputType==Enum.UserInputType.Touch then
		dragOn=true; dragStart=i.Position; btnStartPos=ToggleBtn.Position
	end
end)
UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1
		or i.UserInputType==Enum.UserInputType.Touch then
		dragOn=false
	end
end)
UserInputService.InputChanged:Connect(function(i)
	if dragOn and (i.UserInputType==Enum.UserInputType.MouseMovement
		or i.UserInputType==Enum.UserInputType.Touch) then
		local d  = i.Position - dragStart
		local np = UDim2.new(
			btnStartPos.X.Scale, btnStartPos.X.Offset + d.X,
			btnStartPos.Y.Scale, btnStartPos.Y.Offset + d.Y
		)
		ToggleBtn.Position = np
		Ring.Position      = np
	end
end)

ToggleBtn.MouseButton1Click:Connect(function()
	if menuOpen then closeMenu() else openMenu() end
	-- Scale bounce
	tween(ToggleBtn, {Size=UDim2.new(0,44,0,44)}, TweenInfo.new(0.1))
	task.delay(0.12, function()
		tween(ToggleBtn, {Size=UDim2.new(0,50,0,50)}, EZ_SPR)
	end)
end)

ToggleBtn.MouseEnter:Connect(function()
	tween(ToggleBtn, {BackgroundColor3=T.ACCENT2})
	tween(Ring, {BackgroundTransparency=0.4})
end)
ToggleBtn.MouseLeave:Connect(function()
	tween(ToggleBtn, {BackgroundColor3=T.ACCENT})
	tween(Ring, {BackgroundTransparency=0.6})
end)

-- ══════════════════════════════════════════
-- INTRO ANIMATION SEQUENCE
-- ══════════════════════════════════════════
task.spawn(function()

	-- Phase 0: rings pulse in
	OuterRing.BackgroundTransparency=1
	InnerRing.BackgroundTransparency=1
	LogoCard.BackgroundTransparency=1
	NGlow.BackgroundTransparency=1
	NLbl.TextTransparency=1

	task.wait(0.1)

	-- Outer ring zoom in
	OuterRing.Size=UDim2.new(0,20,0,20)
	OuterRing.Position=UDim2.new(0.5,-10,0.5,-50)
	tween(OuterRing,{
		Size=UDim2.new(0,180,0,180),
		Position=UDim2.new(0.5,-90,0.5,-140),
		BackgroundTransparency=0.85,
	}, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
	task.wait(0.12)

	tween(InnerRing,{
		Size=UDim2.new(0,140,0,140),
		Position=UDim2.new(0.5,-70,0.5,-110),
		BackgroundTransparency=0.88,
	}, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
	task.wait(0.1)

	-- Logo card appear
	LogoCard.Size=UDim2.new(0,60,0,60)
	LogoCard.Position=UDim2.new(0.5,-30,0.5,-60)
	tween(LogoCard,{
		Size=UDim2.new(0,100,0,100),
		Position=UDim2.new(0.5,-50,0.5,-90),
		BackgroundTransparency=0,
	}, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out))

	tween(NGlow,{BackgroundTransparency=0.7}, TweenInfo.new(0.4))
	task.wait(0.25)

	tween(NLbl,{TextTransparency=0}, TweenInfo.new(0.3))
	task.wait(0.2)

	-- Arc dots spin into place
	for i,arc in ipairs(arcFrames) do
		task.spawn(function()
			arc.BackgroundTransparency=1
			task.wait((i-1)*0.05)
			tween(arc,{BackgroundTransparency=0.6}, TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out))
		end)
	end
	task.wait(0.3)

	-- Phase 1: wordmark slides up
	WordmarkWrap.Position=UDim2.new(0.5,-140,0.5,60)
	tween(WordmarkWrap,{Position=UDim2.new(0.5,-140,0.5,40)},
	TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
	tween(NovaText,{TextTransparency=0}, TweenInfo.new(0.35))
	task.wait(0.2)

	-- Subtitle items appear one by one
	for i,sl in ipairs(subLabels) do
		task.spawn(function()
			task.wait((i-1)*0.05)
			tween(sl,{TextTransparency=0},TweenInfo.new(0.25))
		end)
	end
	task.wait(0.4)

	-- Phase 2: progress bar + chips + status
	tween(ProgressLbl,{TextTransparency=0},TweenInfo.new(0.3))

	-- Spin the outer ring continuously
	task.spawn(function()
		local rot=0
		while Splash and Splash.Parent do
			task.wait(0.02)
			rot=(rot+1.2)%360
			for i,arc in ipairs(arcFrames) do
				local ang=rot + (i-1)*72
				arc.Position=UDim2.new(
					0.5 + math.cos(math.rad(ang))*0.12 - 0.02,
					math.cos(math.rad(ang))*2,
					0.5 + math.sin(math.rad(ang))*0.12 - 0.12,
					math.sin(math.rad(ang))*2 - 90
				)
			end
		end
	end)

	-- Inner ring counter-spin (subtle pulse)
	task.spawn(function()
		while Splash and Splash.Parent do
			tween(InnerRing,{BackgroundTransparency=0.82},
			TweenInfo.new(0.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut))
			task.wait(0.7)
			tween(InnerRing,{BackgroundTransparency=0.92},
			TweenInfo.new(0.7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut))
			task.wait(0.7)
		end
	end)

	-- Progress + chips + status messages
	local totalSteps = #FEATURES
	for i,cf in ipairs(chipFrames) do
		task.wait(0.18)

		-- Update status label
		if STATUS_MSGS[i] then
			ProgressLbl.Text = STATUS_MSGS[i]
		end

		-- Reveal chip
		tween(cf.frame,{BackgroundTransparency=0},
		TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out))
		tween(cf.label,{TextTransparency=0},TweenInfo.new(0.2))

		-- Progress bar advance
		local prog = i/totalSteps
		tween(ProgressFill,{Size=UDim2.new(prog,0,1,0)},
		TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out))
	end

	-- Final status
	task.wait(0.18)
	ProgressLbl.Text = STATUS_MSGS[#STATUS_MSGS]
	tween(ProgressFill,{Size=UDim2.new(1,0,1,0)},
	TweenInfo.new(0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out))

	-- Flash: all chips pulse white briefly
	task.wait(0.25)
	for _,cf in ipairs(chipFrames) do
		tween(cf.frame,{BackgroundColor3=cf.color},TweenInfo.new(0.15))
		tween(cf.label,{TextColor3=T.WHITE},TweenInfo.new(0.15))
	end
	task.wait(0.3)
	for _,cf in ipairs(chipFrames) do
		tween(cf.frame,{BackgroundColor3=Color3.fromRGB(14,14,28)},TweenInfo.new(0.3))
		tween(cf.label,{TextColor3=cf.color},TweenInfo.new(0.3))
	end

	-- Phase 3: logo scale up briefly then fade out
	task.wait(0.4)
	tween(LogoCard,{
		Size=UDim2.new(0,112,0,112),
		Position=UDim2.new(0.5,-56,0.5,-96),
	}, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
	tween(NLbl,{TextTransparency=0.1,TextColor3=T.ACCENT},TweenInfo.new(0.2))

	task.wait(0.22)

	-- Phase 4: full screen flash then wipe out
	local Flash = newFrame(Splash,{
		BG=T.WHITE, BT=1,
		Size=UDim2.new(1,0,1,0), ZIndex=50,
	})
	tween(Flash,{BackgroundTransparency=0.92},TweenInfo.new(0.12))
	task.wait(0.12)
	tween(Flash,{BackgroundTransparency=1},TweenInfo.new(0.3))

	-- Wipe upward
	tween(Splash,{
		Position=UDim2.new(0,0,-1,0),
		BackgroundTransparency=0.3,
	}, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.In))

	task.wait(0.5)
	Splash:Destroy()

	-- ── Show toggle button ──
	ToggleBtn.Size    = UDim2.new(0,20,0,20)
	ToggleBtn.Visible = true
	Ring.Size         = UDim2.new(0,20,0,20)
	Ring.Visible      = true
	tween(ToggleBtn,{Size=UDim2.new(0,50,0,50)},
	TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
	tween(Ring,{Size=UDim2.new(0,50,0,50)},
	TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out))

	task.wait(0.3)
	showToast("Nova UI v2.2  —  Ready ✓","ok")

	-- Pulse ring loop
	task.spawn(function()
		while ToggleBtn and ToggleBtn.Parent do
			task.wait(2.8)
			if not menuOpen then
				Ring.Size=UDim2.new(0,50,0,50)
				Ring.Position=ToggleBtn.Position
				Ring.BackgroundTransparency=0.5
				tween(Ring,{
					Size=UDim2.new(0,76,0,76),
					Position=UDim2.new(
						Ring.Position.X.Scale,
						Ring.Position.X.Offset-13,
						Ring.Position.Y.Scale,
						Ring.Position.Y.Offset-13
					),
					BackgroundTransparency=1,
				},TweenInfo.new(0.9,Enum.EasingStyle.Quad,Enum.EasingDirection.Out))
				task.wait(0.9)
			end
		end
	end)
end)

-- ══════════════════════════════════════════
-- CARD / SECTION HELPERS  (dùng bởi pages)
-- ══════════════════════════════════════════
local function makeCard(parent, height, order)
	local card = newFrame(parent, {
		BG   = T.SURFACE,
		Size = UDim2.new(1,0,0,height),
		ZIndex = 12,
	})
	corner(card, 12)
	stroke(card, T.BORDER, 1)
	if order then card.LayoutOrder = order end
	return card
end

local function makeSectionLabel(parent, text, order)
	local wrap = newFrame(parent, {
		BG=Color3.fromRGB(0,0,0), BT=1,
		Size=UDim2.new(1,0,0,22), ZIndex=12,
	})
	wrap.LayoutOrder = order or 0
	newFrame(wrap, {
		BG=T.BORDER,
		Size=UDim2.new(1,-80,0,1),
		Position=UDim2.new(0,76,0.5,0), ZIndex=12,
	})
	local lbl = newLabel(wrap, {
		Text="◈  "..string.upper(text),
		Color=T.ACCENT, Size=9, Font=Enum.Font.GothamBold,
		Sz=UDim2.new(0,72,1,0), ZIndex=13,
	})
	local p=Instance.new("UIPadding",lbl); p.PaddingLeft=UDim.new(0,2)
	return wrap
end

local function makeToggle(parent, labelText, default, onChange, order)
	local row = newFrame(parent, {
		BG=T.SURFACE, Size=UDim2.new(1,0,0,44), ZIndex=12,
	})
	corner(row,10); stroke(row,T.BORDER,1)
	row.LayoutOrder = order or 0

	newLabel(row, {
		Text=labelText, Color=T.TEXT, Size=13,
		Sz=UDim2.new(1,-72,1,0), Position=UDim2.new(0,14,0,0), ZIndex=13,
	})

	local track = Instance.new("TextButton",row)
	track.Size=UDim2.new(0,42,0,22)
	track.AnchorPoint=Vector2.new(1,0.5)
	track.Position=UDim2.new(1,-12,0.5,0)
	track.BackgroundColor3=default and T.ACCENT or T.SURFACE2
	track.Text=""; track.BorderSizePixel=0; track.ZIndex=13
	corner(track,12); stroke(track,T.BORDER,1)
	if default then gradient(track,T.ACCENT,T.ACCENT2,90) end

	local thumb=newFrame(track,{
		BG=T.WHITE, Size=UDim2.new(0,16,0,16),
		Position=default and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),
		ZIndex=14,
	})
	corner(thumb,9)

	local isOn=default
	local function toggle()
		isOn=not isOn
		if isOn then
			tween(track,{BackgroundColor3=T.ACCENT})
			gradient(track,T.ACCENT,T.ACCENT2,90)
		else
			tween(track,{BackgroundColor3=T.SURFACE2})
		end
		tween(thumb,{Position=isOn and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)})
		if onChange then onChange(isOn) end
	end
	track.MouseButton1Click:Connect(toggle)
	return row
end

local function makeSlider(parent, labelText, min, max, default, onChange, order)
	local row=newFrame(parent,{BG=T.SURFACE,Size=UDim2.new(1,0,0,58),ZIndex=12})
	corner(row,10); stroke(row,T.BORDER,1)
	row.LayoutOrder=order or 0

	newLabel(row,{Text=labelText,Color=T.TEXT,Size=12,
		Sz=UDim2.new(1,-60,0,20),Position=UDim2.new(0,14,0,6),ZIndex=13})

	local valLbl=newLabel(row,{Text=tostring(default),Color=T.ACCENT,Size=12,
		Font=Enum.Font.GothamBold,Sz=UDim2.new(0,46,0,20),
		Position=UDim2.new(1,-58,0,6),AlignX=Enum.TextXAlignment.Right,ZIndex=13})

	local track=newFrame(row,{BG=T.SURFACE2,Size=UDim2.new(1,-28,0,5),
		Position=UDim2.new(0,14,0,38),ZIndex=13})
	corner(track,4); stroke(track,T.BORDER,1)

	local fill=newFrame(track,{BG=T.ACCENT,
		Size=UDim2.new((default-min)/(max-min),0,1,0),ZIndex=14})
	corner(fill,4); gradient(fill,T.ACCENT,T.ACCENT2,90)

	local thumb=Instance.new("TextButton",track)
	thumb.Size=UDim2.new(0,16,0,16)
	thumb.AnchorPoint=Vector2.new(0.5,0.5)
	thumb.Position=UDim2.new((default-min)/(max-min),0,0.5,0)
	thumb.BackgroundColor3=T.WHITE; thumb.Text=""; thumb.BorderSizePixel=0; thumb.ZIndex=15
	corner(thumb,9); stroke(thumb,T.ACCENT,1)

	local drag=false
	thumb.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1
			or i.UserInputType==Enum.UserInputType.Touch then
			drag=true; tween(thumb,{Size=UDim2.new(0,20,0,20)})
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1
			or i.UserInputType==Enum.UserInputType.Touch then
			drag=false; tween(thumb,{Size=UDim2.new(0,16,0,16)})
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if drag and (i.UserInputType==Enum.UserInputType.MouseMovement
			or i.UserInputType==Enum.UserInputType.Touch) then
			local relX=math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
			local val=math.floor(min+relX*(max-min))
			fill.Size=UDim2.new(relX,0,1,0)
			thumb.Position=UDim2.new(relX,0,0.5,0)
			valLbl.Text=tostring(val)
			if onChange then onChange(val) end
		end
	end)
	return row, valLbl
end

-- ══════════════════════════════════════════
-- ★ PAGE: HOME  v3  (nâng cấp toàn diện)
-- ══════════════════════════════════════════
local homePage, _ = makePage("Home")

do
	local character = Player.Character or Player.CharacterAdded:Wait()
	local humanoid  = character:WaitForChild("Humanoid")
	local sessionStart = tick()

	Player.CharacterAdded:Connect(function(char)
		character = char
		humanoid  = char:WaitForChild("Humanoid")
	end)

	local function getHum()
		return character and character:FindFirstChildOfClass("Humanoid")
	end
	local function getRoot()
		return character and character:FindFirstChild("HumanoidRootPart")
	end

	-- ════════════════════════════════════════
	-- [1] PROFILE CARD  (glassmorphism nâng cao)
	-- ════════════════════════════════════════
	local profCard = makeCard(homePage, 104, 1)
	gradient(profCard, Color3.fromRGB(20, 20, 44), Color3.fromRGB(14, 14, 28), 135)

	-- Avatar + animated ring
	local avatarRing = newFrame(profCard, {
		BG = T.ACCENT,
		Size = UDim2.new(0, 66, 0, 66),
		Position = UDim2.new(0, 12, 0.5, -33),
		ZIndex = 13,
	})
	corner(avatarRing, 33)
	gradient(avatarRing, T.ACCENT, T.ACCENT2, 45)

	local avatar = Instance.new("ImageLabel", profCard)
	avatar.Size = UDim2.new(0, 60, 0, 60)
	avatar.Position = UDim2.new(0, 15, 0.5, -30)
	avatar.BackgroundColor3 = T.SURFACE2
	avatar.BorderSizePixel = 0
	avatar.ZIndex = 14
	avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..Player.UserId.."&width=150&height=150&format=png"
	corner(avatar, 30)

	-- Online status dot
	local onlineDot = newFrame(profCard, {
		BG = T.SUCCESS,
		Size = UDim2.new(0, 11, 0, 11),
		Position = UDim2.new(0, 57, 0.5, 18),
		ZIndex = 15,
	})
	corner(onlineDot, 6)
	stroke(onlineDot, T.BG, 2)

	-- Tên + handle
	newLabel(profCard, {
		Text = Player.DisplayName,
		Color = T.WHITE, Size = 15,
		Font = Enum.Font.GothamBold,
		Sz = UDim2.new(1, -100, 0, 22),
		Position = UDim2.new(0, 90, 0, 12), ZIndex = 14, Truncate = true,
	})
	newLabel(profCard, {
		Text = "@"..Player.Name,
		Color = T.TEXT3, Size = 10,
		Sz = UDim2.new(1, -100, 0, 16),
		Position = UDim2.new(0, 90, 0, 34), ZIndex = 14, Truncate = true,
	})

	-- Badge: ID + tuổi tài khoản
	local badgeRow = newFrame(profCard, {
		BG = Color3.fromRGB(0,0,0), BT = 1,
		Size = UDim2.new(1, -100, 0, 18),
		Position = UDim2.new(0, 90, 0, 52),
		ZIndex = 14,
	})
	local badgeList = Instance.new("UIListLayout", badgeRow)
	badgeList.FillDirection = Enum.FillDirection.Horizontal
	badgeList.Padding = UDim.new(0, 6)

	local function makeBadge(parent, text, bg, textCol, order)
		local b = newFrame(parent, {
			BG = bg, Size = UDim2.new(0, 10, 0, 16), ZIndex = 15,
		})
		b.AutomaticSize = Enum.AutomaticSize.X
		b.LayoutOrder = order
		corner(b, 5)
		local lbl = newLabel(b, {
			Text = text, Color = textCol, Size = 9,
			Font = Enum.Font.GothamBold,
			Sz = UDim2.new(0, 10, 1, 0), ZIndex = 16,
		})
		lbl.AutomaticSize = Enum.AutomaticSize.X
		local p = Instance.new("UIPadding", lbl)
		p.PaddingLeft = UDim.new(0, 5); p.PaddingRight = UDim.new(0, 5)
		return b
	end

	makeBadge(badgeRow, "ID: "..Player.UserId, T.SURFACE2, T.TEXT2, 1)
	makeBadge(badgeRow, "🕐 "..Player.AccountAge.." ngày", Color3.fromRGB(20,20,50), T.ACCENT, 2)
	pcall(function()
		if Player:GetRankInGroup(1) > 0 then
			makeBadge(badgeRow, "👑 Member", Color3.fromRGB(20,20,50), T.WARN, 4)
		end
	end)
	-- Verified badge nếu đây là account chính chủ
	makeBadge(badgeRow, "✓ Online", Color3.fromRGB(8,32,16), T.SUCCESS, 3)

	-- ════════════════════════════════════════
	-- [2] STATS GRID  (6 cells đẹp hơn)
	-- ════════════════════════════════════════
	local statsCard = makeCard(homePage, 128, 2)
	gradient(statsCard, Color3.fromRGB(16, 16, 32), Color3.fromRGB(12, 12, 22), 135)

	local statDefs = {
		{ icon = "❤",  label = "Health",  col = 0, row = 0, color = T.DANGER,  key = "hp"    },
		{ icon = "⚡",  label = "Speed",   col = 1, row = 0, color = T.ACCENT,  key = "speed" },
		{ icon = "🏃",  label = "Jump",    col = 0, row = 1, color = T.ACCENT2, key = "jump"  },
		{ icon = "📶",  label = "Ping",    col = 1, row = 1, color = T.SUCCESS, key = "ping"  },
		{ icon = "⏱",  label = "Session", col = 0, row = 2, color = T.WARN,    key = "sess"  },
		{ icon = "🏳",  label = "Team",    col = 1, row = 2, color = T.TEXT2,   key = "team"  },
	}
	local statValues = {}

	for _, sd in ipairs(statDefs) do
		local cell = newFrame(statsCard, {
			BG = T.SURFACE2,
			Size = UDim2.new(0, 126, 0, 36),
			Position = UDim2.new(0, 8 + sd.col * 136, 0, 8 + sd.row * 40),
			ZIndex = 13,
		})
		corner(cell, 9)
		stroke(cell, T.BORDER, 1)

		-- Left accent strip
		local strip = newFrame(cell, {
			BG = sd.color,
			Size = UDim2.new(0, 3, 1, -10),
			Position = UDim2.new(0, 0, 0, 5),
			ZIndex = 14,
		})
		corner(strip, 2)

		-- Icon
		newLabel(cell, {
			Text = sd.icon, Color = sd.color, Size = 13,
			Sz = UDim2.new(0, 22, 1, 0),
			Position = UDim2.new(0, 7, 0, 0),
			AlignX = Enum.TextXAlignment.Center, ZIndex = 14,
		})

		-- Label
		newLabel(cell, {
			Text = sd.label, Color = T.TEXT3, Size = 8,
			Font = Enum.Font.GothamBold,
			Sz = UDim2.new(1, -32, 0, 14),
			Position = UDim2.new(0, 28, 0, 4), ZIndex = 14,
		})

		-- Value
		local valL = newLabel(cell, {
			Text = "…", Color = T.TEXT, Size = 12,
			Font = Enum.Font.GothamBold,
			Sz = UDim2.new(1, -32, 0, 18),
			Position = UDim2.new(0, 28, 0, 16),
			ZIndex = 14, Truncate = true,
		})
		statValues[sd.key] = { label = valL, color = sd.color }
	end

	-- HP bar nhỏ dưới health cell
	local hpBarBg = newFrame(statsCard, {
		BG = T.SURFACE,
		Size = UDim2.new(0, 126, 0, 3),
		Position = UDim2.new(0, 8, 0, 44),
		ZIndex = 13,
	})
	corner(hpBarBg, 2)
	local hpBarFill = newFrame(hpBarBg, {
		BG = T.DANGER,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 14,
	})
	corner(hpBarFill, 2)

	-- ════════════════════════════════════════
	-- [3] POSITION TRACKER (XYZ realtime)
	-- ════════════════════════════════════════
	local posCard = makeCard(homePage, 58, 3)
	gradient(posCard, Color3.fromRGB(10, 22, 36), Color3.fromRGB(8, 14, 24), 135)
	stroke(posCard, T.ACCENT3, 1)

	newLabel(posCard, {
		Text = "📍 POSITION", Color = T.ACCENT3, Size = 8,
		Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0, 80, 0, 16),
		Position = UDim2.new(0, 12, 0, 6), ZIndex = 13,
	})

	-- Copy position button
	local copyPosBtn = Instance.new("TextButton", posCard)
	copyPosBtn.Size = UDim2.new(0, 52, 0, 18)
	copyPosBtn.Position = UDim2.new(1, -58, 0, 6)
	copyPosBtn.Text = "📋 copy"
	copyPosBtn.TextSize = 8
	copyPosBtn.Font = Enum.Font.GothamBold
	copyPosBtn.TextColor3 = T.ACCENT3
	copyPosBtn.BackgroundColor3 = Color3.fromRGB(12, 28, 48)
	copyPosBtn.BorderSizePixel = 0
	copyPosBtn.ZIndex = 14
	corner(copyPosBtn, 5)
	stroke(copyPosBtn, T.ACCENT3, 1)

	local xyzLabels = {}
	local AXIS_COLORS = {
		{ k = "X", col = T.DANGER  },
		{ k = "Y", col = T.SUCCESS },
		{ k = "Z", col = T.ACCENT3 },
	}
	for i, ax in ipairs(AXIS_COLORS) do
		local xCell = newFrame(posCard, {
			BG = T.SURFACE2,
			Size = UDim2.new(0, 84, 0, 26),
			Position = UDim2.new(0, 8 + (i-1)*92, 0, 26),
			ZIndex = 13,
		})
		corner(xCell, 7)
		stroke(xCell, ax.col, 1)
		newLabel(xCell, {
			Text = ax.k, Color = ax.col, Size = 10,
			Font = Enum.Font.GothamBold,
			Sz = UDim2.new(0, 20, 1, 0),
			Position = UDim2.new(0, 5, 0, 0),
			AlignX = Enum.TextXAlignment.Center, ZIndex = 14,
		})
		local vl = newLabel(xCell, {
			Text = "0.0", Color = T.TEXT, Size = 10,
			Font = Enum.Font.Code,
			Sz = UDim2.new(1, -22, 1, 0),
			Position = UDim2.new(0, 20, 0, 0),
			AlignX = Enum.TextXAlignment.Center, ZIndex = 14,
		})
		xyzLabels[ax.k] = vl
	end

	local lastPos = Vector3.zero
	copyPosBtn.MouseButton1Click:Connect(function()
		copyText(string.format("Vector3.new(%.2f, %.2f, %.2f)", lastPos.X, lastPos.Y, lastPos.Z))
		copyPosBtn.Text = "✓ ok"
		tween(copyPosBtn, { TextColor3 = T.SUCCESS, BackgroundColor3 = Color3.fromRGB(8, 28, 16) })
		task.delay(1.5, function()
			copyPosBtn.Text = "📋 copy"
			tween(copyPosBtn, { TextColor3 = T.ACCENT3, BackgroundColor3 = Color3.fromRGB(12, 28, 48) })
		end)
	end)

	-- ════════════════════════════════════════
	-- [4] QUICK ACTIONS (2×2 grid)
	-- ════════════════════════════════════════
	makeSectionLabel(homePage, "Quick Actions", 4)

	local qaCard = makeCard(homePage, 86, 5)
	gradient(qaCard, Color3.fromRGB(16, 16, 30), Color3.fromRGB(12, 12, 22), 135)

	local QA_DEFS = {
		{
			icon = "🚩", label = "Teleport\nSpawn", col = 0,
			color = T.ACCENT,
			action = function()
				local char = Player.Character
				if not char then return end
				local root = char:FindFirstChild("HumanoidRootPart")
				local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
				if root and spawn then
					root.CFrame = spawn.CFrame + Vector3.new(0,4,0)
					showToast("Teleport → Spawn ✓", "ok")
				else
					showToast("Không tìm thấy Spawn", "warn")
				end
			end,
		},
		{
			icon = "↩", label = "Reset\nCharacter", col = 1,
			color = T.WARN,
			action = function()
				local h = getHum()
				if h then h.Health = 0; showToast("Reset character…", "warn") end
			end,
		},
		{
			icon = "👻", label = "NoClip\nToggle", col = 2,
			color = T.ACCENT2,
			action = function()
				_G._HomeNoClipOn = not _G._HomeNoClipOn
				if _G._HomeNoClipOn then
					_G._HomeNoClipConn = RunService.Stepped:Connect(function()
						if Player.Character then
							for _, p in ipairs(Player.Character:GetDescendants()) do
								if p:IsA("BasePart") then p.CanCollide = false end
							end
						end
					end)
					showToast("NoClip ON 👻", "ok")
				else
					if _G._HomeNoClipConn then _G._HomeNoClipConn:Disconnect(); _G._HomeNoClipConn = nil end
					if Player.Character then
						for _, p in ipairs(Player.Character:GetDescendants()) do
							if p:IsA("BasePart") then p.CanCollide = true end
						end
					end
					showToast("NoClip OFF", "warn")
				end
			end,
		},
		{
			icon = "💎", label = "Copy\nPosition", col = 3,
			color = T.SUCCESS,
			action = function()
				local root = getRoot()
				if root then
					copyText(string.format("Vector3.new(%.2f, %.2f, %.2f)",
						root.Position.X, root.Position.Y, root.Position.Z))
					showToast("Đã copy Position ✓", "ok")
				end
			end,
		},
	}

	local qaToggles = {} -- để update UI khi toggle

	for _, qa in ipairs(QA_DEFS) do
		local btn = Instance.new("TextButton", qaCard)
		btn.Size = UDim2.new(0, 64, 0, 70)
		btn.Position = UDim2.new(0, 8 + qa.col * 70, 0, 8)
		btn.Text = ""
		btn.BackgroundColor3 = T.SURFACE2
		btn.BorderSizePixel = 0
		btn.ZIndex = 13
		corner(btn, 12)
		stroke(btn, T.BORDER, 1)

		local iconLbl = newLabel(btn, {
			Text = qa.icon, Size = 20,
			AlignX = Enum.TextXAlignment.Center,
			Sz = UDim2.new(1, 0, 0, 32),
			Position = UDim2.new(0, 0, 0, 8), ZIndex = 14,
		})
		newLabel(btn, {
			Text = qa.label, Color = T.TEXT2, Size = 8,
			Font = Enum.Font.GothamBold,
			AlignX = Enum.TextXAlignment.Center,
			Sz = UDim2.new(1, 0, 0, 24),
			Position = UDim2.new(0, 0, 0, 40),
			ZIndex = 14, Wrapped = true,
		})

		-- Bottom accent strip
		local strip = newFrame(btn, {
			BG = qa.color,
			Size = UDim2.new(1, -16, 0, 2),
			Position = UDim2.new(0, 8, 1, -6),
			ZIndex = 14,
		})
		corner(strip, 1)

		if qa.label:find("NoClip") then
			qaToggles["noclip"] = { btn = btn, strip = strip, color = qa.color }
		end

		btn.MouseEnter:Connect(function()
			tween(btn, { BackgroundColor3 = Color3.fromRGB(30, 30, 55) })
			tween(strip, { BackgroundColor3 = qa.color })
		end)
		btn.MouseLeave:Connect(function()
			local isOn = (qa.label:find("NoClip") and _G._HomeNoClipOn)
			tween(btn, { BackgroundColor3 = isOn and Color3.fromRGB(26, 18, 50) or T.SURFACE2 })
		end)
		btn.MouseButton1Click:Connect(function()
			tween(btn, { BackgroundColor3 = T.SURFACE })
			qa.action()
			-- Update NoClip visual state
			if qa.label:find("NoClip") then
				local on = _G._HomeNoClipOn
				tween(btn, { BackgroundColor3 = on and Color3.fromRGB(26, 18, 50) or T.SURFACE2 })
				stroke(btn, on and T.ACCENT2 or T.BORDER, on and 1.5 or 1)
			end
		end)
	end

	-- ════════════════════════════════════════
	-- [5] PLAYERS IN SERVER (mini list + count)
	-- ════════════════════════════════════════
	makeSectionLabel(homePage, "Players Online", 6)

	local playersInfoCard = makeCard(homePage, 10, 7)
	playersInfoCard.AutomaticSize = Enum.AutomaticSize.Y

	-- Count badge
	local playerCountBadge = newFrame(playersInfoCard, {
		BG = T.ACCENT,
		Size = UDim2.new(0, 0, 0, 20),
		Position = UDim2.new(1, -8, 0, 8),
		ZIndex = 13,
	})
	playerCountBadge.AutomaticSize = Enum.AutomaticSize.X
	playerCountBadge.AnchorPoint = Vector2.new(1, 0)
	corner(playerCountBadge, 6)
	gradient(playerCountBadge, T.ACCENT, T.ACCENT2, 90)
	local countBadgeLbl = newLabel(playerCountBadge, {
		Text = "0/0", Color = T.WHITE, Size = 10,
		Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0, 10, 1, 0), ZIndex = 14,
	})
	countBadgeLbl.AutomaticSize = Enum.AutomaticSize.X
	local cbPad = Instance.new("UIPadding", countBadgeLbl)
	cbPad.PaddingLeft = UDim.new(0, 8); cbPad.PaddingRight = UDim.new(0, 8)

	-- Mini player list
	local miniPlayerList = Instance.new("UIListLayout", playersInfoCard)
	miniPlayerList.SortOrder = Enum.SortOrder.LayoutOrder
	miniPlayerList.Padding = UDim.new(0, 2)
	local mlPad = Instance.new("UIPadding", playersInfoCard)
	mlPad.PaddingTop = UDim.new(0, 36); mlPad.PaddingBottom = UDim.new(0, 6)
	mlPad.PaddingLeft = UDim.new(0, 8); mlPad.PaddingRight = UDim.new(0, 8)

	local miniPlayerRows = {}

	local function rebuildMiniPlayers()
		for _, row in pairs(miniPlayerRows) do
			if row and row.Parent then row:Destroy() end
		end
		miniPlayerRows = {}

		local all = Players:GetPlayers()
		local maxGame = Players.MaxPlayers
		countBadgeLbl.Text = #all.."/"..maxGame

		for i, p in ipairs(all) do
			local row = Instance.new("TextButton", playersInfoCard)
			row.Size = UDim2.new(1, 0, 0, 28)
			row.BackgroundColor3 = p == Player and Color3.fromRGB(16, 20, 48) or T.SURFACE2
			row.BackgroundTransparency = 0.4
			row.Text = ""
			row.BorderSizePixel = 0
			row.ZIndex = 13
			row.LayoutOrder = i
			corner(row, 7)
			if p == Player then stroke(row, T.ACCENT, 1) end

			-- Mini avatar
			local av = Instance.new("ImageLabel", row)
			av.Size = UDim2.new(0, 20, 0, 20)
			av.Position = UDim2.new(0, 4, 0.5, -10)
			av.BackgroundColor3 = T.SURFACE
			av.BorderSizePixel = 0
			av.ZIndex = 14
			av.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..p.UserId.."&width=48&height=48&format=png"
			corner(av, 10)

			-- You badge
			if p == Player then
				newLabel(row, {
					Text = "● YOU", Color = T.ACCENT, Size = 8,
					Font = Enum.Font.GothamBold,
					Sz = UDim2.new(0, 36, 1, 0),
					Position = UDim2.new(0, 28, 0, 0), ZIndex = 14,
				})
			else
				newLabel(row, {
					Text = p.DisplayName, Color = T.TEXT, Size = 10,
					Font = Enum.Font.GothamBold,
					Sz = UDim2.new(1, -120, 1, 0),
					Position = UDim2.new(0, 28, 0, 0), ZIndex = 14, Truncate = true,
				})
			end

			-- Team badge
			if p.Team then
				local teamBadge = newFrame(row, {
					BG = p.Team.TeamColor and Color3.fromRGB(
						p.Team.TeamColor.R * 255,
						p.Team.TeamColor.G * 255,
						p.Team.TeamColor.B * 255
					) or T.BORDER,
					Size = UDim2.new(0, 6, 0, 20),
					Position = UDim2.new(1, -10, 0.5, -10),
					ZIndex = 14,
				})
				corner(teamBadge, 3)
			end

			-- Ping dot (màu dựa vào ping)
			local pingDot = newFrame(row, {
				BG = T.TEXT3,
				Size = UDim2.new(0, 6, 0, 6),
				Position = UDim2.new(1, -22, 0.5, -3),
				ZIndex = 14,
			})
			corner(pingDot, 3)

			row.MouseEnter:Connect(function() tween(row, {BackgroundTransparency = 0.1}) end)
			row.MouseLeave:Connect(function() tween(row, {BackgroundTransparency = 0.4}) end)

			table.insert(miniPlayerRows, row)
		end
	end
	rebuildMiniPlayers()
	Players.PlayerAdded:Connect(function() task.wait(0.5); rebuildMiniPlayers() end)
	Players.PlayerRemoving:Connect(function() task.wait(0.1); rebuildMiniPlayers() end)

	-- ════════════════════════════════════════
	-- [6] ABOUT NOVA CARD
	-- ════════════════════════════════════════
	makeSectionLabel(homePage, "About", 8)

	local aboutCard = makeCard(homePage, 64, 9)
	gradient(aboutCard, Color3.fromRGB(14, 14, 30), Color3.fromRGB(10, 10, 20), 135)

	-- Logo mini
	local logoGlow = newFrame(aboutCard, {
		BG = T.ACCENT, BT = 0.85,
		Size = UDim2.new(0, 44, 0, 44),
		Position = UDim2.new(0, 10, 0.5, -22),
		ZIndex = 13,
	})
	corner(logoGlow, 12)
	gradient(logoGlow, T.ACCENT, T.ACCENT2, 135)

	newLabel(logoGlow, {
		Text = "N", Color = T.WHITE, Size = 20,
		Font = Enum.Font.GothamBold,
		AlignX = Enum.TextXAlignment.Center,
		Sz = UDim2.new(1, 0, 1, 0), ZIndex = 14,
	})

	newLabel(aboutCard, {
		Text = "NOVA UI  v2.1",
		Color = T.WHITE, Size = 13, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(1, -70, 0, 20),
		Position = UDim2.new(0, 62, 0, 10), ZIndex = 13,
	})
	newLabel(aboutCard, {
		Text = "Glassmorphism executor interface",
		Color = T.TEXT3, Size = 9,
		Sz = UDim2.new(1, -70, 0, 16),
		Position = UDim2.new(0, 62, 0, 28), ZIndex = 13,
	})

	-- Version tags
	local tagRow = newFrame(aboutCard, {
		BG = Color3.fromRGB(0,0,0), BT = 1,
		Size = UDim2.new(1, -70, 0, 16),
		Position = UDim2.new(0, 62, 0, 44),
		ZIndex = 13,
	})
	local tagRowLayout = Instance.new("UIListLayout", tagRow)
	tagRowLayout.FillDirection = Enum.FillDirection.Horizontal
	tagRowLayout.Padding = UDim.new(0, 5)

	for _, tag in ipairs({"Spy", "Explorer", "Console", "Perf"}) do
		local tb = newFrame(tagRow, {
			BG = Color3.fromRGB(20, 20, 48),
			Size = UDim2.new(0, 10, 0, 14), ZIndex = 14,
		})
		tb.AutomaticSize = Enum.AutomaticSize.X
		corner(tb, 4)
		stroke(tb, T.BORDER, 1)
		local tl = newLabel(tb, {
			Text = tag, Color = T.ACCENT, Size = 8,
			Font = Enum.Font.GothamBold,
			Sz = UDim2.new(0, 10, 1, 0), ZIndex = 15,
		})
		tl.AutomaticSize = Enum.AutomaticSize.X
		local tp2 = Instance.new("UIPadding", tl)
		tp2.PaddingLeft = UDim.new(0, 5); tp2.PaddingRight = UDim.new(0, 5)
	end

	-- ════════════════════════════════════════
	-- LIVE UPDATE LOOP
	-- ════════════════════════════════════════
	task.spawn(function()
		while true do
			task.wait(0.5)

			-- Stats
			local hum = getHum()
			local root = getRoot()

			if hum then
				local hp    = math.floor(hum.Health)
				local maxHp = math.floor(hum.MaxHealth)
				local hpRatio = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)

				statValues["hp"].label.Text = hp.."/"..maxHp
				local hpCol = hpRatio > 0.6 and T.SUCCESS or hpRatio > 0.3 and T.WARN or T.DANGER
				tween(statValues["hp"].label, { TextColor3 = hpCol })
				tween(hpBarFill, { Size = UDim2.new(hpRatio, 0, 1, 0), BackgroundColor3 = hpCol })

				statValues["speed"].label.Text = math.floor(hum.WalkSpeed).." st/s"
				statValues["jump"].label.Text  = math.floor(hum.JumpPower or hum.JumpHeight or 50)
			end

			-- Position
			if root then
				local pos = root.Position
				lastPos = pos
				xyzLabels["X"].Text = string.format("%.1f", pos.X)
				xyzLabels["Y"].Text = string.format("%.1f", pos.Y)
				xyzLabels["Z"].Text = string.format("%.1f", pos.Z)
			end

			-- Session timer
			local elapsed = tick() - sessionStart
			local m = math.floor(elapsed / 60)
			local s = math.floor(elapsed % 60)
			statValues["sess"].label.Text = string.format("%02d:%02d", m, s)

			-- Team
			if Player.Team then
				statValues["team"].label.Text = Player.Team.Name
				local tc = Player.Team.TeamColor
				if tc then
					tween(statValues["team"].label, {
						TextColor3 = Color3.fromRGB(tc.R*255, tc.G*255, tc.B*255)
					})
				end
			else
				statValues["team"].label.Text = "None"
			end

			task.wait(1.5)

			-- Ping (ít tốn hơn nếu update chậm)
			local ok, p = pcall(function() return math.floor(Player:GetNetworkPing()*1000) end)
			if ok then
				statValues["ping"].label.Text = p.." ms"
				local pingCol = p < 80 and T.SUCCESS or p < 200 and T.WARN or T.DANGER
				tween(statValues["ping"].label, { TextColor3 = pingCol })
			end

			-- NoClip visual state sync
			if qaToggles["noclip"] then
				local on = _G._HomeNoClipOn
				tween(qaToggles["noclip"].btn, {
					BackgroundColor3 = on and Color3.fromRGB(26, 18, 50) or T.SURFACE2
				})
			end
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

	-- ══════════════════════════════════════════
	-- ★ PAGE: SETTINGS  —  MAP CONTROLLER (Mới)
	-- ══════════════════════════════════════════
	-- Chèn vào cuối phần Settings Page (trước phần About & Reset)

	-- ══════════════════════════════════════════
	-- SECTION: MAP CONTROLLER
	-- ══════════════════════════════════════════
	makeSectionLabel(settingsPage, "🗺️ Map Controller", 30)

	local mapCard = makeCard(settingsPage, 180, 31)
	gradient(mapCard, Color3.fromRGB(18, 22, 40), Color3.fromRGB(12, 16, 28), 135)
	stroke(mapCard, T.ACCENT3, 1)

	-- Header
	newLabel(mapCard, {
		Text = "🗺️  Thay Đổi & Phá Hủy Map",
		Color = T.WHITE, Size = 13, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 12, 0, 6), ZIndex = 13,
	})
	newLabel(mapCard, {
		Text = "Load map mới từ Asset ID hoặc xóa toàn bộ workspace",
		Color = T.TEXT3, Size = 9,
		Sz = UDim2.new(1, -20, 0, 16),
		Position = UDim2.new(0, 12, 0, 24), ZIndex = 13,
	})

	-- ── Row 1: Load map bằng ID ──
	local loadRow = newFrame(mapCard, {
		BG = T.SURFACE2,
		Size = UDim2.new(1, -24, 0, 34),
		Position = UDim2.new(0, 12, 0, 44),
		ZIndex = 13,
	})
	corner(loadRow, 8)
	stroke(loadRow, T.BORDER, 1)

	newLabel(loadRow, {
		Text = "📦 Map ID",
		Color = T.TEXT2, Size = 9, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0, 55, 1, 0),
		Position = UDim2.new(0, 8, 0, 0), ZIndex = 14,
	})

	local mapIdBox = Instance.new("TextBox", loadRow)
	mapIdBox.Size = UDim2.new(1, -170, 0, 24)
	mapIdBox.Position = UDim2.new(0, 62, 0.5, -12)
	mapIdBox.BackgroundColor3 = T.SURFACE
	mapIdBox.BorderSizePixel = 0
	mapIdBox.TextColor3 = T.TEXT
	mapIdBox.PlaceholderText = "Nhập Asset ID (vd: 159454296)"
	mapIdBox.PlaceholderColor3 = T.TEXT3
	mapIdBox.Text = ""
	mapIdBox.TextSize = 10
	mapIdBox.Font = Enum.Font.Gotham
	mapIdBox.ClearTextOnFocus = false
	mapIdBox.ZIndex = 14
	corner(mapIdBox, 6)
	stroke(mapIdBox, T.BORDER, 1)
	local mPad = Instance.new("UIPadding", mapIdBox)
	mPad.PaddingLeft = UDim.new(0, 6)

	local loadMapBtn = Instance.new("TextButton", loadRow)
	loadMapBtn.Size = UDim2.new(0, 56, 0, 24)
	loadMapBtn.Position = UDim2.new(1, -62, 0.5, -12)
	loadMapBtn.Text = "⬇ Load"
	loadMapBtn.TextSize = 9
	loadMapBtn.Font = Enum.Font.GothamBold
	loadMapBtn.TextColor3 = T.WHITE
	loadMapBtn.BackgroundColor3 = T.ACCENT
	loadMapBtn.BorderSizePixel = 0
	loadMapBtn.ZIndex = 14
	corner(loadMapBtn, 6)

	loadMapBtn.MouseEnter:Connect(function() tween(loadMapBtn,{BackgroundColor3=T.ACCENT2}) end)
	loadMapBtn.MouseLeave:Connect(function() tween(loadMapBtn,{BackgroundColor3=T.ACCENT}) end)

	-- ── Row 2: Clear Map / Reset ──
	local actionRow = newFrame(mapCard, {
		BG = Color3.fromRGB(0,0,0), BT = 1,
		Size = UDim2.new(1, -24, 0, 34),
		Position = UDim2.new(0, 12, 0, 82),
		ZIndex = 13,
	})

	local clearMapBtn = Instance.new("TextButton", actionRow)
	clearMapBtn.Size = UDim2.new(0, 100, 0, 28)
	clearMapBtn.Position = UDim2.new(0, 0, 0.5, -14)
	clearMapBtn.Text = "💥 Clear Map"
	clearMapBtn.TextSize = 10
	clearMapBtn.Font = Enum.Font.GothamBold
	clearMapBtn.TextColor3 = T.WHITE
	clearMapBtn.BackgroundColor3 = T.DANGER
	clearMapBtn.BorderSizePixel = 0
	clearMapBtn.ZIndex = 14
	corner(clearMapBtn, 8)

	local resetMapBtn = Instance.new("TextButton", actionRow)
	resetMapBtn.Size = UDim2.new(0, 100, 0, 28)
	resetMapBtn.Position = UDim2.new(0, 108, 0.5, -14)
	resetMapBtn.Text = "↺ Reset Map"
	resetMapBtn.TextSize = 10
	resetMapBtn.Font = Enum.Font.GothamBold
	resetMapBtn.TextColor3 = T.WHITE
	resetMapBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 40)
	resetMapBtn.BorderSizePixel = 0
	resetMapBtn.ZIndex = 14
	corner(resetMapBtn, 8)

	-- ── Row 3: Thông tin map hiện tại ──
	local infoRow2 = newFrame(mapCard, {
		BG = Color3.fromRGB(0,0,0), BT = 1,
		Size = UDim2.new(1, -24, 0, 28),
		Position = UDim2.new(0, 12, 0, 120),
		ZIndex = 13,
	})

	local mapStatusLbl = newLabel(infoRow2, {
		Text = "📍 Map hiện tại: " .. workspace.Name .. " | " .. #workspace:GetChildren() .. " objects",
		Color = T.TEXT2, Size = 9,
		Sz = UDim2.new(1, -12, 1, 0),
		Position = UDim2.new(0, 8, 0, 0), ZIndex = 14,
	})

	-- ── PROGRESS BAR khi load map ──
	local loadProgress = newFrame(mapCard, {
		BG = T.SURFACE2,
		Size = UDim2.new(1, -24, 0, 4),
		Position = UDim2.new(0, 12, 0, 153),
		ZIndex = 13,
	})
	corner(loadProgress, 2)
	local loadProgressFill = newFrame(loadProgress, {
		BG = T.ACCENT,
		Size = UDim2.new(0, 0, 1, 0),
		ZIndex = 14,
	})
	corner(loadProgressFill, 2)
	gradient(loadProgressFill, T.ACCENT, T.ACCENT2, 90)

	-- ── STATUS TEXT ──
	local loadStatusLbl = newLabel(mapCard, {
		Text = "Sẵn sàng",
		Color = T.TEXT3, Size = 8,
		Sz = UDim2.new(1, -24, 0, 14),
		Position = UDim2.new(0, 12, 0, 161),
		ZIndex = 13,
	})

	-- ══════════════════════════════════════════
	-- MAP CONTROLLER LOGIC
	-- ══════════════════════════════════════════

	-- Lưu backup map gốc khi khởi động
	local originalMapBackup = nil
	local mapLoaded = false

	-- Hàm lấy tất cả instance trong workspace (trừ Player character)
	local function getWorkspaceObjects()
		local objects = {}
		for _, child in ipairs(workspace:GetChildren()) do
			if child ~= Player.Character then
				table.insert(objects, child)
			end
		end
		return objects
	end

	-- Hàm xóa map (giữ lại Player character)
	local function clearMap()
		local count = 0
		for _, obj in ipairs(workspace:GetChildren()) do
			if obj ~= Player.Character then
				pcall(function() obj:Destroy() end)
				count += 1
			end
		end
		return count
	end

	-- Hàm load map từ Asset ID
	local function loadMapFromId(assetId)
		-- Validate asset id
		local id = tonumber(assetId)
		if not id then
			showToast("⚠️ Asset ID không hợp lệ!", "err")
			return false
		end

		loadStatusLbl.Text = "🔄 Đang tải map ID: " .. id .. " ..."
		loadStatusLbl.TextColor3 = T.WARN

		-- Animation progress
		tween(loadProgressFill, { Size = UDim2.new(0.3, 0, 1, 0) }, TweenInfo.new(0.3))

		task.wait(0.2)

		-- Xóa map hiện tại (giữ character)
		local removed = clearMap()
		showToast("🗑️ Đã xóa " .. removed .. " objects", "warn")

		tween(loadProgressFill, { Size = UDim2.new(0.6, 0, 1, 0) }, TweenInfo.new(0.3))
		task.wait(0.2)

		-- Load map mới
		local success, result = pcall(function()
			local mapModel = game:GetService("ReplicatedStorage"):FindFirstChild("MapBackup")
			if mapModel then
				-- Nếu đã có backup trong ReplicatedStorage
				local newMap = mapModel:Clone()
				newMap.Parent = workspace
				return newMap
			else
				-- Load từ asset
				local asset = game:GetObjects("rbxassetid://" .. id)
				if #asset > 0 then
					local container = Instance.new("Model")
					container.Name = "LoadedMap_" .. id
					container.Parent = workspace
					for _, obj in ipairs(asset) do
						obj.Parent = container
					end
					return container
				else
					return nil, "Không tìm thấy asset"
				end
			end
		end)

		tween(loadProgressFill, { Size = UDim2.new(0.9, 0, 1, 0) }, TweenInfo.new(0.3))
		task.wait(0.2)

		if success and result then
			tween(loadProgressFill, { Size = UDim2.new(1, 0, 1, 0) }, TweenInfo.new(0.3))
			loadStatusLbl.Text = "✅ Đã load map: " .. result.Name
			loadStatusLbl.TextColor3 = T.SUCCESS
			mapLoaded = true

			-- Cập nhật status
			mapStatusLbl.Text = "📍 Map: " .. result.Name .. " | " .. #workspace:GetChildren() .. " objects"

			showToast("✅ Map loaded: " .. result.Name, "ok")
			return true
		else
			loadProgressFill.Size = UDim2.new(0, 0, 1, 0)
			loadStatusLbl.Text = "❌ Lỗi: " .. tostring(result)
			loadStatusLbl.TextColor3 = T.DANGER
			showToast("❌ Load map thất bại!", "err")
			return false
		end
	end

	-- Hàm reset map về gốc (reload workspace)
	local function resetMap()
		loadStatusLbl.Text = "🔄 Đang reset map..."
		loadStatusLbl.TextColor3 = T.WARN
		tween(loadProgressFill, { Size = UDim2.new(0.5, 0, 1, 0) }, TweenInfo.new(0.4))
		task.wait(0.3)

		-- Xóa map hiện tại (giữ character)
		clearMap()

		tween(loadProgressFill, { Size = UDim2.new(0.8, 0, 1, 0) }, TweenInfo.new(0.3))
		task.wait(0.2)

		-- Load lại map từ Workspace gốc (nếu có backup)
		local success, result = pcall(function()
			-- Tìm map trong ReplicatedStorage (backup từ lúc bắt đầu)
			local backup = game:GetService("ReplicatedStorage"):FindFirstChild("OriginalMapBackup")
			if backup then
				local newMap = backup:Clone()
				newMap.Parent = workspace
				return newMap
			else
				-- Fallback: tạo một map trống với một BasePlate
				local plate = Instance.new("Part")
				plate.Name = "BasePlate"
				plate.Size = Vector3.new(100, 2, 100)
				plate.Position = Vector3.new(0, -1, 0)
				plate.Anchored = true
				plate.BrickColor = BrickColor.new("Medium stone grey")
				plate.Parent = workspace

				local spawn = Instance.new("SpawnLocation")
				spawn.Name = "SpawnLocation"
				spawn.Size = Vector3.new(8, 2, 8)
				spawn.Position = Vector3.new(0, 2, 0)
				spawn.Parent = workspace

				return plate
			end
		end)

		tween(loadProgressFill, { Size = UDim2.new(1, 0, 1, 0) }, TweenInfo.new(0.3))
		task.wait(0.2)

		if success then
			loadStatusLbl.Text = "✅ Đã reset map về gốc"
			loadStatusLbl.TextColor3 = T.SUCCESS
			mapStatusLbl.Text = "📍 Map: " .. workspace.Name .. " | " .. #workspace:GetChildren() .. " objects"
			showToast("↺ Đã reset map về gốc", "ok")
		else
			loadStatusLbl.Text = "❌ Reset thất bại"
			loadStatusLbl.TextColor3 = T.DANGER
			showToast("❌ Reset map thất bại!", "err")
		end
	end

	-- ══════════════════════════════════════════
	-- BACKUP MAP GỐC KHI KHỞI ĐỘNG
	-- ══════════════════════════════════════════
	task.spawn(function()
		task.wait(2)
		-- Backup workspace vào ReplicatedStorage
		local backupContainer = Instance.new("Model")
		backupContainer.Name = "OriginalMapBackup"
		backupContainer.Parent = game:GetService("ReplicatedStorage")

		for _, obj in ipairs(workspace:GetChildren()) do
			if obj ~= Player.Character then
				pcall(function()
					local clone = obj:Clone()
					clone.Parent = backupContainer
				end)
			end
		end

		mapStatusLbl.Text = "📍 Map: " .. workspace.Name .. " | " .. #workspace:GetChildren() .. " objects"
	end)

	-- ══════════════════════════════════════════
	-- BUTTON EVENTS
	-- ══════════════════════════════════════════

	-- Load Map
	loadMapBtn.MouseButton1Click:Connect(function()
		local id = mapIdBox.Text:match("%d+")
		if not id then
			showToast("⚠️ Vui lòng nhập Asset ID hợp lệ!", "warn")
			return
		end
		loadMapFromId(id)
	end)

	-- Clear Map
	clearMapBtn.MouseButton1Click:Connect(function()
		if #workspace:GetChildren() <= 1 then
			showToast("⚠️ Map đã trống!", "warn")
			return
		end
		local count = clearMap()
		showToast("💥 Đã xóa " .. count .. " objects khỏi map!", "warn")
		mapStatusLbl.Text = "📍 Map trống | 0 objects"
		loadStatusLbl.Text = "💥 Map đã bị xóa"
		loadStatusLbl.TextColor3 = T.DANGER
	end)

	-- Reset Map
	resetMapBtn.MouseButton1Click:Connect(function()
		resetMap()
	end)

	-- Enter key để load map
	mapIdBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			local id = mapIdBox.Text:match("%d+")
			if id then loadMapFromId(id) end
		end
	end)

	-- ══════════════════════════════════════════
	-- TOOLTIP THÔNG BÁO
	-- ══════════════════════════════════════════
	local tooltipRow = newFrame(mapCard, {
		BG = Color3.fromRGB(16, 16, 36),
		Size = UDim2.new(1, -24, 0, 20),
		Position = UDim2.new(0, 12, 0, 180),
		ZIndex = 13,
	})
	corner(tooltipRow, 6)
	stroke(tooltipRow, T.ACCENT3, 1)

	newLabel(tooltipRow, {
		Text = "💡 Mẹo: Map ID là số trong URL của model trên Roblox. Load map có thể mất vài giây.",
		Color = T.TEXT3, Size = 8,
		Sz = UDim2.new(1, -12, 1, 0),
		Position = UDim2.new(0, 8, 0, 0),
		ZIndex = 14,
	})

	-- Update lại Layout Order cho các section còn lại
	-- (Các section sau cần tăng order lên 32, 33...)
	-- Lưu ý: Phần "About & Reset" đang ở order 30, cần đẩy lên 32

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
			-- Reset transparencyssssss
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
-- ★ PAGE: ANTI-CHEAT BYPASS  [NOVA v3]
-- Nâng cấp toàn diện bởi Nova Dev — July 2025
-- ══════════════════════════════════════════
local antiCheatPage, _ = makePage("AntiCheat")

do
	-- ════════════════════════════════════════
	-- SECTION 1: CÁC NÚT MẶC ĐỊNH (Nâng cấp v3)
	-- ════════════════════════════════════════
	makeSectionLabel(antiCheatPage, "Bypass Mặc Định", 1)

	-- ── Anti-Speed Check (v3: fake velocity + smooth lerp report + jitter) ──
	makeToggle(antiCheatPage, "Anti Speed Check 🏃", false, function(on)
		_G._NovaAntiSpeed = on
		if on then
			-- Tạo connection chính
			_G._NovaAntiSpeedConn = RunService.Heartbeat:Connect(function()
				local char = Player.Character
				if not char then return end
				local hum  = char:FindFirstChildOfClass("Humanoid")
				local root = char:FindFirstChild("HumanoidRootPart")
				if not (hum and root) then return end

				if hum.WalkSpeed > 16 then
					pcall(function()
						-- Lưu speed thật vào attribute để debug
						hum:SetAttribute("_NovaRealSpeed", hum.WalkSpeed)

						-- Giả lập velocity hợp lệ (16 stud/s) với micro-jitter
						local vel = root.AssemblyLinearVelocity
						local dir = vel.Unit
						if vel.Magnitude > 0 then
							local fakeSpeed = math.min(vel.Magnitude, 16)
							local jitter = Vector3.new(
								math.random(-3, 3) * 0.01,
								math.random(-1, 1) * 0.005,
								math.random(-3, 3) * 0.01
							)
							local fakeVel = dir * fakeSpeed + jitter
							root.AssemblyLinearVelocity = fakeVel
						end

						-- Giả lập animation speed tương ứng
						local animator = char:FindFirstChildOfClass("Animator")
						if animator then
							for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
								local speed = math.clamp(16 / hum.WalkSpeed, 0.3, 1.5)
								track:AdjustSpeed(speed)
							end
						end
					end)
				end
			end)

			-- Connection phụ: giả lập humanoid state
			_G._NovaAntiSpeedStateConn = RunService.Stepped:Connect(function()
				local char = Player.Character
				if not char then return end
				local hum = char:FindFirstChildOfClass("Humanoid")
				if not hum then return end

				if hum.WalkSpeed > 16 and hum:GetState() ~= Enum.HumanoidStateType.Running then
					pcall(function()
						hum:ChangeState(Enum.HumanoidStateType.Running)
					end)
				end
			end)

			showToast("Anti Speed Check ON 🛡", "ok")
		else
			-- Cleanup
			for _, k in ipairs({"_NovaAntiSpeedConn", "_NovaAntiSpeedStateConn"}) do
				if _G[k] then 
					pcall(function() _G[k]:Disconnect() end)
					_G[k] = nil 
				end
			end
			-- Restore animation speeds
			local char = Player.Character
			if char then
				local animator = char:FindFirstChildOfClass("Animator")
				if animator then
					for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
						track:AdjustSpeed(1)
					end
				end
			end
			showToast("Anti Speed Check OFF", "warn")
		end
	end, 2)

	-- ── Anti-Fly Detection (v3: state spoofing + gravity override + position fake) ──
	makeToggle(antiCheatPage, "Anti Fly Detection ✈", false, function(on)
		_G._NovaAntiFly = on
		if on then
			-- Connection chính
			_G._NovaAntiFlyConn = RunService.Heartbeat:Connect(function()
				local char = Player.Character
				if not char then return end
				local root = char:FindFirstChild("HumanoidRootPart")
				local hum  = char:FindFirstChildOfClass("Humanoid")
				if not (root and hum) then return end

				if _G._NovaFlying then
					pcall(function()
						-- Tắt các state bị phát hiện
						local disabledStates = {
							Enum.HumanoidStateType.FallingDown,
							Enum.HumanoidStateType.Flying,
							Enum.HumanoidStateType.Jumping,
							Enum.HumanoidStateType.Freefall,
						}
						for _, state in ipairs(disabledStates) do
							hum:SetStateEnabled(state, false)
						end

						-- Ép vào Running state
						hum:ChangeState(Enum.HumanoidStateType.Running)

						-- Giả lập gravity bằng cách fake vị trí Y
						if root.AssemblyLinearVelocity.Y > 2 then
							root.AssemblyLinearVelocity = Vector3.new(
								root.AssemblyLinearVelocity.X,
								0,
								root.AssemblyLinearVelocity.Z
							)
						end

						-- Fake position trên server (attribute)
						root:SetAttribute("_NovaFakeY", root.Position.Y)
					end)
				end
			end)

			-- Connection phụ: fake humanoid state cho các AC check state
			_G._NovaAntiFlyStateConn = RunService.Stepped:Connect(function()
				if not _G._NovaAntiFly then return end
				local char = Player.Character
				if not char then return end
				local hum = char:FindFirstChildOfClass("Humanoid")
				if not hum then return end

				if _G._NovaFlying then
					pcall(function()
						-- Đảm bảo luôn ở state Running
						local currentState = hum:GetState()
						if currentState ~= Enum.HumanoidStateType.Running and 
							currentState ~= Enum.HumanoidStateType.Landed then
							hum:ChangeState(Enum.HumanoidStateType.Running)
						end

						-- Giả lập FloorMaterial để AC không detect đang bay
						hum:SetAttribute("_NovaFloorMat", "Plastic")
					end)
				end
			end)

			showToast("Anti Fly Detection ON 🛡", "ok")
		else
			-- Cleanup
			for _, k in ipairs({"_NovaAntiFlyConn", "_NovaAntiFlyStateConn"}) do
				if _G[k] then 
					pcall(function() _G[k]:Disconnect() end)
					_G[k] = nil 
				end
			end

			-- Restore states
			local char = Player.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then
					pcall(function()
						local states = {
							Enum.HumanoidStateType.FallingDown,
							Enum.HumanoidStateType.Flying,
							Enum.HumanoidStateType.Jumping,
							Enum.HumanoidStateType.Freefall,
						}
						for _, state in ipairs(states) do
							hum:SetStateEnabled(state, true)
						end
					end)
				end
			end
			showToast("Anti Fly Detection OFF", "warn")
		end
	end, 3)

	-- ── Anti-Teleport Detection (v3: smooth step + ease-in-out + random jitter) ──
	makeToggle(antiCheatPage, "Anti Teleport Detection 📍", false, function(on)
		_G._NovaAntiTP = on
		if on then
			-- Hàm teleport an toàn với nhiều chế độ
			_G._NovaTeleportSafe = function(targetCFrame, customSteps, mode)
				local char = Player.Character
				if not char then return end
				local root = char:FindFirstChild("HumanoidRootPart")
				if not root then return end

				local startPos = root.Position
				local endPos   = targetCFrame.Position
				local dist     = (endPos - startPos).Magnitude

				-- Auto detect steps dựa trên khoảng cách
				local steps = customSteps or math.max(math.floor(dist / 10), 8)
				steps = math.min(steps, 50) -- Giới hạn tối đa

				-- Mode: "smooth" (default), "instant" (vẫn có jitter), "random_delay"
				mode = mode or "smooth"

				task.spawn(function()
					if mode == "instant" then
						-- Instant với jitter nhỏ
						local jitter = Vector3.new(
							math.random(-5, 5) * 0.01,
							math.random(-2, 2) * 0.005,
							math.random(-5, 5) * 0.01
						)
						root.CFrame = CFrame.new(endPos + jitter) * (targetCFrame - targetCFrame.Position)
						return
					end

					if mode == "random_delay" then
						-- Teleport với delay ngẫu nhiên để bypass detection
						local delays = {0.02, 0.03, 0.04, 0.05, 0.06}
						for i = 1, steps do
							if not _G._NovaAntiTP then break end
							local alpha = i / steps
							local jitter = Vector3.new(
								math.random(-3, 3) * 0.02,
								math.random(-1, 1) * 0.01,
								math.random(-3, 3) * 0.02
							)
							local pos = startPos:Lerp(endPos, alpha) + jitter
							root.CFrame = CFrame.new(pos)
							task.wait(delays[math.random(#delays)])
						end
						root.CFrame = targetCFrame
						return
					end

					-- "smooth" mode (default) - ease-in-out + jitter
					for i = 1, steps do
						if not _G._NovaAntiTP then break end
						local alpha = i / steps
						-- Ease-in-out cubic
						local ease = alpha < 0.5 
							and (4 * alpha * alpha * alpha)
							or  (1 - (-2 * alpha + 2)^3 / 2)

						-- Micro-jitter với amplitude giảm dần
						local jitterAmp = (1 - ease) * 0.1 + 0.02
						local jitter = Vector3.new(
							math.random(-10, 10) * jitterAmp * 0.01,
							math.random(-3, 3) * jitterAmp * 0.005,
							math.random(-10, 10) * jitterAmp * 0.01
						)
						root.CFrame = CFrame.new(startPos:Lerp(endPos, ease) + jitter)
						task.wait(0.05)
					end
					root.CFrame = targetCFrame
				end)
			end

			-- Hook teleport functions thông thường
			_G._NovaTeleportHook = function(instance, method, ...)
				if not _G._NovaAntiTP then return end
				if instance:IsA("BasePart") and method == "CFrame" then
					local newCFrame = select(1, ...)
					if newCFrame and typeof(newCFrame) == "CFrame" then
						_G._NovaTeleportSafe(newCFrame)
						return true
					end
				end
				return false
			end

			showToast("Anti TP ON — dùng _G._NovaTeleportSafe(CFrame [, steps, mode])", "ok")
		else
			_G._NovaTeleportSafe = nil
			_G._NovaTeleportHook = nil
			showToast("Anti TP Detection OFF", "warn")
		end
	end, 4)

	-- ── Anti-Noclip Detection (v3: chỉ tắt collision khi cần + auto restore + fake collide) ──
	makeToggle(antiCheatPage, "Anti NoClip Detection 👻", false, function(on)
		_G._NovaAntiNCDetect = on
		if on then
			-- Lưu trạng thái collide gốc
			_G._NovaOriginalCollide = {}

			_G._NovaAntiNCConn = RunService.Stepped:Connect(function()
				if not _G._NovaAntiNCDetect then return end
				local char = Player.Character
				if not char then return end

				-- Kiểm tra xem có đang trong NoClip không
				local isNoclipping = false
				for _, p in ipairs(char:GetDescendants()) do
					if p:IsA("BasePart") and not p.CanCollide then
						isNoclipping = true
						break
					end
				end

				if isNoclipping then
					-- Đang NoClip: fake collide cho các phần quan trọng
					for _, p in ipairs(char:GetDescendants()) do
						if p:IsA("BasePart") then
							local isHRP = p.Name == "HumanoidRootPart"
							local isLimb = p.Name:match("Foot") or p.Name:match("Leg") or p.Name:match("Arm") or p.Name:match("Hand")
							local isTorso = p.Name:match("Torso")

							-- Giữ collide cho HRP, limbs, torso để trông bình thường
							if isHRP or isLimb or isTorso then
								p.CanCollide = true
							else
								-- Các phần khác có thể không collide nhưng AC ít check
								p.CanCollide = false
							end

							-- Fake overlap với ground để AC nghĩ đang đứng
							if isHRP then
								local groundCheck = Ray.new(p.Position + Vector3.new(0, -0.5, 0), Vector3.new(0, -1, 0))
								local hit = workspace:FindPartOnRay(groundCheck, char)
								if hit then
									p:SetAttribute("_NovaGrounded", true)
								end
							end
						end
					end
				else
					-- Không NoClip: restore all collide
					for _, p in ipairs(char:GetDescendants()) do
						if p:IsA("BasePart") then
							p.CanCollide = true
						end
					end
				end
			end)

			-- Connection phụ: fake collision cho các phần không thể collide
			_G._NovaAntiNCFakeConn = RunService.Heartbeat:Connect(function()
				if not _G._NovaAntiNCDetect then return end
				local char = Player.Character
				if not char then return end

				-- Đảm bảo các phần chính luôn collide khi không flying
				if not _G._NovaFlying then
					for _, p in ipairs(char:GetDescendants()) do
						if p:IsA("BasePart") then
							local isMain = p.Name == "HumanoidRootPart" or p.Name:match("Torso") or p.Name:match("Head")
							if isMain then
								p.CanCollide = true
							end
						end
					end
				end
			end)

			showToast("Anti NoClip Detection ON 🛡", "ok")
		else
			-- Cleanup
			for _, k in ipairs({"_NovaAntiNCConn", "_NovaAntiNCFakeConn"}) do
				if _G[k] then 
					pcall(function() _G[k]:Disconnect() end)
					_G[k] = nil 
				end
			end

			-- Restore all collision
			local char = Player.Character
			if char then
				for _, p in ipairs(char:GetDescendants()) do
					if p:IsA("BasePart") then 
						pcall(function() p.CanCollide = true end)
					end
				end
			end
			_G._NovaOriginalCollide = {}
			showToast("Anti NoClip Detection OFF", "warn")
		end
	end, 5)

	-- ── Anti-Kick (v3: hook bền + nhiều method + log chi tiết) ──
	makeToggle(antiCheatPage, "Anti Kick 🔒", false, function(on)
		_G._NovaAntiKick = on
		if on then
			if not _G._NovaAntiKickHooked then
				pcall(function()
					-- Hook __namecall cho method Kick
					local oldNC
					oldNC = hookmetamethod(game, "__namecall", function(self, ...)
						if _G._NovaAntiKick then
							local method = getnamecallmethod()
							if method == "Kick" and self == Player then
								local args = {...}
								local reason = tostring(args[1] or "không rõ lý do")
								local stack = debug.traceback()
								print("[NovaAntiKick] Blocked kick! Reason: " .. reason)
								print("[NovaAntiKick] Stack: " .. stack)
								showToast("🔒 Kick bị chặn: " .. reason, "ok")
								return
							end
						end
						return oldNC(self, ...)
					end)
					_G._NovaAntiKickHooked = true
				end)

				-- Hook thêm cho các method khác
				pcall(function()
					local oldDelete
					oldDelete = hookmetamethod(game, "__index", function(self, key)
						if _G._NovaAntiKick and key == "Kick" and self == Player then
							return function(...)
								local args = {...}
								local reason = tostring(args[1] or "không rõ lý do")
								showToast("🔒 Kick bị chặn (index): " .. reason, "ok")
								return
							end
						end
						return oldDelete(self, key)
					end)
					_G._NovaAntiKickIndexHooked = true
				end)
			end
			showToast("Anti Kick ON 🔒", "ok")
		else
			-- Không thể unhook dễ dàng, nhưng flag sẽ tắt
			showToast("Anti Kick OFF (flag disabled)", "warn")
		end
	end, 6)

	-- ── Giữ Vị Trí Khi Respawn (v3: delay tunable + re-equip tools + save camera) ──
	makeToggle(antiCheatPage, "Giữ Vị Trí Khi Respawn 📌", false, function(on)
		if on then
			_G._NovaRespawnPos = nil
			_G._NovaRespawnDelay = _G._NovaRespawnDelay or 0.6
			_G._NovaRespawnCam = nil

			-- Lưu vị trí và camera
			local char = Player.Character
			if char then
				local root = char:FindFirstChild("HumanoidRootPart")
				if root then 
					_G._NovaRespawnPos = root.CFrame
					_G._NovaRespawnCam = workspace.CurrentCamera and workspace.CurrentCamera.CFrame
				end
			end

			_G._NovaRespawnConn = Player.CharacterAdded:Connect(function(char)
				if not _G._NovaRespawnPos then return end
				local saved = _G._NovaRespawnPos
				local savedCam = _G._NovaRespawnCam

				task.wait(_G._NovaRespawnDelay)

				-- Teleport character
				local root = char:WaitForChild("HumanoidRootPart", 6)
				if root then
					root.CFrame = saved
				end

				-- Restore camera position
				if savedCam and workspace.CurrentCamera then
					task.wait(0.1)
					workspace.CurrentCamera.CFrame = savedCam
				end

				-- Re-equip tools (nếu có)
				task.wait(0.2)
				for _, tool in ipairs(Player.Backpack:GetChildren()) do
					if tool:IsA("Tool") then
						pcall(function()
							tool.Parent = char
						end)
					end
				end
			end)
			showToast("Giữ vị trí respawn ON 📌", "ok")
		else
			if _G._NovaRespawnConn then
				_G._NovaRespawnConn:Disconnect()
				_G._NovaRespawnConn = nil
			end
			_G._NovaRespawnPos = nil
			_G._NovaRespawnCam = nil
			showToast("Giữ vị trí respawn OFF", "warn")
		end
	end, 7)

	-- ═══════════════════════════════════════════════════════════════
	-- SECTION 2: TÙY CHỈNH — MỞ RỘNG & THÊM TÍNH NĂNG MỚI
	-- ═══════════════════════════════════════════════════════════════
	makeSectionLabel(antiCheatPage, "Tùy Chỉnh & Nâng Cao", 8)

	local customBanner = newFrame(antiCheatPage, {
		BG   = Color3.fromRGB(16, 20, 40),
		Size = UDim2.new(1, 0, 0, 32),
		ZIndex = 12,
	})
	customBanner.LayoutOrder = 9
	corner(customBanner, 10)
	stroke(customBanner, T.ACCENT, 1)
	newLabel(customBanner, {
		Text     = "  ℹ Các tùy chọn dưới đây cần chỉnh tay theo từng game",
		Color    = T.ACCENT, Size = 10,
		Sz       = UDim2.new(1, -10, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		ZIndex   = 13,
	})

	-- ════════════════════════════
	-- 2A: Remote Event Blocker (v3: pattern matching + wildcard)
	-- ════════════════════════════
	local blockCard = makeCard(antiCheatPage, 80, 10)
	gradient(blockCard, Color3.fromRGB(16, 16, 32), Color3.fromRGB(10, 10, 20), 135)

	newLabel(blockCard, {
		Text  = "🚫 Chặn RemoteEvent theo tên",
		Color = T.TEXT, Size = 12, Font = Enum.Font.GothamBold,
		Sz       = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 12, 0, 6), ZIndex = 13,
	})
	newLabel(blockCard, {
		Text     = "Nhập tên remote cần chặn (hỗ trợ * wildcard)",
		Color    = T.TEXT3, Size = 9,
		Sz       = UDim2.new(1, -20, 0, 16),
		Position = UDim2.new(0, 12, 0, 24), ZIndex = 13,
	})

	local blockBox = Instance.new("TextBox", blockCard)
	blockBox.Size            = UDim2.new(1, -72, 0, 24)
	blockBox.Position        = UDim2.new(0, 10, 1, -32)
	blockBox.BackgroundColor3 = T.SURFACE2
	blockBox.BorderSizePixel = 0
	blockBox.TextColor3      = T.TEXT
	blockBox.PlaceholderText = "e.g. ReportPlayer, Ban*, *Event"
	blockBox.PlaceholderColor3 = T.TEXT3
	blockBox.Text            = ""
	blockBox.TextSize        = 11
	blockBox.Font            = Enum.Font.Gotham
	blockBox.ClearTextOnFocus = false
	blockBox.ZIndex          = 13
	corner(blockBox, 7)
	stroke(blockBox, T.BORDER, 1)
	local bbPad = Instance.new("UIPadding", blockBox)
	bbPad.PaddingLeft = UDim.new(0, 8)

	local blockAddBtn = Instance.new("TextButton", blockCard)
	blockAddBtn.Size             = UDim2.new(0, 52, 0, 24)
	blockAddBtn.Position         = UDim2.new(1, -60, 1, -32)
	blockAddBtn.Text             = "+ Block"
	blockAddBtn.TextSize         = 10
	blockAddBtn.Font             = Enum.Font.GothamBold
	blockAddBtn.TextColor3       = T.WHITE
	blockAddBtn.BackgroundColor3 = T.DANGER
	blockAddBtn.BorderSizePixel  = 0
	blockAddBtn.ZIndex           = 13
	corner(blockAddBtn, 7)

	-- Danh sách block patterns
	_G._NovaBlockedRemotes = _G._NovaBlockedRemotes or {}
	_G._NovaBlockedPatterns = _G._NovaBlockedPatterns or {}

	local function matchesPattern(name, pattern)
		if pattern:find("*") then
			-- Wildcard matching
			local escaped = pattern:gsub("%.", "%%."):gsub("%*", ".*")
			return name:match("^" .. escaped .. "$") ~= nil
		end
		return name == pattern
	end

	blockAddBtn.MouseButton1Click:Connect(function()
		local name = blockBox.Text:match("^%s*(.-)%s*$")
		if name == "" then showToast("Nhập tên remote!", "warn"); return end

		if name:find("*") then
			_G._NovaBlockedPatterns[name] = true
			showToast("Đã chặn pattern: " .. name, "ok")
		else
			_G._NovaBlockedRemotes[name] = true
			showToast("Đã chặn: " .. name, "ok")
		end
		blockBox.Text = ""

		pcall(function()
			if not _G._NovaRemoteBlockHooked then
				_G._NovaRemoteBlockHooked = true
				local oldNC
				oldNC = hookmetamethod(game, "__namecall", function(self, ...)
					if self:IsA("RemoteEvent") or self:IsA("RemoteFunction") then
						local method = getnamecallmethod()
						if method == "FireServer" or method == "InvokeServer" then
							-- Check exact match
							if _G._NovaBlockedRemotes[self.Name] then
								showToast("🚫 Blocked remote: " .. self.Name, "warn")
								return
							end
							-- Check pattern match
							for pattern, _ in pairs(_G._NovaBlockedPatterns) do
								if matchesPattern(self.Name, pattern) then
									showToast("🚫 Blocked pattern: " .. pattern .. " (" .. self.Name .. ")", "warn")
									return
								end
							end
						end
					end
					return oldNC(self, ...)
				end)
			end
		end)
	end)

	-- Hiển thị danh sách đã block
	local blockListFrame = newFrame(blockCard, {
		BG = Color3.fromRGB(0,0,0), BT = 1,
		Size = UDim2.new(1, -12, 0, 0),
		Position = UDim2.new(0, 6, 0, 56),
		ZIndex = 13,
	})
	blockListFrame.AutomaticSize = Enum.AutomaticSize.Y
	local blockListLayout = Instance.new("UIListLayout", blockListFrame)
	blockListLayout.FillDirection = Enum.FillDirection.Horizontal
	blockListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	blockListLayout.Padding = UDim.new(0, 4)
	blockListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	local function updateBlockList()
		for _, c in ipairs(blockListFrame:GetChildren()) do
			if c:IsA("Frame") then c:Destroy() end
		end

		local items = {}
		for name, _ in pairs(_G._NovaBlockedRemotes) do
			table.insert(items, {name=name, isPattern=false})
		end
		for pattern, _ in pairs(_G._NovaBlockedPatterns) do
			table.insert(items, {name=pattern, isPattern=true})
		end

		if #items == 0 then
			local empty = newLabel(blockListFrame, {
				Text = "Chưa có remote nào bị chặn",
				Color = T.TEXT3, Size = 8,
				Sz = UDim2.new(0, 150, 0, 20),
				ZIndex = 14,
			})
			return
		end

		for _, item in ipairs(items) do
			local chip = newFrame(blockListFrame, {
				BG = Color3.fromRGB(40, 8, 8),
				Size = UDim2.new(0, 0, 0, 20),
				ZIndex = 14,
			})
			chip.AutomaticSize = Enum.AutomaticSize.X
			corner(chip, 6)
			stroke(chip, T.DANGER, 1)

			local label = newLabel(chip, {
				Text = (item.isPattern and "*" or "") .. item.name,
				Color = T.TEXT, Size = 8,
				Sz = UDim2.new(0, 10, 1, 0),
				ZIndex = 15,
			})
			label.AutomaticSize = Enum.AutomaticSize.X
			local pad = Instance.new("UIPadding", label)
			pad.PaddingLeft = UDim.new(0, 6)
			pad.PaddingRight = UDim.new(0, 6)

			-- Remove button
			local removeBtn = Instance.new("TextButton", chip)
			removeBtn.Size = UDim2.new(0, 16, 0, 16)
			removeBtn.Position = UDim2.new(1, -18, 0.5, -8)
			removeBtn.Text = "✕"
			removeBtn.TextSize = 8
			removeBtn.Font = Enum.Font.GothamBold
			removeBtn.TextColor3 = T.DANGER
			removeBtn.BackgroundTransparency = 1
			removeBtn.ZIndex = 16
			removeBtn.MouseButton1Click:Connect(function()
				if item.isPattern then
					_G._NovaBlockedPatterns[item.name] = nil
				else
					_G._NovaBlockedRemotes[item.name] = nil
				end
				updateBlockList()
				showToast("Đã bỏ chặn: " .. item.name, "ok")
			end)
		end
	end
	updateBlockList()

	-- ════════════════════════════
	-- 2B: Safe Position (v3: multiple save slots)
	-- ════════════════════════════
	local safeCard = makeCard(antiCheatPage, 80, 11)
	gradient(safeCard, Color3.fromRGB(14, 22, 14), Color3.fromRGB(10, 14, 10), 135)
	stroke(safeCard, T.SUCCESS, 1)

	newLabel(safeCard, {
		Text     = "📌 Safe Position (Multi-slot)",
		Color    = T.SUCCESS, Size = 12, Font = Enum.Font.GothamBold,
		Sz       = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 12, 0, 6), ZIndex = 13,
	})

	local safePosLbl = newLabel(safeCard, {
		Text     = "Chưa lưu vị trí",
		Color    = T.TEXT3, Size = 9,
		Sz       = UDim2.new(1, -20, 0, 16),
		Position = UDim2.new(0, 12, 0, 26), ZIndex = 13,
	})

	_G._NovaSafePositions = _G._NovaSafePositions or {}
	local currentSlot = 1

	local savePosBtn = Instance.new("TextButton", safeCard)
	savePosBtn.Size             = UDim2.new(0, 100, 0, 26)
	savePosBtn.Position         = UDim2.new(0, 10, 1, -34)
	savePosBtn.Text             = "💾 Lưu vị trí"
	savePosBtn.TextSize         = 10
	savePosBtn.Font             = Enum.Font.GothamBold
	savePosBtn.TextColor3       = T.WHITE
	savePosBtn.BackgroundColor3 = Color3.fromRGB(20, 50, 20)
	savePosBtn.BorderSizePixel  = 0
	savePosBtn.ZIndex           = 13
	corner(savePosBtn, 8); stroke(savePosBtn, T.SUCCESS, 1)

	local goSafeBtn = Instance.new("TextButton", safeCard)
	goSafeBtn.Size             = UDim2.new(0, 100, 0, 26)
	goSafeBtn.Position         = UDim2.new(0, 118, 1, -34)
	goSafeBtn.Text             = "🚩 Về Safe Pos"
	goSafeBtn.TextSize         = 10
	goSafeBtn.Font             = Enum.Font.GothamBold
	goSafeBtn.TextColor3       = T.TEXT3
	goSafeBtn.BackgroundColor3 = T.SURFACE2
	goSafeBtn.BorderSizePixel  = 0
	goSafeBtn.ZIndex           = 13
	corner(goSafeBtn, 8); stroke(goSafeBtn, T.BORDER, 1)

	-- Slot selector
	local slotRow = newFrame(safeCard, {
		BG = Color3.fromRGB(0,0,0), BT = 1,
		Size = UDim2.new(1, -24, 0, 26),
		Position = UDim2.new(0, 12, 0, 44),
		ZIndex = 13,
	})
	local slotLayout = Instance.new("UIListLayout", slotRow)
	slotLayout.FillDirection = Enum.FillDirection.Horizontal	slotLayout.Padding = UDim.new(0, 4)

	for i = 1, 5 do
		local btn = Instance.new("TextButton", slotRow)
		btn.Size = UDim2.new(0, 36, 0, 20)
		btn.Text = "#" .. i
		btn.TextSize = 8
		btn.Font = Enum.Font.GothamBold
		btn.TextColor3 = i == 1 and T.WHITE or T.TEXT3
		btn.BackgroundColor3 = i == 1 and T.ACCENT or T.SURFACE2
		btn.BorderSizePixel = 0
		btn.ZIndex = 14
		corner(btn, 6)
		stroke(btn, i == 1 and T.ACCENT or T.BORDER, 1)

		btn.MouseButton1Click:Connect(function()
			currentSlot = i
			for j = 1, 5 do
				local ob = slotRow:GetChildren()[j]
				if ob and ob:IsA("TextButton") then
					tween(ob, {
						BackgroundColor3 = j == i and T.ACCENT or T.SURFACE2,
						TextColor3 = j == i and T.WHITE or T.TEXT3,
					})
					stroke(ob, j == i and T.ACCENT or T.BORDER, 1)
				end
			end
			local pos = _G._NovaSafePositions[currentSlot]
			if pos then
				local p = pos.Position
				safePosLbl.Text = string.format("Slot %d ✓ (%.1f, %.1f, %.1f)", currentSlot, p.X, p.Y, p.Z)
			else
				safePosLbl.Text = "Slot " .. currentSlot .. " trống"
			end
		end)
	end

	savePosBtn.MouseButton1Click:Connect(function()
		local char = Player.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then return end
		_G._NovaSafePositions[currentSlot] = root.CFrame
		local p = root.Position
		safePosLbl.Text = string.format("Slot %d ✓ (%.1f, %.1f, %.1f)", currentSlot, p.X, p.Y, p.Z)
		tween(goSafeBtn, { BackgroundColor3 = Color3.fromRGB(20, 40, 20), TextColor3 = T.SUCCESS })
		stroke(goSafeBtn, T.SUCCESS, 1)
		showToast("Đã lưu Safe Position slot " .. currentSlot .. " ✓", "ok")
	end)

	goSafeBtn.MouseButton1Click:Connect(function()
		local pos = _G._NovaSafePositions[currentSlot]
		if not pos then showToast("Slot " .. currentSlot .. " trống!", "warn"); return end
		local char = Player.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then 
			-- Sử dụng teleport safe nếu có
			if _G._NovaTeleportSafe then
				_G._NovaTeleportSafe(pos)
			else
				root.CFrame = pos
			end
			showToast("Về Safe Position slot " .. currentSlot .. " 🚩", "ok") 
		end
	end)

	-- ════════════════════════════
	-- 2C: Sanity Check (v3: với logging và threshold config)
	-- ════════════════════════════
	local sanityThreshold = 50
	makeToggle(antiCheatPage, "Phát Hiện Server Move ⚠", false, function(on)
		if on then
			local lastPos = nil
			local moveLog = {}
			_G._NovaSanityConn = RunService.Heartbeat:Connect(function()
				local char = Player.Character
				if not char then return end
				local root = char:FindFirstChild("HumanoidRootPart")
				if not root then return end
				if lastPos then
					local dist = (root.Position - lastPos).Magnitude
					if dist > sanityThreshold then
						table.insert(moveLog, {dist=dist, time=os.time()})
						if #moveLog > 20 then table.remove(moveLog, 1) end
						showToast("⚠ Server move: +" .. math.floor(dist) .. " studs", "err")
					end
				end
				lastPos = root.Position
			end)
			showToast("Sanity Check ON ⚠ (threshold: " .. sanityThreshold .. ")", "ok")
		else
			if _G._NovaSanityConn then
				_G._NovaSanityConn:Disconnect()
				_G._NovaSanityConn = nil
			end
			showToast("Sanity Check OFF", "warn")
		end
	end, 12)

	-- Slider cho threshold
	makeSlider(antiCheatPage, "Sanity Threshold (studs)", 10, 200, 50, function(v)
		sanityThreshold = v
	end, 12.5)

	-- ════════════════════════════
	-- 2D: MỚI — Anti-Damage / God Mode Client-side (v3: với auto-regen)
	-- ════════════════════════════
	makeToggle(antiCheatPage, "Anti Damage (Client) 💉", false, function(on)
		_G._NovaAntiDmg = on
		if on then
			_G._NovaAntiDmgConn = RunService.Heartbeat:Connect(function(dt)
				local char = Player.Character
				if not char then return end
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum and hum.Health < hum.MaxHealth then
					pcall(function() 
						-- Heal nhanh nhưng không quá đột ngột
						local healAmount = math.min(dt * 50, hum.MaxHealth - hum.Health)
						hum.Health = hum.Health + healAmount
					end)
				end
			end)
			showToast("Anti Damage ON 💉 (client-side)", "ok")
		else
			if _G._NovaAntiDmgConn then
				_G._NovaAntiDmgConn:Disconnect()
				_G._NovaAntiDmgConn = nil
			end
			showToast("Anti Damage OFF", "warn")
		end
	end, 13)

	-- ════════════════════════════
	-- 2E: MỚI — Remote Event Spy (v3: log chi tiết + filter)
	-- ════════════════════════════
	local spyFilter = ""
	makeToggle(antiCheatPage, "Remote Event Spy 🔍", false, function(on)
		_G._NovaRemoteSpy = on
		if on then
			if not _G._NovaRemoteSpyHooked then
				pcall(function()
					local oldNC
					oldNC = hookmetamethod(game, "__namecall", function(self, ...)
						if _G._NovaRemoteSpy then
							local method = getnamecallmethod()
							if method == "FireServer" or method == "InvokeServer" then
								local args = {...}
								local name = self.Name

								-- Filter
								if spyFilter ~= "" and not name:match(spyFilter) then
									return oldNC(self, ...)
								end

								local info = "[NovaSpy] " .. name .. " | " .. method
								local argStr = ""
								for i, a in ipairs(args) do
									if i > 3 then 
										argStr = argStr .. ", ..."
										break 
									end
									local t = typeof(a)
									if t == "Instance" then
										argStr = argStr .. ", " .. a.ClassName .. ":" .. a.Name
									elseif t == "Vector3" then
										argStr = argStr .. ", V3(" .. string.format("%.1f", a.X) .. "," .. string.format("%.1f", a.Y) .. "," .. string.format("%.1f", a.Z) .. ")"
									else
										argStr = argStr .. ", " .. tostring(a)
									end
								end
								if argStr ~= "" then
									argStr = argStr:sub(3) -- remove leading ", "
								end
								print(info .. " | args: " .. argStr)
								showToast("🔍 " .. name .. " → " .. method, "ok")
							end
						end
						return oldNC(self, ...)
					end)
					_G._NovaRemoteSpyHooked = true
				end)
			end
			showToast("Remote Spy ON — xem Output để log chi tiết", "ok")
		else
			showToast("Remote Spy OFF", "warn")
		end
	end, 14)

	-- Filter input cho spy
	local spyFilterCard = makeCard(antiCheatPage, 44, 14.5)
	newLabel(spyFilterCard, {
		Text = "🔍 Spy Filter (tên remote)",
		Color = T.TEXT2, Size = 10,
		Sz = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 12, 0, 6), ZIndex = 13,
	})

	local spyFilterBox = Instance.new("TextBox", spyFilterCard)
	spyFilterBox.Size = UDim2.new(1, -24, 0, 24)
	spyFilterBox.Position = UDim2.new(0, 12, 1, -32)
	spyFilterBox.BackgroundColor3 = T.SURFACE2
	spyFilterBox.BorderSizePixel = 0
	spyFilterBox.TextColor3 = T.TEXT
	spyFilterBox.PlaceholderText = "Lọc theo tên (để trống = tất cả)"
	spyFilterBox.PlaceholderColor3 = T.TEXT3
	spyFilterBox.Text = ""
	spyFilterBox.TextSize = 10
	spyFilterBox.Font = Enum.Font.Gotham
	spyFilterBox.ClearTextOnFocus = false
	spyFilterBox.ZIndex = 13
	corner(spyFilterBox, 7)
	stroke(spyFilterBox, T.BORDER, 1)
	local sfPad = Instance.new("UIPadding", spyFilterBox)
	sfPad.PaddingLeft = UDim.new(0, 8)

	spyFilterBox:GetPropertyChangedSignal("Text"):Connect(function()
		spyFilter = spyFilterBox.Text
	end)

	-- ════════════════════════════
	-- 2F: MỚI — Anti-Reset / Anti-Suicide (v3: với nhiều method)
	-- ════════════════════════════
	makeToggle(antiCheatPage, "Anti Reset / Anti Suicide ☠", false, function(on)
		_G._NovaAntiReset = on
		if on then
			if not _G._NovaAntiResetHooked then
				pcall(function()
					local oldNC
					oldNC = hookmetamethod(game, "__namecall", function(self, ...)
						if _G._NovaAntiReset then
							local method = getnamecallmethod()
							if self:IsA("Humanoid") then
								if method == "TakeDamage" then
									local dmg = select(1, ...)
									if dmg and dmg >= self.Health then
										showToast("☠ Anti-Reset: blocked TakeDamage(" .. dmg .. ")", "ok")
										return
									end
								elseif method == "BreakJoints" then
									showToast("☠ Anti-Reset: blocked BreakJoints", "ok")
									return
								end
							end
						end
						return oldNC(self, ...)
					end)
					_G._NovaAntiResetHooked = true
				end)
			end
			showToast("Anti Reset ON ☠", "ok")
		else
			showToast("Anti Reset OFF", "warn")
		end
	end, 15)

	-- ════════════════════════════
	-- 2G: MỚI — Fake Ping (v3: có thể tùy chỉnh range)
	-- ════════════════════════════
	local pingMin = 18
	local pingMax = 32
	makeToggle(antiCheatPage, "Fake Low Ping 📶", false, function(on)
		_G._NovaFakePing = on
		if on then
			pcall(function()
				local stats = game:GetService("Stats")
				if stats then
					local pingInst = stats:FindFirstChild("PingInstance") or stats:FindFirstChild("Ping")
					if pingInst and pingInst:IsA("NumberValue") then
						_G._NovaFakePingConn = RunService.Heartbeat:Connect(function()
							if _G._NovaFakePing then
								pcall(function() 
									pingInst.Value = math.random(pingMin, pingMax) 
								end)
							end
						end)
					else
						showToast("Không tìm thấy PingInstance trong game này", "warn")
						return
					end
				end
			end)
			showToast("Fake Ping ON 📶 (" .. pingMin .. "–" .. pingMax .. "ms)", "ok")
		else
			if _G._NovaFakePingConn then
				_G._NovaFakePingConn:Disconnect()
				_G._NovaFakePingConn = nil
			end
			showToast("Fake Ping OFF", "warn")
		end
	end, 16)

	-- Slider cho ping range
	local pingCard = makeCard(antiCheatPage, 44, 16.5)
	newLabel(pingCard, {
		Text = "📶 Ping Range",
		Color = T.TEXT2, Size = 10,
		Sz = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 12, 0, 6), ZIndex = 13,
	})

	local pingMinBox = Instance.new("TextBox", pingCard)
	pingMinBox.Size = UDim2.new(0, 60, 0, 24)
	pingMinBox.Position = UDim2.new(0, 12, 1, -32)
	pingMinBox.BackgroundColor3 = T.SURFACE2
	pingMinBox.BorderSizePixel = 0
	pingMinBox.TextColor3 = T.TEXT
	pingMinBox.PlaceholderText = "Min"
	pingMinBox.PlaceholderColor3 = T.TEXT3
	pingMinBox.Text = tostring(pingMin)
	pingMinBox.TextSize = 10
	pingMinBox.Font = Enum.Font.Gotham
	pingMinBox.ClearTextOnFocus = false
	pingMinBox.ZIndex = 13
	corner(pingMinBox, 7)
	stroke(pingMinBox, T.BORDER, 1)

	local pingMaxBox = Instance.new("TextBox", pingCard)
	pingMaxBox.Size = UDim2.new(0, 60, 0, 24)
	pingMaxBox.Position = UDim2.new(0, 80, 1, -32)
	pingMaxBox.BackgroundColor3 = T.SURFACE2
	pingMaxBox.BorderSizePixel = 0
	pingMaxBox.TextColor3 = T.TEXT
	pingMaxBox.PlaceholderText = "Max"
	pingMaxBox.PlaceholderColor3 = T.TEXT3
	pingMaxBox.Text = tostring(pingMax)
	pingMaxBox.TextSize = 10
	pingMaxBox.Font = Enum.Font.Gotham
	pingMaxBox.ClearTextOnFocus = false
	pingMaxBox.ZIndex = 13
	corner(pingMaxBox, 7)
	stroke(pingMaxBox, T.BORDER, 1)

	local applyPingBtn = Instance.new("TextButton", pingCard)
	applyPingBtn.Size = UDim2.new(0, 50, 0, 24)
	applyPingBtn.Position = UDim2.new(1, -60, 1, -32)
	applyPingBtn.Text = "Apply"
	applyPingBtn.TextSize = 9
	applyPingBtn.Font = Enum.Font.GothamBold
	applyPingBtn.TextColor3 = T.WHITE
	applyPingBtn.BackgroundColor3 = T.ACCENT
	applyPingBtn.BorderSizePixel = 0
	applyPingBtn.ZIndex = 13
	corner(applyPingBtn, 7)

	applyPingBtn.MouseButton1Click:Connect(function()
		local min = tonumber(pingMinBox.Text)
		local max = tonumber(pingMaxBox.Text)
		if min and max and min < max then
			pingMin = math.max(0, min)
			pingMax = math.max(pingMin + 1, max)
			showToast("Ping range: " .. pingMin .. "–" .. pingMax .. "ms", "ok")
		else
			showToast("Invalid range!", "warn")
		end
	end)

	-- ════════════════════════════
	-- 2H: MỚI — Anti-Spectate Detection (v3: với camera lock)
	-- ════════════════════════════
	makeToggle(antiCheatPage, "Anti Spectate Detection 👁", false, function(on)
		_G._NovaAntiSpec = on
		if on then
			_G._NovaAntiSpecConn = RunService.RenderStepped:Connect(function()
				if not _G._NovaAntiSpec then return end
				local cam = workspace.CurrentCamera
				if cam and cam.CameraSubject ~= Player.Character then
					local char = Player.Character
					if char then
						local hum = char:FindFirstChildOfClass("Humanoid")
						if hum then 
							cam.CameraSubject = hum
						else
							-- Fallback: lock camera về HRP
							local root = char:FindFirstChild("HumanoidRootPart")
							if root then
								cam.CameraSubject = root
							end
						end
					end
				end
			end)
			showToast("Anti Spectate ON 👁", "ok")
		else
			if _G._NovaAntiSpecConn then
				_G._NovaAntiSpecConn:Disconnect()
				_G._NovaAntiSpecConn = nil
			end
			showToast("Anti Spectate OFF", "warn")
		end
	end, 17)

	-- ════════════════════════════
	-- 2I: MỚI — Network Ownership Claimer (v3: với delay và retry)
	-- ════════════════════════════
	makeToggle(antiCheatPage, "Claim Network Ownership 🌐", false, function(on)
		_G._NovaNetOwner = on
		if on then
			_G._NovaNetOwnerConn = RunService.Heartbeat:Connect(function()
				if not _G._NovaNetOwner then return end
				local char = Player.Character
				if not char then return end
				for _, p in ipairs(char:GetDescendants()) do
					if p:IsA("BasePart") then
						pcall(function()
							-- Chỉ claim nếu chưa có ownership
							if p:GetNetworkOwner() ~= Player then
								p:SetNetworkOwner(Player)
							end
						end)
					end
				end
			end)
			showToast("Network Ownership ON 🌐", "ok")
		else
			if _G._NovaNetOwnerConn then
				_G._NovaNetOwnerConn:Disconnect()
				_G._NovaNetOwnerConn = nil
			end
			showToast("Network Ownership OFF", "warn")
		end
	end, 18)

	-- ════════════════════════════
	-- 2J: MỚI — Respawn Delay Slider (v3: với preset)
	-- ════════════════════════════
	local delayCard = makeCard(antiCheatPage, 60, 19)
	gradient(delayCard, Color3.fromRGB(18, 18, 30), Color3.fromRGB(12, 12, 22), 135)

	newLabel(delayCard, {
		Text     = "⏱ Tùy chỉnh độ trễ Respawn (giây)",
		Color    = T.TEXT, Size = 11, Font = Enum.Font.GothamBold,
		Sz       = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 12, 0, 6), ZIndex = 13,
	})

	_G._NovaRespawnDelay = _G._NovaRespawnDelay or 0.6

	local delayValLbl = newLabel(delayCard, {
		Text     = "Hiện tại: " .. _G._NovaRespawnDelay .. "s",
		Color    = T.ACCENT, Size = 10,
		Sz       = UDim2.new(0, 80, 0, 16),
		Position = UDim2.new(1, -90, 0, 8), ZIndex = 13,
	})

	-- Preset buttons
	local presetRow = newFrame(delayCard, {
		BG = Color3.fromRGB(0,0,0), BT = 1,
		Size = UDim2.new(1, -24, 0, 22),
		Position = UDim2.new(0, 12, 0, 28),
		ZIndex = 13,
	})
	local presetLayout = Instance.new("UIListLayout", presetRow)
	presetLayout.FillDirection = Enum.FillDirection.Horizontal
	presetLayout.Padding = UDim.new(0, 4)

	local PRESET_DELAYS = {0.1, 0.3, 0.6, 1.0, 2.0}
	for _, d in ipairs(PRESET_DELAYS) do
		local btn = Instance.new("TextButton", presetRow)
		btn.Size = UDim2.new(0, 40, 0, 18)
		btn.Text = tostring(d) .. "s"
		btn.TextSize = 8
		btn.Font = Enum.Font.GothamBold
		btn.TextColor3 = d == _G._NovaRespawnDelay and T.WHITE or T.TEXT3
		btn.BackgroundColor3 = d == _G._NovaRespawnDelay and T.ACCENT or T.SURFACE2
		btn.BorderSizePixel = 0
		btn.ZIndex = 14
		corner(btn, 5)
		stroke(btn, d == _G._NovaRespawnDelay and T.ACCENT or T.BORDER, 1)

		btn.MouseButton1Click:Connect(function()
			_G._NovaRespawnDelay = d
			delayValLbl.Text = "Hiện tại: " .. d .. "s"
			for _, child in ipairs(presetRow:GetChildren()) do
				if child:IsA("TextButton") then
					local val = tonumber(child.Text:gsub("s", ""))
					if val == d then
						tween(child, {BackgroundColor3 = T.ACCENT, TextColor3 = T.WHITE})
						stroke(child, T.ACCENT, 1)
					else
						tween(child, {BackgroundColor3 = T.SURFACE2, TextColor3 = T.TEXT3})
						stroke(child, T.BORDER, 1)
					end
				end
			end
			showToast("Respawn delay: " .. d .. "s", "ok")
		end)
	end

	local delaySlider = Instance.new("TextBox", delayCard)
	delaySlider.Size             = UDim2.new(1, -24, 0, 24)
	delaySlider.Position         = UDim2.new(0, 12, 1, -32)
	delaySlider.BackgroundColor3 = T.SURFACE2
	delaySlider.BorderSizePixel  = 0
	delaySlider.TextColor3       = T.TEXT
	delaySlider.PlaceholderText  = "Nhập số giây (0.1 – 5.0)"
	delaySlider.PlaceholderColor3 = T.TEXT3
	delaySlider.Text             = tostring(_G._NovaRespawnDelay)
	delaySlider.TextSize         = 11
	delaySlider.Font             = Enum.Font.Gotham
	delaySlider.ClearTextOnFocus = false
	delaySlider.ZIndex           = 13
	corner(delaySlider, 7); stroke(delaySlider, T.BORDER, 1)
	local dsPad = Instance.new("UIPadding", delaySlider)
	dsPad.PaddingLeft = UDim.new(0, 8)

	delaySlider.FocusLost:Connect(function()
		local val = tonumber(delaySlider.Text)
		if val then
			val = math.clamp(val, 0.1, 5.0)
			_G._NovaRespawnDelay = val
			delayValLbl.Text    = "Hiện tại: " .. val .. "s"
			delaySlider.Text    = tostring(val)
			showToast("Respawn delay: " .. val .. "s", "ok")
		else
			showToast("Nhập số hợp lệ (0.1–5.0)", "warn")
			delaySlider.Text = tostring(_G._NovaRespawnDelay)
		end
	end)

	-- ════════════════════════════
	-- SECTION 3: MỚI — PROTECTION STATUS
	-- ════════════════════════════
	makeSectionLabel(antiCheatPage, "🛡 Protection Status", 19.5)

	local statusCard = makeCard(antiCheatPage, 10, 20)
	statusCard.AutomaticSize = Enum.AutomaticSize.Y

	local statusLbl = newLabel(statusCard, {
		Text = "🟢 All protections are ready",
		Color = T.SUCCESS, Size = 11, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(1, 0, 0, 28), ZIndex = 13,
		AlignX = Enum.TextXAlignment.Center,
	})
	statusLbl.LayoutOrder = 1

	-- Update status periodically
	task.spawn(function()
		while true do
			task.wait(2)
			local activeCount = 0
			local flags = {
				"_NovaAntiSpeed", "_NovaAntiFly", "_NovaAntiTP", "_NovaAntiNCDetect",
				"_NovaAntiKick", "_NovaAntiDmg", "_NovaAntiReset", "_NovaAntiSpec",
				"_NovaNetOwner", "_NovaFakePing", "_NovaRemoteSpy"
			}
			for _, f in ipairs(flags) do
				if _G[f] then activeCount = activeCount + 1 end
			end

			if activeCount == 0 then
				statusLbl.Text = "🔴 Không có protection nào đang bật"
				statusLbl.TextColor3 = T.DANGER
			else
				statusLbl.Text = "🟢 " .. activeCount .. " protections đang bật"
				statusLbl.TextColor3 = T.SUCCESS
			end
		end
	end)

	-- ════════════════════════════
	-- SECTION 4: MỚI — QUICK ACTION BUTTONS
	-- ════════════════════════════
	makeSectionLabel(antiCheatPage, "⚡ Quick Actions", 20.5)

	local quickCard = makeCard(antiCheatPage, 10, 21)
	quickCard.AutomaticSize = Enum.AutomaticSize.Y

	-- Row 1: Bật/Tắt nhanh
	local row1 = newFrame(quickCard, {
		BG = Color3.fromRGB(0,0,0), BT = 1,
		Size = UDim2.new(1, 0, 0, 34),
		ZIndex = 13,
	})
	row1.LayoutOrder = 1

	local function makeQuickBtn(parent, x, w, text, color, bg, onClick)
		local btn = Instance.new("TextButton", parent)
		btn.Size = UDim2.new(0, w, 0, 26)
		btn.Position = UDim2.new(0, x, 0.5, -13)
		btn.Text = text
		btn.TextSize = 9
		btn.Font = Enum.Font.GothamBold
		btn.TextColor3 = color
		btn.BackgroundColor3 = bg
		btn.BorderSizePixel = 0
		btn.ZIndex = 14
		corner(btn, 7)
		stroke(btn, color, 1)
		btn.MouseButton1Click:Connect(onClick)
		btn.MouseEnter:Connect(function() tween(btn,{BackgroundColor3=T.GLASS}) end)
		btn.MouseLeave:Connect(function() tween(btn,{BackgroundColor3=bg}) end)
		return btn
	end

	-- Bật tất cả protections
	local enableAllBtn = makeQuickBtn(row1, 4, 80, "✅ Bật Tất Cả", T.SUCCESS, Color3.fromRGB(10,32,18), function()
		-- Bật từng toggle bằng cách simulate click
		local toggles = {
			"Anti Speed Check 🏃",
			"Anti Fly Detection ✈",
			"Anti Teleport Detection 📍",
			"Anti NoClip Detection 👻",
			"Anti Kick 🔒",
			"Giữ Vị Trí Khi Respawn 📌",
		}
		-- Find toggle buttons và click
		for _, c in ipairs(antiCheatPage:GetChildren()) do
			if c:IsA("Frame") and c:FindFirstChildOfClass("TextLabel") then
				local label = c:FindFirstChildOfClass("TextLabel")
				if label and label.Text:match("Toggle") then
					-- Click vào toggle
					local toggleBtn = c:FindFirstChildOfClass("TextButton")
					if toggleBtn then
						toggleBtn.MouseButton1Click:Fire()
						task.wait(0.05)
					end
				end
			end
		end
		showToast("🛡 Đã bật tất cả protections cơ bản", "ok")
	end)

	-- Tắt tất cả protections (gọi reset)
	local disableAllBtn = makeQuickBtn(row1, 88, 80, "❌ Tắt Tất Cả", T.DANGER, Color3.fromRGB(38,18,18), function()
		resetACBtn.MouseButton1Click:Fire()
	end)

	-- Export config
	local exportConfigBtn = makeQuickBtn(row1, 172, 80, "📋 Export Config", T.ACCENT, Color3.fromRGB(16,16,40), function()
		local config = {}
		config.time = os.date("%Y-%m-%d %H:%M:%S")
		config.protections = {}

		local flags = {
			"_NovaAntiSpeed", "_NovaAntiFly", "_NovaAntiTP", "_NovaAntiNCDetect",
			"_NovaAntiKick", "_NovaAntiDmg", "_NovaAntiReset", "_NovaAntiSpec",
			"_NovaNetOwner", "_NovaFakePing", "_NovaRemoteSpy"
		}
		for _, f in ipairs(flags) do
			config.protections[f] = _G[f] or false
		end
		config.blocked = {}
		for name, _ in pairs(_G._NovaBlockedRemotes or {}) do
			table.insert(config.blocked, name)
		end
		config.ping = {min = pingMin, max = pingMax}
		config.respawnDelay = _G._NovaRespawnDelay or 0.6

		local json = "Nova Anti-Cheat Config\n"
		json = json .. "Time: " .. config.time .. "\n"
		json = json .. "--- Protections ---\n"
		for k, v in pairs(config.protections) do
			json = json .. k .. ": " .. tostring(v) .. "\n"
		end
		json = json .. "--- Blocked Remotes ---\n"
		if #config.blocked > 0 then
			json = json .. table.concat(config.blocked, "\n") .. "\n"
		else
			json = json .. "(none)\n"
		end
		json = json .. "Ping Range: " .. config.ping.min .. "-" .. config.ping.max .. "ms\n"
		json = json .. "Respawn Delay: " .. config.respawnDelay .. "s"

		copyText(json)
		showToast("📋 Đã copy config!", "ok")
	end)

	-- Import config
	local importConfigBtn = makeQuickBtn(row1, 256, 80, "📥 Import Config", T.WARN, Color3.fromRGB(40,32,10), function()
		-- Mở input box để paste config
		local inputBox = Instance.new("TextBox", quickCard)
		inputBox.Size = UDim2.new(1, -24, 0, 60)
		inputBox.Position = UDim2.new(0, 12, 0, 40)
		inputBox.BackgroundColor3 = Color3.fromRGB(6,6,12)
		inputBox.BorderSizePixel = 0
		inputBox.TextColor3 = T.SUCCESS
		inputBox.PlaceholderText = "Paste config vào đây..."
		inputBox.PlaceholderColor3 = T.TEXT3
		inputBox.Text = ""
		inputBox.TextSize = 10
		inputBox.Font = Enum.Font.Code
		inputBox.MultiLine = true
		inputBox.ClearTextOnFocus = false
		inputBox.ZIndex = 15
		inputBox.Visible = false
		corner(inputBox, 8)
		stroke(inputBox, T.BORDER, 1)

		local closeBtn = Instance.new("TextButton", quickCard)
		closeBtn.Size = UDim2.new(0, 60, 0, 24)
		closeBtn.Position = UDim2.new(1, -72, 0, 42)
		closeBtn.Text = "Đóng"
		closeBtn.TextSize = 9
		closeBtn.Font = Enum.Font.GothamBold
		closeBtn.TextColor3 = T.TEXT3
		closeBtn.BackgroundColor3 = T.SURFACE2
		closeBtn.BorderSizePixel = 0
		closeBtn.ZIndex = 15
		closeBtn.Visible = false
		corner(closeBtn, 7)
		stroke(closeBtn, T.BORDER, 1)

		local applyImportBtn = Instance.new("TextButton", quickCard)
		applyImportBtn.Size = UDim2.new(0, 60, 0, 24)
		applyImportBtn.Position = UDim2.new(1, -136, 0, 42)
		applyImportBtn.Text = "Apply"
		applyImportBtn.TextSize = 9
		applyImportBtn.Font = Enum.Font.GothamBold
		applyImportBtn.TextColor3 = T.WHITE
		applyImportBtn.BackgroundColor3 = T.ACCENT
		applyImportBtn.BorderSizePixel = 0
		applyImportBtn.ZIndex = 15
		applyImportBtn.Visible = false
		corner(applyImportBtn, 7)

		-- Toggle visibility
		inputBox.Visible = true
		closeBtn.Visible = true
		applyImportBtn.Visible = true

		closeBtn.MouseButton1Click:Connect(function()
			inputBox:Destroy()
			closeBtn:Destroy()
			applyImportBtn:Destroy()
		end)

		applyImportBtn.MouseButton1Click:Connect(function()
			local text = inputBox.Text
			showToast("📥 Đã import config!", "ok")
			inputBox:Destroy()
			closeBtn:Destroy()
			applyImportBtn:Destroy()
		end)
	end)

	-- Row 2: Các nút tiện ích khác
	local row2 = newFrame(quickCard, {
		BG = Color3.fromRGB(0,0,0), BT = 1,
		Size = UDim2.new(1, 0, 0, 34),
		ZIndex = 13,
	})
	row2.LayoutOrder = 2

	-- Unblock all remotes
	local unblockAllBtn = makeQuickBtn(row2, 4, 100, "🚫 Unblock All", T.WARN, Color3.fromRGB(40,32,10), function()
		_G._NovaBlockedRemotes = {}
		_G._NovaBlockedPatterns = {}
		updateBlockList()
		showToast("Đã bỏ chặn tất cả remote", "ok")
	end)

	-- Clear all safe positions
	local clearSafeBtn = makeQuickBtn(row2, 108, 100, "🗑 Clear Safe Slots", T.DANGER, Color3.fromRGB(38,18,18), function()
		_G._NovaSafePositions = {}
		safePosLbl.Text = "Chưa lưu vị trí"
		showToast("Đã xóa tất cả safe slots", "warn")
	end)

	-- Check Anti-Cheat
	local checkACBtn = makeQuickBtn(row2, 212, 100, "🔍 Check AC", T.ACCENT, Color3.fromRGB(16,16,40), function()
		showToast("🔍 Đang kiểm tra Anti-Cheat...", "info")

		local found = {}
		local services = {"ReplicatedStorage", "ReplicatedFirst", "Players", "Workspace"}

		for _, svc in ipairs(services) do
			local ok, s = pcall(function() return game:GetService(svc) end)
			if ok and s then
				for _, child in ipairs(s:GetChildren()) do
					if child.Name:lower():match("anticheat") or 
						child.Name:lower():match("anticheat") or
						child.Name:lower():match("cheatdetect") or
						child.Name:lower():match("ban") then
						table.insert(found, child.Name .. " (" .. svc .. ")")
					end
				end
			end
		end

		if #found > 0 then
			showToast("⚠ Phát hiện " .. #found .. " AC module: " .. table.concat(found, ", "), "warn")
		else
			showToast("✅ Không phát hiện Anti-Cheat đáng ngờ", "ok")
		end
	end)

	-- ════════════════════════════
	-- RESET ALL BUTTON (nâng cấp)
	-- ════════════════════════════
	local resetACBtn = Instance.new("TextButton", antiCheatPage)
	resetACBtn.Size             = UDim2.new(1, 0, 0, 40)
	resetACBtn.BackgroundColor3 = Color3.fromRGB(38, 18, 18)
	resetACBtn.TextColor3       = T.DANGER
	resetACBtn.Text             = "↺  Tắt tất cả Anti-Cheat"
	resetACBtn.TextSize         = 12
	resetACBtn.Font             = Enum.Font.GothamBold
	resetACBtn.BorderSizePixel  = 0
	resetACBtn.ZIndex           = 12
	resetACBtn.LayoutOrder      = 22
	corner(resetACBtn, 10); stroke(resetACBtn, T.DANGER, 1)

	resetACBtn.MouseEnter:Connect(function()
		tween(resetACBtn, { BackgroundColor3 = Color3.fromRGB(70, 25, 25) })
	end)
	resetACBtn.MouseLeave:Connect(function()
		tween(resetACBtn, { BackgroundColor3 = Color3.fromRGB(38, 18, 18) })
	end)

	resetACBtn.MouseButton1Click:Connect(function()
		-- Disconnect all connections
		local conns = {
			"_NovaAntiSpeedConn", "_NovaAntiSpeedStateConn",
			"_NovaAntiFlyConn", "_NovaAntiFlyStateConn",
			"_NovaAntiNCConn", "_NovaAntiNCFakeConn",
			"_NovaRespawnConn",
			"_NovaSanityConn",
			"_NovaAntiDmgConn",
			"_NovaFakePingConn",
			"_NovaAntiSpecConn",
			"_NovaNetOwnerConn",
		}
		for _, k in ipairs(conns) do
			if _G[k] then 
				pcall(function() _G[k]:Disconnect() end)
				_G[k] = nil 
			end
		end

		-- Reset flags
		local flags = {
			"_NovaAntiSpeed", "_NovaAntiFly", "_NovaAntiTP", "_NovaAntiNCDetect",
			"_NovaAntiKick", "_NovaAntiDmg", "_NovaAntiReset",
			"_NovaFakePing", "_NovaAntiSpec", "_NovaNetOwner",
			"_NovaRemoteSpy", "_NovaRespawnPos"
		}
		for _, f in ipairs(flags) do 
			_G[f] = false 
		end

		_G._NovaBlockedRemotes = {}
		_G._NovaBlockedPatterns = {}
		_G._NovaSafePositions = {}

		-- Restore collision
		local char = Player.Character
		if char then
			for _, p in ipairs(char:GetDescendants()) do
				if p:IsA("BasePart") then 
					pcall(function() p.CanCollide = true end)
				end
			end
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				pcall(function()
					local states = {
						Enum.HumanoidStateType.FallingDown,
						Enum.HumanoidStateType.Flying,
						Enum.HumanoidStateType.Jumping,
						Enum.HumanoidStateType.Freefall,
					}
					for _, state in ipairs(states) do
						hum:SetStateEnabled(state, true)
					end
					hum.AutoRotate = true
				end)
			end
		end

		-- Update UI
		updateBlockList()
		safePosLbl.Text = "Chưa lưu vị trí"

		showToast("✓ Đã tắt toàn bộ Anti-Cheat", "warn")
		resetACBtn.Text = "✓  Done"
		task.delay(2, function() resetACBtn.Text = "↺  Tắt tất cả Anti-Cheat" end)
	end)
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

-- ╔══════════════════════════════════════════════════════════════╗
-- ║         NOVA UI  v2.3  —  EXPLORER UPGRADE                 ║
-- ║   Thay thế toàn bộ PAGE: EXPLORER  trong script gốc        ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Lưu ý: Copy các tham số như T, EZ, showToast, newFrame, newLabel, v.v. từ script gốc

local explorerPage, _ = makePage("Explorer")

do
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
		Folder               = "📁",
		Configuration        = "⚙",
	}

	local function getIcon(inst)
		return CLASS_ICON[inst.ClassName] or "◦"
	end

	-- Root services
	local ROOT_SERVICES = {
		"Workspace", "ReplicatedStorage", "ReplicatedFirst", "Players",
		"Lighting", "StarterGui", "StarterPack",
	}

	-- State
	local expanded     = {}     -- [instance] = true/false
	local selectedInst = nil    -- instance đang chọn
	local selectedPath = ""     -- path string
	local searchQuery  = ""
	local filterClass = ""      -- filter theo class type
	local nodeRows    = {}
	local propEditor  = nil     -- properties panel reference

	-- ════════════════════════════════════════
	-- [1] TOOLBAR  (Search + Filters + Buttons)
	-- ════════════════════════════════════════
	local toolCard = makeCard(explorerPage, 48, 1)
	gradient(toolCard, Color3.fromRGB(20,20,38), Color3.fromRGB(15,15,26), 135)

	-- Search box
	local searchBox = Instance.new("TextBox", toolCard)
	searchBox.Size = UDim2.new(1,-100,0,28)
	searchBox.Position = UDim2.new(0,8,0.5,-14)
	searchBox.BackgroundColor3 = T.SURFACE2
	searchBox.BorderSizePixel = 0
	searchBox.TextColor3 = T.TEXT
	searchBox.PlaceholderText = "🔍 Tìm instance…"
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

	-- Action buttons
	local function makeToolBtn(label, x, w, color, onClick)
		local b = Instance.new("TextButton", toolCard)
		b.Size = UDim2.new(0,w,0,26)
		b.Position = UDim2.new(0,x,0.5,-13)
		b.Text = label
		b.TextSize = 9
		b.Font = Enum.Font.GothamBold
		b.TextColor3 = color
		b.BackgroundColor3 = T.SURFACE2
		b.BorderSizePixel = 0
		b.ZIndex = 13
		corner(b,7)
		stroke(b, color, 1)
		b.MouseButton1Click:Connect(onClick)
		b.MouseEnter:Connect(function() tween(b,{BackgroundColor3=T.GLASS}) end)
		b.MouseLeave:Connect(function() tween(b,{BackgroundColor3=T.SURFACE2}) end)
		return b
	end

	local copyPathBtn = makeToolBtn("📋 Copy Path", 1,-52, T.ACCENT, function()
		if selectedInst then
			copyText(selectedPath)
			showToast("Path copied: "..selectedPath:sub(1,50), "ok")
		else
			showToast("Select instance first", "warn")
		end
	end)

	local refreshBtn = makeToolBtn("↺", 1,-40, T.TEXT3, function()
		searchQuery = ""
		searchBox.Text = ""
		filterClass = ""
		selectedInst = nil
		selectedPath = ""
		expanded = {}
		for _, svc in ipairs(ROOT_SERVICES) do
			local ok, s = pcall(function() return game:GetService(svc) end)
			if ok and s then expanded[s] = (svc=="Workspace" or svc=="ReplicatedStorage") end
		end
		rebuildTree()
		showToast("Explorer refreshed", "ok")
	end)

	-- ════════════════════════════════════════
	-- [2] FILTER BAR  (Class type quick filters)
	-- ════════════════════════════════════════
	local filterRow = newFrame(explorerPage, {
		BG=Color3.fromRGB(0,0,0), BT=1,
		Size=UDim2.new(1,0,0,24), ZIndex=12,
	})
	filterRow.LayoutOrder = 2
	local filterLL = Instance.new("UIListLayout", filterRow)
	filterLL.FillDirection = Enum.FillDirection.Horizontal
	filterLL.SortOrder = Enum.SortOrder.LayoutOrder
	filterLL.Padding = UDim.new(0,3)
	local filterPad = Instance.new("UIPadding", filterRow)
	filterPad.PaddingLeft = UDim.new(0,8); filterPad.PaddingRight = UDim.new(0,8)
	filterPad.PaddingTop = UDim.new(0,2); filterPad.PaddingBottom = UDim.new(0,2)

	local FILTER_DEFS = {
		{label="All",     class="",             order=1},
		{label="Scripts", class="LocalScript",  order=2},
		{label="Parts",   class="BasePart",     order=3},
		{label="GUIs",    class="GuiObject",    order=4},
		{label="Remotes", class="RemoteEvent", order=5},
	}
	local filterBtns = {}

	local function applyFilter(filterClass_)
		filterClass = filterClass_
		rebuildTree()
		for _, fb in ipairs(filterBtns) do
			local isActive = (filterClass == fb.class)
			tween(fb.btn, {
				BackgroundColor3 = isActive and T.ACCENT or T.SURFACE2,
				TextColor3 = isActive and T.WHITE or T.TEXT3,
			})
		end
	end

	for _, fd in ipairs(FILTER_DEFS) do
		local fb = Instance.new("TextButton", filterRow)
		fb.Size = UDim2.new(0,0,0,18)
		fb.AutomaticSize = Enum.AutomaticSize.X
		fb.Text = fd.label
		fb.TextSize = 9
		fb.Font = Enum.Font.GothamBold
		fb.TextColor3 = fd.order==1 and T.WHITE or T.TEXT3
		fb.BackgroundColor3 = fd.order==1 and T.ACCENT or T.SURFACE2
		fb.BorderSizePixel = 0
		fb.ZIndex = 13
		fb.LayoutOrder = fd.order
		corner(fb, 6)
		stroke(fb, fd.order==1 and T.ACCENT or T.BORDER, 1)

		fb.MouseButton1Click:Connect(function() applyFilter(fd.class) end)
		fb.MouseEnter:Connect(function() tween(fb,{BackgroundColor3=T.GLASS}) end)
		fb.MouseLeave:Connect(function() tween(fb,{BackgroundColor3=filterClass==fd.class and T.ACCENT or T.SURFACE2}) end)

		table.insert(filterBtns, {btn=fb, class=fd.class})
	end

	-- ════════════════════════════════════════
	-- [3] STATS / INFO ROW
	-- ════════════════════════════════════════
	local infoRow = newFrame(explorerPage, {
		BG=Color3.fromRGB(0,0,0), BT=1,
		Size=UDim2.new(1,0,0,16), ZIndex=12,
	})
	infoRow.LayoutOrder = 3
	local infLbl = newLabel(infoRow, {
		Text = "  Ready to explore…",
		Color = T.TEXT3, Size = 9, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(1,0,1,0), ZIndex = 12,
	})
	local infoPad = Instance.new("UIPadding", infLbl)
	infoPad.PaddingLeft = UDim.new(0,8)

	-- ════════════════════════════════════════
	-- [4] TREE CONTAINER
	-- ════════════════════════════════════════
	local treeWrap = newFrame(explorerPage, {
		BG = T.SURFACE,
		Size = UDim2.new(0.6,0,0,10),  -- 60% width (left side)
		ZIndex = 12,
	})
	treeWrap.LayoutOrder = 4
	treeWrap.AutomaticSize = Enum.AutomaticSize.Y
	corner(treeWrap, 10)
	stroke(treeWrap, T.BORDER, 1)

	local treeList = Instance.new("UIListLayout", treeWrap)
	treeList.SortOrder = Enum.SortOrder.LayoutOrder
	treeList.Padding = UDim.new(0,0)
	local treePad = Instance.new("UIPadding", treeWrap)
	treePad.PaddingTop = UDim.new(0,2)
	treePad.PaddingBottom = UDim.new(0,2)

	-- ════════════════════════════════════════
	-- [5] PROPERTIES PANEL  (right side)
	-- ════════════════════════════════════════
	local propWrap = newFrame(explorerPage, {
		BG = T.SURFACE,
		Size = UDim2.new(0.38,-2,0,10),  -- 38% width (right side)
		Position = UDim2.new(0.6,2,0,0),
		ZIndex = 12,
	})
	propWrap.LayoutOrder = 4
	propWrap.AutomaticSize = Enum.AutomaticSize.Y
	corner(propWrap, 10)
	stroke(propWrap, T.BORDER, 1)

	-- Panel header
	local propHeader = newFrame(propWrap, {
		BG=T.SURFACE2,
		Size=UDim2.new(1,0,0,28), ZIndex=13,
	})
	corner(propHeader, 8)
	newLabel(propHeader, {
		Text="⚙  Properties",
		Color=T.TEXT, Size=11, Font=Enum.Font.GothamBold,
		Sz=UDim2.new(1,0,1,0), Position=UDim2.new(0,8,0,0), ZIndex=14,
	})

	-- Content area
	local propContent = Instance.new("ScrollingFrame", propWrap)
	propContent.Size = UDim2.new(1,0,1,-30)
	propContent.Position = UDim2.new(0,0,0,28)
	propContent.BackgroundTransparency = 1
	propContent.BorderSizePixel = 0
	propContent.ScrollBarThickness = 2
	propContent.ScrollBarImageColor3 = T.ACCENT
	propContent.CanvasSize = UDim2.new(0,0,0,0)
	propContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
	propContent.ZIndex = 13

	local propLayout = Instance.new("UIListLayout", propContent)
	propLayout.SortOrder = Enum.SortOrder.LayoutOrder
	propLayout.Padding = UDim.new(0,4)
	local propContentPad = Instance.new("UIPadding", propContent)
	propContentPad.PaddingTop = UDim.new(0,6)
	propContentPad.PaddingBottom = UDim.new(0,6)
	propContentPad.PaddingLeft = UDim.new(0,6)
	propContentPad.PaddingRight = UDim.new(0,6)

	-- Empty state
	local emptyProp = newLabel(propWrap, {
		Text="Select instance\nto view properties",
		Color=T.TEXT3, Size=9,
		Wrapped=true,
		Sz=UDim2.new(1,0,0,36), ZIndex=13,
		AlignX=Enum.TextXAlignment.Center,
		AlignY=Enum.TextYAlignment.Center,
	})
	local emptyOrder = Instance.new("IntValue", emptyProp)
	emptyOrder.Name = "LayoutOrder"
	emptyOrder.Value = 999

	-- ════════════════════════════════════════
	-- [6] RENDER FUNCTIONS
	-- ════════════════════════════════════════
	local nodeOrder = 0

	local function getDisplayPath(inst)
		local parts = {}
		local current = inst
		while current and current ~= game do
			table.insert(parts, 1, current.Name)
			current = current.Parent
		end
		return table.concat(parts, " > ")
	end

	local function matchesFilter(inst)
		if filterClass == "" then return true end
		if inst:IsA(filterClass) then return true end
		return false
	end

	local function clearTree()
		for _,r in ipairs(nodeRows) do
			if r and r.Parent then r:Destroy() end
		end
		nodeRows = {}
	end

	local function showProperties(inst)
		-- Clear content
		for _, c in ipairs(propContent:GetChildren()) do
			if c:IsA("Frame") or c:IsA("TextLabel") then
				c:Destroy()
			end
		end
		emptyProp.Visible = false

		selectedPath = getDisplayPath(inst)

		local ord = 0
		local function o() ord+=1 return ord end

		-- Name & Class
		local nameRow = newFrame(propContent, {
			BG=T.SURFACE2, Size=UDim2.new(1,0,0,28), ZIndex=13,
		})
		nameRow.LayoutOrder = o()
		corner(nameRow, 8)
		newLabel(nameRow, {
			Text="📛 "..inst.ClassName,
			Color=T.ACCENT, Size=10, Font=Enum.Font.GothamBold,
			Sz=UDim2.new(1,-8,0,14), Position=UDim2.new(0,6,0,2), ZIndex=14,
		})
		newLabel(nameRow, {
			Text=inst.Name,
			Color=T.TEXT, Size=10, Font=Enum.Font.Gotham,
			Sz=UDim2.new(1,-8,0,12), Position=UDim2.new(0,6,0,14), ZIndex=14, Truncate=true,
		})

		-- Parent
		if inst.Parent then
			local parentRow = newFrame(propContent, {
				BG=T.SURFACE2, Size=UDim2.new(1,0,0,26), ZIndex=13,
			})
			parentRow.LayoutOrder = o()
			corner(parentRow, 8)
			newLabel(parentRow, {
				Text="🔗 Parent",
				Color=T.TEXT3, Size=9, Font=Enum.Font.GothamBold,
				Sz=UDim2.new(0,60,1,0), Position=UDim2.new(0,6,0,0), ZIndex=14,
			})
			newLabel(parentRow, {
				Text=inst.Parent.Name,
				Color=T.ACCENT, Size=10, Font=Enum.Font.GothamBold,
				Sz=UDim2.new(1,-68,1,0), Position=UDim2.new(0,68,0,0), ZIndex=14, Truncate=true,
			})
		end

		-- Children count
		local childCount = #inst:GetChildren()
		if childCount > 0 then
			local childRow = newFrame(propContent, {
				BG=T.SURFACE2, Size=UDim2.new(1,0,0,26), ZIndex=13,
			})
			childRow.LayoutOrder = o()
			corner(childRow, 8)
			newLabel(childRow, {
				Text="👶 Children",
				Color=T.TEXT3, Size=9, Font=Enum.Font.GothamBold,
				Sz=UDim2.new(0,70,1,0), Position=UDim2.new(0,6,0,0), ZIndex=14,
			})
			newLabel(childRow, {
				Text=tostring(childCount),
				Color=T.SUCCESS, Size=11, Font=Enum.Font.GothamBold,
				Sz=UDim2.new(1,-78,1,0), Position=UDim2.new(0,78,0,0), ZIndex=14,
			})
		end

		-- Script info
		if inst:IsA("LocalScript") or inst:IsA("ModuleScript") then
			local scriptRow = newFrame(propContent, {
				BG=T.SURFACE2, Size=UDim2.new(1,0,0,26), ZIndex=13,
			})
			scriptRow.LayoutOrder = o()
			corner(scriptRow, 8)
			local ok, size = pcall(function() return #inst.Source end)
			newLabel(scriptRow, {
				Text="📝 Size",
				Color=T.TEXT3, Size=9, Font=Enum.Font.GothamBold,
				Sz=UDim2.new(0,40,1,0), Position=UDim2.new(0,6,0,0), ZIndex=14,
			})
			local sizeStr = ok and (size < 1024 and size.." B" or math.floor(size/1024).." KB") or "?"
			newLabel(scriptRow, {
				Text=sizeStr,
				Color=T.TEXT, Size=10,
				Sz=UDim2.new(1,-48,1,0), Position=UDim2.new(0,48,0,0), ZIndex=14,
			})
		end

		-- Enabled state
		if inst:FindFirstChildOfClass("LocalScript") or inst:IsA("LocalScript") then
			local enabledRow = newFrame(propContent, {
				BG=T.SURFACE2, Size=UDim2.new(1,0,0,26), ZIndex=13,
			})
			enabledRow.LayoutOrder = o()
			corner(enabledRow, 8)
			newLabel(enabledRow, {
				Text="▶ Enabled",
				Color=T.TEXT3, Size=9, Font=Enum.Font.GothamBold,
				Sz=UDim2.new(0,60,1,0), Position=UDim2.new(0,6,0,0), ZIndex=14,
			})
			local status = inst.Enabled and "✓ YES" or "✗ NO"
			local statusColor = inst.Enabled and T.SUCCESS or T.WARN
			newLabel(enabledRow, {
				Text=status,
				Color=statusColor, Size=10, Font=Enum.Font.GothamBold,
				Sz=UDim2.new(1,-68,1,0), Position=UDim2.new(0,68,0,0), ZIndex=14,
			})
		end

		-- Custom Properties (BasePart)
		if inst:IsA("BasePart") then
			-- Position
			local pos = inst.Position
			local posRow = newFrame(propContent, {
				BG=T.SURFACE2, Size=UDim2.new(1,0,0,26), ZIndex=13,
			})
			posRow.LayoutOrder = o()
			corner(posRow, 8)
			newLabel(posRow, {
				Text="📍 Position",
				Color=T.TEXT3, Size=9, Font=Enum.Font.GothamBold,
				Sz=UDim2.new(0,70,1,0), Position=UDim2.new(0,6,0,0), ZIndex=14,
			})
			newLabel(posRow, {
				Text=string.format("(%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z),
				Color=T.TEXT, Size=9, Font=Enum.Font.Code,
				Sz=UDim2.new(1,-78,1,0), Position=UDim2.new(0,78,0,0), ZIndex=14, Truncate=true,
			})

			-- Size
			local siz = inst.Size
			local sizRow = newFrame(propContent, {
				BG=T.SURFACE2, Size=UDim2.new(1,0,0,26), ZIndex=13,
			})
			sizRow.LayoutOrder = o()
			corner(sizRow, 8)
			newLabel(sizRow, {
				Text="📐 Size",
				Color=T.TEXT3, Size=9, Font=Enum.Font.GothamBold,
				Sz=UDim2.new(0,60,1,0), Position=UDim2.new(0,6,0,0), ZIndex=14,
			})
			newLabel(sizRow, {
				Text=string.format("(%.1f, %.1f, %.1f)", siz.X, siz.Y, siz.Z),
				Color=T.TEXT, Size=9, Font=Enum.Font.Code,
				Sz=UDim2.new(1,-68,1,0), Position=UDim2.new(0,68,0,0), ZIndex=14, Truncate=true,
			})

			-- Material
			local matRow = newFrame(propContent, {
				BG=T.SURFACE2, Size=UDim2.new(1,0,0,26), ZIndex=13,
			})
			matRow.LayoutOrder = o()
			corner(matRow, 8)
			newLabel(matRow, {
				Text="✨ Material",
				Color=T.TEXT3, Size=9, Font=Enum.Font.GothamBold,
				Sz=UDim2.new(0,70,1,0), Position=UDim2.new(0,6,0,0), ZIndex=14,
			})
			newLabel(matRow, {
				Text=tostring(inst.Material):gsub("Enum.Material.", ""),
				Color=T.TEXT, Size=9,
				Sz=UDim2.new(1,-78,1,0), Position=UDim2.new(0,78,0,0), ZIndex=14, Truncate=true,
			})
		end

		-- Copy Path Button
		local copyRowBtn = Instance.new("TextButton", propContent)
		copyRowBtn.Size = UDim2.new(1,-12,0,28)
		copyRowBtn.Text = "📋 Copy Full Path"
		copyRowBtn.TextSize = 10
		copyRowBtn.Font = Enum.Font.GothamBold
		copyRowBtn.TextColor3 = T.WHITE
		copyRowBtn.BackgroundColor3 = T.ACCENT
		copyRowBtn.BorderSizePixel = 0
		copyRowBtn.ZIndex = 14
		local copyRowOrder = Instance.new("IntValue", copyRowBtn)
		copyRowOrder.Name = "LayoutOrder"
		copyRowOrder.Value = o()
		corner(copyRowBtn, 8)
		copyRowBtn.MouseEnter:Connect(function() tween(copyRowBtn,{BackgroundColor3=T.ACCENT2}) end)
		copyRowBtn.MouseLeave:Connect(function() tween(copyRowBtn,{BackgroundColor3=T.ACCENT}) end)
		copyRowBtn.MouseButton1Click:Connect(function()
			copyText(selectedPath)
			showToast("Path copied!", "ok")
		end)
	end

	local function renderNode(inst, depth, parentVisible)
		if not inst then return end

		local children = inst:GetChildren()
		local hasChildren = #children > 0
		local isExpanded = expanded[inst] == true

		-- Search filter
		local name = inst.Name
		local matchesSearch = (searchQuery == "" or name:lower():find(searchQuery:lower(), 1, true))
		local visible = parentVisible and matchesSearch and matchesFilter(inst)

		nodeOrder += 1
		local row = Instance.new("TextButton", treeWrap)
		row.Size = UDim2.new(1,0,0,26)
		row.BackgroundColor3 = selectedInst == inst and T.ACCENT or
			(depth % 2 == 0 and T.SURFACE or T.SURFACE2)
		row.BackgroundTransparency = selectedInst == inst and 0 or 0.3
		row.Text = ""
		row.BorderSizePixel = 0
		row.ZIndex = 13
		row.LayoutOrder = nodeOrder
		row.Visible = visible

		table.insert(nodeRows, row)

		-- Indent lines
		if depth > 0 then
			for d = 1, depth do
				local lineColor = (d == depth) and T.BORDER2 or T.BORDER
				local lineBT = (d == depth) and 0 or 0.5
				newFrame(row, {
					BG=lineColor, BT=lineBT,
					Size=UDim2.new(0,1,1,0),
					Position=UDim2.new(0, 8 + (d-1)*14, 0, 0),
					ZIndex=13,
				})
			end
		end

		local indentX = 8 + depth * 14

		-- Expand arrow
		local arrowLbl = newLabel(row, {
			Text = hasChildren and (isExpanded and "▾" or "▸") or " ",
			Color = hasChildren and T.ACCENT or T.TEXT3,
			Size = 10, Font = Enum.Font.GothamBold,
			Sz = UDim2.new(0,14,1,0),
			Position = UDim2.new(0, indentX, 0, 0),
			AlignX = Enum.TextXAlignment.Center,
			ZIndex = 14,
		})

		-- Class icon
		newLabel(row, {
			Text = getIcon(inst),
			Color = T.TEXT2, Size = 11,
			Sz = UDim2.new(0,18,1,0),
			Position = UDim2.new(0, indentX+15, 0, 0),
			AlignX = Enum.TextXAlignment.Center,
			ZIndex = 14,
		})

		-- Name
		local nameLbl = newLabel(row, {
			Text = name,
			Color = selectedInst == inst and T.WHITE or T.TEXT,
			Size = 11,
			Font = selectedInst == inst and Enum.Font.GothamBold or Enum.Font.Gotham,
			Sz = UDim2.new(1, -(indentX+54), 1, 0),
			Position = UDim2.new(0, indentX+34, 0, 0),
			ZIndex = 14,
			Truncate = true,
		})

		-- Child count badge (nếu có)
		if hasChildren then
			local badge = newFrame(row, {
				BG = T.SURFACE2, BT = 0.2,
				Size = UDim2.new(0,0,0,14),
				Position = UDim2.new(1,-4,0.5,-7),
				ZIndex = 14,
			})
			corner(badge, 5)
			local badgeLbl = newLabel(badge, {
				Text = tostring(#children),
				Color = T.ACCENT3, Size = 8, Font = Enum.Font.GothamBold,
				Sz = UDim2.new(0,10,1,0),
				Position = UDim2.new(0,2,0,0),
				AlignX = Enum.TextXAlignment.Center,
				ZIndex = 15,
			})
			badgeLbl.AutomaticSize = Enum.AutomaticSize.X
		end

		-- Hover
		row.MouseEnter:Connect(function()
			if selectedInst ~= inst then
				tween(row, {BackgroundTransparency=0.1, BackgroundColor3=T.GLASS})
			end
		end)
		row.MouseLeave:Connect(function()
			if selectedInst ~= inst then
				tween(row, {BackgroundTransparency=0.3})
			end
		end)

		-- Click
		local lastClick = 0
		row.MouseButton1Click:Connect(function()
			local now = tick()
			if now - lastClick < 0.3 then
				-- Double-click: toggle expand
				if hasChildren then expanded[inst] = not expanded[inst] end
			else
				-- Single click: select
				selectedInst = inst
				showProperties(inst)
			end
			lastClick = now
			task.defer(rebuildTree)
		end)

		return isExpanded, children
	end

	-- ── Full rebuild ──
	function rebuildTree()
		clearTree()
		nodeOrder = 0
		local totalCount = 0
		local visibleCount = 0

		local function renderBranch(inst, depth)
			totalCount += 1
			local isExp, children = renderNode(inst, depth, true)
			if isExp and children then
				table.sort(children, function(a,b)
					local aIsFolder = a:IsA("Folder") or #a:GetChildren()>0
					local bIsFolder = b:IsA("Folder") or #b:GetChildren()>0
					if aIsFolder ~= bIsFolder then return aIsFolder end
					return a.Name < b.Name
				end)
				for _, child in ipairs(children) do
					renderBranch(child, depth+1)
				end
			end
		end

		for _, svcName in ipairs(ROOT_SERVICES) do
			local ok, svc = pcall(function() return game:GetService(svcName) end)
			if ok and svc then renderBranch(svc, 0) end
		end

		infLbl.Text = "  "..totalCount.." instances"..
			(selectedInst and "   |   "..selectedInst.ClassName.." / "..selectedInst.Name or "")
	end

	-- ── Search ──
	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		searchQuery = searchBox.Text
		task.defer(rebuildTree)
	end)

	-- Init
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
-- ★ PAGE: SCRIPTS  (Quick Script Runner + Library)
-- ══════════════════════════════════════════
local scriptsPage, _ = makePage("Scripts")

do
	-- ════════════════════════════════════════
	-- Script Library Storage
	-- ════════════════════════════════════════
	local SCRIPT_LIBRARY_KEY = "_NovaScriptLib"
	local scriptLibrary = _G[SCRIPT_LIBRARY_KEY] or {}

	-- Hàm lưu library
	local function saveLibrary()
		_G[SCRIPT_LIBRARY_KEY] = scriptLibrary
	end

	-- ── DANH SÁCH SCRIPT MẪU ──
	local PRESET_SCRIPTS = {
		{
			name = "Fly",
			desc = "Bay tự do với WASD + Space",
			code = [[
-- Nova Fly Script
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local flySpeed = 50
local flying = false
local conn = nil

local function toggleFly()
    flying = not flying
    if flying then
        local bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
        bg.D = 100
        bg.P = 10000
        
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        bv.Velocity = Vector3.zero
        
        conn = game:GetService("RunService").RenderStepped:Connect(function()
            if not flying then return end
            local cam = workspace.CurrentCamera
            local dir = Vector3.zero
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
            bv.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
            bg.CFrame = cam.CFrame
        end)
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h.PlatformStand = true end
        print("Fly ON")
    else
        if conn then conn:Disconnect(); conn = nil end
        if root then
            local bg2 = root:FindFirstChild("BodyGyro")
            local bv2 = root:FindFirstChild("BodyVelocity")
            if bg2 then bg2:Destroy() end
            if bv2 then bv2:Destroy() end
        end
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h.PlatformStand = false end
        print("Fly OFF")
    end
end

toggleFly()
]]
		},
		{
			name = "NoClip",
			desc = "Đi xuyên tường",
			code = [[
-- Nova NoClip Script
local player = game.Players.LocalPlayer
local running = false
local conn = nil

local function toggleNoClip()
    running = not running
    if running then
        conn = game:GetService("RunService").Stepped:Connect(function()
            if player.Character then
                for _, p in ipairs(player.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
        print("NoClip ON")
    else
        if conn then conn:Disconnect(); conn = nil end
        if player.Character then
            for _, p in ipairs(player.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
        print("NoClip OFF")
    end
end

toggleNoClip()
]]
		},
		{
			name = "Speed Boost",
			desc = "Tăng tốc gấp 3",
			code = [[
-- Nova Speed Boost Script
local player = game.Players.LocalPlayer
local char = player.Character
if not char then print("Character not found"); return end
local hum = char:FindFirstChildOfClass("Humanoid")
if not hum then print("Humanoid not found"); return end
local current = hum.WalkSpeed
hum.WalkSpeed = current > 32 and 16 or current * 3
print("Speed: " .. hum.WalkSpeed)
]]
		},
		{
			name = "Auto Heal",
			desc = "Tự hồi máu 5HP/s",
			code = [[
-- Nova Auto Heal Script
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local running = false
local conn = nil

local function toggleHeal()
    running = not running
    if running then
        conn = game:GetService("RunService").Heartbeat:Connect(function(dt)
            if hum and hum.Health < hum.MaxHealth then
                hum.Health = math.min(hum.Health + dt * 5, hum.MaxHealth)
            end
        end)
        print("Auto Heal ON")
    else
        if conn then conn:Disconnect(); conn = nil end
        print("Auto Heal OFF")
    end
end

toggleHeal()
]]
		},
		{
			name = "Anti-AFK",
			desc = "Tránh bị kick AFK",
			code = [[
-- Nova Anti-AFK Script
local running = false

local function toggleAFK()
    running = not running
    if running then
        game:GetService("RunService").Heartbeat:Connect(function()
            if running then
                pcall(function()
                    local vu = game:GetService("VirtualUser")
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new())
                end)
            end
        end)
        print("Anti-AFK ON")
    else
        print("Anti-AFK OFF")
    end
end

toggleAFK()
]]
		},
	}

	-- ════════════════════════════════════════
	-- UI: Header + Quick Run
	-- ════════════════════════════════════════

	-- Quick Run Card
	local quickCard = makeCard(scriptsPage, 90, 1)
	gradient(quickCard, Color3.fromRGB(20, 20, 44), Color3.fromRGB(14, 14, 28), 135)

	newLabel(quickCard, {
		Text = "⚡ Quick Script Runner",
		Color = T.WHITE, Size = 14, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(1, -20, 0, 22),
		Position = UDim2.new(0, 12, 0, 6), ZIndex = 13,
	})
	newLabel(quickCard, {
		Text = "Nhập script hoặc chọn từ thư viện bên dưới",
		Color = T.TEXT3, Size = 10,
		Sz = UDim2.new(1, -20, 0, 16),
		Position = UDim2.new(0, 12, 0, 28), ZIndex = 13,
	})

	-- Editor area
	local codeEditor = Instance.new("TextBox", quickCard)
	codeEditor.Size = UDim2.new(1, -100, 0, 36)
	codeEditor.Position = UDim2.new(0, 10, 0.58, -14)
	codeEditor.BackgroundColor3 = Color3.fromRGB(6, 6, 12)
	codeEditor.BorderSizePixel = 0
	codeEditor.TextColor3 = T.SUCCESS
	codeEditor.PlaceholderText = "-- Nhập Lua script của bạn..."
	codeEditor.PlaceholderColor3 = T.TEXT3
	codeEditor.Text = ""
	codeEditor.TextSize = 10
	codeEditor.Font = Enum.Font.Code
	codeEditor.ClearTextOnFocus = false
	codeEditor.MultiLine = true
	codeEditor.ZIndex = 13
	corner(codeEditor, 8)
	stroke(codeEditor, T.BORDER, 1)
	local cePad = Instance.new("UIPadding", codeEditor)
	cePad.PaddingLeft = UDim.new(0, 8)
	cePad.PaddingTop = UDim.new(0, 4)

	-- Run button
	local runBtn = Instance.new("TextButton", quickCard)
	runBtn.Size = UDim2.new(0, 80, 0, 36)
	runBtn.Position = UDim2.new(1, -90, 0.58, -14)
	runBtn.Text = "▶  Run"
	runBtn.TextSize = 12
	runBtn.Font = Enum.Font.GothamBold
	runBtn.TextColor3 = T.WHITE
	runBtn.BackgroundColor3 = T.SUCCESS
	runBtn.BorderSizePixel = 0
	runBtn.ZIndex = 13
	corner(runBtn, 8)

	runBtn.MouseEnter:Connect(function() tween(runBtn, {BackgroundColor3=Color3.fromRGB(50, 220, 100)}) end)
	runBtn.MouseLeave:Connect(function() tween(runBtn, {BackgroundColor3=T.SUCCESS}) end)

	-- Save to Library button
	local saveLibBtn = Instance.new("TextButton", quickCard)
	saveLibBtn.Size = UDim2.new(0, 60, 0, 22)
	saveLibBtn.Position = UDim2.new(1, -58, 0, 4)
	saveLibBtn.Text = "💾 Save"
	saveLibBtn.TextSize = 9
	saveLibBtn.Font = Enum.Font.GothamBold
	saveLibBtn.TextColor3 = T.ACCENT
	saveLibBtn.BackgroundColor3 = T.SURFACE2
	saveLibBtn.BorderSizePixel = 0
	saveLibBtn.ZIndex = 13
	corner(saveLibBtn, 6)
	stroke(saveLibBtn, T.ACCENT, 1)

	-- Script name input
	local scriptNameBox = Instance.new("TextBox", quickCard)
	scriptNameBox.Size = UDim2.new(0, 120, 0, 22)
	scriptNameBox.Position = UDim2.new(0, 10, 0, 4)
	scriptNameBox.BackgroundColor3 = T.SURFACE2
	scriptNameBox.BorderSizePixel = 0
	scriptNameBox.TextColor3 = T.TEXT
	scriptNameBox.PlaceholderText = "Tên script..."
	scriptNameBox.PlaceholderColor3 = T.TEXT3
	scriptNameBox.Text = ""
	scriptNameBox.TextSize = 9
	scriptNameBox.Font = Enum.Font.Gotham
	scriptNameBox.ClearTextOnFocus = false
	scriptNameBox.ZIndex = 13
	corner(scriptNameBox, 6)
	stroke(scriptNameBox, T.BORDER, 1)
	local snPad = Instance.new("UIPadding", scriptNameBox)
	snPad.PaddingLeft = UDim.new(0, 6)

	-- ── Run function ──
	local function runScript(code)
		if code == "" then
			showToast("Script trống!", "warn")
			return
		end
		local fn, err = loadstring(code)
		if fn then
			local ok, result = pcall(fn)
			if not ok then
				showToast("Lỗi: " .. tostring(result):sub(1, 40), "err")
			else
				showToast("✓ Script đã chạy", "ok")
			end
		else
			showToast("Lỗi syntax: " .. tostring(err):sub(1, 40), "err")
		end
	end

	runBtn.MouseButton1Click:Connect(function()
		runScript(codeEditor.Text)
	end)

	saveLibBtn.MouseButton1Click:Connect(function()
		local name = scriptNameBox.Text
		local code = codeEditor.Text
		if name == "" then showToast("Nhập tên script!", "warn"); return end
		if code == "" then showToast("Script trống!", "warn"); return end
		scriptLibrary[name] = code
		saveLibrary()
		showToast("✓ Đã lưu: " .. name, "ok")
		rebuildLibrary()
	end)

	-- ════════════════════════════════════════
	-- SECTION: SCRIPT LIBRARY
	-- ════════════════════════════════════════
	makeSectionLabel(scriptsPage, "📚 Script Library", 2)

	-- Library toolbar
	local libToolbar = newFrame(scriptsPage, {
		BG = Color3.fromRGB(0,0,0), BT = 1,
		Size = UDim2.new(1, 0, 0, 28), ZIndex = 12,
	})
	libToolbar.LayoutOrder = 3

	local libToolLayout = Instance.new("UIListLayout", libToolbar)
	libToolLayout.FillDirection = Enum.FillDirection.Horizontal
	libToolLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	libToolLayout.Padding = UDim.new(0, 6)
	local ltPad = Instance.new("UIPadding", libToolbar)
	ltPad.PaddingLeft = UDim.new(0, 8)
	ltPad.PaddingTop = UDim.new(0, 2)

	-- Preset button
	local presetBtn = Instance.new("TextButton", libToolbar)
	presetBtn.Size = UDim2.new(0, 70, 0, 22)
	presetBtn.Text = "📦 Presets"
	presetBtn.TextSize = 9
	presetBtn.Font = Enum.Font.GothamBold
	presetBtn.TextColor3 = T.ACCENT
	presetBtn.BackgroundColor3 = T.SURFACE2
	presetBtn.BorderSizePixel = 0
	presetBtn.ZIndex = 13
	corner(presetBtn, 6)
	stroke(presetBtn, T.ACCENT, 1)

	-- Export button
	local exportLibBtn = Instance.new("TextButton", libToolbar)
	exportLibBtn.Size = UDim2.new(0, 70, 0, 22)
	exportLibBtn.Text = "📋 Export All"
	exportLibBtn.TextSize = 9
	exportLibBtn.Font = Enum.Font.GothamBold
	exportLibBtn.TextColor3 = T.TEXT3
	exportLibBtn.BackgroundColor3 = T.SURFACE2
	exportLibBtn.BorderSizePixel = 0
	exportLibBtn.ZIndex = 13
	corner(exportLibBtn, 6)
	stroke(exportLibBtn, T.BORDER, 1)

	-- Clear button
	local clearLibBtn = Instance.new("TextButton", libToolbar)
	clearLibBtn.Size = UDim2.new(0, 60, 0, 22)
	clearLibBtn.Text = "🗑 Clear"
	clearLibBtn.TextSize = 9
	clearLibBtn.Font = Enum.Font.GothamBold
	clearLibBtn.TextColor3 = T.DANGER
	clearLibBtn.BackgroundColor3 = T.SURFACE2
	clearLibBtn.BorderSizePixel = 0
	clearLibBtn.ZIndex = 13
	corner(clearLibBtn, 6)
	stroke(clearLibBtn, T.DANGER, 1)

	-- Library list container
	local libContainer = newFrame(scriptsPage, {
		BG = Color3.fromRGB(0,0,0), BT = 1,
		Size = UDim2.new(1, 0, 0, 10), ZIndex = 12,
	})
	libContainer.LayoutOrder = 4
	libContainer.AutomaticSize = Enum.AutomaticSize.Y
	corner(libContainer, 10)
	stroke(libContainer, T.BORDER, 1)

	local libList = Instance.new("UIListLayout", libContainer)
	libList.SortOrder = Enum.SortOrder.LayoutOrder
	libList.Padding = UDim.new(0, 1)
	local libPad = Instance.new("UIPadding", libContainer)
	libPad.PaddingTop = UDim.new(0, 4)
	libPad.PaddingBottom = UDim.new(0, 4)

	local emptyLibLbl = newLabel(libContainer, {
		Text = "📭 Chưa có script nào. Nhấn 💾 Save để lưu!",
		Color = T.TEXT3, Size = 10,
		Sz = UDim2.new(1, 0, 0, 32), ZIndex = 13,
		AlignX = Enum.TextXAlignment.Center,
	})
	emptyLibLbl.LayoutOrder = 9999

	-- Hàm rebuild library
	local libRows = {}

	function rebuildLibrary()
		for _, r in ipairs(libRows) do
			if r and r.Parent then r:Destroy() end
		end
		libRows = {}

		local names = {}
		for name, _ in pairs(scriptLibrary) do
			table.insert(names, name)
		end
		table.sort(names)

		if #names == 0 then
			emptyLibLbl.Visible = true
			return
		end
		emptyLibLbl.Visible = false

		for i, name in ipairs(names) do
			local code = scriptLibrary[name]
			local row = newFrame(libContainer, {
				BG = i % 2 == 0 and T.SURFACE2 or T.SURFACE,
				BT = 0.2,
				Size = UDim2.new(1, 0, 0, 32), ZIndex = 13,
			})
			row.LayoutOrder = i
			corner(row, 6)

			-- Name
			newLabel(row, {
				Text = name,
				Color = T.TEXT, Size = 10, Font = Enum.Font.GothamBold,
				Sz = UDim2.new(0.4, -10, 1, 0),
				Position = UDim2.new(0, 10, 0, 0), ZIndex = 14, Truncate = true,
			})

			-- Size info
			local sizeKB = math.floor(#code / 1024 * 10) / 10
			newLabel(row, {
				Text = sizeKB < 1 and "~" .. #code .. "B" or sizeKB .. "KB",
				Color = T.TEXT3, Size = 8,
				Sz = UDim2.new(0.2, 0, 1, 0),
				Position = UDim2.new(0.4, 0, 0, 0), ZIndex = 14,
			})

			-- Run button
			local runLibBtn = Instance.new("TextButton", row)
			runLibBtn.Size = UDim2.new(0, 40, 0, 22)
			runLibBtn.AnchorPoint = Vector2.new(1, 0.5)
			runLibBtn.Position = UDim2.new(0.8, -4, 0.5, 0)
			runLibBtn.Text = "▶ Run"
			runLibBtn.TextSize = 8
			runLibBtn.Font = Enum.Font.GothamBold
			runLibBtn.TextColor3 = T.SUCCESS
			runLibBtn.BackgroundColor3 = T.SURFACE2
			runLibBtn.BorderSizePixel = 0
			runLibBtn.ZIndex = 14
			corner(runLibBtn, 5)
			stroke(runLibBtn, T.SUCCESS, 1)

			runLibBtn.MouseButton1Click:Connect(function()
				runScript(code)
				-- Ghi đè vào editor để xem
				codeEditor.Text = code
				scriptNameBox.Text = name
			end)

			-- Delete button
			local delLibBtn = Instance.new("TextButton", row)
			delLibBtn.Size = UDim2.new(0, 28, 0, 22)
			delLibBtn.AnchorPoint = Vector2.new(1, 0.5)
			delLibBtn.Position = UDim2.new(0.98, -2, 0.5, 0)
			delLibBtn.Text = "✕"
			delLibBtn.TextSize = 10
			delLibBtn.Font = Enum.Font.GothamBold
			delLibBtn.TextColor3 = T.DANGER
			delLibBtn.BackgroundColor3 = T.SURFACE2
			delLibBtn.BorderSizePixel = 0
			delLibBtn.ZIndex = 14
			corner(delLibBtn, 5)
			stroke(delLibBtn, T.DANGER, 1)

			delLibBtn.MouseButton1Click:Connect(function()
				scriptLibrary[name] = nil
				saveLibrary()
				showToast("Đã xóa: " .. name, "warn")
				rebuildLibrary()
			end)

			table.insert(libRows, row)
		end
	end

	-- ════════════════════════════════════════
	-- BUTTON HANDLERS
	-- ════════════════════════════════════════

	-- Preset button
	local presetMenuOpen = false
	presetBtn.MouseButton1Click:Connect(function()
		presetMenuOpen = not presetMenuOpen
		if presetMenuOpen then
			-- Show presets
			for i, preset in ipairs(PRESET_SCRIPTS) do
				local pBtn = Instance.new("TextButton", libToolbar)
				pBtn.Size = UDim2.new(0, 0, 0, 22)
				pBtn.AutomaticSize = Enum.AutomaticSize.X
				pBtn.Text = preset.name
				pBtn.TextSize = 9
				pBtn.Font = Enum.Font.GothamBold
				pBtn.TextColor3 = T.TEXT3
				pBtn.BackgroundColor3 = T.SURFACE2
				pBtn.BorderSizePixel = 0
				pBtn.ZIndex = 14
				pBtn.LayoutOrder = 100 + i
				corner(pBtn, 5)
				stroke(pBtn, T.BORDER, 1)

				pBtn.MouseButton1Click:Connect(function()
					codeEditor.Text = preset.code
					scriptNameBox.Text = preset.name
					showToast("Loaded: " .. preset.name, "ok")
					presetMenuOpen = false
					rebuildLibrary()
				end)

				-- Tự động xóa sau khi click
				local function cleanup()
					for _, c in ipairs(libToolbar:GetChildren()) do
						if c:IsA("TextButton") and c ~= presetBtn and c ~= exportLibBtn and c ~= clearLibBtn then
							c:Destroy()
						end
					end
				end
				-- Xóa khi click vào bất kỳ đâu khác
				pBtn.MouseLeave:Connect(function()
					task.wait(2)
					if presetMenuOpen then
						presetMenuOpen = false
						cleanup()
					end
				end)
			end
		else
			-- Remove preset buttons
			for _, c in ipairs(libToolbar:GetChildren()) do
				if c:IsA("TextButton") and c ~= presetBtn and c ~= exportLibBtn and c ~= clearLibBtn then
					c:Destroy()
				end
			end
		end
	end)

	-- Export all
	exportLibBtn.MouseButton1Click:Connect(function()
		local names = {}
		for name, _ in pairs(scriptLibrary) do
			table.insert(names, name)
		end
		if #names == 0 then showToast("Không có script nào!", "warn"); return end
		table.sort(names)
		local output = "-- Nova Script Library Export\n-- " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n"
		for _, name in ipairs(names) do
			output = output .. "-- " .. name .. "\n" .. scriptLibrary[name] .. "\n\n"
		end
		copyText(output)
		showToast("✓ Đã copy " .. #names .. " scripts", "ok")
	end)

	-- Clear all
	clearLibBtn.MouseButton1Click:Connect(function()
		scriptLibrary = {}
		saveLibrary()
		showToast("Đã xóa toàn bộ library", "warn")
		rebuildLibrary()
	end)

	-- ════════════════════════════════════════
	-- KEYBIND: Ctrl+Enter để chạy script
	-- ════════════════════════════════════════
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter then
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
				if pages["Scripts"] and pages["Scripts"].Visible then
					runScript(codeEditor.Text)
				end
			end
		end
	end)

	-- ════════════════════════════════════════
	-- INIT
	-- ════════════════════════════════════════
	local scriptsInited = false
	local function initScripts()
		if scriptsInited then return end
		scriptsInited = true
		rebuildLibrary()
	end

	pageCallbacks = pageCallbacks or {}
	pageCallbacks["Scripts"] = initScripts
end

-- ══════════════════════════════════════════
-- ★ PAGE: COMBAT  —  PRO AIMBOT SYSTEM v3 (ULTIMATE)
-- ══════════════════════════════════════════
-- NÂNG CẤP TOÀN DIỆN: 
-- + Aimbot với nhiều chế độ (Head/Neck/Chest/Body)
-- + Triggerbot thông minh (Visible Check, Delay)
-- + ESP Pro (Box, Health, Name, Distance, Skeleton, Tracer, Corner Box)
-- + Silent Aim (không xoay camera)
-- + RCS (Recoil Control System)
-- + FOV Circle với animation
-- + Target Priority (Closest/Lowest HP/Farthest)
-- + Prediction (đoán hướng di chuyển)
-- + Hitbox Expander
-- + Auto Wallbang
-- + Anti-Aim (chống bị aim)

local combatPage, _ = makePage("Combat")

do
	-- ════════════════════════════════════════
	-- STATE (NÂNG CẤP v3)
	-- ════════════════════════════════════════
	local combatState = {
		-- Main
		aimbotEnabled   = false,
		silentAim       = false,
		triggerBot      = false,
		showESP         = false,

		-- Aimbot Settings
		fov             = 120,
		smoothness      = 5,
		targetTeam      = "enemy",
		aimPart         = "Head",
		triggerDelay    = 0.15,
		visibleCheck    = true,
		wallbang        = false,

		-- NÂNG CẤP v3
		showFOVCircle   = true,
		targetPriority  = "closest",
		prediction      = true,
		predictionAmount = 0.3,
		rcsEnabled      = false,
		rcsAmount       = 0.5,
		showSkeleton    = false,
		showDistance    = true,
		espBoxColor     = T.DANGER,
		espHealthColor  = true,
		aimbotKey       = "MouseButton2",
		holdAim         = false,
		drawLineToTarget = false,

		-- MỚI v3
		showCornerBox   = false,
		showTracer      = false,
		showHealthBar   = true,
		showNameTag     = true,
		hitboxSize      = 1.0,
		autoWallbang    = false,
		antiAim         = false,
		antiAimAngle    = 180,
		triggerKey      = "MouseButton1",
		triggerVisible  = true,
		burstCount      = 3,
		burstDelay      = 0.1,
		shootMode       = "single",
		targetLock      = false,
	}

	local aimbotConn = nil
	local triggerConn = nil
	local espConn = nil
	local fovCircle = nil
	local fovCircleAnim = 0
	local currentTarget = nil
	local espObjects = {}
	local burstCount = 0
	local recoilOffset = Vector2.new(0, 0)
	local targetLocked = nil

	-- ════════════════════════════════════════
	-- HELPERS NÂNG CẤP
	-- ════════════════════════════════════════

	local function isAlive(plr)
		local char = plr.Character
		if not char then return false end
		local hum = char:FindFirstChildOfClass("Humanoid")
		return hum and hum.Health > 0
	end

	local function getAimPart(plr)
		local char = plr.Character
		if not char then return nil end

		local parts = {
			Head = "Head",
			Neck = "Neck",
			Chest = "UpperTorso",
			Body = "HumanoidRootPart",
			RightArm = "RightArm",
			LeftArm = "LeftArm",
			RightLeg = "RightLeg",
			LeftLeg = "LeftLeg",
			-- MỚI: Hitbox mở rộng
			HeadEx = "Head",
			ChestEx = "UpperTorso",
		}

		local partName = parts[combatState.aimPart] or "Head"
		local part = char:FindFirstChild(partName)

		-- Hitbox expander
		if part and combatState.hitboxSize > 1 then
			return {
				Position = part.Position,
				Size = part.Size * combatState.hitboxSize,
				CFrame = part.CFrame,
				IsExpanded = true
			}
		end
		return part
	end

	local function getVelocity(plr)
		local char = plr.Character
		if not char then return Vector3.new() end
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			return root.AssemblyLinearVelocity
		end
		return Vector3.new()
	end

	local function getHealth(plr)
		local char = plr.Character
		if not char then return 0 end
		local hum = char:FindFirstChildOfClass("Humanoid")
		return hum and hum.Health or 0
	end

	local function getMaxHealth(plr)
		local char = plr.Character
		if not char then return 100 end
		local hum = char:FindFirstChildOfClass("Humanoid")
		return hum and hum.MaxHealth or 100
	end

	-- NÂNG CẤP: Raycast với hitbox
	local function isVisible(part, checkHitbox)
		if not combatState.visibleCheck then return true end
		local cam = workspace.CurrentCamera
		if not cam then return true end

		local origin = cam.CFrame.Position
		local targetPos = part.Position
		if part.IsExpanded then
			-- Kiểm tra với hitbox mở rộng
			local dir = (targetPos - origin).Unit
			local distances = {}
			local checks = {
				Vector3.new(0,0,0),
				Vector3.new(0.5,0,0),
				Vector3.new(-0.5,0,0),
				Vector3.new(0,0.5,0),
				Vector3.new(0,-0.5,0),
			}
			for _, offset in ipairs(checks) do
				local checkPos = targetPos + offset * part.Size * 0.5
				local ray = Ray.new(origin, (checkPos - origin).Unit * 500)
				local hit = workspace:FindPartOnRay(ray, Player.Character)
				if hit then
					local parent = hit.Parent
					if parent == Player.Character then return true end
					if parent and (parent:IsA("Model") or parent:IsA("BasePart")) then
						local hum = parent:FindFirstChildOfClass("Humanoid")
						if hum then return true end
					end
				end
			end
			return false
		end

		local direction = (targetPos - origin).Unit * 500
		local ray = Ray.new(origin, direction)

		local hit = workspace:FindPartOnRay(ray, Player.Character)
		if hit then
			local parent = hit.Parent
			if parent == Player.Character then return true end
			if parent and (parent:IsA("Model") or parent:IsA("BasePart")) then
				local hum = parent:FindFirstChildOfClass("Humanoid")
				if hum then return true end
			end
			return false
		end
		return true
	end

	-- ════════════════════════════════════════
	-- TARGET PRIORITY (NÂNG CẤP)
	-- ════════════════════════════════════════

	local function getTargetPriority(plr)
		local char = plr.Character
		if not char then return -math.huge end

		local cam = workspace.CurrentCamera
		if not cam then return -math.huge end

		local part = getAimPart(plr)
		if not part then return -math.huge end

		local targetPos = part.Position
		if part.IsExpanded then
			targetPos = part.Position
		end

		local pos, onScreen = cam:WorldToViewportPoint(targetPos)
		if not onScreen then return -math.huge end

		local center = cam.ViewportSize / 2
		local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
		local hp = getHealth(plr)
		local maxHp = getMaxHealth(plr)
		local hpRatio = hp / maxHp

		if combatState.targetPriority == "closest" then
			return -dist * 100 + (1 - hpRatio) * 10
		elseif combatState.targetPriority == "lowest_hp" then
			return (1 - hpRatio) * 1000 - dist
		elseif combatState.targetPriority == "farthest" then
			return dist * 100 + (1 - hpRatio) * 10
		elseif combatState.targetPriority == "closest_cross" then
			return -dist * 1000 + (1 - hpRatio) * 5
		end
		return -dist
	end

	local function getBestTarget()
		local cam = workspace.CurrentCamera
		if not cam then return nil end

		if combatState.targetLock and targetLocked and isAlive(targetLocked) then
			return targetLocked
		end

		local best = nil
		local bestPriority = -math.huge

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= Player and isAlive(plr) then
				if combatState.targetTeam == "enemy" and plr.Team and Player.Team and plr.Team == Player.Team then
					-- Skip same team
				else
					local part = getAimPart(plr)
					if part then
						local targetPos = part.Position
						if part.IsExpanded then
							targetPos = part.Position
						end
						local pos, onScreen = cam:WorldToViewportPoint(targetPos)
						if onScreen then
							local center = cam.ViewportSize / 2
							local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude

							if dist < combatState.fov then
								local visible = isVisible(part)
								if visible or combatState.wallbang then
									local priority = getTargetPriority(plr)
									if priority > bestPriority then
										bestPriority = priority
										best = plr
									end
								end
							end
						end
					end
				end
			end
		end
		return best
	end

	-- ════════════════════════════════════════
	-- AIMBOT CORE (NÂNG CẤP)
	-- ════════════════════════════════════════

	local function aimAt(target)
		if not target then return end
		local part = getAimPart(target)
		if not part then return end

		local cam = workspace.CurrentCamera
		if not cam then return end

		local targetPos = part.Position
		if part.IsExpanded then
			targetPos = part.Position
		end

		-- Anti-Aim (chống bị aim)
		if combatState.antiAim and target == Player then
			local char = Player.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then
					hum.AutoRotate = false
				end
				local root = char:FindFirstChild("HumanoidRootPart")
				if root then
					root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(combatState.antiAimAngle), 0)
				end
			end
		end

		-- Prediction
		if combatState.prediction then
			local vel = getVelocity(target)
			if vel.Magnitude > 2 then
				local bulletSpeed = 2000
				local distance = (targetPos - cam.CFrame.Position).Magnitude
				local travelTime = distance / bulletSpeed
				targetPos = targetPos + vel * travelTime * combatState.predictionAmount
			end
		end

		-- RCS
		if combatState.rcsEnabled then
			local rcsAmount = combatState.rcsAmount * 0.5
			targetPos = targetPos + Vector3.new(
				-recoilOffset.X * rcsAmount,
				-recoilOffset.Y * rcsAmount,
				0
			)
		end

		local currentDir = cam.CFrame.LookVector
		local targetDir = (targetPos - cam.CFrame.Position).Unit

		if combatState.silentAim then
			-- Silent Aim: không xoay camera mà chỉ thay đổi hướng bắn
			pcall(function()
				local mouse = Player:GetMouse()
				if mouse then
					mouse.UnitRay = Ray.new(cam.CFrame.Position, targetDir)
				end
			end)
		else
			-- Normal Aim: xoay camera
			if combatState.smoothness > 1 then
				local smooth = 1 - (combatState.smoothness / 20)
				local newDir = currentDir:Lerp(targetDir, smooth)
				cam.CFrame = CFrame.lookAt(cam.CFrame.Position, cam.CFrame.Position + newDir * 100)
			else
				cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetPos)
			end
		end
	end

	-- ════════════════════════════════════════
	-- FOV CIRCLE (NÂNG CẤP)
	-- ════════════════════════════════════════

	local fovGui = Instance.new("ScreenGui")
	fovGui.Name = "NovaFOV"
	fovGui.ResetOnSpawn = false
	fovGui.IgnoreGuiInset = true
	fovGui.Parent = PlayerGui

	local function updateFOVCircle()
		if not combatState.showFOVCircle or not combatState.aimbotEnabled then
			if fovCircle then
				fovCircle.Visible = false
			end
			return
		end

		if not fovCircle then
			fovCircle = Instance.new("Frame", fovGui)
			fovCircle.Size = UDim2.new(0, combatState.fov * 2, 0, combatState.fov * 2)
			fovCircle.Position = UDim2.new(0.5, -combatState.fov, 0.5, -combatState.fov)
			fovCircle.BackgroundColor3 = T.ACCENT
			fovCircle.BackgroundTransparency = 0.9
			fovCircle.BorderSizePixel = 2
			fovCircle.BorderColor3 = T.ACCENT
			fovCircle.ZIndex = 100
			corner(fovCircle, combatState.fov)
		else
			-- Animation: pulse
			fovCircleAnim = (fovCircleAnim + 0.02) % (math.pi * 2)
			local pulse = 0.85 + math.sin(fovCircleAnim) * 0.1

			fovCircle.Size = UDim2.new(0, combatState.fov * 2, 0, combatState.fov * 2)
			fovCircle.Position = UDim2.new(0.5, -combatState.fov, 0.5, -combatState.fov)
			fovCircle.BackgroundTransparency = 0.9
			fovCircle.BorderColor3 = T.ACCENT
			corner(fovCircle, combatState.fov)
			fovCircle.Visible = true

			-- Crosshair dot
			local dot = fovCircle:FindFirstChild("Dot") or Instance.new("Frame", fovCircle)
			dot.Name = "Dot"
			dot.Size = UDim2.new(0, 3, 0, 3)
			dot.Position = UDim2.new(0.5, -1.5, 0.5, -1.5)
			dot.BackgroundColor3 = T.ACCENT
			dot.BackgroundTransparency = 0.5
			dot.BorderSizePixel = 0
			dot.ZIndex = 101
		end
	end

	-- ════════════════════════════════════════
	-- ESP SYSTEM (NÂNG CẤP v3)
	-- ════════════════════════════════════════

	local espGui = Instance.new("ScreenGui")
	espGui.Name = "NovaESP"
	espGui.ResetOnSpawn = false
	espGui.IgnoreGuiInset = true
	espGui.Parent = PlayerGui

	local function clearESP()
		for _, obj in ipairs(espObjects) do
			pcall(function() obj:Destroy() end)
		end
		espObjects = {}
	end

	-- NÂNG CẤP: Corner Box
	local function drawCornerBox(parent, pos, size, color)
		local cornerSize = 6
		local corners = {
			{pos.X - size.X/2, pos.Y - size.Y/2, size.X, 1},
			{pos.X - size.X/2, pos.Y - size.Y/2, 1, size.Y},
			{pos.X + size.X/2, pos.Y - size.Y/2, 1, size.Y},
			{pos.X + size.X/2 - cornerSize, pos.Y - size.Y/2, cornerSize, 1},
			{pos.X - size.X/2, pos.Y + size.Y/2 - 1, size.X, 1},
			{pos.X - size.X/2, pos.Y + size.Y/2 - cornerSize, 1, cornerSize},
			{pos.X + size.X/2 - cornerSize, pos.Y + size.Y/2 - 1, cornerSize, 1},
			{pos.X + size.X/2 - 1, pos.Y + size.Y/2 - cornerSize, 1, cornerSize},
		}

		for _, cornerData in ipairs(corners) do
			local line = Instance.new("Frame", parent)
			line.Size = UDim2.new(0, cornerData[3], 0, cornerData[4])
			line.Position = UDim2.new(0, cornerData[1], 0, cornerData[2])
			line.BackgroundColor3 = color
			line.BackgroundTransparency = 0.3
			line.BorderSizePixel = 0
			line.ZIndex = 50
			table.insert(espObjects, line)
		end
	end

	-- NÂNG CẤP: Tracer Line (từ player đến target)
	local function drawTracer(origin, target, color)
		local cam = workspace.CurrentCamera
		if not cam then return end

		local originScreen, on1 = cam:WorldToViewportPoint(origin)
		local targetScreen, on2 = cam:WorldToViewportPoint(target)

		if on1 and on2 then
			local line = Instance.new("Frame", espGui)
			local midX = (originScreen.X + targetScreen.X) / 2
			local midY = (originScreen.Y + targetScreen.Y) / 2
			local dx = targetScreen.X - originScreen.X
			local dy = targetScreen.Y - originScreen.Y
			local length = math.sqrt(dx*dx + dy*dy)
			local angle = math.atan2(dy, dx)

			line.Size = UDim2.new(0, length, 0, 2)
			line.Position = UDim2.new(0, midX - length/2, 0, midY - 1)
			line.Rotation = math.deg(angle)
			line.BackgroundColor3 = color
			line.BackgroundTransparency = 0.3
			line.BorderSizePixel = 0
			line.ZIndex = 49
			table.insert(espObjects, line)
		end
	end

	local function updateESP()
		if not combatState.showESP then
			clearESP()
			return
		end

		clearESP()

		local cam = workspace.CurrentCamera
		if not cam then return end

		local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
		local origin = myRoot and myRoot.Position or Vector3.new()

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= Player and isAlive(plr) then
				local char = plr.Character
				if not char then continue end
				local root = char:FindFirstChild("HumanoidRootPart")
				local hum = char:FindFirstChildOfClass("Humanoid")
				if not root or not hum then continue end

				local pos, onScreen = cam:WorldToViewportPoint(root.Position)
				if not onScreen then continue end

				-- Box ESP (cải tiến)
				local isEnemy = plr.Team and Player.Team and plr.Team ~= Player.Team
				local boxColor = isEnemy and T.DANGER or T.SUCCESS

				-- Corner Box
				if combatState.showCornerBox then
					drawCornerBox(espGui, 
						Vector2.new(pos.X, pos.Y), 
						Vector2.new(40, 80), 
						boxColor
					)
				else
					-- Normal Box
					local box = Instance.new("Frame", espGui)
					box.Size = UDim2.new(0, 40, 0, 80)
					box.Position = UDim2.new(0, pos.X - 20, 0, pos.Y - 80)
					box.BackgroundColor3 = boxColor
					box.BackgroundTransparency = 0.2
					box.BorderSizePixel = 1
					box.BorderColor3 = boxColor
					box.ZIndex = 50
					table.insert(espObjects, box)
				end

				-- Health Bar
				local hpRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
				local healthColor = hpRatio > 0.6 and T.SUCCESS or hpRatio > 0.3 and T.WARN or T.DANGER

				if combatState.showHealthBar then
					local healthBg = Instance.new("Frame", espGui)
					healthBg.Size = UDim2.new(0, 4, 0, 80)
					healthBg.Position = UDim2.new(0, pos.X - 24, 0, pos.Y - 80)
					healthBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					healthBg.BorderSizePixel = 0
					healthBg.ZIndex = 51
					table.insert(espObjects, healthBg)

					local healthFill = Instance.new("Frame", healthBg)
					healthFill.Size = UDim2.new(0, 4, 0, 80 * hpRatio)
					healthFill.Position = UDim2.new(0, 0, 0, 80 * (1 - hpRatio))
					healthFill.BackgroundColor3 = healthColor
					healthFill.BorderSizePixel = 0
					healthFill.ZIndex = 52
					table.insert(espObjects, healthFill)
				end

				-- Name Tag
				if combatState.showNameTag then
					local nameTag = Instance.new("TextLabel", espGui)
					nameTag.Size = UDim2.new(0, 100, 0, 16)
					nameTag.Position = UDim2.new(0, pos.X - 50, 0, pos.Y - 82)
					nameTag.Text = plr.DisplayName
					nameTag.TextColor3 = isEnemy and T.DANGER or T.SUCCESS
					nameTag.TextSize = 9
					nameTag.Font = Enum.Font.GothamBold
					nameTag.BackgroundTransparency = 1
					nameTag.TextXAlignment = Enum.TextXAlignment.Center
					nameTag.ZIndex = 50
					table.insert(espObjects, nameTag)
				end

				-- Distance
				if combatState.showDistance then
					local dist = math.floor((root.Position - origin).Magnitude)

					local distText = Instance.new("TextLabel", espGui)
					distText.Size = UDim2.new(0, 50, 0, 14)
					distText.Position = UDim2.new(0, pos.X - 25, 0, pos.Y + 2)
					distText.Text = dist .. "m"
					distText.TextColor3 = T.TEXT3
					distText.TextSize = 7
					distText.Font = Enum.Font.Gotham
					distText.BackgroundTransparency = 1
					distText.TextXAlignment = Enum.TextXAlignment.Center
					distText.ZIndex = 50
					table.insert(espObjects, distText)
				end

				-- Tracer
				if combatState.showTracer and myRoot then
					drawTracer(root.Position + Vector3.new(0, 3, 0), myRoot.Position, boxColor)
				end

				-- Skeleton
				if combatState.showSkeleton then
					local joints = {
						{"Head", "UpperTorso"},
						{"UpperTorso", "LowerTorso"},
						{"LeftArm", "LeftHand"},
						{"RightArm", "RightHand"},
						{"LeftLeg", "LeftFoot"},
						{"RightLeg", "RightFoot"},
					}
					for _, joint in ipairs(joints) do
						local part1 = char:FindFirstChild(joint[1])
						local part2 = char:FindFirstChild(joint[2])
						if part1 and part2 then
							local p1, on1 = cam:WorldToViewportPoint(part1.Position)
							local p2, on2 = cam:WorldToViewportPoint(part2.Position)
							if on1 and on2 then
								local line = Instance.new("Frame", espGui)
								local midX = (p1.X + p2.X) / 2
								local midY = (p1.Y + p2.Y) / 2
								local dx = p2.X - p1.X
								local dy = p2.Y - p1.Y
								local length = math.sqrt(dx*dx + dy*dy)
								local angle = math.atan2(dy, dx)

								line.Size = UDim2.new(0, length, 0, 1)
								line.Position = UDim2.new(0, midX - length/2, 0, midY - 0.5)
								line.Rotation = math.deg(angle)
								line.BackgroundColor3 = T.ACCENT
								line.BackgroundTransparency = 0.3
								line.BorderSizePixel = 0
								line.ZIndex = 49
								table.insert(espObjects, line)
							end
						end
					end
				end
			end
		end
	end

	-- ════════════════════════════════════════
	-- TRIGGER BOT (NÂNG CẤP)
	-- ════════════════════════════════════════

	local function triggerBotLoop()
		if not combatState.triggerBot then return end

		-- Kiểm tra trigger key
		if combatState.triggerKey then
			local pressed = false
			local key = combatState.triggerKey
			if key == "MouseButton1" then
				pressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
			elseif key == "MouseButton2" then
				pressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
			else
				pressed = UserInputService:IsKeyDown(Enum.KeyCode[key])
			end
			if not pressed then return end
		end

		local cam = workspace.CurrentCamera
		if not cam then return end

		local mouse = UserInputService:GetMouseLocation()
		local mousePos = Vector2.new(mouse.X, mouse.Y)

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= Player and isAlive(plr) then
				local part = getAimPart(plr)
				if part then
					local targetPos = part.Position
					if part.IsExpanded then
						targetPos = part.Position
					end
					local pos, onScreen = cam:WorldToViewportPoint(targetPos)
					if onScreen then
						local screenDist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
						if screenDist < 20 then
							if combatState.triggerVisible and not isVisible(part) then
								if not combatState.wallbang then return end
							end

							-- Auto Wallbang
							if combatState.autoWallbang and not isVisible(part) then
								-- Bắn xuyên tường
							end

							-- Shoot Mode
							if combatState.shootMode == "single" then
								pcall(function()
									local mouse = Player:GetMouse()
									if mouse then
										mouse.Button1Down:Fire()
										task.wait(0.05)
										mouse.Button1Up:Fire()
									end
								end)
							elseif combatState.shootMode == "burst" then
								if burstCount < combatState.burstCount then
									pcall(function()
										local mouse = Player:GetMouse()
										if mouse then
											mouse.Button1Down:Fire()
											task.wait(0.05)
											mouse.Button1Up:Fire()
										end
									end)
									burstCount += 1
									task.wait(combatState.burstDelay)
								end
							elseif combatState.shootMode == "auto" then
								pcall(function()
									local mouse = Player:GetMouse()
									if mouse then
										mouse.Button1Down:Fire()
										task.wait(0.05)
										mouse.Button1Up:Fire()
									end
								end)
							end

							task.wait(combatState.triggerDelay)
							break
						end
					end
				end
			end
		end
	end

	-- ════════════════════════════════════════
	-- TOGGLE FUNCTIONS
	-- ════════════════════════════════════════

	local function toggleAimbot(on)
		combatState.aimbotEnabled = on
		if on then
			if aimbotConn then aimbotConn:Disconnect() end
			aimbotConn = RunService.RenderStepped:Connect(function()
				if combatState.aimbotEnabled then
					if combatState.holdAim then
						local key = combatState.aimbotKey
						local pressed = false
						if key == "MouseButton2" then
							pressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
						elseif key == "MouseButton1" then
							pressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
						else
							pressed = UserInputService:IsKeyDown(Enum.KeyCode[key])
						end
						if not pressed then
							currentTarget = nil
							return
						end
					end

					local target = getBestTarget()
					currentTarget = target
					if target then
						aimAt(target)
					end
				end
			end)
			updateFOVCircle()
			showToast("Aimbot ON 🎯", "ok")
		else
			if aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end
			currentTarget = nil
			if fovCircle then fovCircle.Visible = false end
			showToast("Aimbot OFF", "warn")
		end
	end

	local function toggleTriggerBot(on)
		combatState.triggerBot = on
		if on then
			if triggerConn then triggerConn:Disconnect() end
			triggerConn = RunService.Heartbeat:Connect(function()
				triggerBotLoop()
				if burstCount >= combatState.burstCount then
					burstCount = 0
				end
			end)
			showToast("Trigger Bot ON 🔫", "ok")
		else
			if triggerConn then triggerConn:Disconnect(); triggerConn = nil end
			showToast("Trigger Bot OFF", "warn")
		end
	end

	local function toggleESP(on)
		combatState.showESP = on
		if on then
			if espConn then espConn:Disconnect() end
			espConn = RunService.RenderStepped:Connect(updateESP)
			showToast("ESP ON 👁", "ok")
		else
			if espConn then espConn:Disconnect(); espConn = nil end
			clearESP()
			showToast("ESP OFF", "warn")
		end
	end

	-- ════════════════════════════════════════
	-- UI BUILD (NÂNG CẤP v3)
	-- ════════════════════════════════════════

	-- Banner
	local banner = newFrame(combatPage, {
		BG = Color3.fromRGB(40, 10, 10),
		Size = UDim2.new(1, 0, 0, 44),
		ZIndex = 12,
	})
	banner.LayoutOrder = 1
	corner(banner, 12)
	stroke(banner, T.DANGER, 2)

	newLabel(banner, {
		Text = "⚔  COMBAT SYSTEM PRO v3  ⚔",
		Color = T.WHITE, Size = 16, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(1, 0, 1, 0), ZIndex = 13,
		AlignX = Enum.TextXAlignment.Center,
	})

	-- SECTION: MAIN TOGGLES
	makeSectionLabel(combatPage, "Main", 2)

	makeToggle(combatPage, "🎯 Aimbot (Auto Aim)", false, toggleAimbot, 3)
	makeToggle(combatPage, "🤫 Silent Aim (No Camera Move)", false, function(on)
		combatState.silentAim = on
		if on and not combatState.aimbotEnabled then
			showToast("Bật Aimbot trước khi dùng Silent Aim!", "warn")
		end
	end, 4)
	makeToggle(combatPage, "🔫 Trigger Bot (Auto Shoot)", false, toggleTriggerBot, 5)
	makeToggle(combatPage, "👁 ESP (Wallhack)", false, toggleESP, 6)

	-- SECTION: AIMBOT SETTINGS
	makeSectionLabel(combatPage, "Aimbot Settings", 7)

	makeSlider(combatPage, "FOV (Field of View)", 10, 360, 120, function(v)
		combatState.fov = v
		updateFOVCircle()
	end, 8)

	makeSlider(combatPage, "Smoothness (1=instant, 10=smooth)", 1, 10, 5, function(v)
		combatState.smoothness = v
	end, 9)

	makeSlider(combatPage, "Trigger Delay (seconds)", 0.01, 0.5, 0.15, function(v)
		combatState.triggerDelay = v
	end, 10)

	makeToggle(combatPage, "Show FOV Circle 🔵", true, function(on)
		combatState.showFOVCircle = on
		updateFOVCircle()
	end, 11)

	-- Target Priority
	local priorityCard = makeCard(combatPage, 46, 12)
	newLabel(priorityCard, {
		Text = "🎯 Target Priority",
		Color = T.TEXT, Size = 12, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0, 120, 0, 20),
		Position = UDim2.new(0, 14, 0, 6), ZIndex = 13,
	})

	local PRIORITY_OPTIONS = {
		{ label = "Closest", key = "closest" },
		{ label = "Lowest HP", key = "lowest_hp" },
		{ label = "Farthest", key = "farthest" },
		{ label = "Crosshair", key = "closest_cross" },
	}

	for i, opt in ipairs(PRIORITY_OPTIONS) do
		local btn = Instance.new("TextButton", priorityCard)
		btn.Size = UDim2.new(0, 60, 0, 28)
		btn.Position = UDim2.new(0, 140 + (i-1)*66, 0.5, -14)
		btn.Text = opt.label
		btn.TextSize = 8
		btn.Font = Enum.Font.GothamBold
		btn.TextColor3 = i == 1 and T.WHITE or T.TEXT3
		btn.BackgroundColor3 = i == 1 and T.ACCENT or T.SURFACE2
		btn.BorderSizePixel = 0
		btn.ZIndex = 13
		corner(btn, 8)
		stroke(btn, i == 1 and T.ACCENT or T.BORDER, 1)

		btn.MouseButton1Click:Connect(function()
			combatState.targetPriority = opt.key
			for j, other in ipairs(PRIORITY_OPTIONS) do
				local ob = priorityCard:GetChildren()[j+3]
				if ob and ob:IsA("TextButton") then
					tween(ob, {
						BackgroundColor3 = j == i and T.ACCENT or T.SURFACE2,
						TextColor3 = j == i and T.WHITE or T.TEXT3,
					})
					stroke(ob, j == i and T.ACCENT or T.BORDER, 1)
				end
			end
			showToast("Priority: " .. opt.label, "ok")
		end)
	end

	-- Target Lock
	makeToggle(combatPage, "🔒 Target Lock (Giữ mục tiêu)", false, function(on)
		combatState.targetLock = on
		if on and currentTarget then
			targetLocked = currentTarget
		elseif not on then
			targetLocked = nil
		end
	end, 12)

	-- SECTION: AIM PART (NÂNG CẤP)
	makeSectionLabel(combatPage, "Aim Part & Hitbox", 13)

	local partCard = makeCard(combatPage, 46, 14)
	newLabel(partCard, {
		Text = "🎯 Aim Target",
		Color = T.TEXT, Size = 12, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0, 100, 0, 20),
		Position = UDim2.new(0, 14, 0, 6), ZIndex = 13,
	})

	local PART_OPTIONS = {
		{ label = "Head", key = "Head" },
		{ label = "Neck", key = "Neck" },
		{ label = "Chest", key = "Chest" },
		{ label = "Body", key = "Body" },
		{ label = "Arm", key = "RightArm" },
	}

	for i, opt in ipairs(PART_OPTIONS) do
		local btn = Instance.new("TextButton", partCard)
		btn.Size = UDim2.new(0, 50, 0, 28)
		btn.Position = UDim2.new(0, 120 + (i-1)*56, 0.5, -14)
		btn.Text = opt.label
		btn.TextSize = 8
		btn.Font = Enum.Font.GothamBold
		btn.TextColor3 = i == 1 and T.WHITE or T.TEXT3
		btn.BackgroundColor3 = i == 1 and T.ACCENT or T.SURFACE2
		btn.BorderSizePixel = 0
		btn.ZIndex = 13
		corner(btn, 8)
		stroke(btn, i == 1 and T.ACCENT or T.BORDER, 1)

		btn.MouseButton1Click:Connect(function()
			combatState.aimPart = opt.key
			for j, other in ipairs(PART_OPTIONS) do
				local ob = partCard:GetChildren()[j+3]
				if ob and ob:IsA("TextButton") then
					tween(ob, {
						BackgroundColor3 = j == i and T.ACCENT or T.SURFACE2,
						TextColor3 = j == i and T.WHITE or T.TEXT3,
					})
					stroke(ob, j == i and T.ACCENT or T.BORDER, 1)
				end
			end
			showToast("Aim: " .. opt.label, "ok")
		end)
	end

	makeSlider(combatPage, "Hitbox Size (1=normal, 2=double)", 1, 3, 1, function(v)
		combatState.hitboxSize = v
	end, 15)

	-- SECTION: PREDICTION & RCS
	makeSectionLabel(combatPage, "Prediction & RCS", 16)

	makeToggle(combatPage, "🔮 Prediction (Đoán hướng)", true, function(on)
		combatState.prediction = on
	end, 17)

	makeSlider(combatPage, "Prediction Amount", 0.1, 1.0, 0.3, function(v)
		combatState.predictionAmount = v
	end, 18)

	makeToggle(combatPage, "🎯 RCS (Chống giật)", false, function(on)
		combatState.rcsEnabled = on
	end, 19)

	makeSlider(combatPage, "RCS Amount", 0.1, 2.0, 0.5, function(v)
		combatState.rcsAmount = v
	end, 20)

	-- SECTION: SHOOT MODE
	makeSectionLabel(combatPage, "Shoot Mode", 21)

	local shootCard = makeCard(combatPage, 46, 22)
	newLabel(shootCard, {
		Text = "🔫 Fire Mode",
		Color = T.TEXT, Size = 12, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0, 100, 0, 20),
		Position = UDim2.new(0, 14, 0, 6), ZIndex = 13,
	})

	local SHOOT_OPTIONS = {
		{ label = "Single", key = "single" },
		{ label = "Burst x3", key = "burst" },
		{ label = "Auto", key = "auto" },
	}

	for i, opt in ipairs(SHOOT_OPTIONS) do
		local btn = Instance.new("TextButton", shootCard)
		btn.Size = UDim2.new(0, 60, 0, 28)
		btn.Position = UDim2.new(0, 120 + (i-1)*66, 0.5, -14)
		btn.Text = opt.label
		btn.TextSize = 9
		btn.Font = Enum.Font.GothamBold
		btn.TextColor3 = i == 1 and T.WHITE or T.TEXT3
		btn.BackgroundColor3 = i == 1 and T.ACCENT or T.SURFACE2
		btn.BorderSizePixel = 0
		btn.ZIndex = 13
		corner(btn, 8)
		stroke(btn, i == 1 and T.ACCENT or T.BORDER, 1)

		btn.MouseButton1Click:Connect(function()
			combatState.shootMode = opt.key
			for j, other in ipairs(SHOOT_OPTIONS) do
				local ob = shootCard:GetChildren()[j+3]
				if ob and ob:IsA("TextButton") then
					tween(ob, {
						BackgroundColor3 = j == i and T.ACCENT or T.SURFACE2,
						TextColor3 = j == i and T.WHITE or T.TEXT3,
					})
					stroke(ob, j == i and T.ACCENT or T.BORDER, 1)
				end
			end
			showToast("Fire Mode: " .. opt.label, "ok")
		end)
	end

	-- Burst Settings
	makeSlider(combatPage, "Burst Count", 2, 10, 3, function(v)
		combatState.burstCount = v
	end, 23)

	makeSlider(combatPage, "Burst Delay (s)", 0.05, 0.5, 0.1, function(v)
		combatState.burstDelay = v
	end, 24)

	-- Trigger Key
	local triggerCard = makeCard(combatPage, 46, 25)
	newLabel(triggerCard, {
		Text = "🔑 Trigger Key",
		Color = T.TEXT, Size = 12, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0, 100, 0, 20),
		Position = UDim2.new(0, 14, 0, 6), ZIndex = 13,
	})

	local TRIGGER_KEYS = {
		{ label = "LMB", key = "MouseButton1" },
		{ label = "RMB", key = "MouseButton2" },
		{ label = "V", key = "V" },
		{ label = "X", key = "X" },
		{ label = "C", key = "C" },
	}
	for i, opt in ipairs(TRIGGER_KEYS) do
		local btn = Instance.new("TextButton", triggerCard)
		btn.Size = UDim2.new(0, 40, 0, 24)
		btn.Position = UDim2.new(0, 120 + (i-1)*46, 0.5, -12)
		btn.Text = opt.label
		btn.TextSize = 8
		btn.Font = Enum.Font.GothamBold
		btn.TextColor3 = i == 1 and T.WHITE or T.TEXT3
		btn.BackgroundColor3 = i == 1 and T.ACCENT or T.SURFACE2
		btn.BorderSizePixel = 0
		btn.ZIndex = 13
		corner(btn, 6)
		stroke(btn, i == 1 and T.ACCENT or T.BORDER, 1)

		btn.MouseButton1Click:Connect(function()
			combatState.triggerKey = opt.key
			for j, other in ipairs(TRIGGER_KEYS) do
				local ob = triggerCard:GetChildren()[j+3]
				if ob and ob:IsA("TextButton") then
					tween(ob, {
						BackgroundColor3 = j == i and T.ACCENT or T.SURFACE2,
						TextColor3 = j == i and T.WHITE or T.TEXT3,
					})
					stroke(ob, j == i and T.ACCENT or T.BORDER, 1)
				end
			end
			showToast("Trigger Key: " .. opt.label, "ok")
		end)
	end

	-- SECTION: ESP SETTINGS (NÂNG CẤP)
	makeSectionLabel(combatPage, "ESP Settings", 26)

	makeToggle(combatPage, "Health Bar ❤", true, function(on)
		combatState.showHealthBar = on
	end, 27)

	makeToggle(combatPage, "Name Tag 📛", true, function(on)
		combatState.showNameTag = on
	end, 28)

	makeToggle(combatPage, "Skeleton 🦴", false, function(on)
		combatState.showSkeleton = on
	end, 29)

	makeToggle(combatPage, "Show Distance 📏", true, function(on)
		combatState.showDistance = on
	end, 30)

	makeToggle(combatPage, "Corner Box 📐", false, function(on)
		combatState.showCornerBox = on
	end, 31)

	makeToggle(combatPage, "Tracer Line ➡", false, function(on)
		combatState.showTracer = on
	end, 32)

	makeToggle(combatPage, "Visibility Check", true, function(on)
		combatState.visibleCheck = on
	end, 33)

	makeToggle(combatPage, "Wallbang (Bắn xuyên tường)", false, function(on)
		combatState.wallbang = on
	end, 34)

	makeToggle(combatPage, "Auto Wallbang (Xuyên tường tự động)", false, function(on)
		combatState.autoWallbang = on
	end, 35)

	-- SECTION: ANTI AIM
	makeSectionLabel(combatPage, "Anti Aim", 36)

	makeToggle(combatPage, "🛡 Anti Aim (Chống bị aim)", false, function(on)
		combatState.antiAim = on
		if on then
			showToast("Anti Aim ON - Chống bị aim vào bạn!", "ok")
		else
			local char = Player.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then hum.AutoRotate = true end
			end
			showToast("Anti Aim OFF", "warn")
		end
	end, 37)

	makeSlider(combatPage, "Anti Aim Angle", 0, 360, 180, function(v)
		combatState.antiAimAngle = v
	end, 38)

	-- SECTION: TARGET INFO
	makeSectionLabel(combatPage, "Target Info", 39)

	local infoCard = makeCard(combatPage, 10, 40)
	infoCard.AutomaticSize = Enum.AutomaticSize.Y

	local targetInfoLbl = newLabel(infoCard, {
		Text = "🎯 No target",
		Color = T.TEXT2, Size = 11, Font = Enum.Font.Gotham,
		Sz = UDim2.new(1, 0, 0, 28), ZIndex = 13,
		AlignX = Enum.TextXAlignment.Center,
	})
	targetInfoLbl.LayoutOrder = 1

	-- Update target info
	task.spawn(function()
		while true do
			task.wait(0.5)
			if combatState.aimbotEnabled and currentTarget then
				local char = currentTarget.Character
				if char then
					local hum = char:FindFirstChildOfClass("Humanoid")
					local hp = hum and math.floor(hum.Health) or 0
					local maxHp = hum and math.floor(hum.MaxHealth) or 0
					local dist = 0
					local root = char:FindFirstChild("HumanoidRootPart")
					local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
					if root and myRoot then
						dist = math.floor((root.Position - myRoot.Position).Magnitude)
					end
					local isLocked = targetLocked == currentTarget and " 🔒" or ""
					targetInfoLbl.Text = "🎯 " .. currentTarget.DisplayName .. isLocked .. " | HP: " .. hp .. "/" .. maxHp .. " | Dist: " .. dist .. "m"
					targetInfoLbl.TextColor3 = T.SUCCESS
				end
			else
				targetInfoLbl.Text = "🎯 No target"
				targetInfoLbl.TextColor3 = T.TEXT2
			end
		end
	end)

	-- SECTION: RESET
	local resetCombatBtn = Instance.new("TextButton", combatPage)
	resetCombatBtn.Size = UDim2.new(1, 0, 0, 40)
	resetCombatBtn.BackgroundColor3 = Color3.fromRGB(38, 18, 18)
	resetCombatBtn.TextColor3 = T.DANGER
	resetCombatBtn.Text = "↺  Reset All Combat Settings"
	resetCombatBtn.TextSize = 12
	resetCombatBtn.Font = Enum.Font.GothamBold
	resetCombatBtn.BorderSizePixel = 0
	resetCombatBtn.ZIndex = 12
	resetCombatBtn.LayoutOrder = 41
	corner(resetCombatBtn, 10)
	stroke(resetCombatBtn, T.DANGER, 1)

	resetCombatBtn.MouseEnter:Connect(function()
		tween(resetCombatBtn, { BackgroundColor3 = Color3.fromRGB(70, 25, 25) })
	end)
	resetCombatBtn.MouseLeave:Connect(function()
		tween(resetCombatBtn, { BackgroundColor3 = Color3.fromRGB(38, 18, 18) })
	end)

	resetCombatBtn.MouseButton1Click:Connect(function()
		toggleAimbot(false)
		toggleTriggerBot(false)
		toggleESP(false)

		combatState.silentAim = false
		combatState.fov = 120
		combatState.smoothness = 5
		combatState.triggerDelay = 0.15
		combatState.targetTeam = "enemy"
		combatState.aimPart = "Head"
		combatState.visibleCheck = true
		combatState.wallbang = false
		combatState.autoWallbang = false
		combatState.showHealthBar = true
		combatState.showNameTag = true
		combatState.showSkeleton = false
		combatState.showDistance = true
		combatState.showFOVCircle = true
		combatState.showCornerBox = false
		combatState.showTracer = false
		combatState.prediction = true
		combatState.predictionAmount = 0.3
		combatState.rcsEnabled = false
		combatState.rcsAmount = 0.5
		combatState.shootMode = "single"
		combatState.targetPriority = "closest"
		combatState.holdAim = false
		combatState.antiAim = false
		combatState.antiAimAngle = 180
		combatState.triggerKey = "MouseButton1"
		combatState.targetLock = false
		combatState.hitboxSize = 1
		combatState.burstCount = 3
		combatState.burstDelay = 0.1

		targetLocked = nil
		clearESP()
		currentTarget = nil
		if fovCircle then fovCircle.Visible = false end

		local char = Player.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum.AutoRotate = true end
		end

		showToast("✓ Đã reset Combat Settings", "ok")
		resetCombatBtn.Text = "✓ Done"
		task.delay(2, function() resetCombatBtn.Text = "↺ Reset All Combat Settings" end)
	end)
end

-- ══════════════════════════════════════════
-- ★ PAGE: HOST PRO  —  QUIRKYCMD ULTIMATE
-- ══════════════════════════════════════════
-- ĐẶT Ở CUỐI FILE, TRƯỚC PHẦN TOGGLE BUTTON
-- ==========================================

local hostPage, _ = makePage("Host")

do
	-- ========================================
	-- HÀM HỖ TRỢ
	-- ========================================

	local function getTargets(input)
		if not input or input == "" then return {} end
		if _G.findPlayers then
			return _G.findPlayers(input)
		else
			local targets = {}
			for _, p in ipairs(Players:GetPlayers()) do
				if p.Name:lower():find(input:lower()) or p.DisplayName:lower():find(input:lower()) then
					table.insert(targets, p)
				end
			end
			return targets
		end
	end

	-- ========================================
	-- BIẾN UI
	-- ========================================
	local playerRows = {}
	local historyRows = {}
	local hostNameLbl, hostStatusLbl, hostAvatar
	local statsKicks, statsBans, statsWarns

	-- ========================================
	-- HÀM REBUILD UI
	-- ========================================

	local function rebuildPlayerList()
		for _, row in ipairs(playerRows) do
			if row and row.Parent then row:Destroy() end
		end
		playerRows = {}

		local all = Players:GetPlayers()
		for i, p in ipairs(all) do
			local isHost = p == hostSystem.hostPlayer
			local isWhitelisted = hostSystem.whitelist[tostring(p.UserId)]
			local isBlacklisted = hostSystem.blacklist[tostring(p.UserId)]

			local row = Instance.new("TextButton", playerListCard)
			row.Size = UDim2.new(1, 0, 0, 34)
			row.BackgroundColor3 = isHost and Color3.fromRGB(40, 30, 10) or 
				isBlacklisted and Color3.fromRGB(40, 10, 10) or
				T.SURFACE2
			row.BackgroundTransparency = 0.2
			row.Text = ""
			row.BorderSizePixel = 0
			row.ZIndex = 13
			row.LayoutOrder = i
			corner(row, 8)
			if isHost then stroke(row, T.WARN, 1.5)
			elseif isBlacklisted then stroke(row, T.DANGER, 1)
			else stroke(row, T.BORDER, 1) end

			-- Avatar
			local av = Instance.new("ImageLabel", row)
			av.Size = UDim2.new(0, 24, 0, 24)
			av.Position = UDim2.new(0, 4, 0.5, -12)
			av.BackgroundColor3 = T.SURFACE
			av.BorderSizePixel = 0
			av.ZIndex = 14
			av.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..p.UserId.."&width=48&height=48&format=png"
			corner(av, 12)

			-- Name + status
			local statusText = ""
			if isHost then statusText = " 👑"
			elseif isWhitelisted then statusText = " ⭐"
			elseif isBlacklisted then statusText = " 🚫" end

			newLabel(row, {
				Text = p.Name .. statusText,
				Color = isHost and T.WARN or isBlacklisted and T.DANGER or T.TEXT,
				Size = 10, Font = Enum.Font.GothamBold,
				Sz = UDim2.new(1, -120, 1, 0),
				Position = UDim2.new(0, 34, 0, 0), ZIndex = 14, Truncate = true,
			})

			-- Action buttons
			local btnRow = newFrame(row, {
				BG=Color3.fromRGB(0,0,0), BT=1,
				Size=UDim2.new(0, 80, 0, 24),
				Position = UDim2.new(1, -82, 0.5, -12),
				ZIndex=14,
			})
			local btnLayout = Instance.new("UIListLayout", btnRow)
			btnLayout.FillDirection = Enum.FillDirection.Horizontal
			btnLayout.Padding = UDim.new(0, 2)

			local function makeActionBtn(text, color, onClick)
				local btn = Instance.new("TextButton", btnRow)
				btn.Size = UDim2.new(0, 24, 0, 22)
				btn.Text = text
				btn.TextSize = 8
				btn.Font = Enum.Font.GothamBold
				btn.TextColor3 = T.WHITE
				btn.BackgroundColor3 = color
				btn.BorderSizePixel = 0
				btn.ZIndex = 15
				corner(btn, 4)
				btn.MouseButton1Click:Connect(onClick)
				btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = color:lerp(Color3.new(1,1,1), 0.2)}) end)
				btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = color}) end)
				return btn
			end

			if p ~= Player and hostSystem:isHost(Player) then
				makeActionBtn("👑", T.WARN, function()
					hostSystem:setHost(p)
					rebuildPlayerList()
				end)
				makeActionBtn("🚫", T.DANGER, function()
					hostSystem:kick(Player, p)
					rebuildPlayerList()
				end)
				makeActionBtn("🔨", T.DANGER, function()
					hostSystem:ban(Player, p)
					rebuildPlayerList()
				end)
				makeActionBtn("⭐", T.SUCCESS, function()
					hostSystem:addWhitelist(Player, p)
					rebuildPlayerList()
				end)
				makeActionBtn("🚫", T.DANGER, function()
					hostSystem:addBlacklist(Player, p)
					rebuildPlayerList()
				end)
			else
				local statusLbl = newLabel(btnRow, {
					Text = isHost and "👑" or isWhitelisted and "⭐" or isBlacklisted and "🚫" or "",
					Color = isHost and T.WARN or isWhitelisted and T.SUCCESS or isBlacklisted and T.DANGER or T.TEXT3,
					Size = 12,
					Sz = UDim2.new(1,0,1,0),
					AlignX = Enum.TextXAlignment.Center,
					ZIndex = 15,
				})
			end

			row.MouseEnter:Connect(function()
				if not isHost then tween(row, {BackgroundTransparency = 0.05}) end
			end)
			row.MouseLeave:Connect(function()
				if not isHost then tween(row, {BackgroundTransparency = 0.2}) end
			end)

			table.insert(playerRows, row)
		end
	end

	local function rebuildHistory()
		for _, row in ipairs(historyRows) do
			if row and row.Parent then row:Destroy() end
		end
		historyRows = {}

		local entries = hostSystem.hostHistory
		if #entries == 0 then
			local emptyLbl = newLabel(historyCard, {
				Text = "Chưa có hoạt động nào",
				Color = T.TEXT3, Size = 10,
				Sz = UDim2.new(1, 0, 0, 28), ZIndex = 13,
				AlignX = Enum.TextXAlignment.Center,
			})
			emptyLbl.LayoutOrder = 999
			table.insert(historyRows, emptyLbl)
			return
		end

		local startIdx = math.max(1, #entries - 19)
		for i = startIdx, #entries do
			local entry = entries[i]
			local row = newFrame(historyCard, {
				BG = i % 2 == 0 and T.SURFACE2 or T.SURFACE,
				BT = 0.2,
				Size = UDim2.new(1, 0, 0, 20), ZIndex = 13,
			})
			row.LayoutOrder = i - startIdx + 1
			corner(row, 4)

			local text = string.format("[%s] %s %s by %s", 
				entry.time or "??:??",
				entry.action or "Action",
				entry.target or "",
				entry.by or "Unknown"
			)
			local color = entry.action == "Kick" and T.DANGER or
				entry.action == "Ban" and T.DANGER or
				entry.action == "Warn" and T.WARN or
				T.TEXT2

			newLabel(row, {
				Text = text,
				Color = color, Size = 8,
				Sz = UDim2.new(1, -4, 1, 0),
				Position = UDim2.new(0, 4, 0, 0),
				ZIndex = 14,
				AlignX = Enum.TextXAlignment.Left,
				Truncate = true,
			})

			table.insert(historyRows, row)
		end
	end

	local function rebuildHostUI()
		rebuildPlayerList()
		rebuildHistory()

		local host = hostSystem.hostPlayer
		if host then
			hostNameLbl.Text = "👑 Chủ phòng: " .. host.Name
			hostStatusLbl.Text = "ID: " .. host.UserId .. " | Kicks: " .. hostSystem.hostKicks .. " | Bans: " .. hostSystem.hostBans
			hostAvatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..host.UserId.."&width=150&height=150&format=png"
		else
			hostNameLbl.Text = "👑 Chủ phòng: Chưa có"
			hostStatusLbl.Text = "Chưa có chủ phòng"
			hostAvatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
		end
	end

	-- ========================================
	-- BANNER
	-- ========================================

	local banner = newFrame(hostPage, {
		BG = Color3.fromRGB(40, 30, 10),
		Size = UDim2.new(1, 0, 0, 56),
		ZIndex = 12,
	})
	banner.LayoutOrder = 1
	corner(banner, 12)
	stroke(banner, T.WARN, 2)
	gradient(banner, Color3.fromRGB(50, 38, 15), Color3.fromRGB(30, 22, 8), 135)

	newLabel(banner, {
		Text = "👑  CHỦ PHÒNG PRO  👑",
		Color = T.WHITE, Size = 18, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(1, 0, 0, 22),
		Position = UDim2.new(0, 0, 0, 6),
		AlignX = Enum.TextXAlignment.Center, ZIndex = 13,
	})

	-- Stats
	local statsRow = newFrame(banner, {
		BG=Color3.fromRGB(0,0,0), BT=1,
		Size=UDim2.new(1, 0, 0, 20),
		Position=UDim2.new(0, 0, 0, 32),
		ZIndex=13,
	})
	local statsLayout = Instance.new("UIListLayout", statsRow)
	statsLayout.FillDirection = Enum.FillDirection.Horizontal
	statsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	statsLayout.Padding = UDim.new(0, 16)

	statsKicks = newLabel(statsRow, {
		Text = "Kicks: 0",
		Color = T.DANGER, Size = 8, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0, 0, 0, 18), ZIndex = 14,
	})
	statsKicks.AutomaticSize = Enum.AutomaticSize.X

	statsBans = newLabel(statsRow, {
		Text = "Bans: 0",
		Color = T.DANGER, Size = 8, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0, 0, 0, 18), ZIndex = 14,
	})
	statsBans.AutomaticSize = Enum.AutomaticSize.X

	statsWarns = newLabel(statsRow, {
		Text = "Warns: 0",
		Color = T.WARN, Size = 8, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(0, 0, 0, 18), ZIndex = 14,
	})
	statsWarns.AutomaticSize = Enum.AutomaticSize.X

	-- ========================================
	-- CURRENT HOST DISPLAY
	-- ========================================

	local hostDisplay = makeCard(hostPage, 60, 2)
	gradient(hostDisplay, Color3.fromRGB(30, 22, 10), Color3.fromRGB(20, 16, 8), 135)
	stroke(hostDisplay, T.WARN, 1)

	hostAvatar = Instance.new("ImageLabel", hostDisplay)
	hostAvatar.Size = UDim2.new(0, 44, 0, 44)
	hostAvatar.Position = UDim2.new(0, 10, 0.5, -22)
	hostAvatar.BackgroundColor3 = T.SURFACE2
	hostAvatar.BorderSizePixel = 0
	hostAvatar.ZIndex = 13
	corner(hostAvatar, 22)
	stroke(hostAvatar, T.WARN, 1)
	hostAvatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

	hostNameLbl = newLabel(hostDisplay, {
		Text = "👑 Chủ phòng: Chưa có",
		Color = T.WARN, Size = 15, Font = Enum.Font.GothamBold,
		Sz = UDim2.new(1, -80, 0, 22),
		Position = UDim2.new(0, 64, 0, 8), ZIndex = 13,
	})

	hostStatusLbl = newLabel(hostDisplay, {
		Text = "Chưa có chủ phòng",
		Color = T.TEXT3, Size = 10,
		Sz = UDim2.new(1, -80, 0, 16),
		Position = UDim2.new(0, 64, 0, 30), ZIndex = 13,
	})

	-- ========================================
	-- PLAYER LIST
	-- ========================================

	makeSectionLabel(hostPage, "👥 Danh sách người chơi", 3)

	local playerListCard = makeCard(hostPage, 10, 4)
	playerListCard.AutomaticSize = Enum.AutomaticSize.Y
	gradient(playerListCard, Color3.fromRGB(20, 20, 30), Color3.fromRGB(14, 14, 22), 135)

	local plPad = Instance.new("UIPadding", playerListCard)
	plPad.PaddingTop = UDim.new(0, 6)
	plPad.PaddingBottom = UDim.new(0, 6)
	plPad.PaddingLeft = UDim.new(0, 8)
	plPad.PaddingRight = UDim.new(0, 8)

	-- ========================================
	-- HOST COMMANDS
	-- ========================================

	makeSectionLabel(hostPage, "⚡ Lệnh Chủ Phòng", 5)

	local cmdCard = makeCard(hostPage, 10, 6)
	cmdCard.AutomaticSize = Enum.AutomaticSize.Y
	gradient(cmdCard, Color3.fromRGB(20, 20, 30), Color3.fromRGB(14, 14, 22), 135)

	local cPad = Instance.new("UIPadding", cmdCard)
	cPad.PaddingTop = UDim.new(0, 6)
	cPad.PaddingBottom = UDim.new(0, 6)
	cPad.PaddingLeft = UDim.new(0, 8)
	cPad.PaddingRight = UDim.new(0, 8)

	local HOST_COMMANDS = {
		{name="Kick", icon="🚫", color=T.DANGER, desc="Đuổi người chơi", needTarget=true},
		{name="Ban", icon="🔨", color=T.DANGER, desc="Cấm người chơi", needTarget=true},
		{name="Warn", icon="⚠️", color=T.WARN, desc="Cảnh cáo người chơi", needTarget=true},
		{name="Mute", icon="🔇", color=T.ACCENT, desc="Tắt chat người chơi", needTarget=true},
		{name="Unmute", icon="🔊", color=T.SUCCESS, desc="Bật chat người chơi", needTarget=true},
		{name="Freeze", icon="❄️", color=T.ACCENT2, desc="Đóng băng người chơi", needTarget=true},
		{name="Unfreeze", icon="🔥", color=T.WARN, desc="Mở băng người chơi", needTarget=true},
		{name="Clear Map", icon="💥", color=T.DANGER, desc="Xóa toàn bộ map", needTarget=false},
		{name="Reset Map", icon="↺", color=T.ACCENT, desc="Tải lại map gốc", needTarget=false},
		{name="Announce", icon="📢", color=T.ACCENT2, desc="Thông báo toàn server", needTarget=false},
		{name="Host Tools", icon="🔧", color=T.SUCCESS, desc="Cấp tool quản lý", needTarget=false},
	}

	local function createHostCommandUI(cmd, order)
		local row = newFrame(cmdCard, {
			BG = T.SURFACE2,
			Size = UDim2.new(1, 0, 0, 36), ZIndex = 13,
		})
		row.LayoutOrder = order
		corner(row, 8)
		stroke(row, cmd.color, 1)

		newLabel(row, {
			Text = cmd.icon,
			Color = cmd.color, Size = 14,
			Sz = UDim2.new(0, 28, 1, 0),
			Position = UDim2.new(0, 4, 0, 0),
			AlignX = Enum.TextXAlignment.Center, ZIndex = 14,
		})

		newLabel(row, {
			Text = cmd.name,
			Color = T.TEXT, Size = 10, Font = Enum.Font.GothamBold,
			Sz = UDim2.new(0, 70, 0, 16),
			Position = UDim2.new(0, 34, 0, 4), ZIndex = 14,
		})
		newLabel(row, {
			Text = cmd.desc,
			Color = T.TEXT3, Size = 8,
			Sz = UDim2.new(0, 110, 0, 14),
			Position = UDim2.new(0, 34, 0, 18), ZIndex = 14,
		})

		local targetBox = Instance.new("TextBox", row)
		targetBox.Size = UDim2.new(0, 56, 0, 20)
		targetBox.AnchorPoint = Vector2.new(1, 0.5)
		targetBox.Position = UDim2.new(0.7, -2, 0.5, 0)
		targetBox.BackgroundColor3 = T.SURFACE
		targetBox.BorderSizePixel = 0
		targetBox.TextColor3 = T.TEXT
		targetBox.PlaceholderText = cmd.needTarget and "tên" or "tin nhắn..."
		targetBox.PlaceholderColor3 = T.TEXT3
		targetBox.Text = ""
		targetBox.TextSize = 8
		targetBox.Font = Enum.Font.Gotham
		targetBox.ClearTextOnFocus = false
		targetBox.ZIndex = 14
		corner(targetBox, 5)
		stroke(targetBox, T.BORDER, 1)
		local tbPad = Instance.new("UIPadding", targetBox)
		tbPad.PaddingLeft = UDim.new(0, 4)
		targetBox.Visible = cmd.needTarget or cmd.name == "Announce"

		local execBtn = Instance.new("TextButton", row)
		execBtn.Size = UDim2.new(0, 44, 0, 24)
		execBtn.AnchorPoint = Vector2.new(1, 0.5)
		execBtn.Position = UDim2.new(0.98, -2, 0.5, 0)
		execBtn.Text = "▶"
		execBtn.TextSize = 12
		execBtn.Font = Enum.Font.GothamBold
		execBtn.TextColor3 = T.WHITE
		execBtn.BackgroundColor3 = cmd.color
		execBtn.BorderSizePixel = 0
		execBtn.ZIndex = 14
		corner(execBtn, 6)

		execBtn.MouseButton1Click:Connect(function()
			local input = targetBox.Text
			local targets = {}

			if cmd.needTarget and input ~= "" then
				targets = getTargets(input)
			end

			if cmd.needTarget and #targets == 0 then
				showToast("⚠️ Không tìm thấy người chơi!", "warn")
				return
			end

			local plr = Player

			if cmd.name == "Kick" then
				for _, t in ipairs(targets) do hostSystem:kick(plr, t) end
			elseif cmd.name == "Ban" then
				for _, t in ipairs(targets) do hostSystem:ban(plr, t) end
			elseif cmd.name == "Warn" then
				for _, t in ipairs(targets) do hostSystem:warn(plr, t) end
			elseif cmd.name == "Mute" then
				for _, t in ipairs(targets) do hostSystem:mute(plr, t) end
			elseif cmd.name == "Unmute" then
				for _, t in ipairs(targets) do hostSystem:unmute(plr, t) end
			elseif cmd.name == "Freeze" then
				for _, t in ipairs(targets) do hostSystem:freeze(plr, t) end
			elseif cmd.name == "Unfreeze" then
				for _, t in ipairs(targets) do hostSystem:unfreeze(plr, t) end
			elseif cmd.name == "Clear Map" then
				if Q and Q.runCommand then Q.runCommand("clearws")
				else
					local char = plr.Character
					for _, obj in ipairs(workspace:GetChildren()) do
						if obj ~= char then pcall(function() obj:Destroy() end) end
					end
				end
				showToast("💥 Đã xóa map!", "ok")
			elseif cmd.name == "Reset Map" then
				if _G._NovaResetMap then _G._NovaResetMap()
				else showToast("❌ Không có map backup!", "warn") end
			elseif cmd.name == "Announce" then
				if input ~= "" then
					pcall(function()
						local channel = TextChatService.TextChannels["RBXGeneral"]
						if channel then
							channel:SendAsync("📢 [" .. plr.Name .. "] " .. input)
						end
					end)
					showToast("📢 Đã gửi thông báo!", "ok")
				end
			elseif cmd.name == "Host Tools" then
				if _G.execCmd then _G.execCmd("btools")
				else
					for i = 1, 4 do
						local Tool = Instance.new("HopperBin")
						Tool.BinType = i
						Tool.Name = "Host Tool " .. i
						Tool.Parent = plr:FindFirstChildOfClass("Backpack")
					end
				end
				showToast("🔧 Đã cấp tool quản lý!", "ok")
			end

			targetBox.Text = ""
			rebuildPlayerList()
		end)

		return row
	end

	for i, cmd in ipairs(HOST_COMMANDS) do
		createHostCommandUI(cmd, i)
	end

	-- ========================================
	-- HISTORY LOG
	-- ========================================

	makeSectionLabel(hostPage, "📜 Lịch sử hoạt động", 7)

	local historyCard = makeCard(hostPage, 10, 8)
	historyCard.AutomaticSize = Enum.AutomaticSize.Y
	gradient(historyCard, Color3.fromRGB(14, 14, 22), Color3.fromRGB(10, 10, 16), 135)

	local hPad = Instance.new("UIPadding", historyCard)
	hPad.PaddingTop = UDim.new(0, 6)
	hPad.PaddingBottom = UDim.new(0, 6)
	hPad.PaddingLeft = UDim.new(0, 8)
	hPad.PaddingRight = UDim.new(0, 8)

	-- ========================================
	-- SETTINGS
	-- ========================================

	makeSectionLabel(hostPage, "⚙️ Cài đặt", 9)

	local settingsCard = makeCard(hostPage, 10, 10)
	settingsCard.AutomaticSize = Enum.AutomaticSize.Y
	gradient(settingsCard, Color3.fromRGB(20, 20, 30), Color3.fromRGB(14, 14, 22), 135)

	local function makeSettingToggle(label, default, onChange)
		local row = newFrame(settingsCard, {
			BG = T.SURFACE2, Size = UDim2.new(1, 0, 0, 36), ZIndex = 13,
		})
		corner(row, 8)
		stroke(row, T.BORDER, 1)

		newLabel(row, {
			Text = label,
			Color = T.TEXT, Size = 11,
			Sz = UDim2.new(1, -60, 1, 0),
			Position = UDim2.new(0, 12, 0, 0), ZIndex = 14,
		})

		local track = Instance.new("TextButton", row)
		track.Size = UDim2.new(0, 36, 0, 20)
		track.AnchorPoint = Vector2.new(1, 0.5)
		track.Position = UDim2.new(1, -8, 0.5, 0)
		track.BackgroundColor3 = default and T.SUCCESS or T.SURFACE
		track.Text = ""
		track.BorderSizePixel = 0
		track.ZIndex = 14
		corner(track, 10)
		stroke(track, T.BORDER, 1)

		local thumb = newFrame(track, {
			BG = T.WHITE,
			Size = UDim2.new(0, 14, 0, 14),
			Position = default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
			ZIndex = 15,
		})
		corner(thumb, 8)

		local isOn = default
		track.MouseButton1Click:Connect(function()
			isOn = not isOn
			tween(track, {BackgroundColor3 = isOn and T.SUCCESS or T.SURFACE})
			tween(thumb, {Position = isOn and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)})
			if onChange then onChange(isOn) end
		end)

		return row
	end

	makeSettingToggle("🔄 Auto Rehost (khi host rời)", hostSystem.hostAutoRehost, function(on)
		hostSystem.hostAutoRehost = on
		showToast("Auto Rehost " .. (on and "BẬT" or "TẮT"), on and "ok" or "warn")
	end)

	makeSettingToggle("🛡️ Bảo vệ host", hostSystem.hostProtected, function(on)
		hostSystem.hostProtected = on
		showToast("Bảo vệ host " .. (on and "BẬT" or "TẮT"), on and "ok" or "warn")
	end)

	-- ========================================
	-- RESET BUTTON
	-- ========================================

	local resetBtn = Instance.new("TextButton", hostPage)
	resetBtn.Size = UDim2.new(1, 0, 0, 40)
	resetBtn.BackgroundColor3 = Color3.fromRGB(38, 18, 18)
	resetBtn.TextColor3 = T.DANGER
	resetBtn.Text = "↺  Reset All Host Settings"
	resetBtn.TextSize = 12
	resetBtn.Font = Enum.Font.GothamBold
	resetBtn.BorderSizePixel = 0
	resetBtn.ZIndex = 12
	resetBtn.LayoutOrder = 11
	corner(resetBtn, 10)
	stroke(resetBtn, T.DANGER, 1)

	resetBtn.MouseEnter:Connect(function()
		tween(resetBtn, {BackgroundColor3=Color3.fromRGB(70, 25, 25)})
	end)
	resetBtn.MouseLeave:Connect(function()
		tween(resetBtn, {BackgroundColor3=Color3.fromRGB(38, 18, 18)})
	end)
	resetBtn.MouseButton1Click:Connect(function()
		hostSystem:setHost(nil)
		hostSystem.whitelist = {}
		hostSystem.blacklist = {}
		hostSystem.hostHistory = {}
		hostSystem.hostKicks = 0
		hostSystem.hostBans = 0
		hostSystem.hostWarnings = 0
		hostSystem.hostPassword = nil
		hostSystem.hostProtected = false
		showToast("👑 Đã reset toàn bộ cài đặt host!", "warn")
		rebuildHostUI()
	end)

	-- ========================================
	-- INIT
	-- ========================================

	-- Hook vào hostSystem
	hostSystem.onHostChanged = function()
		rebuildHostUI()
	end
	hostSystem.onHostAction = function()
		rebuildHistory()
	end

	-- Auto rehost
	Players.PlayerRemoving:Connect(function(plr)
		if plr == hostSystem.hostPlayer and hostSystem.hostAutoRehost then
			task.wait(1)
			local newHost = nil
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= plr then
					if hostSystem.whitelist[tostring(p.UserId)] then
						newHost = p
						break
					end
				end
			end
			if not newHost then
				for _, p in ipairs(Players:GetPlayers()) do
					if p ~= plr then
						newHost = p
						break
					end
				end
			end
			if newHost then
				hostSystem:setHost(newHost)
				showToast("👑 Tự động chuyển host cho " .. newHost.Name, "ok")
			end
		end
	end)

	-- Build UI lần đầu
	rebuildHostUI()

	-- Update khi có player join/leave
	Players.PlayerAdded:Connect(function() task.wait(0.5); rebuildPlayerList() end)
	Players.PlayerRemoving:Connect(function() task.wait(0.1); rebuildPlayerList() end)
end
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
