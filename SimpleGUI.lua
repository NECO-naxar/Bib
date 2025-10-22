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
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Size = UDim2.new(0, 300, 0, 400)
    sectionFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    sectionFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    sectionFrame.Parent = self.Menu

    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1,0,0,50)
    sectionLabel.Text = name
    sectionLabel.TextScaled = true
    sectionLabel.BackgroundColor3 = Color3.fromRGB(70,70,70)
    sectionLabel.Parent = sectionFrame

    local section = {
        Frame = sectionFrame,
        Buttons = {}
    }

    table.insert(self.Sections, section)
    return section
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
