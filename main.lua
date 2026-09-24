local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local CONFIG = {
    FolderName = "RenderedEggs",
    FlySpeed = 120,
    ArriveDistance = 6,
    PromptHoldTime = 0.5,
}

local RANKING = {
    { nome = "Comuns",    atalho = "Co", cor = Color3.fromRGB(180, 180, 180), eggs = {
        "White Egg", "Brown Egg"
    }},
    { nome = "Raros",     atalho = "Ra", cor = Color3.fromRGB(80, 180, 90), eggs = {
        "Cracked Egg", "Easter Egg", "Stone Egg", "Leaf Egg"
    }},
    { nome = "Épicos",    atalho = "Ép", cor = Color3.fromRGB(140, 80, 220), eggs = {
        "Mushroom Egg", "Flower Egg", "Slime Egg", "Ice Egg"
    }},
    { nome = "Lendários", atalho = "Le", cor = Color3.fromRGB(255, 190, 40), eggs = {
        "Glass Egg", "Golden Egg"
    }},
    { nome = "Míticos",   atalho = "Mí", cor = Color3.fromRGB(240, 90, 90), eggs = {
        "Diamond Egg", "Crystal Egg", "Skull Egg", "Asterold Egg",
        "Dominus Egg", "Flaming Egg", "Sinister Egg", "Soul Egg"
    }},
    { nome = "Divinos",   atalho = "Di", cor = Color3.fromRGB(90, 220, 240), eggs = {
        "Aurora Egg", "Galaxy Egg"
    }},
    { nome = "Etéreos",   atalho = "Et", cor = Color3.fromRGB(255, 90, 220), eggs = {
        "Blackhole Egg", "Solaris Egg", "Cherub Egg"
    }},
}

local rankPorNome = {}
for i, rank in ipairs(RANKING) do
    for _, nomeEgg in ipairs(rank.eggs) do
        rankPorNome[nomeEgg] = { ordem = i, cor = rank.cor, nomeRank = rank.nome }
    end
end

local existingGui = CoreGui:FindFirstChild("EggFinderGui")
if existingGui then existingGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EggFinderGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

local PANEL_W = 140
local PANEL_H = 235
local HEADER_H = 28

local BorderWrapper = Instance.new("Frame")
BorderWrapper.Name = "BorderWrapper"
BorderWrapper.Size = UDim2.new(0, PANEL_W + 4, 0, PANEL_H + 4)
BorderWrapper.Position = UDim2.new(0.5, -(PANEL_W/2 + 2), 0.5, -(PANEL_H/2 + 2))
BorderWrapper.BackgroundColor3 = Color3.fromRGB(60, 130, 220)
BorderWrapper.BorderSizePixel = 0
BorderWrapper.ZIndex = 0
BorderWrapper.Parent = ScreenGui
Instance.new("UICorner", BorderWrapper).CornerRadius = UDim.new(0, 9)

local borderGrad = Instance.new("UIGradient")
borderGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 90, 180)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(120, 200, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 130, 220)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(30, 70, 160)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 90, 180)),
})
borderGrad.Parent = BorderWrapper

task.spawn(function()
    while BorderWrapper.Parent do
        borderGrad.Rotation = 0
        local t = TweenService:Create(borderGrad, TweenInfo.new(3, Enum.EasingStyle.Linear), { Rotation = 360 })
        t:Play()
        t.Completed:Wait()
        task.wait(0.01)
    end
end)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
MainFrame.Position = UDim2.new(0.5, -PANEL_W/2, 0.5, -PANEL_H/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 2
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 7)

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, HEADER_H)
TitleBar.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 3
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 7)

local titleBarFix = Instance.new("Frame")
titleBarFix.Size = UDim2.new(1, 0, 0, 8)
titleBarFix.Position = UDim2.new(0, 0, 1, -8)
titleBarFix.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
titleBarFix.BorderSizePixel = 0
titleBarFix.ZIndex = 3
titleBarFix.Parent = TitleBar

local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, -4, 0, 2)
TopLine.Position = UDim2.new(0, 2, 0, 0)
TopLine.BackgroundColor3 = Color3.fromRGB(120, 200, 255)
TopLine.BorderSizePixel = 0
TopLine.ZIndex = 4
TopLine.Parent = TitleBar

