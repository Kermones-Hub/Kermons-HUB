-- Проверка загрузки игры
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Сервисы
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game.Players
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Удаление старого UI
if game.CoreGui:FindFirstChild("DeltaPurpleMenuPro") then
    game.CoreGui.DeltaPurpleMenuPro:Destroy()
end

-- Переменные состояния
local selectedPack = nil
local defaultAnimBackup = {}
local CORRECT_KEY = "кера" -- Ключ для доступа

-- Таблица всех анимаций (Официальные R15 ID)
local AnimationPacks = {
    ["Zombie 🧟"] = {
        idle = 616158929, walk = 616168072, run = 616163682,
        jump = 616161997, fall = 616157476, swim = 616165109, climb = 616156113
    },
    ["Ninja 🥷"] = {
        idle = 656117400, walk = 656121766, run = 656118852,
        jump = 656117878, fall = 656115606, swim = 656119721, climb = 656114377
    },
    ["Toy 🧸"] = {
        idle = 782841498, walk = 782842708, run = 782842708,
        jump = 782847020, fall = 782846465, swim = 782845914, climb = 782844888
    },
    ["Vampire 🧛"] = {
        idle = 1083445855, walk = 1083452052, run = 1083451491,
        jump = 1083450588, fall = 1083443587, swim = 1083452661, climb = 1083441402
    },
    ["Mage 🧙‍♂️"] = {
        idle = 707742142, walk = 707897309, run = 707861613,
        jump = 707853694, fall = 707829716, swim = 707825590, climb = 707823708
    },
    ["Superhero 🦸"] = {
        idle = 616111295, walk = 616123289, run = 616117076,
        jump = 616115533, fall = 616109230, swim = 616119932, climb = 616104706
    },
    ["Robot 🤖"] = {
        idle = 616088211, walk = 616095330, run = 616091570,
        jump = 616090535, fall = 616087089, swim = 616093392, climb = 616086034
    },
    ["Knight ⚔️"] = {
        idle = 657593020, walk = 657552424, run = 657550889,
        jump = 657551221, fall = 657550058, swim = 657551719, climb = 657549420
    },
    ["Cartoony 🎨"] = {
        idle = 742637544, walk = 742640026, run = 742638842,
        jump = 742637942, fall = 742636889, swim = 742639233, climb = 742636368
    },
    ["Astronaut 👨‍🚀"] = {
        idle = 891621366, walk = 891667138, run = 891636393,
        jump = 891627522, fall = 891617961, swim = 891653800, climb = 891609353
    }
}

-- Создание бэкапа анимаций
local function backupDefaultAnimations(animate)
    defaultAnimBackup = {}
    for _, folder in ipairs(animate:GetChildren()) do
        if folder:IsA("StringValue") or folder:IsA("Configuration") or folder:IsA("Folder") then
            defaultAnimBackup[folder.Name] = {}
            for _, anim in ipairs(folder:GetChildren()) do
                if anim:IsA("Animation") then
                    defaultAnimBackup[folder.Name][anim.Name] = anim.AnimationId
                end
            end
        end
    end
end

-- Применение анимаций
local function applyAnimations(animTable)
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local animate = char:FindFirstChild("Animate")
    if not humanoid or not animate then return end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:Stop(0)
        end
    end

    animate.Disabled = true

    for folderName, id in pairs(animTable) do
        local folder = animate:FindFirstChild(folderName)
        if folder then
            for _, child in ipairs(folder:GetChildren()) do
                if child:IsA("Animation") then
                    child.AnimationId = "rbxassetid://" .. tostring(id)
                end
            end
        end
    end

    task.wait(0.05)
    animate.Disabled = false
end

-- Сброс анимаций
local function restoreDefaultAnimations()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local animate = char:FindFirstChild("Animate")
    if not humanoid or not animate then return end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:Stop(0)
        end
    end

    animate.Disabled = true

    for folderName, anims in pairs(defaultAnimBackup) do
        local folder = animate:FindFirstChild(folderName)
        if folder then
            for animName, animId in pairs(anims) do
                local animObj = folder:FindFirstChild(animName)
                if animObj and animObj:IsA("Animation") then
                    animObj.AnimationId = animId
                end
            end
        end
    end

    task.wait(0.05)
    animate.Disabled = false
    selectedPack = nil
end

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    local animate = char:WaitForChild("Animate", 5)
    if animate then
        backupDefaultAnimations(animate)
        if selectedPack and AnimationPacks[selectedPack] then
            task.wait(0.2)
            applyAnimations(AnimationPacks[selectedPack])
        end
    end
end)

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaPurpleMenuPro"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- ==================== ОКНО ВВОДА КЛЮЧА ====================

