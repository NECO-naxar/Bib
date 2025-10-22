-- SimpleGUI.lua
local GUI = {}
GUI.__index = GUI

-- Создание меню
function GUI:CreateMenu(title)
    local self = setmetatable({}, GUI)

    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    self.Menu = Instance.new("ScreenGui")
    self.Menu.Name = title
    self.Menu.ResetOnSpawn = false
    self.Menu.Parent = playerGui

    -- Основное окно
    self.Window = Instance.new("Frame")
    self.Window.Size = UDim2.new(0, 500, 0, 400)
    self.Window.Position = UDim2.new(0.3, 0, 0.3, 0)
    self.Window.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    self.Window.Parent = self.Menu
    self.Window.Active = true
    self.Window.Draggable = true -- Перетаскивание

    -- Секция слева (список разделов)
    self.SectionsList = Instance.new("Frame")
    self.SectionsList.Size = UDim2.new(0, 150, 1, 0)
    self.SectionsList.Position = UDim2.new(0,0,0,0)
    self.SectionsList.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    self.SectionsList.Parent = self.Window

    -- Контейнер для кнопок раздела справа
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Size = UDim2.new(1, -150, 1, 0)
    self.ContentArea.Position = UDim2.new(0, 150, 0, 0)
    self.ContentArea.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    self.ContentArea.Parent = self.Window

    self.Sections = {}
    self.CurrentSection = nil

    return self
end

-- Добавление раздела
function GUI:AddSection(name)
    local sectionButton = Instance.new("TextButton")
    sectionButton.Size = UDim2.new(1, 0, 0, 50)
    sectionButton.Text = name
    sectionButton.TextScaled = true
    sectionButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    sectionButton.Parent = self.SectionsList

    local section = {
        Name = name,
        Buttons = {},
        ButtonFrame = self.ContentArea
    }

    sectionButton.MouseButton1Click:Connect(function()
        self.CurrentSection = section
        self:RefreshContent()
    end)

    table.insert(self.Sections, section)
    return section
end

-- Обновление отображения кнопок текущего раздела
function GUI:RefreshContent()
    -- Убираем все старые элементы
    for _, child in ipairs(self.ContentArea:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextBox") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    if not self.CurrentSection then return end

    local buttons = self.CurrentSection.Buttons
    for i, btn in ipairs(buttons) do
        btn.Parent = self.ContentArea
        btn.Position = UDim2.new(0, 10, 0, 10 + (i-1)*60)
    end
end

-- Добавление обычной кнопки
function GUI:AddButton(section, name, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 320, 0, 50)
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    button.MouseButton1Click:Connect(callback)

    table.insert(section.Buttons, button)

    if self.CurrentSection == section then
        self:RefreshContent()
    end
end

-- Добавление кнопки с текстом
function GUI:AddTextButton(section, name, callback)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 240, 0, 50)
    textBox.PlaceholderText = name
    textBox.BackgroundColor3 = Color3.fromRGB(120, 120, 120)

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 70, 0, 50)
    button.Text = "OK"
    button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

    button.MouseButton1Click:Connect(function()
        callback(textBox.Text)
    end)

    table.insert(section.Buttons, textBox)
    table.insert(section.Buttons, button)

    if self.CurrentSection == section then
        self:RefreshContent()
    end
end

-- Добавление ползунка
function GUI:AddSlider(section, name, min, max, default, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 320, 0, 30)
    label.Text = name .. ": " .. default
    label.TextScaled = true
    label.BackgroundColor3 = Color3.fromRGB(120, 120, 120)

    local slider = Instance.new("TextBox")
    slider.Size = UDim2.new(0, 320, 0, 30)
    slider.Text = tostring(default)
    slider.BackgroundColor3 = Color3.fromRGB(140, 140, 140)

    slider.FocusLost:Connect(function()
        local value = tonumber(slider.Text)
        if value then
            label.Text = name .. ": " .. value
            callback(value)
        end
    end)

    table.insert(section.Buttons, label)
    table.insert(section.Buttons, slider)

    if self.CurrentSection == section then
        self:RefreshContent()
    end
end

return GUI