local topLineGrad = Instance.new("UIGradient")
topLineGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1),
})
topLineGrad.Parent = TopLine

local HeaderLED = Instance.new("Frame")
HeaderLED.Size = UDim2.new(0, 5, 0, 5)
HeaderLED.Position = UDim2.new(0, 6, 0, 6)
HeaderLED.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
HeaderLED.BorderSizePixel = 0
HeaderLED.ZIndex = 4
HeaderLED.Parent = TitleBar
Instance.new("UICorner", HeaderLED).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    while HeaderLED.Parent do
        local t1 = TweenService:Create(HeaderLED, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.6,
            Size = UDim2.new(0, 3, 0, 3),
            Position = UDim2.new(0, 7, 0, 7),
        })
        t1:Play(); t1.Completed:Wait()
        if not HeaderLED.Parent then break end
        local t2 = TweenService:Create(HeaderLED, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0,
            Size = UDim2.new(0, 5, 0, 5),
            Position = UDim2.new(0, 6, 0, 6),
        })
        t2:Play(); t2.Completed:Wait()
    end
end)

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -60, 0, 12)
TitleText.Position = UDim2.new(0, 16, 0, 2)
TitleText.BackgroundTransparency = 1
TitleText.Text = "PL HUB"
TitleText.TextColor3 = Color3.fromRGB(230, 240, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 10
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 4
TitleText.Parent = TitleBar

local SubtitleText = Instance.new("TextLabel")
SubtitleText.Size = UDim2.new(1, -60, 0, 9)
SubtitleText.Position = UDim2.new(0, 16, 0, 15)
SubtitleText.BackgroundTransparency = 1
SubtitleText.Text = "Ride An Egg v1.0"
SubtitleText.TextColor3 = Color3.fromRGB(110, 160, 220)
SubtitleText.Font = Enum.Font.Gotham
SubtitleText.TextSize = 6
SubtitleText.TextXAlignment = Enum.TextXAlignment.Left
SubtitleText.ZIndex = 4
SubtitleText.Parent = TitleBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 14, 0, 14)
MinimizeButton.Position = UDim2.new(1, -36, 0, 7)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 130, 220)
MinimizeButton.Text = "–"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 12
MinimizeButton.BorderSizePixel = 0
MinimizeButton.AutoButtonColor = false
MinimizeButton.ZIndex = 4
MinimizeButton.Parent = TitleBar
Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 3)

local CloseButtonTop = Instance.new("TextButton")
CloseButtonTop.Size = UDim2.new(0, 14, 0, 14)
CloseButtonTop.Position = UDim2.new(1, -19, 0, 7)
CloseButtonTop.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButtonTop.Text = "✕"
CloseButtonTop.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButtonTop.Font = Enum.Font.GothamBold
CloseButtonTop.TextSize = 9
CloseButtonTop.BorderSizePixel = 0
CloseButtonTop.AutoButtonColor = false
CloseButtonTop.ZIndex = 4
CloseButtonTop.Parent = TitleBar
Instance.new("UICorner", CloseButtonTop).CornerRadius = UDim.new(0, 3)

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -HEADER_H)
ContentFrame.Position = UDim2.new(0, 0, 0, HEADER_H)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ClipsDescendants = true
ContentFrame.ZIndex = 3
ContentFrame.Parent = MainFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -8, 0, 108)
ScrollFrame.Position = UDim2.new(0, 4, 0, 4)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 130, 200)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.ZIndex = 3
ScrollFrame.Parent = ContentFrame
Instance.new("UICorner", ScrollFrame).CornerRadius = UDim.new(0, 4)

local scrollStroke = Instance.new("UIStroke")
scrollStroke.Color = Color3.fromRGB(60, 90, 140)
scrollStroke.Thickness = 1
scrollStroke.Transparency = 0.5
scrollStroke.Parent = ScrollFrame

local ScrollPadding = Instance.new("UIPadding")
ScrollPadding.PaddingTop = UDim.new(0, 2)
ScrollPadding.PaddingBottom = UDim.new(0, 2)
ScrollPadding.PaddingLeft = UDim.new(0, 2)
ScrollPadding.PaddingRight = UDim.new(0, 2)
ScrollPadding.Parent = ScrollFrame

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollLayout.Padding = UDim.new(0, 2)
ScrollLayout.Parent = ScrollFrame