local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Parent = ScreenGui
KeyFrame.BackgroundColor3 = Color3.fromRGB(18, 14, 25)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
KeyFrame.Size = UDim2.new(0, 300, 0, 200)
KeyFrame.Active = true
KeyFrame.Draggable = true

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 16)
KeyCorner.Parent = KeyFrame

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Parent = KeyFrame
KeyStroke.Color = Color3.fromRGB(130, 40, 220)
KeyStroke.Thickness = 2

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyFrame
KeyTitle.BackgroundTransparency = 1
KeyTitle.Position = UDim2.new(0, 0, 0, 15)
KeyTitle.Size = UDim2.new(1, 0, 0, 30)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Text = "🔑 Ввод ключа доступа"
KeyTitle.TextColor3 = Color3.fromRGB(220, 180, 255)
KeyTitle.TextSize = 16

local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Parent = KeyFrame
KeyTextBox.BackgroundColor3 = Color3.fromRGB(28, 20, 40)
KeyTextBox.Position = UDim2.new(0.1, 0, 0, 65)
KeyTextBox.Size = UDim2.new(0.8, 0, 0, 40)
KeyTextBox.Font = Enum.Font.Gotham
KeyTextBox.PlaceholderText = "Введите ключ..."
KeyTextBox.Text = ""
KeyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTextBox.PlaceholderColor3 = Color3.fromRGB(130, 110, 160)
KeyTextBox.TextSize = 14

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0, 10)
KeyBoxCorner.Parent = KeyTextBox

local KeyBoxStroke = Instance.new("UIStroke")
KeyBoxStroke.Parent = KeyTextBox
KeyBoxStroke.Color = Color3.fromRGB(90, 40, 150)

local SubmitButton = Instance.new("TextButton")
SubmitButton.Parent = KeyFrame
SubmitButton.BackgroundColor3 = Color3.fromRGB(85, 25, 140)
SubmitButton.Position = UDim2.new(0.1, 0, 0, 125)
SubmitButton.Size = UDim2.new(0.8, 0, 0, 40)
SubmitButton.Font = Enum.Font.GothamBold
SubmitButton.Text = "Подтвердить"
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.TextSize = 14

local SubmitCorner = Instance.new("UICorner")
SubmitCorner.CornerRadius = UDim.new(0, 10)
SubmitCorner.Parent = SubmitButton

local ErrorLabel = Instance.new("TextLabel")
ErrorLabel.Parent = KeyFrame
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Position = UDim2.new(0, 0, 0, 170)
ErrorLabel.Size = UDim2.new(1, 0, 0, 20)
ErrorLabel.Font = Enum.Font.Gotham
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
ErrorLabel.TextSize = 12


-- ==================== ОСНОВНОЙ ИНТЕРФЕЙС (Скрыт до ввода ключа) ====================

-- Кнопка открытия
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Parent = ScreenGui
OpenButton.BackgroundColor3 = Color3.fromRGB(85, 25, 140)
OpenButton.Position = UDim2.new(0.02, 0, 0.3, 0)
OpenButton.Size = UDim2.new(0, 52, 0, 52)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Text = "🔮"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 22
OpenButton.Active = true
OpenButton.Draggable = true
OpenButton.Visible = false

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 14)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Parent = OpenButton
OpenStroke.Color = Color3.fromRGB(170, 80, 255)
OpenStroke.Thickness = 2

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 14, 25)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -180)
MainFrame.Size = UDim2.new(0, 340, 0, 370)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(130, 40, 220)
MainStroke.Thickness = 2

-- Шапка
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 20, 40)
TitleBar.Size = UDim2.new(1, 0, 0, 48)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0.05, 0, 0, 0)
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "Kermons | HUB"
TitleText.TextColor3 = Color3.fromRGB(220, 180, 255)
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 40, 70)
CloseButton.Position = UDim2.new(1, -42, 0.5, -14)
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

local isOpen = false
local function toggleMenu()
    isOpen = not isOpen
    if isOpen then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 340, 0, 370),
            Position = UDim2.new(0.5, -170, 0.5, -185)
        }):Play()
    else
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            if not isOpen then MainFrame.Visible = false end
        end)
    end
end

CloseButton.MouseButton1Click:Connect(toggleMenu)
OpenButton.MouseButton1Click:Connect(toggleMenu)

-- Вкладки
local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.BackgroundTransparency = 1
TabBar.Position = UDim2.new(0, 10, 0, 54)
TabBar.Size = UDim2.new(1, -20, 0, 32)

local TabMainBtn = Instance.new("TextButton")
TabMainBtn.Parent = TabBar
TabMainBtn.BackgroundColor3 = Color3.fromRGB(70, 25, 120)
TabMainBtn.Size = UDim2.new(0.32, 0, 1, 0)
TabMainBtn.Font = Enum.Font.GothamBold
TabMainBtn.Text = "⚙️ Главная"
TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabMainBtn.TextSize = 11

