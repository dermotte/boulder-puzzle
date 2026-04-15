-- main.lua
local Sprite = require("sprite")
local FontManager = require("font_manager")

local VIRTUAL_WIDTH = 1920
local VIRTUAL_HEIGHT = 1080
local canvas
local scale = 1
local offsetX = 0
local offsetY = 0

--- UI color themes for the game.
local Themes = {
    ocean = {
        bg      = {0.04, 0.08, 0.15}, -- Deep Midnight Blue
        text_1  = {0.95, 0.98, 1.0},  -- Ice White (Title)
        text_2  = {0.7, 0.85, 0.9},   -- Sky Blue (Body)
        text_3  = {0.6, 0.9, 0.8},    -- Mint (Accent)
        white   = {1, 1, 1},
        name    = "Deep Ocean"
    },
    sunset = {
        bg      = {0.1, 0.12, 0.15},  -- Dark Slate
        text_1  = {1.0, 1.0, 1.0},    -- Pure White (Title)
        text_2  = {1.0, 0.7, 0.5},    -- Peach/Coral (Body)
        text_3  = {1.0, 0.9, 0.4},    -- Golden Sun (Accent)
        white   = {1, 1, 1},
        name    = "Sunset Pop"
    }
}

--- Color palette for the 'hold' indicator text.
local holdColors = {
    {0.5, 1.0, 0.6},  -- Green (Minty/Bright)
    {0.5, 0.8, 1.0},  -- Blue (Sky Blue)
    {1.0, 1.0, 0.6},  -- Yellow (Soft Lemon)
    {1.0, 0.5, 0.5},  -- Red (Soft Coral)
    {1.0, 0.7, 0.4},  -- Orange (Warm Peach)
    {0.2, 0.2, 0.2},  -- Black (Dark Grey for visibility)
    {1.0, 1.0, 1.0},  -- White (Pure White)
    {0.8, 0.7, 1.0}   -- Purple (Lavender)
}

local myColors = Themes.ocean

local gameFont
local button  -- Button sprite object
local screenW
local screenH

local handOptions = {"Left Hand", "Right Hand", "Both Hands", "Left Foot", "Right Foot"}
local handText
local handIndex

local holdOptions = {"Green", "Blue", "Yellow", "Red", "Orange", "Black", "White", "Purple"}
local holdText
local holdIndex

-- Animation
local buttonAnimation = false
local buttonAnimationState = 0
local buttonScale = 0.75

local textAnimation = false
local textAnimationState = 1

local handTextPosition
local holdTextPosition

--- Initializes game state, assets, and UI elements.
local function updateScale()
    local windowW = love.graphics.getWidth()
    local windowH = love.graphics.getHeight()

    local scaleX = windowW / VIRTUAL_WIDTH
    local scaleY = windowH / VIRTUAL_HEIGHT
    scale = math.min(scaleX, scaleY)

    offsetX = (windowW - VIRTUAL_WIDTH * scale) / 2
    offsetY = (windowH - VIRTUAL_HEIGHT * scale) / 2
end

