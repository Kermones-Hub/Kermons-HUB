-- Kermons | HUB (Часть 1)
if not game:IsLoaded() then game.Loaded:Wait() end

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if game.CoreGui:FindFirstChild("DeltaPurpleMenuPro") then
    game.CoreGui.DeltaPurpleMenuPro:Destroy()
end

getgenv().SelectedPack = nil
getgenv().DefaultAnimBackup = {}
getgenv().CorrectKey = "кера"

getgenv().AnimationPacks = {
    ["Zombie 🧟"] = {idle = 616158929, walk = 616168072, run = 616163682, jump = 616161997, fall = 616157476, swim = 616165109, climb = 616156113},
    ["Ninja 🥷"] = {idle = 656117400, walk = 656121766, run = 656118852, jump = 656117878, fall = 656115606, swim = 656119721, climb = 656114377},
    ["Toy 🧸"] = {idle = 782841498, walk = 782842708, run = 782842708, jump = 782847020, fall = 782846465, swim = 782845914, climb = 782844888},
    ["Vampire 🧛"] = {idle = 1083445855, walk = 1083452052, run = 1083451491, jump = 1083450588, fall = 1083443587, swim = 1083452661, climb = 1083441402},
    ["Mage 🧙‍♂️"] = {idle = 707742142, walk = 707897309, run = 707861613, jump = 707853694, fall = 707829716, swim = 707825590, climb = 707823708},
    ["Superhero 🦸"] = {idle = 616111295, walk = 616123289, run = 616117076, jump = 616115533, fall = 616109230, swim = 616119932, climb = 616104706},
    ["Robot 🤖"] = {idle = 616088211, walk = 616095330, run = 616091570, jump = 616090535, fall = 616087089, swim = 616093392, climb = 616086034},
    ["Knight ⚔️"] = {idle = 657593020, walk = 657552424, run = 657550889, jump = 657551221, fall = 657550058, swim = 657551719, climb = 657549420},
    ["Cartoony 🎨"] = {idle = 742637544, walk = 742640026, run = 742638842, jump = 742637942, fall = 742636889, swim = 742639233, climb = 742636368},
    ["Astronaut 👨‍🚀"] = {idle = 891621366, walk = 891667138, run = 891636393, jump = 891627522, fall = 891617961, swim = 891653800, climb = 891609353}
}

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "DeltaPurpleMenuPro"
ScreenGui.ResetOnSpawn = false

-- Окно ключа
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.BackgroundColor3 = Color3.fromRGB(18, 14, 25)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
KeyFrame.Size = UDim2.new(0, 300, 0, 200)
KeyFrame.Active = true
KeyFrame.Draggable = true
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 16)
Instance.new("UIStroke", KeyFrame).Color = Color3.fromRGB(130, 40, 220)

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Position = UDim2.new(0, 0, 0, 15)
KeyTitle.Size = UDim2.new(1, 0, 0, 30)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Text = "🔑 Ввод ключа доступа"
KeyTitle.TextColor3 = Color3.fromRGB(220, 180, 255)
KeyTitle.TextSize = 16

local KeyTextBox = Instance.new("TextBox", KeyFrame)
KeyTextBox.BackgroundColor3 = Color3.fromRGB(28, 20, 40)
KeyTextBox.Position = UDim2.new(0.1, 0, 0, 65)
KeyTextBox.Size = UDim2.new(0.8, 0, 0, 40)
KeyTextBox.Font = Enum.Font.Gotham
KeyTextBox.PlaceholderText = "Введите ключ..."
KeyTextBox.Text = ""
KeyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTextBox.PlaceholderColor3 = Color3.fromRGB(130, 110, 160)
KeyTextBox.TextSize = 14
Instance.new("UICorner", KeyTextBox).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", KeyTextBox).Color = Color3.fromRGB(90, 40, 150)