local TabMainCorner = Instance.new("UICorner")
TabMainCorner.CornerRadius = UDim.new(0, 8)
TabMainCorner.Parent = TabMainBtn

local TabAnimBtn = Instance.new("TextButton")
TabAnimBtn.Parent = TabBar
TabAnimBtn.BackgroundColor3 = Color3.fromRGB(32, 24, 48)
TabAnimBtn.Position = UDim2.new(0.34, 0, 0, 0)
TabAnimBtn.Size = UDim2.new(0.32, 0, 1, 0)
TabAnimBtn.Font = Enum.Font.GothamBold
TabAnimBtn.Text = "🎭 Аним"
TabAnimBtn.TextColor3 = Color3.fromRGB(180, 150, 220)
TabAnimBtn.TextSize = 11

local TabAnimCorner = Instance.new("UICorner")
TabAnimCorner.CornerRadius = UDim.new(0, 8)
TabAnimCorner.Parent = TabAnimBtn

local TabInfoBtn = Instance.new("TextButton")
TabInfoBtn.Parent = TabBar
TabInfoBtn.BackgroundColor3 = Color3.fromRGB(32, 24, 48)
TabInfoBtn.Position = UDim2.new(0.68, 0, 0, 0)
TabInfoBtn.Size = UDim2.new(0.32, 0, 1, 0)
TabInfoBtn.Font = Enum.Font.GothamBold
TabInfoBtn.Text = "👤 Владелец"
TabInfoBtn.TextColor3 = Color3.fromRGB(180, 150, 220)
TabInfoBtn.TextSize = 11

local TabInfoCorner = Instance.new("UICorner")
TabInfoCorner.CornerRadius = UDim.new(0, 8)
TabInfoCorner.Parent = TabInfoBtn

-- Страницы
local PageMain = Instance.new("ScrollingFrame")
PageMain.Parent = MainFrame
PageMain.BackgroundTransparency = 1
PageMain.Position = UDim2.new(0, 10, 0, 94)
PageMain.Size = UDim2.new(1, -20, 1, -104)
PageMain.AutomaticCanvasSize = Enum.AutomaticSize.Y
PageMain.ScrollBarThickness = 3
PageMain.ScrollBarImageColor3 = Color3.fromRGB(150, 60, 255)
PageMain.Visible = true

local UIListMain = Instance.new("UIListLayout")
UIListMain.Parent = PageMain
UIListMain.SortOrder = Enum.SortOrder.LayoutOrder
UIListMain.Padding = UDim.new(0, 10)

local PageAnim = Instance.new("ScrollingFrame")
PageAnim.Parent = MainFrame
PageAnim.BackgroundTransparency = 1
PageAnim.Position = UDim2.new(0, 10, 0, 94)
PageAnim.Size = UDim2.new(1, -20, 1, -104)
PageAnim.AutomaticCanvasSize = Enum.AutomaticSize.Y
PageAnim.ScrollBarThickness = 3
PageAnim.ScrollBarImageColor3 = Color3.fromRGB(150, 60, 255)
PageAnim.Visible = false

local UIListAnim = Instance.new("UIListLayout")
UIListAnim.Parent = PageAnim
UIListAnim.SortOrder = Enum.SortOrder.LayoutOrder
UIListAnim.Padding = UDim.new(0, 8)

local PageInfo = Instance.new("ScrollingFrame")
PageInfo.Parent = MainFrame
PageInfo.BackgroundTransparency = 1
PageInfo.Position = UDim2.new(0, 10, 0, 94)
PageInfo.Size = UDim2.new(1, -20, 1, -104)
PageInfo.AutomaticCanvasSize = Enum.AutomaticSize.Y
PageInfo.ScrollBarThickness = 3
PageInfo.ScrollBarImageColor3 = Color3.fromRGB(150, 60, 255)
PageInfo.Visible = false

local UIListInfo = Instance.new("UIListLayout")
UIListInfo.Parent = PageInfo
UIListInfo.SortOrder = Enum.SortOrder.LayoutOrder
UIListInfo.Padding = UDim.new(0, 10)

-- Переключение вкладок
TabMainBtn.MouseButton1Click:Connect(function()
    PageMain.Visible = true; PageAnim.Visible = false; PageInfo.Visible = false
    TabMainBtn.BackgroundColor3 = Color3.fromRGB(70, 25, 120); TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabAnimBtn.BackgroundColor3 = Color3.fromRGB(32, 24, 48); TabAnimBtn.TextColor3 = Color3.fromRGB(180, 150, 220)
    TabInfoBtn.BackgroundColor3 = Color3.fromRGB(32, 24, 48); TabInfoBtn.TextColor3 = Color3.fromRGB(180, 150, 220)
end)

