-- SimpleGUI.lua
local GUI = {}
GUI.__index = GUI

-- Создание меню
function GUI:CreateMenu(title)
    local self = setmetatable({}, GUI)
    self.Menu = Instance.new("ScreenGui")
    self.Menu.Name = title
    self.Menu.ResetOnSpawn = false
    self.Menu.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    self.Sections = {}
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

    -- Если это первый раздел, сразу открываем его
    if #self.Sections == 1 then
        self.CurrentSection = section
        self:RefreshContent()
    end

    return section
end

-- Обновление контента
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


-- Обычная кнопка
function GUI:AddButton(section, name, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 280, 0, 50)
    button.Position = UDim2.new(0,10,0,50 + (#section.Buttons * 60))
    button.Text = name
    button.Parent = section.Frame

    button.MouseButton1Click:Connect(callback)
    table.insert(section.Buttons, button)
end

-- Кнопка с текстом
function GUI:AddTextButton(section, name, callback)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 200, 0, 50)
    textBox.Position = UDim2.new(0,10,0,50 + (#section.Buttons * 60))
    textBox.PlaceholderText = name
    textBox.Parent = section.Frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 70, 0, 50)
    button.Position = UDim2.new(0, 220, 0, 50 + (#section.Buttons * 60))
    button.Text = "OK"
    button.Parent = section.Frame

    button.MouseButton1Click:Connect(function()
        callback(textBox.Text)
    end)

    table.insert(section.Buttons, textBox)
    table.insert(section.Buttons, button)
end

-- Ползунок
function GUI:AddSlider(section, name, min, max, default, callback)
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(0, 280, 0, 30)
    sliderLabel.Position = UDim2.new(0,10,0,50 + (#section.Buttons * 60))
    sliderLabel.Text = name .. ": " .. default
    sliderLabel.TextScaled = true
    sliderLabel.BackgroundColor3 = Color3.fromRGB(70,70,70)
    sliderLabel.Parent = section.Frame

    local slider = Instance.new("TextBox")
    slider.Size = UDim2.new(0, 280, 0, 30)
    slider.Position = UDim2.new(0,10,0,80 + (#section.Buttons * 60))
    slider.Text = tostring(default)
    slider.Parent = section.Frame

    slider.FocusLost:Connect(function()
        local value = tonumber(slider.Text)
        if value then
            sliderLabel.Text = name .. ": " .. value
            callback(value)
        end
    end)

    table.insert(section.Buttons, sliderLabel)
    table.insert(section.Buttons, slider)
end

return GUI