local TierScroll = Instance.new("ScrollingFrame")
TierScroll.Size = UDim2.new(1, -8, 0, 16)
TierScroll.Position = UDim2.new(0, 4, 0, 116)
TierScroll.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
TierScroll.BorderSizePixel = 0
TierScroll.ScrollBarThickness = 2
TierScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 130, 200)
TierScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TierScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
TierScroll.ScrollingDirection = Enum.ScrollingDirection.X
TierScroll.ZIndex = 3
TierScroll.Parent = ContentFrame
Instance.new("UICorner", TierScroll).CornerRadius = UDim.new(0, 3)

local TierLayout = Instance.new("UIListLayout")
TierLayout.FillDirection = Enum.FillDirection.Horizontal
TierLayout.Padding = UDim.new(0, 2)
TierLayout.SortOrder = Enum.SortOrder.LayoutOrder
TierLayout.Parent = TierScroll

local TierPad = Instance.new("UIPadding")
TierPad.PaddingLeft = UDim.new(0, 2)
TierPad.PaddingRight = UDim.new(0, 2)
TierPad.PaddingTop = UDim.new(0, 2)
TierPad.Parent = TierScroll

local SearchButton = Instance.new("TextButton")
SearchButton.Size = UDim2.new(1, -8, 0, 20)
SearchButton.Position = UDim2.new(0, 4, 0, 136)
SearchButton.BackgroundColor3 = Color3.fromRGB(60, 130, 220)
SearchButton.Text = "Buscar Egg"
SearchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchButton.Font = Enum.Font.GothamBold
SearchButton.TextSize = 9
SearchButton.BorderSizePixel = 0
SearchButton.AutoButtonColor = false
SearchButton.ZIndex = 3
SearchButton.Parent = ContentFrame
Instance.new("UICorner", SearchButton).CornerRadius = UDim.new(0, 4)

local searchScale = Instance.new("UIScale")
searchScale.Parent = SearchButton

local StatusRow = Instance.new("Frame")
StatusRow.Size = UDim2.new(1, -8, 0, 13)
StatusRow.Position = UDim2.new(0, 4, 0, 160)
StatusRow.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
StatusRow.BorderSizePixel = 0
StatusRow.ZIndex = 3
StatusRow.Parent = ContentFrame
Instance.new("UICorner", StatusRow).CornerRadius = UDim.new(0, 3)

local StatusLED = Instance.new("Frame")
StatusLED.Size = UDim2.new(0, 5, 0, 5)
StatusLED.Position = UDim2.new(0, 5, 0.5, -2.5)
StatusLED.BackgroundColor3 = Color3.fromRGB(80, 220, 100)
StatusLED.BorderSizePixel = 0
StatusLED.ZIndex = 4
StatusLED.Parent = StatusRow
Instance.new("UICorner", StatusLED).CornerRadius = UDim.new(1, 0)

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -18, 1, 0)
StatusText.Position = UDim2.new(0, 15, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Pronto"
StatusText.TextColor3 = Color3.fromRGB(120, 220, 150)
StatusText.Font = Enum.Font.GothamBold
StatusText.TextSize = 7
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.ZIndex = 4
StatusText.Parent = StatusRow

local CloseButtonBottom = Instance.new("TextButton")
CloseButtonBottom.Size = UDim2.new(1, -8, 0, 18)
CloseButtonBottom.Position = UDim2.new(0, 4, 0, 177)
CloseButtonBottom.BackgroundColor3 = Color3.fromRGB(180, 55, 55)
CloseButtonBottom.Text = "Fechar"
CloseButtonBottom.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButtonBottom.Font = Enum.Font.GothamBold
CloseButtonBottom.TextSize = 9
CloseButtonBottom.BorderSizePixel = 0
CloseButtonBottom.AutoButtonColor = false
CloseButtonBottom.ZIndex = 3
CloseButtonBottom.Parent = ContentFrame
Instance.new("UICorner", CloseButtonBottom).CornerRadius = UDim.new(0, 4)

local closeScale = Instance.new("UIScale")
closeScale.Parent = CloseButtonBottom

local selectedEgg = nil
local eggButtons = {}
local flying = false
local filtroAtivo = nil
local tierButtons = {}
local minimizado = false

local COR_NORMAL = Color3.fromRGB(46, 46, 58)
local COR_SELECIONADO = Color3.fromRGB(60, 180, 90)
local COR_TIER_OFF = Color3.fromRGB(40, 40, 52)

local COR_STATUS_OK = Color3.fromRGB(80, 220, 100)
local COR_STATUS_WORK = Color3.fromRGB(255, 170, 60)
local COR_STATUS_ERR = Color3.fromRGB(255, 80, 80)

local function setStatus(cor, texto)
    StatusLED.BackgroundColor3 = cor
    StatusText.TextColor3 = cor
    StatusText.Text = texto
    StatusLED.Size = UDim2.new(0, 5, 0, 5)
    StatusLED.Position = UDim2.new(0, 5, 0.5, -2.5)
    task.spawn(function()
        if not StatusLED.Parent then return end
        local t1 = TweenService:Create(StatusLED, TweenInfo.new(0.12), {
            Size = UDim2.new(0, 9, 0, 9),
            Position = UDim2.new(0, 3, 0.5, -4.5),
        })
        t1:Play(); t1.Completed:Wait()
        if not StatusLED.Parent then return end
        local t2 = TweenService:Create(StatusLED, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 5, 0, 5),
            Position = UDim2.new(0, 5, 0.5, -2.5),
        })
        t2:Play()
    end)