TabAnimBtn.MouseButton1Click:Connect(function()
    PageMain.Visible = false; PageAnim.Visible = true; PageInfo.Visible = false
    TabAnimBtn.BackgroundColor3 = Color3.fromRGB(70, 25, 120); TabAnimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabMainBtn.BackgroundColor3 = Color3.fromRGB(32, 24, 48); TabMainBtn.TextColor3 = Color3.fromRGB(180, 150, 220)
    TabInfoBtn.BackgroundColor3 = Color3.fromRGB(32, 24, 48); TabInfoBtn.TextColor3 = Color3.fromRGB(180, 150, 220)
end)

TabInfoBtn.MouseButton1Click:Connect(function()
    PageMain.Visible = false; PageAnim.Visible = false; PageInfo.Visible = true
    TabInfoBtn.BackgroundColor3 = Color3.fromRGB(70, 25, 120); TabInfoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabMainBtn.BackgroundColor3 = Color3.fromRGB(32, 24, 48); TabMainBtn.TextColor3 = Color3.fromRGB(180, 150, 220)
    TabAnimBtn.BackgroundColor3 = Color3.fromRGB(32, 24, 48); TabAnimBtn.TextColor3 = Color3.fromRGB(180, 150, 220)
end)

-- Логика проверки ключа
SubmitButton.MouseButton1Click:Connect(function()
    if string.lower(string.gsub(KeyTextBox.Text, "%s+", "")) == CORRECT_KEY then
        KeyFrame:Destroy()
        OpenButton.Visible = true
        toggleMenu() -- Автоматически открываем хаб после ввода
    else
        ErrorLabel.Text = "❌ Неверный ключ! Попробуйте снова."
        task.delay(2, function()
            if ErrorLabel then ErrorLabel.Text = "" end
        end)
    end
end)

-- Скорость
local SpeedContainer = Instance.new("Frame")
SpeedContainer.Parent = PageMain
SpeedContainer.BackgroundColor3 = Color3.fromRGB(32, 24, 48)
SpeedContainer.Size = UDim2.new(1, 0, 0, 70)

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 10)
SpeedCorner.Parent = SpeedContainer

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = SpeedContainer
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.new(0, 12, 0, 8)
SpeedLabel.Size = UDim2.new(1, -24, 0, 20)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.Text = "🏃 Скорость: 16"
SpeedLabel.TextColor3 = Color3.fromRGB(230, 200, 255)
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local SliderBar = Instance.new("Frame")
SliderBar.Parent = SpeedContainer
SliderBar.BackgroundColor3 = Color3.fromRGB(50, 35, 75)
SliderBar.Position = UDim2.new(0, 12, 0, 40)
SliderBar.Size = UDim2.new(1, -24, 0, 12)

local SliderBarCorner = Instance.new("UICorner")
SliderBarCorner.CornerRadius = UDim.new(0, 6)
SliderBarCorner.Parent = SliderBar

local SliderFill = Instance.new("Frame")
SliderFill.Parent = SliderBar
SliderFill.BackgroundColor3 = Color3.fromRGB(150, 60, 255)
SliderFill.Size = UDim2.new(16/200, 0, 1, 0)

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(0, 6)
SliderFillCorner.Parent = SliderFill

local currentSpeed = 16
local draggingSpeed = false

local function updateSpeed(input)
    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
    currentSpeed = math.floor(pos * 200)
    if currentSpeed < 16 then currentSpeed = 16 end
    SpeedLabel.Text = "🏃 Скорость: " .. currentSpeed
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = currentSpeed
    end
end

SpeedContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSpeed = true
        updateSpeed(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSpeed = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSpeed and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSpeed(input)
    end
end)

-- Полет
local FlyButton = Instance.new("TextButton")
FlyButton.Parent = PageMain
FlyButton.BackgroundColor3 = Color3.fromRGB(32, 24, 48)
FlyButton.Size = UDim2.new(1, 0, 0, 45)
FlyButton.Font = Enum.Font.GothamBold
FlyButton.Text = "🛸 Полет: ВЫКЛ"
FlyButton.TextColor3 = Color3.fromRGB(230, 200, 255)
FlyButton.TextSize = 13

local FlyCorner = Instance.new("UICorner")
FlyCorner.CornerRadius = UDim.new(0, 10)
FlyCorner.Parent = FlyButton

local FlyStroke = Instance.new("UIStroke")
FlyStroke.Parent = FlyButton
FlyStroke.Color = Color3.fromRGB(90, 40, 150)
FlyStroke.Transp