function love.load()
    -- Get screen dimensions for virtual space
    screenW = VIRTUAL_WIDTH
    screenH = VIRTUAL_HEIGHT
    
    -- Initialize canvas
    canvas = love.graphics.newCanvas(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    updateScale()

    -- Initialize button sprite
    button = Sprite.new("assets/button_round_depth_flat.png", screenW/2, screenH/2)
    button.scale = buttonScale

    -- Position the button relative to virtual screen dimensions
    button.x = screenW - (button.w*button.scale)/2 - screenW/8
    button.y = screenH - (button.h*button.scale) - screenH/8

    -- Set text layout positions
    handTextPosition = {
        x = 3 * (screenW / 8),
        y =  2 * (screenH / 5),
    }
    holdTextPosition = {
        x = 4 * (screenW / 8), 
        y = 3 * (screenH / 5),
    }

    -- Define button click behavior
    button.onClick = function()
        handText, handIndex = getRandomFromList(handOptions, handIndex)
        holdText, holdIndex = getRandomFromList(holdOptions, holdIndex)

        -- Trigger animations
        buttonAnimation = true
        textAnimation = true
        textAnimationState = 0
    end

    -- Load font assets
    gameFont = FontManager.get("assets/fonts/CarterOne-Regular.ttf", 256)

    -- Initialize game state and random seed
    math.randomseed(os.time())
    handText, handIndex = getRandomFromList(handOptions, handIndex)
    holdText, holdIndex = getRandomFromList(holdOptions, holdIndex)
end 

function love.resize(w, h)
    updateScale()
end

--- Handles mouse click events.
--- @param x number - The x-coordinate of the mouse click.
--- @param y number - The y-coordinate of the mouse click.
--- @param mbtn number - The mouse button pressed (1 for left).
--- @param istouch boolean - Whether the event was a touch.
--- @param presses number - Number of presses in the sequence.
function love.mousepressed(x, y, mbtn, istouch, presses)
    -- Transform mouse coordinates to virtual space
    local virtualX = (x - offsetX) / scale
    local virtualY = (y - offsetY) / scale

    -- Check if Left Mouse Button (1) was pressed
    if mbtn == 1 then
        if Sprite.isMouseOver(button, virtualX, virtualY) then
            if button.onClick ~= nil then
                button.onClick()
            end
        end
    end
end

--- Draws text at a specified position and angle.
--- @param text string - The text to draw.
--- @param x number - The x-coordinate for the center of the text.
--- @param y number - The y-coordinate for the center of the text.
--- @param angle number - The rotation angle in radians.
--- @param font love.Font - The font object to use.
function drawRotatedText(text, x, y, angle, font)
    love.graphics.setFont(font)
    
    local width = font:getWidth(text)
    local height = font:getHeight()

    love.graphics.push()          -- Save current state
        love.graphics.translate(x, y) -- Move "the world" to the target X, Y
        love.graphics.rotate(angle)   -- Rotate "the world"
        
        -- Draw text offset by half its size to center it at (x, y)
        love.graphics.print(text, -width/2, -height/2)
    love.graphics.pop()           -- Restore everything else to normal
end

--- Selects a random item from a list and returns both its value and its index.
--- @param list table - The list to select from.
--- @param lastIndex number|nil - An index to avoid re-selecting.
--- @return any - The selected value.
--- @return number|nil - The index of the selected value.
function getRandomFromList(list, lastIndex)
    if #list == 0 then return nil, nil end
    local index = math.random(1, #list)
    if index == lastIndex then 
        index = math.random(1, #list)
    end
    local value = list[index]
    return value, index
end

--- Converts an angle from degrees to radians.
--- @param degrees number - The angle in degrees.
--- @return number - The angle in radians.
local function degToRad(degrees)
    return degrees * (math.pi / 180)
end

--- Performs a linear interpolation with an ease-out quadratic effect.
--- @param a number - The starting value.
--- @param b number - The target value.
--- @param t number - The progress (0 to 1).
--- @return number - The interpolated value.
function lerpEaseOut(a, b, t)
    t = math.max(0, math.min(1, t))
    local easedT = 1 - (1 - t) * (1 - t)
    return a + (b - a) * easedT
end

--- Updates game logic and handles animations.
--- @param dt number - The delta time since the last update.
function love.update(dt)
    -- Handle button scale animation
    if buttonAnimation then
        button.scale = lerpEaseOut(0.7, 0.75, buttonAnimationState)
        buttonAnimationState = buttonAnimationState + dt * 3

        -- Update position after scaling
        button.x = screenW - (button.w*button.scale)/2 - screenW/8
        button.y = screenH - (button.h*button.scale) - screenH/8
    end

    if buttonAnimationState > 1 then
        buttonAnimation = false
        buttonAnimationState = 0
    end

    -- Handle text entry animation
    if textAnimation then
        textAnimationState = textAnimationState + dt*3
    end

    if textAnimationState > 1 then
        textAnimation = false
        textAnimationState = 1
    end
end

--- Renders the game scene, including backgrounds and UI elements.
function love.draw()
    -- 1. Render everything to the canvas
    love.graphics.setCanvas(canvas)
        -- Clear canvas with background color
        love.graphics.clear(myColors.bg[1], myColors.bg[2], myColors.bg[3])
        
        -- Draw hand text
        love.graphics.setColor(myColors.text_2[1], myColors.text_2[2], myColors.text_2[3])
        drawRotatedText(handText, handTextPosition.x, lerpEaseOut(0, handTextPosition.y, textAnimationState), degToRad(-15), gameFont)

        -- Draw hold text
        love.graphics.setColor(holdColors[holdIndex][1], holdColors[holdIndex][2], holdColors[holdIndex][3])
        drawRotatedText("on " .. holdText, lerpEaseOut(0, holdTextPosition.x, textAnimationState), holdTextPosition.y, degToRad(-15), gameFont)

        -- Reset color
        love.graphics.setColor(myColors.white)

        Sprite.draw(button)
    love.graphics.setCanvas()

    -- 2. Draw the canvas to the screen with scaling and offsets
    love.graphics.clear(myColors.bg[1], myColors.bg[2], myColors.bg[3]) -- Clear window with game background color
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(canvas, offsetX, offsetY, 0, scale, scale)
end