end

local function tactile(btn)
    local scale = Instance.new("UIScale")
    scale.Parent = btn
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.08), { Scale = 0.97 }):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    end)
end

local function atualizarSelecaoTier()
    for idx, btn in pairs(tierButtons) do
        if idx == 0 then
            if filtroAtivo == nil then
                btn.BackgroundColor3 = Color3.fromRGB(60, 130, 220)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                btn.BackgroundColor3 = COR_TIER_OFF
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        else
            local rankInfo = RANKING[idx]
            if filtroAtivo == idx then
                btn.BackgroundColor3 = rankInfo.cor
                btn.TextColor3 = Color3.fromRGB(20, 20, 25)
            else
                btn.BackgroundColor3 = COR_TIER_OFF
                btn.TextColor3 = rankInfo.cor
            end
        end
    end
end

local function criarBotoesTier()
    local btnTodos = Instance.new("TextButton")
    btnTodos.Size = UDim2.new(0, 26, 0, 12)
    btnTodos.BackgroundColor3 = Color3.fromRGB(60, 130, 220)
    btnTodos.Text = "Todos"
    btnTodos.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnTodos.Font = Enum.Font.GothamBold
    btnTodos.TextSize = 7
    btnTodos.BorderSizePixel = 0
    btnTodos.AutoButtonColor = false
    btnTodos.LayoutOrder = 0
    btnTodos.Parent = TierScroll
    Instance.new("UICorner", btnTodos).CornerRadius = UDim.new(0, 3)
    tactile(btnTodos)

    btnTodos.MouseButton1Click:Connect(function()
        filtroAtivo = nil
        atualizarSelecaoTier()
        popularLista()
    end)
    tierButtons[0] = btnTodos

    for i, rankInfo in ipairs(RANKING) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 24, 0, 12)
        btn.BackgroundColor3 = COR_TIER_OFF
        btn.Text = rankInfo.atalho
        btn.TextColor3 = rankInfo.cor
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 7
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.LayoutOrder = i
        btn.Parent = TierScroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)

        local stroke = Instance.new("UIStroke")
        stroke.Color = rankInfo.cor
        stroke.Thickness = 1
        stroke.Transparency = 0.6
        stroke.Parent = btn

        tactile(btn)

        btn.MouseButton1Click:Connect(function()
            if filtroAtivo == i then
                filtroAtivo = nil
            else
                filtroAtivo = i
            end
            atualizarSelecaoTier()
            popularLista()
        end)
        tierButtons[i] = btn
    end
end

