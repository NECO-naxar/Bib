--// Services
local UserInputService = game:GetService("UserInputService")

--// Library
local Library = {}
Library.__index = Library

-- Theme configurations
local Themes = {
    Light = {
        --// Frames:
        Primary = Color3.fromRGB(232, 232, 232),
        Secondary = Color3.fromRGB(255, 255, 255),
        Component = Color3.fromRGB(245, 245, 245),
        Interactables = Color3.fromRGB(235, 235, 235),

        --// Text:
        Tab = Color3.fromRGB(50, 50, 50),
        Title = Color3.fromRGB(0, 0, 0),
        Description = Color3.fromRGB(100, 100, 100),

        --// Outlines:
        Shadow = Color3.fromRGB(255, 255, 255),
        Outline = Color3.fromRGB(210, 210, 210),

        --// Image:
        Icon = Color3.fromRGB(100, 100, 100),
    },
    
    Dark = {
        --// Frames:
        Primary = Color3.fromRGB(30, 30, 30),
        Secondary = Color3.fromRGB(35, 35, 35),
        Component = Color3.fromRGB(40, 40, 40),
        Interactables = Color3.fromRGB(45, 45, 45),

        --// Text:
        Tab = Color3.fromRGB(200, 200, 200),
        Title = Color3.fromRGB(240,240,240),
        Description = Color3.fromRGB(200,200,200),

        --// Outlines:
        Shadow = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(40, 40, 40),

        --// Image:
        Icon = Color3.fromRGB(220, 220, 220),
    },
    
    Void = {
        --// Frames:
        Primary = Color3.fromRGB(15, 15, 15),
        Secondary = Color3.fromRGB(20, 20, 20),
        Component = Color3.fromRGB(25, 25, 25),
        Interactables = Color3.fromRGB(30, 30, 30),

        --// Text:
        Tab = Color3.fromRGB(200, 200, 200),
        Title = Color3.fromRGB(240,240,240),
        Description = Color3.fromRGB(200,200,200),

        --// Outlines:
        Shadow = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(40, 40, 40),

        --// Image:
        Icon = Color3.fromRGB(220, 220, 220),
    },
}

-- Create a new window
function Library:CreateWindow(config)
    local window = {}
    setmetatable(window, self)
    
    -- Default settings
    window.Title = config.Title or "Window"
    window.Theme = config.Theme or "Dark"
    window.Size = config.Size or UDim2.fromOffset(570, 370)
    window.Transparency = config.Transparency or 0.2
    window.Blurring = config.Blurring or false
    window.MinimizeKeybind = config.MinimizeKeybind or Enum.KeyCode.LeftAlt
    
    -- Create the main GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "LibraryGUI"
    gui.Parent = game:GetService("CoreGui")
    
    -- Main frame
    local frame = Instance.new("Frame")
    frame.Size = window.Size
    frame.Position = UDim2.new(0.5, -window.Size.X.Offset/2, 0.5, -window.Size.Y.Offset/2)
    frame.BackgroundColor3 = Themes[window.Theme].Primary
    frame.BorderSizePixel = 0
    frame.ZIndex = 2
    frame.Parent = gui
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)
    
    -- Store references
    window.GUI = gui
    window.Frame = frame
    window.Tabs = {}
    window.Settings = {}
    
    -- Initialize window methods
    function window:SetTheme(theme)
        if type(theme) == "string" then
            theme = Themes[theme] or Themes.Dark
        end
        
        -- Update window colors
        self.Frame.BackgroundColor3 = theme.Primary
        
        -- Store the current theme
        self.Theme = theme
        
        -- Update all UI elements with new theme
        -- (Implementation depends on your UI structure)
    end
    
    function window:SetSetting(key, value)
        self.Settings[key] = value
    end
    
    function window:AddTabSection(config)
        -- Implementation for tab sections
    end
    
    function window:AddTab(config)
        local tab = {
            Title = config.Title,
            Section = config.Section,
            Icon = config.Icon,
            Elements = {}
        }
        
        -- Store the tab
        if not self.Tabs[config.Section] then
            self.Tabs[config.Section] = {}
        end
        table.insert(self.Tabs[config.Section], tab)
        
        -- Add tab methods
        function tab:AddButton(config)
            local button = {
                Title = config.Title,
                Description = config.Description or "",
                Callback = config.Callback or function() end
            }
            
            -- Store the button
            table.insert(self.Elements, {
                Type = "Button",
                Data = button
            })
            
            return button
        end
        
        -- Add other element types (Slider, Toggle, Input, Dropdown, Keybind) similarly
        
        return tab
    end
    
    function window:Notify(config)
        -- Implementation for notifications
        print("Notification:", config.Title, "-", config.Description)
    end
    
    -- Set the initial theme
    window:SetTheme(window.Theme)
    
    return window
end

-- Create a global instance
function CreateWindow(config)
    return Library:CreateWindow(config)
end

return {
    CreateWindow = CreateWindow
}