local SubmitButton = Instance.new("TextButton", KeyFrame)
SubmitButton.BackgroundColor3 = Color3.fromRGB(85, 25, 140)
SubmitButton.Position = UDim2.new(0.1, 0, 0, 125)
SubmitButton.Size = UDim2.new(0.8, 0, 0, 40)
SubmitButton.Font = Enum.Font.GothamBold
SubmitButton.Text = "Подтвердить"
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.TextSize = 14
Instance.new("UICorner", SubmitButton).CornerRadius = UDim.new(0, 10)

local ErrorLabel = Instance.new("TextLabel", KeyFrame)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Position = UDim2.new(0, 0, 0, 170)
ErrorLabel.Size = UDim2.new(1, 0, 0, 20)
ErrorLabel.Font = Enum.Font.Gotham
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
ErrorLabel.TextSize = 12

-- Главная кнопка открытия (спрятана до ключа)
local OpenButton = Instance.new("TextButton", ScreenGui)
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
Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", OpenButton).Color = Color3.fromRGB(170, 80, 255)

-- Главное меню
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 14, 25)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -180)
MainFrame.Size = UDim2.new(0, 340, 0, 370)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(130, 40, 220)

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 20, 40)
TitleBar.Size = UDim2.new(1, 0, 0, 48)
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 16)

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0.05, 0, 0, 0)
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "Kermons | HUB"
TitleText.TextColor3 = Color3.fromRGB(220, 180, 255)
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton", TitleBar)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 40, 70)
CloseButton.Position = UDim2.new(1, -42, 0.5, -14)
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 8)

local isOpen = false
local function toggleMenu()
    isOpen = not isOpen
    if isOpen then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 340, 0, 370)}):Play()
    else
        local t = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0)})
        t:Play()
        t.Completed:Connect(function() if not isOpen then MainFrame.Visible = false end end)
    end
end

CloseButton.MouseButton1Click:Connect(toggleMenu)
OpenButton.MouseButton1Click:Connect(toggleMenu)

SubmitButton.MouseButton1Click:Connect(function()
    if string.lower(string.gsub(KeyTextBox.Text, "%s+", "")) == getgenv().CorrectKey then
        KeyFrame:Destroy()
        OpenButton.Visible = true
        toggleMenu()
    else
        ErrorLabel.Text = "❌ Неверный ключ!"
        task.delay(2, function() if ErrorLabel then ErrorLabel.Text = "" end end)
    end
end)
-- Kermons | HUB (Часть 2)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local ScreenGui = game.CoreGui:WaitForChild("DeltaPurpleMenuPro")
local MainFrame = ScreenGui:WaitForChild("MainFrame")

-- Создание вкладок
local TabBar = Instance.new("Frame", MainFrame)
TabBar.BackgroundTransparency = 1
TabBar.Position = UDim2.new(0, 10, 0, 54)
TabBar.Size = UDim2.new(1, -20, 0, 32)

local function createTab(name, pos, text)
    local btn = Instance.new("TextButton", TabBar)
    btn.BackgroundColor3 = pos == 0 and Color3.fromRGB(70, 25, 120) or Color3.fromRGB(32, 24, 48)
    btn.Position = UDim2.new(pos, 0, 0, 0)
    btn.Size = UDim2.new(0.32, 0, 1, 0)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = pos == 0 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 150, 220)
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local TabMainBtn = createTab("Main", 0, "⚙️ Главная")
local TabAnimBtn = createTab("Anim", 0.34, "🎭 Аним")
local TabInfoBtn = createTab("Info", 0.68, "👤 Владелец")

local function createPage()
    local page = Instance.new("ScrollingFrame", MainFrame)
    page.BackgroundTransparency = 1
    page.Position = UDim2.new(0, 10, 0, 94)
    page.Size = UDim2.new(1, -20, 1, -104)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(150, 60, 255)
    local uiList = Instance.new("UIListLayout", page)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 10)
    return page
end

local PageMain = createPage()
local PageAnim = createPage(); PageAnim.Visible = false
local PageInfo = createPage(); PageInfo.Visible = false

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