local function criarBotaoEgg(model, order, rankData)
    local nomeModel = model.Name
    local corRaridade = rankData and rankData.cor or Color3.fromRGB(150, 150, 150)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 16)
    btn.BackgroundColor3 = COR_NORMAL
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.ClipsDescendants = true
    btn.Parent = ScrollFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)

    local stroke = Instance.new("UIStroke")
    stroke.Color = corRaridade
    stroke.Thickness = 1
    stroke.Transparency = 0.55
    stroke.Parent = btn

    local sideBar = Instance.new("Frame")
    sideBar.Size = UDim2.new(0, 2, 1, -4)
    sideBar.Position = UDim2.new(0, 2, 0, 2)
    sideBar.BackgroundColor3 = corRaridade
    sideBar.BorderSizePixel = 0
    sideBar.Parent = btn
    Instance.new("UICorner", sideBar).CornerRadius = UDim.new(1, 0)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -22, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = nomeModel
    label.TextColor3 = corRaridade
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 8
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.Parent = btn

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 12, 1, 0)
    arrow.Position = UDim2.new(1, -12, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "›"
    arrow.TextColor3 = corRaridade
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 12
    arrow.TextTransparency = 1
    arrow.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(arrow, TweenInfo.new(0.15), {
            TextTransparency = 0,
            Position = UDim2.new(1, -14, 0, 0),
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(arrow, TweenInfo.new(0.15), {
            TextTransparency = 1,
            Position = UDim2.new(1, -12, 0, 0),
        }):Play()
    end)

    tactile(btn)

    btn.MouseButton1Click:Connect(function()
        for _, otherBtn in pairs(eggButtons) do
            otherBtn.BackgroundColor3 = COR_NORMAL
        end
        btn.BackgroundColor3 = COR_SELECIONADO
        selectedEgg = model
    end)

    eggButtons[model] = btn
end

function popularLista()
    for _, btn in pairs(eggButtons) do btn:Destroy() end
    eggButtons = {}
    selectedEgg = nil

    local pasta = Workspace:FindFirstChild(CONFIG.FolderName)
    if not pasta then
        local aviso = Instance.new("TextLabel")
        aviso.Size = UDim2.new(1, 0, 0, 18)
        aviso.BackgroundTransparency = 1
        aviso.Text = "⚠ Pasta não encontrada"
        aviso.TextColor3 = Color3.fromRGB(220, 90, 90)
        aviso.Font = Enum.Font.Gotham
        aviso.TextSize = 7
        aviso.TextWrapped = true
        aviso.Parent = ScrollFrame
        return
    end

    local modelsEncontrados = {}
    for _, obj in ipairs(pasta:GetChildren()) do
        if obj:IsA("Model") then
            table.insert(modelsEncontrados, obj)
        end
    end

    local listaFiltrada = {}
    for _, model in ipairs(modelsEncontrados) do
        local rankData = rankPorNome[model.Name]
        if not rankData then
            for nomeRank, dados in pairs(rankPorNome) do
                if string.find(model.Name, nomeRank, 1, true) then
                    rankData = dados
                    break
                end
            end
        end

        if rankData then
            if filtroAtivo == nil or rankData.ordem == filtroAtivo then
                table.insert(listaFiltrada, { model = model, rank = rankData })
            end
        else
            if filtroAtivo == nil then
                table.insert(listaFiltrada, { model = model, rank = nil })
            end
        end
    end

    table.sort(listaFiltrada, function(a, b)
        local ordA = a.rank and a.rank.ordem or 999
        local ordB = b.rank and b.rank.ordem or 999
        if ordA ~= ordB then return ordA < ordB end
        return a.model.Name < b.model.Name
    end)

    for i, item in ipairs(listaFiltrada) do
        criarBotaoEgg(item.model, i, item.rank)
    end

    if #listaFiltrada == 0 then
        local aviso = Instance.new("TextLabel")
        aviso.Size = UDim2.new(1, 0, 0, 18)
        aviso.BackgroundTransparency = 1
        aviso.Text = filtroAtivo and "Nenhum egg desse tier" or "Nenhum egg encontrado"
        aviso.TextColor3 = Color3.fromRGB(180, 180, 190)
        aviso.Font = Enum.Font.Gotham
        aviso.TextSize = 7
        aviso.Parent = ScrollFrame
    end
end

local function observarPasta()
    local pasta = Workspace:FindFirstChild(CONFIG.FolderName)
    if pasta then
        pasta.ChildAdded:Connect(function() task.wait(0.1) popularLista() end)
        pasta.ChildRemoved:Connect(function() task.wait(0.1) popularLista() end)
    end
end

local function voarParaPosicao(destinoPos, distanciaParada)
    flying = true
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if not flying or not rootPart or not rootPart.Parent then
            if conn then conn:Disconnect() end
            return
        end
        local atual = rootPart.Position
        local direcao = destinoPos - atual
        local dist = direcao.Magnitude
        if dist <= distanciaParada then
            conn:Disconnect()
            return
        end
        local passo = direcao.Unit * math.min(CONFIG.FlySpeed * dt, dist)
        rootPart.CFrame = CFrame.new(atual + passo)
    end)
    repeat task.wait(0.03) until not conn.Connected
end

local function acionarPrompt(model)
    local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
    if not prompt then return false end
    local ok = pcall(function() fireproximityprompt(prompt) end)
    if not ok then
        pcall(function()
            prompt:InputHoldBegin()
            task.wait(CONFIG.PromptHoldTime)
            prompt:InputHoldEnd()
        end)
    end
    task.wait(0.3)
    return true
end

local function buscarEgg()
    if flying then return end

    if not selectedEgg or not selectedEgg.Parent then
        setStatus(COR_STATUS_ERR, "Selecione um egg!")
        SearchButton.Text = "⚠ Selecione!"
        SearchButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
        task.wait(1)
        SearchButton.Text = "Buscar Egg"
        SearchButton.BackgroundColor3 = Color3.fromRGB(60, 130, 220)
        setStatus(COR_STATUS_OK, "Pronto")
        return
    end

    character = player.Character
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")

    setStatus(COR_STATUS_WORK, "Voando...")
    SearchButton.Text = "🛫 Voando..."
    SearchButton.BackgroundColor3 = Color3.fromRGB(80, 180, 100)

    local eggPos
    if selectedEgg:IsA("Model") then
        local primary = selectedEgg.PrimaryPart or selectedEgg:FindFirstChildWhichIsA("BasePart")
        eggPos = primary and primary.Position or selectedEgg:GetPivot().Position
    end

    if not eggPos then
        setStatus(COR_STATUS_ERR, "Erro: sem posição")
        SearchButton.Text = "⚠ Sem posição!"
        SearchButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
        task.wait(1)
        SearchButton.Text = "Buscar Egg"
        SearchButton.BackgroundColor3 = Color3.fromRGB(60, 130, 220)
        setStatus(COR_STATUS_OK, "Pronto")
        return
    end

    local old = {
        WalkSpeed = humanoid.WalkSpeed,
        JumpPower = humanoid.JumpPower,
        JumpHeight = humanoid.JumpHeight,
        UseJumpPower = humanoid.UseJumpPower,
        Anchored = rootPart.Anchored,
        CanCollide = rootPart.CanCollide,
        Gravity = Workspace.Gravity,
        PlatformStand = humanoid.PlatformStand,
        StartPos = rootPart.CFrame,
    }

    humanoid.PlatformStand = true
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    humanoid.JumpHeight = 0
    Workspace.Gravity = 0
    rootPart.Anchored = false
    rootPart.CanCollide = false

    voarParaPosicao(eggPos, CONFIG.ArriveDistance)

    setStatus(COR_STATUS_WORK, "Interagindo...")
    SearchButton.Text = "✋ Interagindo..."
    acionarPrompt(selectedEgg)

    setStatus(COR_STATUS_WORK, "Voltando...")
    SearchButton.Text = "🛬 Voltando..."
    voarParaPosicao(old.StartPos.Position, 3)
    flying = false
    task.wait(0.15)

    if rootPart and rootPart.Parent then
        rootPart.CFrame = old.StartPos
        rootPart.Anchored = old.Anchored
        rootPart.CanCollide = old.CanCollide
    end
    if humanoid and humanoid.Parent then
        humanoid.WalkSpeed = old.WalkSpeed
        humanoid.JumpPower = old.JumpPower
        humanoid.JumpHeight = old.JumpHeight
        humanoid.UseJumpPower = old.UseJumpPower
        humanoid.PlatformStand = old.PlatformStand
    end
    Workspace.Gravity = old.Gravity

    setStatus(COR_STATUS_OK, "Feito!")
    SearchButton.Text = "✅ Feito!"
    SearchButton.BackgroundColor3 = Color3.fromRGB(80, 180, 100)
    task.wait(1)
    SearchButton.Text = "Buscar Egg"
    SearchButton.BackgroundColor3 = Color3.fromRGB(60, 130, 220)
    setStatus(COR_STATUS_OK, "Pronto")
end

SearchButton.MouseButton1Click:Connect(buscarEgg)

SearchButton.MouseButton1Down:Connect(function()
    TweenService:Create(searchScale, TweenInfo.new(0.08), { Scale = 0.97 }):Play()
end)
SearchButton.MouseButton1Up:Connect(function()
    TweenService:Create(searchScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
end)
SearchButton.MouseEnter:Connect(function()
    TweenService:Create(SearchButton, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(80, 150, 240)
    }):Play()
end)
SearchButton.MouseLeave:Connect(function()
    TweenService:Create(searchScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    TweenService:Create(SearchButton, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(60, 130, 220)
    }):Play()
end)

local function fecharComAnimacao()
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    }):Play()
    TweenService:Create(BorderWrapper, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    }):Play()
    task.wait(0.26)
    flying = false
    ScreenGui:Destroy()
