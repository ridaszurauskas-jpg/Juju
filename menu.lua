local Menu = {}
Menu.__index = Menu

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Helper functions
local getMouseLocation = UserInputService.GetMouseLocation
local worldToViewportPoint = workspace.CurrentCamera.WorldToViewportPoint
local getValue = TweenService.GetValue

local color3_fromrgb = Color3.fromRGB
local color3_lerp = color3_fromrgb().Lerp
local vector2_new = Vector2.new
local udim2_new = UDim2.new
local math_random = math.random
local clock = os.clock
local delay = task.delay
local spawn = task.spawn
local clamp = math.clamp
local floor = math.floor
local wait = task.wait
local sqrt = math.sqrt
local type = type
local rawget = rawget

-- Base64 data (embedded images)
local shadow_image_data = "iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAQAAABpN6lAAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAHdElNRQfiAQkTIxqKm+UhAAACvElEQVR42u2dzY7aMBhFjxPHEzJQBolRq77/27XSwBCSkD/PwinS7LpBVwrfeYLjI4Ozuy6Cw+HIyHBkOMCxTiIQmYnMzEQi0S9Hz/EUePIlxDpJB58YGRiZmJlTgIKCQMkLYYmwTtLhe2509AwM6QbkFJRUbKnYEChWHGCgp6WhpoF0AzI8gYodB/bs2BDI1aYPYqKn5cIZR7oPkyejoGTLgZ+888aOEq82fRAjHRdOlEBkZGTwODwvVOx55zdH9rxSqE0fxMCVMxXQ0dHS4TwZOYENO9448osDW4La9EH01GyAhhOfBHKy9Ar4JcGeA0d2Kw5QAu3yT+fJcB7IyJdn8JUtO36sOAB0vFISKNJz7+9fgelTKBAIlGrThxEI3z743Fpf/P/GAqgF1FgAtYAaC6AWUGMB1AJqLIBaQI0FUAuosQBqATUWQC2gxgKoBdRYALWAGgugFlBjAdQCaiyAWkCNBVALqLEAagE1FkAtoMYCqAXUWAC1gBoLoBZQYwHUAmosgFpAjQVQC6ixAGoBNRZALaDGAqgF1FgAtYAaC6AWUGMB1AJqLIBaQI0FUAuosQBqATUWQC2gxgKoBdRYALWAGgugFlBjAdQCaiyAWkCNBVALqLEAagE1FkAtoMYCqAXUWAC1gBoLoBZQYwHUAmosgFpAjQVQC6ixAGoBNRZALaDGAqgF1FgAtYAaC6AWUGMB1AJqLIBaQI0nfpsi7enp1VIPI53uPriaVmfT9ORAT8eVmhJWvDZ3oea6TK5OzOkGzIz3Lc4N0K04QM0HZy609IzMRM98nyI9UQHt6ic3/3JaEkzMnsjIjYYzJdA8xejqH8403BjTDRjoqHFAx+lJZnc/qOkYmP3yD9AAkY7PJxpe7hnTT2BiAGZG2ieb3p6ILj75+LqL4O7Dq245/HoDpAjx32cQ8QtpRORenSWX2AAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xOdTWsmQAAAAASUVORK5CYII="
local pixel_image_data = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsIAAA7CARUoSoAAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAA8nYBAOgDAADydgEA6AMAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAACOO8FX0xe8TgAAAAxJREFUGFdj+P//PwAF/gL+pzWBhAAAAABJRU5ErkJggg=="
local checkmark_image_data = "iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAAYAAAAAEAAABgAAAAAQAAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAADp1fY4ytpsegAAAEFJREFUKFOFj0EOACEIxMD//3ncTsSDYbUXDFMhpKS4MVbt4Kf+BI/Nj07YIesRPIpm1QoBIf1qQqgVls4QHmdGTFexGgt5dAJMAAAAAElFTkSuQmCC"
local arrow_image_data = "iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsIAAA7CARUoSoAAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAA8nYBAOgDAADydgEA6AMAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAACOO8FX0xe8TgAAABdJREFUKFNj/A8EDHgAE5QmHwwBKxgYAJzaC/5K6BlzAAAAAElFTkSuQmCC"
local button_image_data = "iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAMAAAC67D+PAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAAOxAAADsQBlSsOGwAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAAAMdwEA6AMAAAx3AQDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAAO7qLRjGzAACAAAAK0lEQVQYVz3KQRIAAAQCwPr/p5WiQ9YAfkDcZiph7HnUucyD3V/RWqbaCjkOewBGmBH+OgAAAABJRU5ErkJggg=="
local cog_image_data = "iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAMAAAC67D+PAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAAQKAAAECgBJz8A6wAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAAB3mgEA6AMAAHeaAQDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAAEyPNqYn0aVIAAAALElEQVQYV2NgBAIGCAmioQhIQACQCZaGYBAJoZGYSApgUhATYAiikJGRkREACr4AMZ+SUSoAAAAASUVORK5CYII="
local transparency_image_data = "iVBORw0KGgoAAAANSUhEUgAAABkAAAAMBAMAAABl3At4AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///8rKyoNe1IIAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAYdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjEuMvu8A7YAAAC2ZVhJZklJKgAIAAAABQAaAQUAAQAAAEoAAAAbAQUAAQAAAFIAAAAoAQMAAQAAAAIAAAAxAQIAEAAAAFoAAABphwQAAQAAAGoAAAAAAAAAYAAAAAEAAABgAAAAAQAAAFBhaW50Lk5FVCA1LjEuMgADAACQBwAEAAAAMDIzMAGgAwABAAAAAQAAAAWgBAABAAAAlAAAAAAAAAACAAEAAgAEAAAAUjk4AAIABwAEAAAAMDEwMAAAAADp1fY4ytpsegAAABdJREFUGNNjYBBEgmg8ZI4AGo+u+hgEAKy7BSkQOa/KAAAAAElFTkSuQmCC"
local star = "iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAMAAABhq6zVAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURf///wAAAFXC034AAAACdFJOU/8A5bcwSgAAAAlwSFlzAAALGAAACxgBiam1EAAAABh0RVh0U29mdHdhcmUAUGFpbnQuTkVUIDUuMS4y+7wDtgAAALZlWElmSUkqAAgAAAAFABoBBQABAAAASgAAABsBBQABAAAAUgAAACgBAwABAAAAAgAAADEBAgAQAAAAWgAAAGmHBAABAAAAagAAAAAAAADIGQEA6AMAAMgZAQDoAwAAUGFpbnQuTkVUIDUuMS4yAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACUAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAACaOS8o1uPhvAAAALklEQVQYV2NgRAIQDgOUgpBIHAYggNE4AEISogfGxuBA2FBlEBrCASsAqWFgBAAZ8wBLe9n4/wAAAABJRU5ErkJggg=="