-- Функции анимаций
local function backupAnimations(animate)
    getgenv().DefaultAnimBackup = {}
    for _, folder in ipairs(animate:GetChildren()) do
        if folder:IsA("Folder") or folder:IsA("StringValue") then
            getgenv().DefaultAnimBackup[folder.Name] = {}
            for _, anim in ipairs(folder:GetChildren()) do
                if anim:IsA("Animation") then getgenv().DefaultAnimBackup[folder.Name][anim.Name] = anim.AnimationId end
            end
        end
    end
end

local function applyAnimations(animTable)
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local animate = char:FindFirstChild("Animate")
    if not humanoid or not animate then return end
    
    animate.Disabled = true
    for folderName, id in pairs(animTable) do
        local folder = animate:FindFirstChild(folderName)
        if folder then
            for _, child in ipairs(folder:GetChildren()) do
                if child:IsA("Animation") then child.AnimationId = "rbxassetid://" .. tostring(id) end
            end
        end
    end
    task.wait(0.05)
    animate.Disabled = false
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    
    animate.Disabled = true
    for folderName, anims in pairs(getgenv().DefaultAnimBackup) do
        local folder = animate:FindFirstChild(folderName)
        if folder then
            for animName, animId in pairs(anims) do
                local animObj = folder:FindFirstChild(animName)
                if animObj then animObj.AnimationId = animId end
            end
        end
    end
    task.wait(0.05)
    animate.Disabled = false
    getgenv().SelectedPack = nil
end

if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Animate") then
    backupAnimations(LocalPlayer.Character.Animate)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    local animate = char:WaitForChild("Animate", 5)
    if animate then
        backupAnimations(animate)
        if getgenv().SelectedPack and getgenv().AnimationPacks[getgenv().SelectedPack] then
            task.wait(0.2)
            applyAnimations(getgenv().AnimationPacks[getgenv().SelectedPack])
        end
    end
end)

-- Слайдер скорости
local SpeedContainer = Instance.new("Frame", PageMain)
SpeedContainer.BackgroundColor3 = Color3.fromRGB(32, 24, 48)
SpeedContainer.Size = UDim2.new(1, 0, 0, 70)
Instance.new("UICorner", SpeedContainer).CornerRadius = UDim.new(0, 10)

local SpeedLabel = Instance.new("TextLabel", SpeedContainer)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.new(0, 12, 0, 8)
SpeedLabel.Size = UDim2.new(1, -24, 0, 20)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.Text = "🏃 Скорость: 16"
SpeedLabel.TextColor3 = Color3.fromRGB(230, 200, 255)
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local SliderBar = Instance.new("Frame", SpeedContainer)
SliderBar.BackgroundColor3 = Color3.fromRGB(50, 35, 75)
SliderBar.Position = UDim2.new(0, 12, 0, 40)
SliderBar.Size = UDim2.new(1, -24, 0, 12)
Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(0, 6)

local SliderFill = Instance.new("Frame", SliderBar)
SliderFill.BackgroundColor3 = Color3.fromRGB(150, 60, 255)
SliderFill.Size = UDim2.new(16/200, 0, 1, 0)
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 6)

local draggingSpeed = false
SpeedContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSpeed = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSpeed = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingSpeed and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        local speed = math.floor(pos * 200)
        if speed < 16 then speed = 16 end
        SpeedLabel.Text = "🏃 Скорость: " .. speed
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end
    end
end)

-- Кнопка полета
local FlyButton = Instance.new("TextButton", PageMain)
FlyButton.BackgroundColor3 = Color3.fromRGB(32, 24, 48)
FlyButton.Size = UDim2.new(1, 0, 0, 45)
FlyButton.Font = Enum.Font.GothamBold
FlyButton.Text = "🛸 Полет: ВЫКЛ"
FlyButton.TextColor3 = Color3.fromRGB(230, 200, 255)
FlyButton.TextSize = 13
Instance.new("UICorner", FlyButton).CornerRadius = UDim.new(0, 10)
local FlyStroke = Instance.new("UIStroke", FlyButton)
FlyStroke.Color = Color3.fromRGB(90, 40, 150)