end

local MIN_W = PANEL_W
local MIN_H = HEADER_H

local function toggleMinimizar()
    minimizado = not minimizado
    if minimizado then
        local mainPos = MainFrame.Position
        local wrapPos = BorderWrapper.Position
        TweenService:Create(ContentFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0, 0, 0, HEADER_H),
            BackgroundTransparency = 1,
        }):Play()
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, MIN_W, 0, MIN_H),
        }):Play()
        TweenService:Create(BorderWrapper, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, MIN_W + 4, 0, MIN_H + 4),
        }):Play()
        MinimizeButton.Text = "+"
    else
        TweenService:Create(ContentFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0, 0, 0, HEADER_H),
            BackgroundTransparency = 1,
        }):Play()
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, PANEL_W, 0, PANEL_H),
        }):Play()
        TweenService:Create(BorderWrapper, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, PANEL_W + 4, 0, PANEL_H + 4),
        }):Play()
        MinimizeButton.Text = "–"
    end
end

MinimizeButton.MouseButton1Click:Connect(toggleMinimizar)
MinimizeButton.MouseEnter:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(80, 150, 240)
    }):Play()
end)
MinimizeButton.MouseLeave:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(60, 130, 220)
    }):Play()
end)

CloseButtonTop.MouseButton1Click:Connect(fecharComAnimacao)
CloseButtonBottom.MouseButton1Click:Connect(fecharComAnimacao)