-- Base64 decode function (simple, works for these images)
local function base64_decode(data)
    -- Use built-in if available, else fallback
    if _G.base64_decode then
        return _G.base64_decode(data)
    end
    -- Minimal decoder (assumes valid base64)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

-- Drawing proxy for compatibility with executors (AWP, Wave, etc.)
local Drawing = Drawing or _G.Drawing
local drawing_new = Drawing and Drawing.new or nil
local drawing_proxy = {}

-- Determine executor type
local is_awp = identifyexecutor and identifyexecutor() == "AWP"

drawing_proxy.new = function(class, properties)
    local object = drawing_new(class)
    local proxy = setmetatable({
        position = udim2_new(0,0,0,0),
        real_position = vector2_new(0,0),
        size = class == "Text" and 12 or udim2_new(0,0,0,0),
        real_size = class == "Text" and 12 or vector2_new(0,0),
        object = object,
        children = {},
        parent = false,
        is_rendering = false,
        skip = class == "Circle",
        visible = false,
        destroy = function()
            object:Destroy()
        end
    }, drawing_proxy)

    local size = properties.Size
    if size and type(size) == "number" then
        properties.Size = size+2
    end
    local z_index = properties.ZIndex
    properties.ZIndex = z_index and z_index+20 or 20

    for prop, val in pairs(properties) do
        proxy[prop] = val
    end

    return proxy
end

local function update_proxy_position(proxy, position)
    local parent = rawget(proxy, "parent")
    local real_position = parent and parent.real_position or vector2_new(position.X.Offset, position.Y.Offset)
    if parent then
        local parent_pos = parent.real_position
        local parent_size = parent.real_size
        real_position = vector2_new(
            (parent_pos.X + parent_size.X * position.X.Scale) + position.X.Offset,
            (parent_pos.Y + parent_size.Y * position.Y.Scale) + position.Y.Offset
        )
    end
    proxy.object.Position = real_position
    proxy.real_position = real_position
    for _, child in ipairs(proxy.children) do
        update_proxy_position(child, child.position)
    end
end

local function update_proxy_visibility(proxy, visible)
    local children = proxy.children
    local parent = rawget(proxy, "parent")
    local obj = proxy.object
    if parent and not parent.is_rendering then
        proxy.is_rendering = false
        obj.Visible = false
    else
        obj.Visible = visible
        proxy.is_rendering = visible
    end
    for _, child in ipairs(children) do
        update_proxy_visibility(child, child.visible)
    end
end