local flying = false
local bg, bv
FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    if flying then
        FlyButton.BackgroundColor3 = Color3.fromRGB(70, 25, 120)
        FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        FlyStroke.Color = Color3.fromRGB(180, 80, 255)
        FlyButton.Text = "🛸 Полет: ВКЛ"
        bg = Instance.new("BodyGyro", char.HumanoidRootPart)
        bg.P = 9e4; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); bg.cframe = char.HumanoidRootPart.CFrame
        bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
        bv.velocity = Vector3.new(0, 0, 0); bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        if char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = true end
        task.spawn(function()
            while flying and char and char:FindFirstChild("HumanoidRootPart") do
                RunService.RenderStepped:Wait()
                local cam = Camera.CFrame
                local moveDir = Vector3.new(0, 0, 0)
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum.MoveDirection.Magnitude > 0 then
                    local rel = cam:VectorToObjectSpace(hum.MoveDirection)
                    moveDir = (cam.LookVector * -rel.Z) + (cam.RightVector * rel.X)
                end
                bv.velocity = moveDir.Magnitude > 0 and moveDir.Unit * 50 or Vector3.new(0, 0.1, 0)
                bg.cframe = cam
            end
        end)
    else
        FlyButton.BackgroundColor3 = Color3.fromRGB(32, 24, 48)
        FlyButton.TextColor3 = Color3.fromRGB(230, 200, 255)
        FlyStroke.Color = Color3.fromRGB(90, 40, 150)
        FlyButton.Text = "🛸 Полет: ВЫКЛ"
        if char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
    end
end)

-- Кнопки анимаций на вкладке Anim
local AnimGrid = Instance.new("UIGridLayout", PageAnim)
AnimGrid.CellSize = UDim2.new(0, 150, 0, 40)
AnimGrid.CellPadding = UDim2.new(0, 10, 0, 10)

local ResetBtn = Instance.new("TextButton", PageAnim)
ResetBtn.BackgroundColor3 = Color3.fromRGB(140, 40, 50)
ResetBtn.Size = UDim2.new(1, 0, 0, 38)
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.Text = "🔄 Сбросить анимации"
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.TextSize = 12
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 8)
ResetBtn.MouseButton1Click:Connect(restoreAnimations)

for packName, _ in pairs(getgenv().AnimationPacks) do
    local btn = Instance.new("TextButton", PageAnim)
    btn.BackgroundColor3 = Color3.fromRGB(32, 24, 48)
    btn.Size = UDim2.new(0, 150, 0, 40)
    btn.Font = Enum.Font.GothamBold
    btn.Text = packName
    btn.TextColor3 = Color3.fromRGB(230, 200, 255)
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(90, 40, 150)
    btn.MouseButton1Click:Connect(function()
        getgenv().SelectedPack = packName
        applyAnimations(getgenv().AnimationPacks[packName])
    end)
end

-- Вкладка Инфо
local InfoContainer = Instance.new("Frame", PageInfo)
InfoContainer.BackgroundColor3 = Color3.fromRGB(32, 24, 48)
InfoContainer.Size = UDim2.new(1, 0, 0, 130)
Instance.new("UICorner", InfoContainer).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", InfoContainer).Color = Color3.fromRGB(130, 40, 220)

local function addLabel(text, pos)
    local l = Instance.new("TextLabel", InfoContainer)
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 15, 0, pos)
    l.Size = UDim2.new(1, -30, 0, 22)
    l.Font = Enum.Font.Gotham
    l.Text = text
    l.TextColor3 = Color3.fromRGB(200, 170, 240)
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
end

addLabel("✨ Информация о создателе", 12).Font = Enum.Font.GothamBold
addLabel("💬 Тг владельца: @Kermones", 48)
addLabel("📢 Канал владельца: @Kerlenders", 80)