CloseButtonTop.MouseButton1Down:Connect(function()
    TweenService:Create(CloseButtonTop, TweenInfo.new(0.08), { Size = UDim2.new(0, 13, 0, 13) }):Play()
end)
CloseButtonTop.MouseButton1Up:Connect(function()
    TweenService:Create(CloseButtonTop, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, 14, 0, 14) }):Play()
end)

CloseButtonBottom.MouseButton1Down:Connect(function()
    TweenService:Create(closeScale, TweenInfo.new(0.08), { Scale = 0.97 }):Play()
end)
CloseButtonBottom.MouseButton1Up:Connect(function()
    TweenService:Create(closeScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
end)
CloseButtonBottom.MouseEnter:Connect(function()
    TweenService:Create(CloseButtonBottom, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(220, 70, 70)
    }):Play()
end)
CloseButtonBottom.MouseLeave:Connect(function()
    TweenService:Create(closeScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    TweenService:Create(CloseButtonBottom, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(180, 55, 55)
    }):Play()
end)

local dragging = false
local dragStart, startPos, wrapperStartPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
       or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        wrapperStartPos = BorderWrapper.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                     or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        BorderWrapper.Position = UDim2.new(
            wrapperStartPos.X.Scale, wrapperStartPos.X.Offset + delta.X,
            wrapperStartPos.Y.Scale, wrapperStartPos.Y.Offset + delta.Y
        )
    end
end)

criarBotoesTier()
atualizarSelecaoTier()
popularLista()
observarPasta()
setStatus(COR_STATUS_OK, "Pronto")