local function update_proxy_size(proxy, size)
    if type(proxy) ~= "table" or type(proxy.real_size) == "number" then return end
    local parent = rawget(proxy, "parent")
    local real_size = parent and parent.real_size or vector2_new(size.X.Offset, size.Y.Offset)
    if parent then
        local parent_size = parent.real_size
        real_size = vector2_new(
            parent_size.X * size.X.Scale + size.X.Offset,
            parent_size.Y * size.Y.Scale + size.Y.Offset
        )
    end
    proxy.object.Size = real_size
    proxy.real_size = real_size
    for _, child in ipairs(proxy.children) do
        update_proxy_size(child, child.size)
        update_proxy_position(child, child.position)
    end
end

function drawing_proxy:__newindex(property, value)
    if property == "Position" or property == "tween_position" then
        self.position = value
        update_proxy_position(self, value)
    elseif property == "Parent" then
        if value then
            value.children[#value.children+1] = self
        end
        self.parent = value
        update_proxy_position(self, self.position)
        update_proxy_visibility(self, self.visible)
        if type(self.size) ~= "number" and not self.skip then
            update_proxy_size(self, self.size)
        end
    elseif property == "Visible" then
        self.visible = value
        update_proxy_visibility(self, value)
    elseif (property == "Size" or property == "tween_size") and type(value) ~= "number" and not self.skip then
        self.size = value
        update_proxy_size(self, value)
    else
        self.object[property] = value
    end
end

function drawing_proxy:__index(property)
    if property == "tween_size" then return self.size end
    if property == "tween_position" then return self.position end
    if property == "Destroy" then return self.destroy end
    return self.object[property]
end

-- Tween library
local active_tweens = {}
local heartbeat = {}

local function tween(object, properties, easing_style, _, duration)
    local start_time = clock()
    local tween_fns = {}
    for prop, target in pairs(properties) do
        local tweens = active_tweens[prop]
        local old_tween = tweens and tweens[object]
        if old_tween then
            for i=1,#heartbeat do
                if heartbeat[i] == old_tween then
                    table.remove(heartbeat,i)
                    break
                end
            end
        end
        local old_val = object[prop]
        if prop == "Color" or prop == "Color3" or prop == "FillColor" or prop == "OutlineColor" then
            tween_fns[prop] = function()
                local t = (clock() - start_time)/duration
                local ease = (easing_style == Enum.EasingStyle.Exponential and (t==1 and 1 or 1-2^(-10*t))) or
                             (easing_style == Enum.EasingStyle.Quad and t^2) or
                             (easing_style == Enum.EasingStyle.Circular and sqrt(1-(t-1)^2)) or
                             (easing_style == Enum.EasingStyle.Sine and (t<0.5 and 0.5*math.sin(clamp(t,0,1)*math.pi) or 0.5+0.5*(1-math.cos((clamp(t,0,1)-0.5)*math.pi))))
                object[prop] = color3_lerp(old_val, target, ease)
            end
        elseif prop == "tween_position" or prop == "tween_size" then
            tween_fns[prop] = function()
                local t = (clock() - start_time)/duration
                local ease = (easing_style == Enum.EasingStyle.Exponential and (t==1 and 1 or 1-2^(-10*t))) or
                             (easing_style == Enum.EasingStyle.Quad and t^2) or
                             (easing_style == Enum.EasingStyle.Circular and sqrt(1-(t-1)^2))
                local delta = target - old_val
                local new = udim2_new(delta.X.Scale * ease, delta.X.Offset * ease, delta.Y.Scale * ease, delta.Y.Offset * ease)
                object[prop] = old_val + new
            end
        else
            tween_fns[prop] = function()
                local t = (clock() - start_time)/duration
                local ease = (easing_style == Enum.EasingStyle.Exponential and (t==1 and 1 or 1-2^(-10*t))) or
                             (easing_style == Enum.EasingStyle.Quad and t^2) or
                             (easing_style == Enum.EasingStyle.Circular and sqrt(1-(t-1)^2))
                object[prop] = old_val + (target - old_val) * ease
            end
        end
        if not active_tweens[prop] then active_tweens[prop] = {} end
        active_tweens[prop][object] = tween_fns[prop]
        table.insert(heartbeat, tween_fns[prop])
    end
    delay(duration, function()
        for prop, fn in pairs(tween_fns) do
            for i=1,#heartbeat do
                if heartbeat[i] == fn then
                    table.remove(heartbeat,i)
                    break
                end
            end
            object[prop] = properties[prop]
        end
    end)
end

-- Signal class
local Signal = {}
Signal.__index = Signal
function Signal.new()
    return setmetatable({callbacks = {}}, Signal)
end
function Signal:Connect(cb)
    table.insert(self.callbacks, cb)
    return {Disconnect = function()
        for i=1,#self.callbacks do
            if self.callbacks[i] == cb then
                table.remove(self.callbacks,i)
                break
            end
        end
    end}
end
function Signal:Fire(...)
    for _,cb in ipairs(self.callbacks) do
        spawn(cb, ...)
    end
end

-- Menu creation
function Menu.new(options)
    local self = setmetatable({}, Menu)
    self.options = options or {}
    self.screenGui = drawing_proxy.new("Image", {
        Position = udim2_new(0,0,0,0),
        Size = udim2_new(1,0,1,0),
        Color = Color3.new(0,0,0),
        Transparency = 0,
        Data = pixel_image_data,
        Visible = true
    })
    self.frame = drawing_proxy.new("Image", {
        Position = udim2_new(0.5, -287, 0.5, -225),
        Size = udim2_new(0,575,0,450),
        Color = Color3.new(0,0,0),
        Rounding = 4,
        Data = pixel_image_data,
        Transparency = 1,
        Visible = false,
        Parent = self.screenGui
    })
    self.inside = drawing_proxy.new("Image", {
        Position = udim2_new(0,1,0,1),
        Size = udim2_new(1,-2,1,-2),
        Color = Color3.new(6,6,6),
        Rounding = 4,
        Data = pixel_image_data,
        Transparency = 1,
        Parent = self.frame,
        Visible = false
    })
    self.rightSide = drawing_proxy.new("Square", {
        Parent = self.inside,
        Position = udim2_new(0,101,0,0),
        Size = udim2_new(1,-101,1,0),
        Color = Color3.new(0,0,0),
        Filled = true,
        Transparency = 1
    })
    self.rightSideCover = drawing_proxy.new("Square", {
        Parent = self.inside,
        Position = udim2_new(0,101,0,0),
        Size = udim2_new(1,-101,1,0),
        Color = Color3.new(0,0,0),
        Filled = true,
        ZIndex = 999,
        Transparency = 0
    })
    self.rightSideDivider = drawing_proxy.new("Square", {
        Parent = self.inside,
        Position = udim2_new(0,100,0,0),
        Size = udim2_new(0,1,1,0),
        Color = Color3.new(0,0,0),
        Thickness = 1,
        Filled = true,
        Transparency = 1
    })
    self.logo = drawing_proxy.new("Image", {
        Color = Color3.new(154,213,222),
        Data = "logo.png",  -- placeholder
        Position = udim2_new(0,15,0,15),
        Parent = self.inside,
        Size = udim2_new(0,35,0,35),
        Transparency = 1
    })
    self.jujuText = drawing_proxy.new("Text", {
        Font = 1,
        Color = Color3.new(255,255,255),
        Text = "juju",
        Parent = self.logo,
        Position = udim2_new(1,5,0,3),
        Size = 14,
        Transparency = 1
    })
    self.buildText = drawing_proxy.new("Text", {
        Font = 1,
        Color = Color3.new(154,213,222),
        Text = "gui",
        Parent = self.logo,
        Position = udim2_new(1,5,0,19),
        Size = 14,
        Transparency = 1
    })
    self.tabLine = drawing_proxy.new("Square", {
        Parent = self.inside,
        Position = udim2_new(0,0,0,0),
        Size = udim2_new(0,1,0,12),
        Filled = true,
        Transparency = 0.5,
        Color = Color3.new(154,213,222)
    })
    self.dragFrame = drawing_proxy.new("Image", {
        Position = udim2_new(0.5,-287,0.5,-225),
        Size = udim2_new(0,575,0,450),
        Color = Color3.new(0,0,0),
        Rounding = 4,
        Data = pixel_image_data,
        Transparency = 0,
        ZIndex = 1000,
        Visible = false,
        Parent = self.screenGui
    })
    self.dragInside = drawing_proxy.new("Image", {
        Position = udim2_new(0,1,0,1),
        Size = udim2_new(1,-2,1,-2),
        Color = Color3.new(6,6,6),
        Rounding = 4,
        Data = pixel_image_data,
        Transparency = 1,
        Parent = self.dragFrame,
        ZIndex = 1001
    })
    self.dragLogo = drawing_proxy.new("Image", {
        Color = Color3.new(154,213,222),
        Data = "logo.png",
        Position = udim2_new(0.5,-20,0.5,-20),
        Parent = self.dragInside,
        Size = udim2_new(0,40,0,40),
        ZIndex = 1002,
        Transparency = 1
    })
    self.groups = {}
    self.orderedGroups = {}
    self.activeTab = nil
    self.menuOpen = true
    self.initialBaseOffset = 75
    self.colors = {
        shadow = Color3.new(154,213,222),
        accent = Color3.new(154,213,222),
        active_text = Color3.new(197,197,197),
        keybind_text = Color3.new(197,197,197),
        border = Color3.new(24,25,24),
        inactive_text = Color3.new(75,72,72),
        highlighted = Color3.new(51,65,70),
        dark_text = Color3.new(70,85,87),
        image = Color3.new(89,89,89),
        section = Color3.new(6,6,6),
        background = Color3.new(0,0,0),
        success = Color3.new(154,213,222),
        error = Color3.new(39,60,96),
        alert = Color3.new(30,51,61),
        logo = Color3.new(154,213,222),
        juju = Color3.new(154,213,222),
        build = Color3.new(154,213,222),
        cursor = Color3.new(154,213,222)
    }
    self.settings = {}
    self.notifications = {}
    self.favorites = {}
    self.autoload = nil
    self.theme = ""
    return self
end

function Menu:open()
    self.menuOpen = true
    tween(self.frame, {Transparency = 0}, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0.18)
    tween(self.inside, {Transparency = 0}, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0.18)
    self.frame.Visible = true
    self.inside.Visible = true
    -- add more tween for children
end

function Menu:close()
    self.menuOpen = false
    tween(self.frame, {Transparency = 1}, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0.18)
    tween(self.inside, {Transparency = 1}, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0.18)
    delay(0.18, function()
        if not self.menuOpen then
            self.frame.Visible = false
            self.inside.Visible = false
        end
    end)
end

function Menu:toggle()
    if self.menuOpen then self:close() else self:open() end
end

-- Group creation
function Menu:createGroup(name)
    local group = {}
    group.name = name
    group.tabs = {}
    group.orderedTabs = {}
    group.isVisible = true
    group.currentHeight = 30
    group.initialOffset = self.initialBaseOffset
    group.text = drawing_proxy.new("Text", {
        Color = self.colors.accent,
        Transparency = 0.5,
        Text = name,
        Parent = self.inside,
        Size = 14,
        Font = 1,
        Position = udim2_new(0,15,0,group.initialOffset)
    })
    group.line = drawing_proxy.new("Square", {
        Parent = self.inside,
        Transparency = 0.5,
        Position = udim2_new(0,15,0,group.initialOffset+15),
        Size = udim2_new(0,70,0,1),
        Color = self.colors.accent,
        Filled = true
    })
    group.createTab = function(self, name)
        local tab = {}
        tab.name = name
        tab.position = udim2_new(0,15,0,self.initialOffset + 20 + #self.orderedTabs * 15)
        tab.text = drawing_proxy.new("Text", {
            Color = self.colors.inactive_text,
            Text = name:sub(1,12),
            Size = 12,
            Font = 1,
            Visible = self.isVisible,
            Parent = self.inside,
            Position = tab.position
        })
        tab.frame = drawing_proxy.new("Square", {
            Parent = self.rightSide,
            Position = udim2_new(0,10,0,10),
            Size = udim2_new(1,-20,1,-20),
            Filled = true,
            Transparency = 0,
            Visible = false
        })
        tab.sections = {}
        tab.group = self
        tab.textFrame = drawing_proxy.new("Square", {
            Parent = self.inside,
            Position = tab.position,
            Size = udim2_new(0,70,0,tab.text.TextBounds.Y),
            Filled = true,
            Transparency = 0,
            Visible = self.isVisible
        })
        -- click and hover
        local function onClick()
            if self.activeTab ~= tab then
                self:setActiveTab(tab)
            end
        end
        -- we'll handle clicks via global handler; for now just store
        tab.onClick = onClick
        table.insert(self.orderedTabs, tab)
        self.tabs[name] = tab
        self.currentHeight = 30 + #self.orderedTabs * 15
        return tab
    end
    group.hide = function()
        group.isVisible = false
        self:updateLayout()
    end
    group.show = function()
        group.isVisible = true
        self:updateLayout()
    end
    table.insert(self.orderedGroups, group)
    self.groups[name] = group
    self:updateLayout()
    return group
end

function Menu:setActiveTab(tab)
    if self.activeTab then
        tween(self.activeTab.text, {Color = self.colors.inactive_text, tween_position = self.activeTab.position}, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0.15)
        tween(self.activeTab.frame, {tween_position = udim2_new(0,10,0,20)}, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0.15)
        self.activeTab.frame.Visible = false
    end
    self.activeTab = tab
    tween(tab.text, {Color = self.colors.active_text, tween_position = udim2_new(0,tab.position.X.Offset+5,0,tab.position.Y.Offset)}, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0.15)
    tween(tab.frame, {tween_position = udim2_new(0,10,0,10)}, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0.15)
    tab.frame.Visible = true
    tween(self.tabLine, {tween_position = udim2_new(0,tab.position.X.Offset,0,tab.position.Y.Offset+1)}, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0.15)
    tween(self.rightSideCover, {Transparency = 0}, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0.15)
    delay(0.14, function()
        if self.activeTab == tab then
            tween(self.rightSideCover, {Transparency = 1}, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0.15)
        end
    end)
end

function Menu:updateLayout()
    local y = self.initialBaseOffset
    for _,group in ipairs(self.orderedGroups) do
        group.initialOffset = y
        group.text.Visible = group.isVisible
        group.line.Visible = group.isVisible
        if group.isVisible then
            group.text.Position = udim2_new(0,15,0,y)
            group.line.Position = udim2_new(0,15,0,y+15)
            local tabY = y + 20
            for i,tab in ipairs(group.orderedTabs) do
                local newPos = udim2_new(0,15,0,tabY + (i-1)*15)
                tab.position = newPos
                tab.text.Visible = true
                tab.textFrame.Visible = true
                if self.activeTab == tab then
                    tab.text.Position = udim2_new(0,20,0,newPos.Y.Offset)
                else
                    tab.text.Position = newPos
                end
                tab.textFrame.Position = newPos
            end
            y = y + group.currentHeight
        else
            for _,tab in ipairs(group.orderedTabs) do
                tab.text.Visible = false
                tab.textFrame.Visible = false
            end
        end
    end
    local newHeight = y > 405 and 450 + (y-405) or 450
    self.frame.Size = udim2_new(0,575,0,newHeight)
    self.dragFrame.Size = udim2_new(0,575,0,newHeight)
end

-- Section creation within a tab
function Menu:createSection(tab, name, side, size, yOffset)
    local section = {}
    section.tab = tab
    section.name = name
    section.side = side
    section.size = size
    section.totalYSize = 10
    section.elements = {}
    section.border = drawing_proxy.new("Image", {
        Parent = tab.frame,
        Position = udim2_new(side==1 and 0 or 0.5, side==1 and 0 or 5, yOffset or 0, yOffset and 10 or 0),
        Size = udim2_new(0.5, -5, size, (yOffset and -10 or 0)),
        Color = self.colors.border,
        Transparency = 1,
        Rounding = 4,
        Data = pixel_image_data
    })
    section.inside = drawing_proxy.new("Image", {
        Parent = section.border,
        Position = udim2_new(0,1,0,0),
        Size = udim2_new(1,-2,1,-1),
        Color = self.colors.section,
        Transparency = 1,
        Rounding = 4,
        Data = pixel_image_data
    })
    section.line = drawing_proxy.new("Square", {
        Parent = section.inside,
        Size = udim2_new(0,9,0,1),
        Position = udim2_new(0,1,0,0),
        Color = self.colors.accent,
        Transparency = 0.5,
        Filled = true
    })
    section.label = drawing_proxy.new("Text", {
        Color = self.colors.accent,
        Transparency = 0.5,
        Text = name,
        Parent = section.inside,
        Position = udim2_new(0,15,0,-8),
        Size = 12,
        Font = 1
    })
    local textBounds = section.label.TextBounds.X + 20
    section.lineTwo = drawing_proxy.new("Square", {
        Parent = section.inside,
        Position = udim2_new(0,textBounds,0,0),
        Size = udim2_new(1,-(textBounds+1),0,1),
        Color = self.colors.accent,
        Filled = true,
        Transparency = 0.5
    })
    section.holder = drawing_proxy.new("Square", {
        Parent = section.inside,
        Position = udim2_new(0,10,0,10),
        Size = udim2_new(1,-20,1,-20),
        Transparency = 0,
        Filled = true
    })
    section.createElement = function(self, info, properties)
        -- info: { name, tip? }
        -- properties: { type, ... }
        local pos = self.totalYSize
        local element = {}
        element.name = info.name
        element.section = self
        element.frame = drawing_proxy.new("Square", {
            Parent = self.inside,
            Position = udim2_new(0,10,0,pos),
            Size = udim2_new(1,-20,0,17),
            Transparency = 0,
            Visible = true
        })
        element.text = drawing_proxy.new("Text", {
            Color = self.colors.inactive_text,
            Text = info.name,
            Size = 12,
            Font = 1,
            Transparency = 1,
            Parent = element.frame,
            Position = udim2_new(0,0,0,-1)
        })
        local totalY = 17
        local type = properties.type
        if type == "toggle" then
            element.text.Position = element.text.Position + udim2_new(0,17,0,0)
            local toggleBorder = drawing_proxy.new("Image", {
                Parent = element.frame,
                Position = udim2_new(0,0,0,0),
                Size = udim2_new(0,12,0,12),
                Color = self.colors.border,
                Transparency = 1,
                Rounding = 4,
                Data = pixel_image_data
            })
            local toggleInside = drawing_proxy.new("Image", {
                Parent = toggleBorder,
                Position = udim2_new(0,1,0,1),
                Size = udim2_new(1,-2,1,-2),
                Color = self.colors.background,
                Transparency = 1,
                Rounding = 4,
                Data = pixel_image_data
            })
            local checkmark = drawing_proxy.new("Image", {
                Parent = toggleInside,
                Position = udim2_new(0,1,0,1),
                Size = udim2_new(1,-2,1,-2),
                Data = checkmark_image_data,
                Transparency = 1,
                Color = self.colors.accent
            })
            local clickArea = drawing_proxy.new("Square", {
                Parent = element.frame,
                Size = udim2_new(0,17+element.text.TextBounds.X,1,0),
                Transparency = 0,
                Visible = true,
                Position = udim2_new(0,0,0,0)
            })
            element.toggleBorder = toggleBorder
            element.checkmark = checkmark
            element.value = false
            element.onToggle = Signal.new()
            element.setValue = function(self, val)
                self.value = val
                tween(self.checkmark, {Transparency = val and 0.5 or 1}, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0.2)
                tween(self.text, {Color = val and self.section.group.menu.colors.active_text or self.section.group.menu.colors.inactive_text}, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0.2)
                self.onToggle:Fire(val)
            end
            -- click handler will be set later
            element.clickArea = clickArea
            element.toggleInside = toggleInside
            self.elements[#self.elements+1] = element
        elseif type == "slider" then
            totalY = totalY + 14
            local sliderBorder = drawing_proxy.new("Image", {
                Parent = element.frame,
                Position = udim2_new(0,0,0,14),
                Size = udim2_new(1,0,0,12),
                Color = self.colors.border,
                Transparency = 1,
                Rounding = 4,
                Data = pixel_image_data
            })
            local sliderInside = drawing_proxy.new("Image", {
                Parent = sliderBorder,
                Position = udim2_new(0,1,0,1),
                Size = udim2_new(1,-2,1,-2),
                Color = self.colors.background,
                Rounding = 4,
                Data = pixel_image_data,
                Transparency = 1
            })
            local sliderFill = drawing_proxy.new("Image", {
                Parent = sliderInside,
                Position = udim2_new(0,1,0,1),
                Size = udim2_new(0,0,1,-2),
                Color = self.colors.accent,
                Rounding = 4,
                Data = pixel_image_data,
                Transparency = 0.5
            })
            local sliderText = drawing_proxy.new("Text", {
                Color = self.colors.dark_text,
                Text = "",
                Size = 12,
                Font = 1,
                Transparency = 1,
                Parent = element.frame,
                Position = udim2_new(0,element.text.TextBounds.X + (properties.toggle and 24 or 7),0,-1)
            })
            element.sliderFill = sliderFill
            element.sliderText = sliderText
            element.value = properties.default or properties.min
            element.min = properties.min
            element.max = properties.max
            element.suffix = properties.suffix or ""
            element.prefix = properties.prefix or ""
            element.onSlider = Signal.new()
            element.setValue = function(self, val)
                val = clamp(val, self.min, self.max)
                self.value = val
                local percent = (val - self.min) / (self.max - self.min)
                tween(self.sliderFill, {tween_size = udim2_new(percent, val==self.max and -2 or 0, 1, -2)}, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0.2)
                self.sliderText.Text = (val==self.min and properties.min_text) or (val==self.max and properties.max_text) or self.prefix..val..self.suffix
                self.onSlider:Fire(val)
            end
            element.setValue(element, element.value)
            self.elements[#self.elements+1] = element
        elseif type == "dropdown" then
            totalY = totalY + 18
            local dropdownBorder = drawing_proxy.new("Image", {
                Parent = element.frame,
                Position = udim2_new(0,0,0,14),
                Size = udim2_new(1,0,0,16),
                Color = self.colors.border,
                Transparency = 1,
                Rounding = 4,
                Data = pixel_image_data
            })
            local dropdownInside = drawing_proxy.new("Image", {
                Parent = dropdownBorder,
                Position = udim2_new(0,1,0,1),
                Size = udim2_new(1,-2,1,-2),
                Color = self.colors.background,
                Rounding = 4,
                Data = pixel_image_data,
                Transparency = 1
            })
            local dropdownText = drawing_proxy.new("Text", {
                Color = self.colors.dark_text,
                Text = "none",
                Size = 12,
                Font = 1,
                Transparency = 1,
                Parent = dropdownInside,
                Position = udim2_new(0,3,0,0)
            })
            local dropdownArrow = drawing_proxy.new("Image", {
                Color = self.colors.dark_text,
                Data = arrow_image_data,
                Size = udim2_new(0,8,0,8),
                Position = udim2_new(1,-11,0.5,-4),
                Transparency = 1,
                Parent = dropdownInside
            })
            element.dropdownText = dropdownText
            element.dropdownArrow = dropdownArrow
            element.dropdownBorder = dropdownBorder
            element.options = properties.options
            element.multi = properties.multi
            element.requires_one = properties.requires_one
            element.value = properties.default or {}
            element.onDropdown = Signal.new()
            element.setValue = function(self, val)
                self.value = val
                local text = ""
                if val and #val>0 then
                    text = table.concat(val, ", ")
                    if #text > 20 then text = text:sub(1,20).."..." end
                else
                    text = "none"
                end
                self.dropdownText.Text = text
                self.onDropdown:Fire(val)
            end
            element.setValue(element, element.value)
            self.elements[#self.elements+1] = element
        elseif type == "button" then
            totalY = totalY + 4
            local buttonBorder = drawing_proxy.new("Image", {
                Parent = element.frame,
                Position = udim2_new(0,0,0,0),
                Size = udim2_new(1,0,0,16),
                Color = self.colors.border,
                Transparency = 1,
                Rounding = 4,
                Data = pixel_image_data
            })
            local buttonInside = drawing_proxy.new("Image", {
                Parent = buttonBorder,
                Position = udim2_new(0,1,0,1),
                Size = udim2_new(1,-2,1,-2),
                Color = self.colors.background,
                Rounding = 4,
                Data = pixel_image_data,
                Transparency = 1
            })
            local buttonText = drawing_proxy.new("Text", {
                Color = self.colors.dark_text,
                Text = info.name,
                Size = 12,
                Font = 1,
                Transparency = 1,
                Parent = buttonInside,
                Position = udim2_new(0,3,0,0)
            })
            local buttonIcon = drawing_proxy.new("Image", {
                Parent = buttonBorder,
                Position = udim2_new(1,-14,0,3),
                Size = udim2_new(0,10,0,10),
                Color = self.colors.dark_text,
                Data = button_image_data,
                Transparency = 1
            })
            element.buttonBorder = buttonBorder
            element.buttonInside = buttonInside
            element.buttonText = buttonText
            element.buttonIcon = buttonIcon
            element.onClick = Signal.new()
            element.text.Visible = false
            self.elements[#self.elements+1] = element
        elseif type == "colorpicker" then
            totalY = totalY + 0  -- colorpicker is inline
            local colorpickerBorder = drawing_proxy.new("Image", {
                Parent = element.frame,
                Position = udim2_new(1,-25,0,0),
                Size = udim2_new(0,25,0,12),
                Color = self.colors.border,
                Transparency = 1,
                Rounding = 4,
                Data = pixel_image_data
            })
            local colorpickerInside = drawing_proxy.new("Image", {
                Parent = colorpickerBorder,
                Position = udim2_new(0,1,0,1),
                Size = udim2_new(1,-2,1,-2),
                Color = self.colors.background,
                Transparency = 1,
                Rounding = 4,
                Data = pixel_image_data
            })
            local colorpickerTransp = drawing_proxy.new("Image", {
                Parent = colorpickerInside,
                Position = udim2_new(0,1,0,1),
                Size = udim2_new(1,-2,1,-2),
                Color = Color3.new(255,255,255),
                Transparency = 1,
                Rounding = 4,
                Data = transparency_image_data
            })
            local colorpickerFill = drawing_proxy.new("Image", {
                Parent = colorpickerTransp,
                Position = udim2_new(0,0,0,0),
                Size = udim2_new(1,0,1,0),
                Color = properties.default_color or Color3.new(255,0,0),
                Transparency = 1,
                Rounding = 2,
                Data = pixel_image_data
            })
            element.colorpickerBorder = colorpickerBorder
            element.colorpickerFill = colorpickerFill
            element.colorpickerTransp = colorpickerTransp
            element.value = properties.default_color or Color3.new(255,0,0)
            element.transparency = properties.default_transparency or 0
            element.onColor = Signal.new()
            element.onTransparency = Signal.new()
            element.setColor = function(self, col)
                self.value = col
                self.colorpickerFill.Color = col
                self.onColor:Fire(col)
            end
            element.setTransparency = function(self, trans)
                self.transparency = trans
                self.colorpickerFill.Transparency = 1 - trans
                self.onTransparency:Fire(trans)
            end
            element.setColor(element, element.value)
            element.setTransparency(element, element.transparency)
            self.elements[#self.elements+1] = element
        end
        element.frame.Size = udim2_new(1,-20,0,totalY)
        self.totalYSize = self.totalYSize + totalY
        -- adjust section size
        if not self.side then
            self.border.Size = udim2_new(0,170,0,self.totalYSize+7)
            self.inside.Size = udim2_new(1,-2,1,-2)
        end
        return element
    end
    tab.sections[name] = section
    return section
end

-- Main loop for rendering
function Menu:start()
    -- Render loop (heartbeat)
    RunService.Heartbeat:Connect(function(dt)
        for _,fn in ipairs(heartbeat) do
            pcall(fn, dt)
        end
    end)
    -- Input handling (simplified)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.Insert then
            self:toggle()
        end
    end)
    -- Mouse move handler for hover (simplified)
    local function handleHover()
        local mousePos = getMouseLocation(UserInputService)
        -- not implemented full hover logic
    end
    RunService.RenderStepped:Connect(handleHover)
end

return Menu
